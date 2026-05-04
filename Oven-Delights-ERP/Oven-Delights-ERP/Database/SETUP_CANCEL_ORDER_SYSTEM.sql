-- =============================================
-- Setup Cancel Order System
-- =============================================

-- 1. Ensure Cancellation Fee product exists
IF NOT EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE Name LIKE '%Cancellation Fee%')
BEGIN
    PRINT 'Creating Cancellation Fee product...'
    
    -- Get a valid CategoryID (use Miscellaneous or create one)
    DECLARE @CategoryID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName LIKE '%Miscellaneous%')
    
    IF @CategoryID IS NULL
    BEGIN
        INSERT INTO Categories (CategoryName) VALUES ('Miscellaneous')
        SET @CategoryID = SCOPE_IDENTITY()
    END
    
    -- Insert Cancellation Fee product for each branch
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, ProductType, BranchID, CurrentStock, IsActive)
    SELECT 
        'CANCEL-FEE',
        'Cancellation Fee',
        'Miscellaneous',
        @CategoryID,
        'External',
        BranchID,
        0,
        1
    FROM Branches
    WHERE BranchID > 0
    
    PRINT 'Cancellation Fee product created for all branches.'
    
    -- Set default price for Cancellation Fee (R100.00)
    INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom)
    SELECT 
        p.ProductID,
        p.BranchID,
        100.00,
        0.00,
        GETDATE()
    FROM Demo_Retail_Product p
    WHERE p.Name = 'Cancellation Fee'
    
    PRINT 'Default cancellation fee price set to R100.00 for all branches.'
END
ELSE
BEGIN
    PRINT 'Cancellation Fee product already exists.'
END

-- 2. Verify Demo_Sales table can handle new SaleType values
-- Check if SaleType column exists and what type it is
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'Demo_Sales' AND COLUMN_NAME = 'SaleType')
BEGIN
    PRINT 'SaleType column exists in Demo_Sales table.'
    
    -- Check current data type
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Demo_Sales' AND COLUMN_NAME = 'SaleType'
    
    -- If it's a constrained type (enum), we may need to alter it
    -- For now, just document the new values
    PRINT 'New SaleType values to be used:'
    PRINT '  - CancellationFee (revenue from cancelled orders)'
    PRINT '  - OrderRefund (money refunded to customers)'
END
ELSE
BEGIN
    PRINT 'WARNING: SaleType column does not exist in Demo_Sales table!'
    PRINT 'Please add the column before using cancel order functionality.'
END

-- 3. Optional: Create DeletedOrders archive table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'POS_DeletedOrders')
BEGIN
    PRINT 'Creating POS_DeletedOrders archive table...'
    
    CREATE TABLE POS_DeletedOrders (
        DeletedOrderID INT IDENTITY(1,1) PRIMARY KEY,
        OrderID INT,
        OrderNumber VARCHAR(50),
        CustomerName VARCHAR(100),
        CustomerSurname VARCHAR(100),
        CustomerPhone VARCHAR(20),
        DepositAmount DECIMAL(18,2),
        CancellationFee DECIMAL(18,2),
        RefundAmount DECIMAL(18,2),
        RefundMethod VARCHAR(20),
        OriginalOrderDate DATETIME,
        CancelledBy INT,
        CancelledDate DATETIME DEFAULT GETDATE(),
        CancellationReason VARCHAR(500),
        BranchID INT,
        CONSTRAINT FK_DeletedOrders_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_DeletedOrders_User FOREIGN KEY (CancelledBy) REFERENCES Users(UserID)
    )
    
    PRINT 'POS_DeletedOrders table created successfully.'
END
ELSE
BEGIN
    PRINT 'POS_DeletedOrders table already exists.'
END

-- 4. Create stored procedure for cancelling orders
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_CancelOrder')
    DROP PROCEDURE sp_CancelOrder
GO

CREATE PROCEDURE sp_CancelOrder
    @OrderNumber VARCHAR(50),
    @CancellationFee DECIMAL(18,2),
    @CancelledBy INT,
    @CancellationReason VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @OrderID INT
    DECLARE @BranchID INT
    DECLARE @CustomerName VARCHAR(100)
    DECLARE @CustomerSurname VARCHAR(100)
    DECLARE @CustomerPhone VARCHAR(20)
    DECLARE @DepositAmount DECIMAL(18,2)
    DECLARE @RefundAmount DECIMAL(18,2)
    DECLARE @PaymentMethod VARCHAR(20)
    DECLARE @OrderDate DATETIME
    DECLARE @OrderStatus VARCHAR(20)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- 1. Get order details
        SELECT 
            @OrderID = OrderID,
            @BranchID = BranchID,
            @CustomerName = CustomerName,
            @CustomerSurname = CustomerSurname,
            @CustomerPhone = CustomerPhone,
            @OrderDate = OrderDate,
            @OrderStatus = OrderStatus
        FROM POS_CustomOrders
        WHERE OrderNumber = @OrderNumber
        
        IF @OrderID IS NULL
        BEGIN
            RAISERROR('Order not found.', 16, 1)
            RETURN
        END
        
        IF @OrderStatus = 'Delivered'
        BEGIN
            RAISERROR('Cannot cancel a delivered order.', 16, 1)
            RETURN
        END
        
        IF @OrderStatus = 'Cancelled'
        BEGIN
            RAISERROR('Order is already cancelled.', 16, 1)
            RETURN
        END
        
        -- 2. Get deposit details
        SELECT TOP 1
            @DepositAmount = TotalAmount,
            @PaymentMethod = PaymentMethod
        FROM Demo_Sales
        WHERE InvoiceNumber = @OrderNumber
        AND SaleType = 'OrderDeposit'
        ORDER BY SaleDate DESC
        
        IF @DepositAmount IS NULL
        BEGIN
            RAISERROR('No deposit found for this order.', 16, 1)
            RETURN
        END
        
        -- 3. Calculate refund
        SET @RefundAmount = @DepositAmount - @CancellationFee
        
        IF @RefundAmount < 0
        BEGIN
            RAISERROR('Cancellation fee cannot exceed deposit amount.', 16, 1)
            RETURN
        END
        
        -- 4. Update order status
        UPDATE POS_CustomOrders
        SET OrderStatus = 'Cancelled',
            ModifiedDate = GETDATE()
        WHERE OrderNumber = @OrderNumber
        
        -- 5. Record cancellation fee as revenue
        DECLARE @CancellationInvoice VARCHAR(50) = 'CANCEL-' + CONVERT(VARCHAR, GETDATE(), 112) + '-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR), 4)
        
        INSERT INTO Demo_Sales (InvoiceNumber, BranchID, TotalAmount, PaymentMethod, SaleType, SaleDate, CashierID, CustomerName)
        VALUES (@CancellationInvoice, @BranchID, @CancellationFee, 'Cash', 'CancellationFee', GETDATE(), @CancelledBy, @CustomerName + ' ' + ISNULL(@CustomerSurname, ''))
        
        -- 6. Record refund transaction (if refund amount > 0)
        IF @RefundAmount > 0
        BEGIN
            DECLARE @RefundInvoice VARCHAR(50) = 'REFUND-' + CONVERT(VARCHAR, GETDATE(), 112) + '-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR), 4)
            
            INSERT INTO Demo_Sales (InvoiceNumber, BranchID, TotalAmount, PaymentMethod, SaleType, SaleDate, CashierID, CustomerName)
            VALUES (@RefundInvoice, @BranchID, -@RefundAmount, @PaymentMethod, 'OrderRefund', GETDATE(), @CancelledBy, @CustomerName + ' ' + ISNULL(@CustomerSurname, ''))
        END
        
        -- 7. Archive to deleted orders (optional)
        IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'POS_DeletedOrders')
        BEGIN
            INSERT INTO POS_DeletedOrders (OrderID, OrderNumber, CustomerName, CustomerSurname, CustomerPhone, 
                                          DepositAmount, CancellationFee, RefundAmount, RefundMethod, 
                                          OriginalOrderDate, CancelledBy, CancellationReason, BranchID)
            VALUES (@OrderID, @OrderNumber, @CustomerName, @CustomerSurname, @CustomerPhone,
                   @DepositAmount, @CancellationFee, @RefundAmount, @PaymentMethod,
                   @OrderDate, @CancelledBy, @CancellationReason, @BranchID)
        END
        
        COMMIT TRANSACTION
        
        -- Return success info
        SELECT 
            'Success' AS Status,
            @OrderNumber AS OrderNumber,
            @RefundAmount AS RefundAmount,
            @PaymentMethod AS RefundMethod,
            @CancellationInvoice AS CancellationInvoice,
            CASE WHEN @RefundAmount > 0 THEN @RefundInvoice ELSE NULL END AS RefundInvoice
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_CancelOrder stored procedure created successfully.'

-- 5. Verify setup
PRINT ''
PRINT '===== SETUP VERIFICATION ====='

-- Check Cancellation Fee product
PRINT 'Cancellation Fee Products:'
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    b.BranchName,
    pr.SellingPrice
FROM Demo_Retail_Product p
INNER JOIN Branches b ON p.BranchID = b.BranchID
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID AND p.BranchID = pr.BranchID
WHERE p.Name LIKE '%Cancellation%'
ORDER BY p.BranchID

-- Check existing order statuses
PRINT ''
PRINT 'Current Order Statuses:'
SELECT 
    OrderStatus,
    COUNT(*) AS OrderCount
FROM POS_CustomOrders
GROUP BY OrderStatus
ORDER BY OrderStatus

-- Check SaleType values
PRINT ''
PRINT 'Existing SaleType Values:'
SELECT DISTINCT SaleType
FROM Demo_Sales
ORDER BY SaleType

PRINT ''
PRINT '===== SETUP COMPLETE ====='
PRINT 'Cancel Order system is ready to use.'
PRINT 'New SaleType values: CancellationFee, OrderRefund'

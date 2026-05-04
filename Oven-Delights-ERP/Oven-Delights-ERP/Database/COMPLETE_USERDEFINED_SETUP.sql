-- =============================================
-- COMPLETE USER DEFINED ORDERS SETUP SCRIPT
-- Run this script to set up the entire User Defined Orders system
-- =============================================

PRINT '========================================='
PRINT 'USER DEFINED ORDERS - COMPLETE SETUP'
PRINT '========================================='
PRINT ''

-- Step 1: Create tables
PRINT 'Step 1: Creating database tables...'
EXEC('
-- Main User Defined Orders Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[POS_UserDefinedOrders]'') AND type in (N''U''))
BEGIN
    CREATE TABLE [dbo].[POS_UserDefinedOrders](
        [UserDefinedOrderID] [int] IDENTITY(1,1) NOT NULL,
        [OrderNumber] [nvarchar](20) NOT NULL,
        [BranchID] [int] NOT NULL,
        [BranchName] [nvarchar](100) NULL,
        [CashierID] [int] NOT NULL,
        [CashierName] [nvarchar](100) NOT NULL,
        [TillPointID] [int] NULL,
        [CustomerCellNumber] [nvarchar](20) NOT NULL,
        [CustomerName] [nvarchar](100) NOT NULL,
        [CustomerSurname] [nvarchar](100) NULL,
        [CakeColour] [nvarchar](100) NULL,
        [CakeImage] [nvarchar](200) NULL,
        [SpecialRequest] [nvarchar](500) NULL,
        [CollectionDate] [date] NOT NULL,
        [CollectionTime] [time](7) NOT NULL,
        [CollectionDay] [nvarchar](20) NULL,
        [OrderDate] [date] NOT NULL,
        [OrderTime] [time](7) NOT NULL,
        [OrderDateTime] [datetime] NOT NULL DEFAULT GETDATE(),
        [TotalAmount] [decimal](18, 2) NOT NULL,
        [AmountPaid] [decimal](18, 2) NOT NULL,
        [PaymentMethod] [nvarchar](20) NOT NULL,
        [CashAmount] [decimal](18, 2) NULL,
        [CardAmount] [decimal](18, 2) NULL,
        [Status] [nvarchar](20) NOT NULL DEFAULT ''Created'',
        [CompletedDate] [datetime] NULL,
        [CompletedBy] [nvarchar](100) NULL,
        [PickedUpDate] [date] NULL,
        [PickedUpTime] [time](7) NULL,
        [PickedUpDateTime] [datetime] NULL,
        [PickedUpBy] [nvarchar](100) NULL,
        [SaleID] [int] NULL,
        [InvoiceNumber] [nvarchar](50) NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] [datetime] NULL,
        CONSTRAINT [PK_POS_UserDefinedOrders] PRIMARY KEY CLUSTERED ([UserDefinedOrderID] ASC),
        CONSTRAINT [UQ_UserDefinedOrderNumber] UNIQUE ([OrderNumber])
    )
    PRINT ''  ✓ POS_UserDefinedOrders table created''
END
ELSE
    PRINT ''  - POS_UserDefinedOrders table already exists''
')

EXEC('
-- User Defined Order Items Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[POS_UserDefinedOrderItems]'') AND type in (N''U''))
BEGIN
    CREATE TABLE [dbo].[POS_UserDefinedOrderItems](
        [ItemID] [int] IDENTITY(1,1) NOT NULL,
        [UserDefinedOrderID] [int] NOT NULL,
        [ProductID] [int] NOT NULL,
        [ProductName] [nvarchar](200) NOT NULL,
        [ProductCode] [nvarchar](50) NULL,
        [Quantity] [decimal](18, 2) NOT NULL,
        [UnitPrice] [decimal](18, 2) NOT NULL,
        [LineTotal] [decimal](18, 2) NOT NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_POS_UserDefinedOrderItems] PRIMARY KEY CLUSTERED ([ItemID] ASC),
        CONSTRAINT [FK_UserDefinedOrderItems_Orders] FOREIGN KEY ([UserDefinedOrderID]) 
            REFERENCES [dbo].[POS_UserDefinedOrders]([UserDefinedOrderID]) ON DELETE CASCADE
    )
    PRINT ''  ✓ POS_UserDefinedOrderItems table created''
END
ELSE
    PRINT ''  - POS_UserDefinedOrderItems table already exists''
')

-- Step 2: Create indexes
PRINT ''
PRINT 'Step 2: Creating indexes...'

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserDefinedOrders_BranchID' AND object_id = OBJECT_ID('POS_UserDefinedOrders'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_UserDefinedOrders_BranchID] ON [dbo].[POS_UserDefinedOrders]([BranchID])
    PRINT '  ✓ Index IX_UserDefinedOrders_BranchID created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserDefinedOrders_Status' AND object_id = OBJECT_ID('POS_UserDefinedOrders'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_UserDefinedOrders_Status] ON [dbo].[POS_UserDefinedOrders]([Status])
    PRINT '  ✓ Index IX_UserDefinedOrders_Status created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserDefinedOrders_CustomerCell' AND object_id = OBJECT_ID('POS_UserDefinedOrders'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_UserDefinedOrders_CustomerCell] ON [dbo].[POS_UserDefinedOrders]([CustomerCellNumber])
    PRINT '  ✓ Index IX_UserDefinedOrders_CustomerCell created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserDefinedOrders_CollectionDate' AND object_id = OBJECT_ID('POS_UserDefinedOrders'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_UserDefinedOrders_CollectionDate] ON [dbo].[POS_UserDefinedOrders]([CollectionDate])
    PRINT '  ✓ Index IX_UserDefinedOrders_CollectionDate created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserDefinedOrderItems_OrderID' AND object_id = OBJECT_ID('POS_UserDefinedOrderItems'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_UserDefinedOrderItems_OrderID] ON [dbo].[POS_UserDefinedOrderItems]([UserDefinedOrderID])
    PRINT '  ✓ Index IX_UserDefinedOrderItems_OrderID created'
END

-- Step 3: Update Cash Up stored procedure
PRINT ''
PRINT 'Step 3: Updating Cash Up stored procedure...'

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetEndOfDayCashUp')
    DROP PROCEDURE sp_GetEndOfDayCashUp

EXEC('
CREATE PROCEDURE sp_GetEndOfDayCashUp
    @BranchID INT,
    @ReportDate DATE,
    @TillID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ds.TillNumber,
        COALESCE(ds.TillNumber, ''Till '' + CAST(ds.TillNumber AS NVARCHAR(10))) AS TillName,
        ds.CashierName,
        SUM(CASE WHEN ds.SaleType = ''SALE'' THEN ds.TotalAmount / 1.15 ELSE 0 END) AS TotalSalesExclVAT,
        SUM(CASE WHEN ds.SaleType = ''SALE'' THEN ds.TotalAmount - (ds.TotalAmount / 1.15) ELSE 0 END) AS VATAmount,
        SUM(CASE WHEN ds.SaleType = ''SALE'' THEN ds.TotalAmount ELSE 0 END) AS TotalSalesInclVAT,
        COUNT(CASE WHEN ds.SaleType IN (''SALE'', ''ORDER'', ''OrderCollection'', ''UserDefined'') THEN 1 END) AS TransactionCount,
        SUM(CASE WHEN ds.PaymentMethod = ''Cash'' THEN ds.TotalAmount ELSE 0 END) AS CashPayments,
        SUM(CASE WHEN ds.PaymentMethod = ''Card'' THEN ds.TotalAmount ELSE 0 END) AS CardPayments,
        SUM(CASE WHEN ds.PaymentMethod = ''EFT'' THEN ds.TotalAmount ELSE 0 END) AS EFTPayments,
        SUM(CASE WHEN ds.PaymentMethod = ''Account'' THEN ds.TotalAmount ELSE 0 END) AS AccountPayments,
        SUM(CASE WHEN ds.SaleType = ''ORDER'' THEN ds.TotalAmount ELSE 0 END) AS OrderDeposits,
        COUNT(CASE WHEN ds.SaleType = ''ORDER'' THEN 1 END) AS OrderDepositCount,
        SUM(CASE WHEN ds.SaleType = ''OrderCollection'' THEN ds.TotalAmount ELSE 0 END) AS OrderCollections,
        COUNT(CASE WHEN ds.SaleType = ''OrderCollection'' THEN 1 END) AS OrderCollectionCount,
        SUM(CASE WHEN ds.SaleType = ''UserDefined'' THEN ds.TotalAmount ELSE 0 END) AS UserDefinedOrders,
        COUNT(CASE WHEN ds.SaleType = ''UserDefined'' THEN 1 END) AS UserDefinedOrderCount,
        MIN(ds.CreatedDate) AS FirstTransaction,
        MAX(ds.CreatedDate) AS LastTransaction
    FROM DailySales ds
    WHERE ds.BranchID = @BranchID
        AND ds.SaleDate = @ReportDate
        AND (@TillID IS NULL OR EXISTS (
            SELECT 1 FROM TillPoints tp 
            WHERE tp.TillNumber = ds.TillNumber 
            AND tp.TillPointID = @TillID
        ))
    GROUP BY ds.TillNumber, ds.CashierName
    ORDER BY ds.TillNumber
END
')

PRINT '  ✓ Cash Up stored procedure updated'

PRINT ''
PRINT '========================================='
PRINT 'SETUP COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'User Defined Orders system is ready to use.'
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '1. Run the POS application'
PRINT '2. Click "User Defined" button to create orders'
PRINT '3. Click "Collect User Defined" to process pickups'
PRINT '4. Use ERP Manufacturing menu to manage orders'
PRINT ''
PRINT 'ORDER NUMBER FORMAT: BranchID + 6 + 5-digit sequence'
PRINT 'Example: 6600001 (Branch 6, sequence 00001)'
PRINT ''
GO

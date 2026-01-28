-- =============================================
-- COMPLETE POS GL INTEGRATION
-- All transaction types with proper accounting treatment
-- =============================================

-- First, ensure all required GL accounts exist
PRINT 'Creating missing GL accounts...'
PRINT '================================'

-- Check and create 1050 - Debtors (Uncleared EFT)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1050')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1050', 'Debtors - Uncleared EFT', 'Asset', 1)
    PRINT '✓ Created account 1050 - Debtors (Uncleared EFT)'
END
ELSE
    PRINT '✓ Account 1050 already exists'

-- Check and create 4020 - Sales Returns
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4020')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('4020', 'Sales Returns', 'Revenue', 1)
    PRINT '✓ Created account 4020 - Sales Returns'
END
ELSE
    PRINT '✓ Account 4020 already exists'

PRINT ''
PRINT 'Dropping existing procedures...'
PRINT '================================'

-- Drop existing procedures
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostSaleToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostSaleToGL

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostRefundToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostRefundToGL

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostOrderDepositToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostOrderDepositToGL

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostOrderCollectionToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostOrderCollectionToGL

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostCashDepositToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostCashDepositToGL

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostEFTClearingToGL' AND type = 'P')
    DROP PROCEDURE sp_POS_PostEFTClearingToGL

PRINT '✓ Dropped existing procedures'
PRINT ''
GO

-- =============================================
-- PROCEDURE 1: POST SALE TO GL
-- Handles: Cash, Card, EFT, and Mixed payments
-- =============================================
CREATE PROCEDURE sp_POS_PostSaleToGL
    @InvoiceNumber NVARCHAR(50),
    @SaleDate DATE,
    @BranchID INT,
    @CashierID INT,
    @Subtotal DECIMAL(18,2),        -- Excl VAT
    @TaxAmount DECIMAL(18,2),       -- VAT amount
    @TotalAmount DECIMAL(18,2),     -- Incl VAT
    @CashAmount DECIMAL(18,2),      -- Cash portion
    @CardAmount DECIMAL(18,2),      -- Card portion
    @EFTAmount DECIMAL(18,2) = 0,   -- EFT portion (optional)
    @TotalCost DECIMAL(18,2),       -- COGS
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @EFTDebtorsAccountID INT
        DECLARE @SalesAccountID INT
        DECLARE @VATAccountID INT
        DECLARE @COGSAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @EFTDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1
        SELECT @SalesAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1
        SELECT @VATAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1
        SELECT @COGSAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number (handle invoice format without dashes)
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @InvoiceNumber) > 0
            SET @SequenceNumber = RIGHT(@InvoiceNumber, CHARINDEX('-', REVERSE(@InvoiceNumber)) - 1)
        ELSE
            SET @SequenceNumber = @InvoiceNumber
        SET @JournalNumber = 'POS-' + @SequenceNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@SaleDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @SaleDate,
            @InvoiceNumber,
            'POS Sale - Invoice ' + @InvoiceNumber,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- DEBIT: Cash on Hand (if cash payment)
        IF @CashAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @CashAccountID, @CashAmount, 0, 'Cash received')
            SET @LineNumber = @LineNumber + 1
        END
        
        -- DEBIT: Bank (if card payment)
        IF @CardAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @BankAccountID, @CardAmount, 0, 'Card payment')
            SET @LineNumber = @LineNumber + 1
        END
        
        -- DEBIT: Debtors - Uncleared EFT (if EFT payment)
        IF @EFTAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @EFTDebtorsAccountID, @EFTAmount, 0, 'EFT pending clearance')
            SET @LineNumber = @LineNumber + 1
        END
        
        -- CREDIT: Sales Revenue (excl VAT)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @SalesAccountID, 0, @Subtotal, 'Sales revenue')
        SET @LineNumber = @LineNumber + 1
        
        -- CREDIT: VAT Output
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @VATAccountID, 0, @TaxAmount, 'VAT collected')
        SET @LineNumber = @LineNumber + 1
        
        -- DEBIT: Cost of Goods Sold
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @COGSAccountID, @TotalCost, 0, 'Cost of goods sold')
            SET @LineNumber = @LineNumber + 1
            
            -- CREDIT: Inventory
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @InventoryAccountID, 0, @TotalCost, 'Inventory reduction')
        END
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'POS sale posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostSaleToGL'
GO

-- =============================================
-- PROCEDURE 2: POST ORDER DEPOSIT TO GL
-- Records customer deposit as liability
-- =============================================
CREATE PROCEDURE sp_POS_PostOrderDepositToGL
    @OrderNumber NVARCHAR(50),
    @DepositDate DATE,
    @BranchID INT,
    @CashierID INT,
    @DepositAmount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(20),    -- Cash, Card, or EFT
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @EFTDebtorsAccountID INT
        DECLARE @CustomerDepositsAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @EFTDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1
        SELECT @CustomerDepositsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        
        -- Generate journal number
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @OrderNumber) > 0
            SET @SequenceNumber = RIGHT(@OrderNumber, CHARINDEX('-', REVERSE(@OrderNumber)) - 1)
        ELSE
            SET @SequenceNumber = @OrderNumber
        SET @JournalNumber = 'DEP-' + @SequenceNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@DepositDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @DepositDate,
            @OrderNumber,
            'Order Deposit - ' + @OrderNumber,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Cash/Bank/EFT Debtors (based on payment method)
        DECLARE @DebitAccountID INT
        DECLARE @DebitDescription NVARCHAR(100)
        
        IF @PaymentMethod = 'Cash'
        BEGIN
            SET @DebitAccountID = @CashAccountID
            SET @DebitDescription = 'Deposit received (Cash)'
        END
        ELSE IF @PaymentMethod = 'Card'
        BEGIN
            SET @DebitAccountID = @BankAccountID
            SET @DebitDescription = 'Deposit received (Card)'
        END
        ELSE IF @PaymentMethod = 'EFT'
        BEGIN
            SET @DebitAccountID = @EFTDebtorsAccountID
            SET @DebitDescription = 'Deposit received (EFT - pending)'
        END
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @DebitAccountID, @DepositAmount, 0, @DebitDescription)
        
        -- CREDIT: Customer Deposits (Liability)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @CustomerDepositsAccountID, 0, @DepositAmount, 'Customer deposit liability')
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Order deposit posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostOrderDepositToGL'
GO

-- =============================================
-- PROCEDURE 3: POST ORDER COLLECTION TO GL
-- Clears deposit liability and records sale
-- =============================================
CREATE PROCEDURE sp_POS_PostOrderCollectionToGL
    @OrderNumber NVARCHAR(50),
    @InvoiceNumber NVARCHAR(50),
    @CollectionDate DATE,
    @BranchID INT,
    @CashierID INT,
    @TotalAmount DECIMAL(18,2),     -- Total order value (incl VAT)
    @Subtotal DECIMAL(18,2),        -- Excl VAT
    @TaxAmount DECIMAL(18,2),       -- VAT amount
    @DepositAmount DECIMAL(18,2),   -- Previously paid deposit
    @BalanceAmount DECIMAL(18,2),   -- Balance due
    @BalancePaymentMethod NVARCHAR(20), -- How balance was paid (Cash/Card/EFT)
    @TotalCost DECIMAL(18,2),       -- COGS
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @EFTDebtorsAccountID INT
        DECLARE @CustomerDepositsAccountID INT
        DECLARE @SalesAccountID INT
        DECLARE @VATAccountID INT
        DECLARE @COGSAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @EFTDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1
        SELECT @CustomerDepositsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        SELECT @SalesAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1
        SELECT @VATAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1
        SELECT @COGSAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @InvoiceNumber) > 0
            SET @SequenceNumber = RIGHT(@InvoiceNumber, CHARINDEX('-', REVERSE(@InvoiceNumber)) - 1)
        ELSE
            SET @SequenceNumber = @InvoiceNumber
        SET @JournalNumber = 'ORD-' + @SequenceNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@CollectionDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @CollectionDate,
            @InvoiceNumber,
            'Order Collection - ' + @OrderNumber,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- DEBIT: Clear Customer Deposit Liability
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @CustomerDepositsAccountID, @DepositAmount, 0, 'Clear deposit liability')
        SET @LineNumber = @LineNumber + 1
        
        -- DEBIT: Balance payment (Cash/Card/EFT based on payment method)
        IF @BalanceAmount > 0
        BEGIN
            DECLARE @BalanceAccountID INT
            DECLARE @BalanceDescription NVARCHAR(100)
            
            IF @BalancePaymentMethod = 'Cash'
            BEGIN
                SET @BalanceAccountID = @CashAccountID
                SET @BalanceDescription = 'Balance paid (Cash)'
            END
            ELSE IF @BalancePaymentMethod = 'Card'
            BEGIN
                SET @BalanceAccountID = @BankAccountID
                SET @BalanceDescription = 'Balance paid (Card)'
            END
            ELSE IF @BalancePaymentMethod = 'EFT'
            BEGIN
                SET @BalanceAccountID = @EFTDebtorsAccountID
                SET @BalanceDescription = 'Balance paid (EFT - pending)'
            END
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @BalanceAccountID, @BalanceAmount, 0, @BalanceDescription)
            SET @LineNumber = @LineNumber + 1
        END
        
        -- CREDIT: Sales Revenue (excl VAT)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @SalesAccountID, 0, @Subtotal, 'Sales revenue')
        SET @LineNumber = @LineNumber + 1
        
        -- CREDIT: VAT Output
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @VATAccountID, 0, @TaxAmount, 'VAT collected')
        SET @LineNumber = @LineNumber + 1
        
        -- DEBIT: Cost of Goods Sold
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @COGSAccountID, @TotalCost, 0, 'Cost of goods sold')
            SET @LineNumber = @LineNumber + 1
            
            -- CREDIT: Inventory
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @InventoryAccountID, 0, @TotalCost, 'Inventory reduction')
        END
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Order collection posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostOrderCollectionToGL'
GO

-- =============================================
-- PROCEDURE 4: POST REFUND TO GL
-- Reverses sale and returns payment
-- =============================================
CREATE PROCEDURE sp_POS_PostRefundToGL
    @ReturnNumber NVARCHAR(50),
    @RefundDate DATE,
    @BranchID INT,
    @CashierID INT,
    @Subtotal DECIMAL(18,2),        -- Excl VAT
    @TaxAmount DECIMAL(18,2),       -- VAT amount
    @TotalAmount DECIMAL(18,2),     -- Incl VAT
    @RefundMethod NVARCHAR(20),     -- Cash or Card
    @TotalCost DECIMAL(18,2),       -- COGS to reverse
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @SalesReturnsAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @COGSAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @SalesReturnsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4020' AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @COGSAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @ReturnNumber) > 0
            SET @SequenceNumber = RIGHT(@ReturnNumber, CHARINDEX('-', REVERSE(@ReturnNumber)) - 1)
        ELSE
            SET @SequenceNumber = @ReturnNumber
        SET @JournalNumber = 'REF-' + @SequenceNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@RefundDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @RefundDate,
            @ReturnNumber,
            'Refund - Return ' + @ReturnNumber,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- DEBIT: Sales Returns (contra-revenue)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @SalesReturnsAccountID, @Subtotal, 0, 'Sales return')
        SET @LineNumber = @LineNumber + 1
        
        -- DEBIT: VAT Input (claim back VAT)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @VATInputAccountID, @TaxAmount, 0, 'VAT refunded')
        SET @LineNumber = @LineNumber + 1
        
        -- DEBIT: Inventory (stock returned)
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @InventoryAccountID, @TotalCost, 0, 'Stock returned')
            SET @LineNumber = @LineNumber + 1
        END
        
        -- CREDIT: Cash/Bank (refund payment)
        DECLARE @RefundAccountID INT
        DECLARE @RefundDescription NVARCHAR(100)
        
        IF @RefundMethod = 'Cash'
        BEGIN
            SET @RefundAccountID = @CashAccountID
            SET @RefundDescription = 'Cash refunded'
        END
        ELSE
        BEGIN
            SET @RefundAccountID = @BankAccountID
            SET @RefundDescription = 'Card refund'
        END
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @LineNumber, @RefundAccountID, 0, @TotalAmount, @RefundDescription)
        SET @LineNumber = @LineNumber + 1
        
        -- CREDIT: COGS (reverse cost)
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @LineNumber, @COGSAccountID, 0, @TotalCost, 'Reverse COGS')
        END
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Refund posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostRefundToGL'
GO

-- =============================================
-- PROCEDURE 5: POST CASH DEPOSIT TO BANK
-- Transfer Cash on Hand to Bank
-- =============================================
CREATE PROCEDURE sp_POS_PostCashDepositToGL
    @DepositReference NVARCHAR(50),
    @DepositDate DATE,
    @BranchID INT,
    @DepositAmount DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'CDEP-' + @DepositReference
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@DepositDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @DepositDate,
            @DepositReference,
            'Cash Deposit to Bank - ' + @DepositReference,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Bank
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @BankAccountID, @DepositAmount, 0, 'Cash deposited to bank')
        
        -- CREDIT: Cash on Hand
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @CashAccountID, 0, @DepositAmount, 'Cash removed from till')
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Cash deposit posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostCashDepositToGL'
GO

-- =============================================
-- PROCEDURE 6: POST EFT CLEARING TO BANK
-- Transfer Uncleared EFT to Bank
-- =============================================
CREATE PROCEDURE sp_POS_PostEFTClearingToGL
    @ClearingReference NVARCHAR(50),
    @ClearingDate DATE,
    @BranchID INT,
    @ClearingAmount DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @EFTDebtorsAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @EFTDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'EFTC-' + @ClearingReference
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@ClearingDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @ClearingDate,
            @ClearingReference,
            'EFT Clearing - ' + @ClearingReference,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Bank
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @BankAccountID, @ClearingAmount, 0, 'EFT cleared to bank')
        
        -- CREDIT: Debtors - Uncleared EFT
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @EFTDebtorsAccountID, 0, @ClearingAmount, 'Clear pending EFT')
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'EFT clearing posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_POS_PostEFTClearingToGL'
GO

PRINT ''
PRINT '========================================='
PRINT 'POS GL INTEGRATION COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Procedures created:'
PRINT '1. sp_POS_PostSaleToGL - Sales (Cash/Card/EFT/Mixed)'
PRINT '2. sp_POS_PostOrderDepositToGL - Order deposits'
PRINT '3. sp_POS_PostOrderCollectionToGL - Order fulfillment'
PRINT '4. sp_POS_PostRefundToGL - Refunds'
PRINT '5. sp_POS_PostCashDepositToGL - Cash deposits to bank'
PRINT '6. sp_POS_PostEFTClearingToGL - EFT clearing'
PRINT ''
PRINT 'GL Accounts required:'
PRINT '1010 - Bank'
PRINT '1030 - Cash on Hand'
PRINT '1050 - Debtors (Uncleared EFT)'
PRINT '1220 - Inventory'
PRINT '2010 - Customer Deposits'
PRINT '2020 - VAT Output'
PRINT '2021 - VAT Input'
PRINT '4010 - Sales Revenue'
PRINT '4020 - Sales Returns'
PRINT '5010 - Cost of Goods Sold'
PRINT ''

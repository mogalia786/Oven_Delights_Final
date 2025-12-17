-- =============================================
-- IBT System Setup Guide
-- =============================================

-- STEP 1: Create Tables
-- Execute CREATE_IBT_WORKFLOW_TABLES.sql first

-- STEP 2: Verify Branch Setup
SELECT BranchID, BranchCode, BranchName, Address, IsActive
FROM Branches
ORDER BY BranchID;

-- Ensure branches have:
-- - BranchCode (e.g., 'B4', 'B6')
-- - BranchName
-- - Address (for delivery notes)

-- STEP 3: Verify Products Have Cost Prices
SELECT p.ProductID, p.Name, p.ProductType, p.Category, p.IsActive,
       rp.BranchID, rp.CostPrice, rp.EffectiveFrom
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID
WHERE p.IsActive = 1
  AND (p.ProductType <> 'Internal' OR p.ProductType IS NULL)
ORDER BY p.Name, rp.BranchID;

-- Products should have cost prices in Demo_Retail_Price for each branch

-- STEP 4: Test Workflow

-- 4a. Create Internal PO (Branch 4 requests from Branch 6)
-- Use Form: InternalPurchaseOrderForm
-- Or manually:
/*
INSERT INTO InternalPurchaseOrders 
(PONumber, RequestingBranchID, SupplyingBranchID, ProductID, Quantity, RequestedDate, RequiredByDate, Status, CreatedBy, CreatedDate)
VALUES 
('B4-i-PO-IBT-00001', 4, 6, 36864, 50, GETDATE(), DATEADD(DAY, 7, GETDATE()), 'Pending', 1, GETDATE());
*/

-- 4b. View Pending Requests
SELECT po.InternalPOID, po.PONumber, po.RequestedDate,
       rb.BranchName AS RequestingBranch,
       sb.BranchName AS SupplyingBranch,
       p.Name AS ProductName, po.Quantity, po.Status
FROM InternalPurchaseOrders po
INNER JOIN Branches rb ON po.RequestingBranchID = rb.BranchID
INNER JOIN Branches sb ON po.SupplyingBranchID = sb.BranchID
INNER JOIN Demo_Retail_Product p ON po.ProductID = p.ProductID
WHERE po.Status = 'Pending'
ORDER BY po.RequestedDate DESC;

-- 4c. Approve Request
/*
UPDATE InternalPurchaseOrders
SET Status = 'Approved', ApprovedBy = 1, ApprovedDate = GETDATE()
WHERE InternalPOID = 1;
*/

-- 4d. View In-Transit Deliveries
SELECT dn.DeliveryNoteID, dn.DeliveryNoteNumber, dn.DispatchDate,
       fb.BranchName AS FromBranch, tb.BranchName AS ToBranch,
       p.Name AS ProductName, dn.Quantity, dn.TotalValue, dn.Status
FROM InternalDeliveryNotes dn
INNER JOIN Branches fb ON dn.FromBranchID = fb.BranchID
INNER JOIN Branches tb ON dn.ToBranchID = tb.BranchID
INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
WHERE dn.Status = 'In Transit'
ORDER BY dn.DispatchDate DESC;

-- 4e. View Delivered Items
SELECT dn.DeliveryNoteNumber, po.PONumber, dn.DispatchDate, dn.ReceiveDate,
       fb.BranchName AS FromBranch, tb.BranchName AS ToBranch,
       p.Name AS ProductName, dn.Quantity, dn.TotalValue,
       u.Username AS ReceivedBy
FROM InternalDeliveryNotes dn
INNER JOIN Branches fb ON dn.FromBranchID = fb.BranchID
INNER JOIN Branches tb ON dn.ToBranchID = tb.BranchID
INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
LEFT JOIN Users u ON dn.ReceivedBy = u.UserID
WHERE dn.Status = 'Delivered'
ORDER BY dn.ReceiveDate DESC;

-- 4f. View Inter-Branch Ledger
SELECT l.LedgerID, l.TransactionDate,
       db.BranchName AS DebtorBranch,
       cb.BranchName AS CreditorBranch,
       dn.DeliveryNoteNumber, po.PONumber,
       l.Amount, l.Status, l.SettlementDate
FROM InterBranchLedger l
INNER JOIN Branches db ON l.DebtorBranchID = db.BranchID
INNER JOIN Branches cb ON l.CreditorBranchID = cb.BranchID
INNER JOIN InternalDeliveryNotes dn ON l.DeliveryNoteID = dn.DeliveryNoteID
INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
ORDER BY l.TransactionDate DESC;

-- 4g. Calculate Outstanding Balances per Branch
SELECT 
    db.BranchName AS DebtorBranch,
    cb.BranchName AS CreditorBranch,
    SUM(l.Amount) AS TotalOutstanding
FROM InterBranchLedger l
INNER JOIN Branches db ON l.DebtorBranchID = db.BranchID
INNER JOIN Branches cb ON l.CreditorBranchID = cb.BranchID
WHERE l.Status = 'Outstanding'
GROUP BY db.BranchName, cb.BranchName
ORDER BY TotalOutstanding DESC;

-- STEP 5: Cleanup (if needed for testing)
/*
-- WARNING: This will delete all IBT data!
DELETE FROM InterBranchLedger;
DELETE FROM InternalDeliveryNotes;
DELETE FROM InternalPurchaseOrders;
*/

-- STEP 6: Verify Stock Movements
SELECT sm.MovementDate, sm.MovementType, sm.Quantity, sm.Reference,
       b.BranchName, p.Name AS ProductName, u.Username AS CreatedBy
FROM StockMovements sm
INNER JOIN Branches b ON sm.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON sm.ProductID = p.ProductID
LEFT JOIN Users u ON sm.CreatedBy = u.UserID
WHERE sm.MovementType IN ('IBT Dispatch', 'IBT Receipt')
ORDER BY sm.MovementDate DESC;

-- =============================================
-- Troubleshooting
-- =============================================

-- Issue: No products showing in Request Products form
-- Solution: Check products are active and not Internal manufactured
SELECT ProductID, Name, ProductType, Category, IsActive
FROM Demo_Retail_Product
WHERE IsActive = 1
  AND (ProductType <> 'Internal' OR ProductType IS NULL)
ORDER BY Name;

-- Issue: No cost price found
-- Solution: Add cost prices to Demo_Retail_Price
/*
INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, EffectiveFrom)
VALUES (36864, 6, 9.83, GETDATE());
*/

-- Issue: Branch code not found
-- Solution: Ensure branches have BranchCode
/*
UPDATE Branches SET BranchCode = 'B4' WHERE BranchID = 4;
UPDATE Branches SET BranchCode = 'B6' WHERE BranchID = 6;
*/

-- Issue: Delivery note not showing branch address
-- Solution: Ensure branches have Address
/*
UPDATE Branches SET Address = '123 Main St, City, Country' WHERE BranchID = 4;
*/

PRINT 'IBT Setup Guide Complete!';

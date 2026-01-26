-- Check what BranchID Head Office actually has
USE Oven_Delights_Main
GO

SELECT 
    BranchID, 
    BranchName, 
    IsActive,
    CASE 
        WHEN BranchID = 1 THEN '✓ Code expects this to be Head Office'
        ELSE '✗ Code expects BranchID = 1 for Head Office'
    END AS CodeExpectation
FROM Branches 
WHERE BranchName LIKE '%Head%' 
   OR BranchName LIKE '%HO%'
   OR BranchName LIKE '%Office%'
   OR BranchID = 1
ORDER BY BranchID

PRINT ''
PRINT '=== SOLUTION ==='
PRINT 'If Head Office is NOT BranchID = 1, you need to update MainDashboard.vb:'
PRINT '1. Find line 515: AppSession.CurrentBranchID = 1'
PRINT '2. Find line 539: AppSession.CurrentBranchID = 1'
PRINT '3. Change both to match your actual Head Office BranchID'
PRINT ''
PRINT 'OR temporarily test by changing line 515 to:'
PRINT 'If AppSession.CurrentRoleName = "Super Administrator" Then'
PRINT '(This will show menu for Super Admin at ANY branch)'

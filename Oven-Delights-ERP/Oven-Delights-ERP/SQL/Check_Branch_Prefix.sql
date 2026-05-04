-- Check Branch Prefix values
SELECT BranchID, BranchCode, BranchName, Prefix 
FROM Branches 
WHERE BranchCode IN ('OD200', 'OD400');

-- Check if there are any active branches for the INSERT to work
SELECT BranchID, BranchName, IsActive
FROM Branches
WHERE IsActive = 1;

-- If no active branches, the INSERT won't create any rows

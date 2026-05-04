# JARVIS Executive Dashboard Troubleshooting

## Issue: Dashboard Menu Not Appearing

The Sales Analytics Dashboard menu should appear in Administration menu when:
1. User is logged in as **Super Administrator**
2. **Head Office** branch is selected (BranchID = 1)

## Quick Test

Run this in your database to check your current session:

```sql
-- Check what BranchID Head Office has
SELECT BranchID, BranchName FROM Branches WHERE BranchName LIKE '%Head%Office%' OR BranchName LIKE '%HO%'

-- If Head Office is NOT BranchID = 1, update the code:
-- Change line 515 and 539 in MainDashboard.vb from:
-- AppSession.CurrentBranchID = 1
-- TO:
-- AppSession.CurrentBranchID = [YOUR_HEAD_OFFICE_BRANCH_ID]
```

## Debugging Steps

1. **Check if you're Super Admin:**
   - Look at the top of the main window - does it say "Super Administrator"?
   
2. **Check which branch is selected:**
   - Look at the branch selector - is "Head Office" selected?
   
3. **Check the BranchID:**
   - Run the SQL above to see what BranchID Head Office actually has
   - If it's NOT 1, you need to update the code

4. **Restart the application:**
   - Close the ERP completely
   - Log in again as Super Administrator
   - Select Head Office branch
   - Check Administration menu

## Alternative: Force Menu to Always Show (For Testing)

If you want to test the dashboard regardless of branch, temporarily change line 515 in MainDashboard.vb:

**FROM:**
```vb
If AppSession.CurrentRoleName = "Super Administrator" AndAlso AppSession.CurrentBranchID = 1 Then
```

**TO:**
```vb
If AppSession.CurrentRoleName = "Super Administrator" Then
```

This will show the menu for Super Admin at ANY branch (for testing only).

## What BranchID is Head Office?

The code assumes Head Office = BranchID 1. If your Head Office has a different BranchID, you need to update:
- Line 515 in MainDashboard.vb
- Line 539 in MainDashboard.vb

Change both instances of `AppSession.CurrentBranchID = 1` to match your actual Head Office BranchID.

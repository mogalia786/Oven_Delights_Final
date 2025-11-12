# BRANCH LOCK - BULK UPDATE GUIDE

## ✅ COMPLETED FORMS:
1. **PurchaseOrderFormNew.vb** - Updated
2. **PurchaseOrderForm.vb** - Updated  
3. **POSForm.vb** - Updated
4. **GeneralLedgerViewerForm.vb** - Updated

---

## 🔧 FIND & REPLACE PATTERNS

### Pattern 1: Simple Enable/Disable
**FIND:**
```vb
If Not isSuperAdmin Then
    cboBranch.Enabled = False
End If
```

**REPLACE WITH:**
```vb
BranchHelper.LockBranchDropdown(cboBranch, isSuperAdmin, currentBranchId)
```

---

### Pattern 2: Visible Control
**FIND:**
```vb
If Not isSuperAdmin Then
    lblBranch.Visible = False
    cboBranch.Visible = False
End If
```

**REPLACE WITH:**
```vb
BranchHelper.LockBranchDropdown(cboBranch, isSuperAdmin, currentBranchId)
lblBranch.Visible = cboBranch.Visible
```

---

### Pattern 3: Conditional Branch Setup
**FIND:**
```vb
If isSuperAdmin Then
    branches = service.GetBranchesLookup()
    cboBranch.DataSource = branches
    cboBranch.DisplayMember = "BranchName"
    cboBranch.ValueMember = "BranchID"
    cboBranch.Visible = True
End If
```

**REPLACE WITH:**
```vb
' Load branches for all users
branches = service.GetBranchesLookup()
cboBranch.DataSource = branches
cboBranch.DisplayMember = "BranchName"
cboBranch.ValueMember = "BranchID"
cboBranch.SelectedValue = currentBranchId

' Lock branch dropdown for non-super admins
BranchHelper.LockBranchDropdown(cboBranch, isSuperAdmin, currentBranchId)
```

---

### Pattern 4: Getting Branch ID
**FIND:**
```vb
Dim branchId As Integer
If isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing Then
    branchId = Convert.ToInt32(cboBranch.SelectedValue)
Else
    branchId = currentBranchId
End If
```

**REPLACE WITH:**
```vb
Dim branchId As Integer = BranchHelper.GetEffectiveBranchId(cboBranch, isSuperAdmin, currentBranchId)
```

---

## 📋 REMAINING FORMS TO UPDATE

Use Visual Studio's **Find in Files** (Ctrl+Shift+F):
- Search for: `cboBranch.Enabled = False`
- Search for: `cboBranch.Visible = False`
- Search for: `If isSuperAdmin Then` (near cboBranch code)

### High Priority (Transaction Forms):
- [ ] GRVCreateForm.vb
- [ ] GRVManagementForm.vb
- [ ] POReceivingForm.vb
- [ ] ManufacturingReceivingForm.vb

### Medium Priority (Reports):
- [ ] JournalViewerForm.vb
- [ ] SupplierLedgerForm.vb
- [ ] AccountLedgerForm.vb
- [ ] TrialBalanceForm.vb
- [ ] CashBookJournalForm.vb
- [ ] SalesReportForm.vb
- [ ] InventoryReportForm.vb
- [ ] LowStockReportForm.vb
- [ ] StockOverviewForm.vb
- [ ] ManufacturingStockReportForm.vb
- [ ] RetailProductsStockReportForm.vb
- [ ] StockFlowReportForm.vb
- [ ] BranchPerformanceReportForm.vb
- [ ] SlowMovingStockReportForm.vb

### Lower Priority (Admin/Setup):
- [ ] ProductUpsertForm.vb
- [ ] ProductionScheduleForm.vb
- [ ] UserAddEditForm.vb
- [ ] RoleAssignmentForm.vb
- [ ] PayrollEntryForm.vb
- [ ] StaffAddEditForm.vb
- [ ] SupplierAddEditForm.vb

---

## 🚀 QUICK UPDATE STEPS

1. **Open each form** in the list
2. **Press Ctrl+F** (Find)
3. **Search for:** `cboBranch`
4. **Locate the code** that sets Enabled or Visible
5. **Apply the appropriate pattern** from above
6. **Save the file**
7. **Check off** the form in the list

---

## ⚠️ IMPORTANT NOTES

1. **Always check** if `isSuperAdmin` and `currentBranchId` variables exist in the form
2. **If missing**, add them:
   ```vb
   Private isSuperAdmin As Boolean = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
   Private currentBranchId As Integer = If(AppSession.CurrentUser?.BranchID, 0)
   ```

3. **Test after updating** each critical form (PO, Invoice, Reports)

---

## ✅ VERIFICATION

After updating all forms:
1. **Login as Super Admin** - Branch dropdown should be **enabled**
2. **Login as Regular User** - Branch dropdown should be **disabled** (grayed out)
3. **Check all forms** - PO, Reports, Accounting, etc.

---

## 🎯 CURRENT STATUS

**4 of ~32 forms updated**
**Remaining: ~28 forms**

**Estimated time:** 1-2 minutes per form = 30-60 minutes total

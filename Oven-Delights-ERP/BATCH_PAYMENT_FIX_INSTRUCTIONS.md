# BATCH PAYMENT FIX - FINAL INSTRUCTIONS

## The Problem

The error shows: **"Violation of UNIQUE KEY constraint UQ_Supplier_B2C1733B621B125"**

This happens because:
1. When you first tried to process the batch, it created some payment records
2. The process failed partway through
3. Those payment records are still in the database
4. When you try again, it tries to create them again → duplicate key error

## The Solution

The new stored procedure **DELETES any existing payments for the batch FIRST**, then creates fresh ones.

```sql
-- CRITICAL FIX: Delete any existing payments for this batch first
DELETE FROM SupplierInvoicePayments
WHERE PaymentID IN (SELECT PaymentID FROM SupplierPayments WHERE BatchID = @BatchID);

DELETE FROM SupplierPayments
WHERE BatchID = @BatchID;
```

---

## Deploy Instructions

### Step 1: Run This SQL Script
```sql
SQL\FIX_BATCH_PAYMENT_FINAL.sql
```

This will:
- Show you what the unique constraint is
- Replace the `sp_ProcessPaymentBatch` stored procedure
- Add cleanup logic to delete old payments before creating new ones

### Step 2: Try Processing the Batch Again
1. Go to Batch Invoice Payment
2. Select the batch (PB-00006)
3. Click "Process Payment"
4. **Should work now!**

---

## What If It Still Fails?

If it still gives an error, run this diagnostic script first:

```sql
SQL\CHECK_SUPPLIER_PAYMENTS_CONSTRAINT.sql
```

This will show:
1. What the unique constraint actually is
2. What payments already exist for this batch
3. What invoices are in the batch

Then we can fix it based on the actual constraint.

---

## How It Works Now

### Old Logic (BROKEN):
```
1. Try to create payment for Supplier A
2. Try to create payment for Supplier B
3. ERROR: Payment for Supplier A already exists!
```

### New Logic (FIXED):
```
1. DELETE all payments for this batch
2. Create fresh payment for Supplier A
3. Create fresh payment for Supplier B
4. SUCCESS!
```

---

## Summary

**Run:** `SQL\FIX_BATCH_PAYMENT_FINAL.sql`  
**Then:** Try processing the batch again  
**Result:** Should work without duplicate key error

The fix ensures a clean slate by deleting any partial payments before creating new ones.

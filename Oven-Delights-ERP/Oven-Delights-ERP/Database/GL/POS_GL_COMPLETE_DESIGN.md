# COMPLETE POS GL INTEGRATION DESIGN

## GL ACCOUNTS REQUIRED

| Code | Account Name | Type | Purpose |
|------|-------------|------|---------|
| **1010** | Bank - Current Account | Asset | Card payments, cleared EFTs, deposited cash |
| **1030** | Cash on Hand | Asset | Cash sales (until deposited) |
| **1050** | Debtors - Uncleared EFT | Asset | EFT payments (until bank confirms) |
| **1220** | Inventory - Retail Stock | Asset | Product inventory value |
| **2010** | Customer Deposits | Liability | Order deposits received (not yet fulfilled) |
| **2020** | VAT Output (Payable) | Liability | VAT collected on sales |
| **2021** | VAT Input (Receivable) | Asset | VAT paid on refunds |
| **4010** | Sales Revenue - Retail | Revenue | Sales income |
| **4020** | Sales Returns | Contra-Revenue | Refunds (reduces revenue) |
| **5010** | Cost of Goods Sold | Expense | Cost of products sold |

---

## TRANSACTION TYPE 1: CASH SALE

**Scenario:** Customer pays R115 cash (R100 + R15 VAT), product cost R60

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1030 - Cash on Hand | 115.00 | | Cash received |
| 4010 - Sales Revenue | | 100.00 | Sale (excl VAT) |
| 2020 - VAT Output | | 15.00 | VAT collected |
| 5010 - COGS | 60.00 | | Cost of sale |
| 1220 - Inventory | | 60.00 | Reduce stock |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

---

## TRANSACTION TYPE 2: CARD SALE

**Scenario:** Customer pays R115 by card (R100 + R15 VAT), product cost R60

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1010 - Bank | 115.00 | | Card payment (immediate) |
| 4010 - Sales Revenue | | 100.00 | Sale (excl VAT) |
| 2020 - VAT Output | | 15.00 | VAT collected |
| 5010 - COGS | 60.00 | | Cost of sale |
| 1220 - Inventory | | 60.00 | Reduce stock |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

---

## TRANSACTION TYPE 3: EFT SALE

**Scenario:** Customer pays R115 by EFT (R100 + R15 VAT), product cost R60

### Journal Entry (At Sale):
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1050 - Debtors (Uncleared EFT) | 115.00 | | EFT pending |
| 4010 - Sales Revenue | | 100.00 | Sale (excl VAT) |
| 2020 - VAT Output | | 15.00 | VAT collected |
| 5010 - COGS | 60.00 | | Cost of sale |
| 1220 - Inventory | | 60.00 | Reduce stock |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

### Journal Entry (When EFT Clears):
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1010 - Bank | 115.00 | | EFT cleared |
| 1050 - Debtors (Uncleared EFT) | | 115.00 | Clear pending EFT |

**Balanced:** Debit 115.00 = Credit 115.00 ✓

---

## TRANSACTION TYPE 4: MIXED PAYMENT SALE

**Scenario:** Customer pays R50 cash + R65 card (R100 + R15 VAT), product cost R60

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1030 - Cash on Hand | 50.00 | | Cash portion |
| 1010 - Bank | 65.00 | | Card portion |
| 4010 - Sales Revenue | | 100.00 | Sale (excl VAT) |
| 2020 - VAT Output | | 15.00 | VAT collected |
| 5010 - COGS | 60.00 | | Cost of sale |
| 1220 - Inventory | | 60.00 | Reduce stock |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

---

## TRANSACTION TYPE 5: ORDER DEPOSIT (Cash)

**Scenario:** Customer pays R200 deposit for future order

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1030 - Cash on Hand | 200.00 | | Deposit received |
| 2010 - Customer Deposits | | 200.00 | Liability until fulfilled |

**Balanced:** Debit 200.00 = Credit 200.00 ✓

**Note:** No revenue recognized yet, no inventory movement, no VAT

---

## TRANSACTION TYPE 6: ORDER COLLECTION (Balance Due)

**Scenario:** Customer collects order, total R500 (R434.78 + R65.22 VAT), deposit R200, balance R300 paid by card, product cost R250

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 2010 - Customer Deposits | 200.00 | | Clear deposit liability |
| 1010 - Bank | 300.00 | | Balance paid by card |
| 4010 - Sales Revenue | | 434.78 | Sale (excl VAT) |
| 2020 - VAT Output | | 65.22 | VAT collected |
| 5010 - COGS | 250.00 | | Cost of sale |
| 1220 - Inventory | | 250.00 | Reduce stock |

**Balanced:** Debit 750.00 = Credit 750.00 ✓

---

## TRANSACTION TYPE 7: CASH REFUND

**Scenario:** Customer returns product, refund R115 cash (R100 + R15 VAT), product cost R60

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 4020 - Sales Returns | 100.00 | | Reverse revenue |
| 2021 - VAT Input | 15.00 | | VAT refunded (claim back) |
| 1220 - Inventory | 60.00 | | Stock returned |
| 1030 - Cash on Hand | | 115.00 | Cash refunded |
| 5010 - COGS | | 60.00 | Reverse COGS |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

---

## TRANSACTION TYPE 8: CARD REFUND

**Scenario:** Customer returns product, refund R115 to card (R100 + R15 VAT), product cost R60

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 4020 - Sales Returns | 100.00 | | Reverse revenue |
| 2021 - VAT Input | 15.00 | | VAT refunded |
| 1220 - Inventory | 60.00 | | Stock returned |
| 1010 - Bank | | 115.00 | Card refund |
| 5010 - COGS | | 60.00 | Reverse COGS |

**Balanced:** Debit 175.00 = Credit 175.00 ✓

---

## TRANSACTION TYPE 9: CASH DEPOSIT TO BANK

**Scenario:** End of day, deposit R5,000 cash to bank

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1010 - Bank | 5,000.00 | | Cash deposited |
| 1030 - Cash on Hand | | 5,000.00 | Reduce cash on hand |

**Balanced:** Debit 5,000.00 = Credit 5,000.00 ✓

**Triggered by:** End of Day Cash-Up process or manual deposit entry

---

## TRANSACTION TYPE 10: EFT CLEARING

**Scenario:** Bank confirms R2,300 EFT received

### Journal Entry:
| Account | Debit | Credit | Description |
|---------|-------|--------|-------------|
| 1010 - Bank | 2,300.00 | | EFT cleared |
| 1050 - Debtors (Uncleared EFT) | | 2,300.00 | Clear pending EFT |

**Balanced:** Debit 2,300.00 = Credit 2,300.00 ✓

**Triggered by:** Bank reconciliation or manual EFT clearing entry

---

## STORED PROCEDURES NEEDED

### Sales Procedures:
1. **sp_POS_PostSaleToGL** - Handle all sale types (Cash/Card/EFT/Mixed)
2. **sp_POS_PostOrderDepositToGL** - Record order deposits
3. **sp_POS_PostOrderCollectionToGL** - Record order fulfillment
4. **sp_POS_PostRefundToGL** - Handle all refund types

### Banking Procedures:
5. **sp_POS_PostCashDepositToGL** - Transfer Cash on Hand → Bank
6. **sp_POS_PostEFTClearingToGL** - Transfer Uncleared EFT → Bank

---

## IMPLEMENTATION PRIORITY

### Phase 1 (Immediate):
1. ✅ Fix sp_POS_PostSaleToGL to handle Cash/Card/EFT correctly
2. ✅ Fix sp_POS_PostRefundToGL to handle Cash/Card correctly
3. ✅ Create account 1050 (Debtors - Uncleared EFT)
4. ✅ Create account 2010 (Customer Deposits)
5. ✅ Create account 4020 (Sales Returns)

### Phase 2 (Next):
6. Create sp_POS_PostOrderDepositToGL
7. Create sp_POS_PostOrderCollectionToGL
8. Update POS code to call deposit/collection procedures

### Phase 3 (Banking):
9. Create sp_POS_PostCashDepositToGL
10. Create sp_POS_PostEFTClearingToGL
11. Add UI for cash deposit entry
12. Add UI for EFT clearing entry

---

## BENEFITS OF THIS APPROACH

✅ **Accurate Cash Flow:** Know exactly how much cash vs bank balance you have
✅ **EFT Tracking:** See pending EFTs vs cleared funds
✅ **Proper VAT:** Separate VAT Output (sales) from VAT Input (refunds)
✅ **Inventory Control:** Real-time COGS and inventory valuation
✅ **Deposit Management:** Track customer deposits as liabilities
✅ **Audit Trail:** Every transaction has complete double-entry journal
✅ **Financial Reporting:** Accurate P&L and Balance Sheet

---

## NEXT STEPS

1. Run TOMORROW_DIAGNOSTIC_PLAN.sql to check current state
2. Create missing GL accounts (1050, 2010, 4020)
3. Update sp_POS_PostSaleToGL for Cash/Card/EFT treatment
4. Update sp_POS_PostRefundToGL for proper reversals
5. Create order deposit and collection procedures
6. Test each transaction type end-to-end
7. Deploy to production

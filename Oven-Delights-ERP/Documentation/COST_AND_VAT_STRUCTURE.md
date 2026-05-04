# Cost and VAT Structure in Oven Delights ERP

## Current Implementation

### Cost Basis
All costs in the system are currently stored as **EXCLUSIVE of VAT** (before tax).

This means:
- Ingredient costs = Purchase price BEFORE VAT
- Sub-recipe costs = Sum of ingredient costs (no VAT)
- Product manufacturing costs = Sum of all component costs (no VAT)
- POS selling prices = Retail price BEFORE VAT

### Why Exclusive Costs?
1. **Accurate Cost Tracking**: Businesses need to know the true cost of goods without tax
2. **VAT Reclaim**: VAT paid on purchases can be reclaimed from SARS
3. **Profit Calculation**: Gross profit = Selling Price (excl VAT) - Cost (excl VAT)
4. **Financial Reporting**: Standard accounting practice uses exclusive amounts

### VAT Calculation Points

#### 1. Purchase Orders (Ingredients/Materials)
```
Supplier Invoice:
- Item Cost (excl VAT): R100.00
- VAT (15%): R15.00
- Total (incl VAT): R115.00

System stores: R100.00 (excl VAT)
```

#### 2. Sub-Recipe Manufacturing
```
White Fondant Recipe:
- Ingredient 1: R50.00 (excl VAT)
- Ingredient 2: R30.00 (excl VAT)
- Total Cost: R80.00 (excl VAT)

System stores: R80.00 per batch
```

#### 3. Product Manufacturing
```
Cake Product:
- Sub-recipe cost: R80.00 (excl VAT)
- Other ingredients: R20.00 (excl VAT)
- Total Cost: R100.00 (excl VAT)

System stores: R100.00 per unit
```

#### 4. POS Sales
```
Retail Sale:
- Selling Price (excl VAT): R200.00
- VAT (15%): R30.00
- Total (incl VAT): R230.00

Customer pays: R230.00
System records:
  - Revenue: R200.00 (excl VAT)
  - VAT Output: R30.00
  - Cost of Sales: R100.00 (excl VAT)
  - Gross Profit: R100.00
```

## VAT Accounting

### Input VAT (Claimable)
VAT paid on purchases:
- Purchase ingredients: VAT can be reclaimed
- Purchase equipment: VAT can be reclaimed
- Purchase services: VAT can be reclaimed

### Output VAT (Payable)
VAT collected on sales:
- Retail sales: VAT must be paid to SARS
- Wholesale sales: VAT must be paid to SARS

### Net VAT Position
```
Output VAT (collected) - Input VAT (paid) = VAT payable to SARS
```

## Recommended Practice

### When Entering Costs
1. **Always enter costs EXCLUSIVE of VAT**
2. If supplier invoice shows inclusive price:
   - Divide by 1.15 to get exclusive amount
   - Example: R115.00 ÷ 1.15 = R100.00

### When Setting Selling Prices
1. **Set prices EXCLUSIVE of VAT**
2. POS will automatically add 15% VAT at checkout
3. Example: Set price R200.00, customer pays R230.00

### Cost Calculations
```
Sub-Recipe Unit Cost = Sum(Ingredient Costs) ÷ Batch Quantity
Product Unit Cost = Sum(Sub-Recipe Costs + Direct Ingredient Costs)
Gross Profit = Selling Price (excl) - Cost (excl)
Markup % = (Selling Price - Cost) ÷ Cost × 100
```

## GL Integration (When Implemented)

### Purchase Transaction
```
DR Inventory (excl VAT)     R100.00
DR VAT Input                 R15.00
   CR Accounts Payable              R115.00
```

### Manufacturing Transaction
```
DR Work in Progress         R100.00
   CR Raw Materials                 R100.00
(No VAT - internal transfer)
```

### Sales Transaction
```
DR Accounts Receivable      R230.00
   CR Sales Revenue (excl)          R200.00
   CR VAT Output                     R30.00

DR Cost of Sales            R100.00
   CR Finished Goods                R100.00
```

## Important Notes

1. **All costs in the system are EXCLUSIVE of VAT**
2. **VAT is only calculated at point of sale**
3. **Manufacturing costs do not include VAT** (internal transfers)
4. **Profit margins are calculated on exclusive amounts**
5. **VAT rate is currently 15%** (South Africa standard rate)

## Future Enhancements

When GL integration is fully implemented:
- Automatic VAT tracking on purchases
- VAT reconciliation reports
- VAT return preparation
- Input VAT vs Output VAT analysis

---

**Last Updated**: January 2026
**VAT Rate**: 15% (South Africa)
**Cost Basis**: Exclusive of VAT

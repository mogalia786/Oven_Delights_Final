# DATABASE SCHEMA REFERENCE - VERIFIED AGAINST LIVE DATABASE
## Generated: 2025-10-07 04:45

## CRITICAL TABLES FOR WORKFLOW

### PRODUCTS & INVENTORY
- **Products** - Main product master (ProductID, ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, BaseUoM, SKU, IsActive)
- **Retail_Product** - SEPARATE retail product table (ProductID, SKU, Name, Category, Subcategory, Code, IsActive)
- **Retail_Variant** - Product variants (VariantID, ProductID, Barcode, AttributesJson, IsActive)
- **Retail_Stock** - Branch-specific stock (StockID, VariantID, BranchID, QtyOnHand, ReorderPoint, Location, AverageCost)
- **Retail_StockMovements** - Stock movements (MovementID, VariantID, BranchID, QtyDelta, Reason, Ref1, Ref2, CreatedAt, CreatedBy)
- **Retail_Price** - Product pricing (PriceID, ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, EffectiveTo)

### RAW MATERIALS
- **RawMaterials** - Ingredients (MaterialID, MaterialCode, MaterialName, CategoryID, BaseUnit, CurrentStock, ReorderLevel, StandardCost, LastCost, AverageCost, UoMID, IsActive)

### MANUFACTURING
- **Manufacturing_Inventory** - WIP inventory (ManufacturingInventoryID, MaterialID, BranchID, QtyOnHand, AverageCost)
- **Manufacturing_InventoryMovements** - Movements (MovementID, MaterialID, BranchID, MovementType, QtyDelta, CostPerUnit, Reference)
- **RecipeNode** - Recipe hierarchy (NodeID, ProductID, ParentNodeID, Level, NodeKind, ItemType, MaterialID, SubAssemblyProductID, ItemName, Qty, UoMID)
- **RecipeTemplate** - Recipe templates (RecipeTemplateID, SubcategoryID, TemplateName, DefaultYieldQty, DefaultYieldUoMID, BranchID)
- **RecipeComponent** - Recipe components (RecipeComponentID, RecipeTemplateID, ComponentType, MaterialID, SubAssemblyProductID, BaseQty, UoMID)
- **RecipeParameters** - Recipe parameters (RecipeTemplateID, UseLength, UseWidth, UseHeight, DefaultLengthCm, DefaultWidthCm)
- **ProductRecipe** - Product-Recipe link (ProductID, RecipeTemplateID, VariantID, CreatedDate, CreatedBy)
- **BOMHeader** - Bill of materials (BOMID, ProductID, VersionNo, BatchYieldQty, YieldUoM, EffectiveFrom, EffectiveTo, IsActive)
- **BOMItems** - BOM items (BOMItemID, BOMID, ComponentType, RawMaterialID, ComponentProductID, QuantityPerBatch, UoM)
- **BomTaskStatus** - BOM task status (InternalOrderID, ManufacturerUserID, Status, ManufacturerName, ProductID)

### STOCKROOM
- **GoodsReceivedNotes** - GRN header (GRNID, PurchaseOrderID, GRNNumber, SupplierID, DeliveryNote, ReceivedDate, TotalValue, Status, BranchID)
- **GRNLines** - GRN lines (GRNLineID, GRNID, POLineID, MaterialID, ProductID, ItemSource, OrderedQuantity, ReceivedQuantity, UnitCost, LineTotal)
- **SupplierInvoices** - Supplier invoices (InvoiceID, InvoiceNumber, SupplierID, BranchID, InvoiceDate, DueDate, TotalAmount, Status, GRVID)
- **PurchaseOrders** - Purchase orders (PurchaseOrderID, PONumber, SupplierID, BranchID, OrderDate, Status, TotalAmount)
- **PurchaseOrderLines** - PO lines (POLineID, PurchaseOrderID, MaterialID, ProductID, ItemSource, OrderedQuantity, ReceivedQuantity, UnitCost)
- **Suppliers** - Suppliers (SupplierID, SupplierCode, CompanyName, ContactPerson, Email, Phone, CurrentBalance, IsActive)
- **InternalOrderHeader** - Internal orders (InternalOrderID, InternalOrderNo, FromLocationID, ToLocationID, RequestedBy, RequestedDate, Status, Notes)
- **InternalOrderLines** - Internal order lines (InternalOrderLineID, InternalOrderID, ItemType, RawMaterialID, ProductID, Quantity, UoM)

### ACCOUNTING
- **ExpenseCategories** - Expense categories (CategoryID, CategoryCode, CategoryName, AccountNumber, IsActive)
- **ExpenseTypes** - SEPARATE expense types (ExpenseTypeID, Code, Name, ExpenseTypeCode, ExpenseTypeName, TypeGroup, IsActive)
- **Expenses** - Expenses (ExpenseID, ExpenseCode, ExpenseName, ExpenseTypeID, CategoryID, SubcategoryID, IsActive)
- **CashBook** - Cash transactions (CashBookID, TransactionDate, TransactionType, Description, Amount, BranchID)
- **Timesheets** - Timesheets (TimesheetID, EmployeeID, WorkDate, ClockIn, ClockOut, HoursWorked, OvertimeHours)
- **Employees** - Employees (EmployeeID, EmployeeNumber, FirstName, LastName, BranchID, IsActive)
- **JournalHeaders** - Journal headers (JournalID, JournalNumber, JournalDate, Reference, Description, BranchID, IsPosted)
- **JournalDetails** - Journal details (JournalDetailID, JournalID, AccountID, Debit, Credit, Description, Reference1, Reference2)
- **GLAccounts** - GL accounts (AccountID, AccountNumber, AccountName, AccountType, BalanceType, IsActive)
- **FiscalPeriods** - Fiscal periods (PeriodID, PeriodName, StartDate, EndDate, IsClosed)

### INTER-BRANCH TRANSFERS
- **InterBranchTransferRequestHeader** - IBT request header (RequestID, FromBranchID, ToBranchID, RequestDate, Status, RequestedBy)
- **InterBranchTransferRequestLine** - IBT request lines (RequestLineID, RequestID, ProductID, VariantID, Quantity, Notes)
- **InterBranchTransferHeader** - IBT header (TransferID, RequestID, FromBranchID, ToBranchID, TransferDate, Status)
- **InterBranchTransferLine** - IBT lines (TransferLineID, TransferID, ProductID, VariantID, Quantity, UnitCost)

### CATEGORIES
- **Categories** - General categories (CategoryID, CategoryName, IsActive, CategoryCode)
- **Subcategories** - General subcategories (SubcategoryID, CategoryID, SubcategoryName, IsActive)
- **ProductCategories** - Product categories (CategoryID, CategoryCode, CategoryName, Description, IsActive)
- **ProductSubcategories** - Product subcategories (SubcategoryID, CategoryID, SubcategoryCode, SubcategoryName, IsActive)

### DAILY ORDER BOOK
- **DailyOrderBook** - Daily orders (BookDate, BranchID, ProductID, SKU, ProductName, OrderQty, IsInternal, RequestedAtUtc, RequestedByName, ManufacturerName, PurchaseOrderID, SupplierName)

### UNITS OF MEASURE
- **UoM** - Units (UoMID, UoMCode, UoMName)

### BRANCHES & USERS
- **Branches** - Branches (BranchID, BranchName, Prefix, BranchCode, IsActive)
- **Users** - Users (UserID, Username, Password, Email, FirstName, LastName, RoleID, BranchID, IsActive)
- **Roles** - Roles (RoleID, RoleName)

### SYSTEM
- **SystemAccounts** - System accounts (SysKey, AccountID)
- **SystemSettings** - System settings (ID, Category, SettingKey, SettingValue)

## CRITICAL COLUMN MAPPINGS

### Stock Columns:
- **Retail_Stock.QtyOnHand** - Current quantity
- **RawMaterials.CurrentStock** - Current raw material stock
- **Manufacturing_Inventory.QtyOnHand** - Manufacturing WIP stock

### Movement Columns:
- **Retail_StockMovements.QtyDelta** - Quantity change (NOT QuantityChange)
- **Manufacturing_InventoryMovements.QtyDelta** - Quantity change

### Product Columns:
- **Products.ProductName** - Product name (NOT Name)
- **Products.ProductCode** - Product code (NOT Code)
- **Products.BaseUoM** - Base unit (NOT DefaultUoMID)
- **Products.ItemType** - Product type (Manufactured/External)
- **Retail_Product.Name** - Retail product name
- **Retail_Product.Code** - Retail product code

### Expense Columns:
- **ExpenseCategories.CategoryName** - Category name
- **ExpenseTypes.Name** OR **ExpenseTypes.ExpenseTypeName** - Type name

## WORKFLOW TABLES

### PO → GRV → Invoice Flow:
1. PurchaseOrders → PurchaseOrderLines
2. GoodsReceivedNotes → GRNLines (links to PO)
3. SupplierInvoices (links to GRN)
4. Update RawMaterials.CurrentStock OR Retail_Stock.QtyOnHand

### Manufacturing Flow:
1. RecipeNode → defines product structure
2. InternalOrderHeader → InternalOrderLines (request materials)
3. IssueToManufacturing: RawMaterials.CurrentStock → Manufacturing_Inventory.QtyOnHand
4. CompleteBuild: Manufacturing_Inventory → Retail_Stock.QtyOnHand

### POS Flow:
1. Products → Retail_Variant → Retail_Stock
2. Retail_Price (get current price)
3. Create sale → Update Retail_Stock.QtyOnHand
4. Insert Retail_StockMovements with QtyDelta

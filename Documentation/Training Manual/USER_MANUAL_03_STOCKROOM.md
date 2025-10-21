# Stockroom Module
## User Training Manual - Complete Guide

**Version:** 1.0  
**Last Updated:** October 2025  
**Module:** Stockroom Management

---

## Table of Contents

1. [Module Overview](#module-overview)
2. [Menu Structure](#menu-structure)
3. [Purchase Orders](#purchase-orders)
4. [Inventory Management](#inventory-management)
5. [GRV Management](#grv-management)
6. [Supply Invoices](#supply-invoices)
7. [Inter-Branch Transfer](#inter-branch-transfer)
8. [Reports](#reports)

---

## Module Overview

### Purpose

The Stockroom module manages the complete procurement cycle from purchase requisition through to goods receipt. It controls:

- Purchase order creation and management
- Goods receiving (GRV)
- Supplier invoice processing
- Raw materials and external products inventory
- Inter-branch stock transfers
- Stockroom reporting

### Who Can Access

**Primary Users:**
- Stockroom Manager (full access)
- Stockroom Clerk (data entry only)
- Branch Manager (approval authority)
- Purchasing Manager (procurement)

### Key Concepts

**Product Types in Stockroom:**
1. **Raw Materials (Ingredients):** Items used in manufacturing
   - Flour, butter, sugar, eggs, etc.
   - Stored in Stockroom_Inventory table
   - Issued to Manufacturing when needed

2. **External Products (Ready-Made):** Finished goods purchased for resale
   - Coke, bread, milk, etc.
   - Move directly to Retail_Products_Inventory
   - Available for immediate sale

**Inventory Flow:**
```
Purchase Order → GRV → Invoice Matching → Stock Update
                                              ↓
                          Raw Materials → Stockroom_Inventory → Manufacturing
                          External Products → Retail_Products_Inventory → Sales
```

---

## Menu Structure

```
Stockroom
├── Purchase Orders
│   └── Create Purchase Order
├── Inventory Management
│   └── Add Inventory
├── GRV Management
├── Supply Invoices
│   ├── Capture Invoice
│   └── Edit Invoice
├── Inter-Branch Transfer
│   ├── Requests List
│   └── Fulfil Transfers
└── Reports
    ├── Stock Movement Report
    └── Cross-Branch Lookup
```

---

## Purchase Orders

### Purpose
Create and manage purchase orders to suppliers for raw materials and external products.

### Accessing Purchase Orders

1. Click **Stockroom** → **Purchase Orders** → **Create Purchase Order**
2. Purchase Order form opens

### Purchase Order Form Overview

**Form Sections:**
- **Header:** Supplier, dates, terms
- **Line Items:** Products being ordered
- **Totals:** Subtotal, VAT, total
- **Notes:** Special instructions

### Creating a Purchase Order

#### Step 1: Open New PO Form

1. Click **Stockroom** → **Purchase Orders** → **Create Purchase Order**
2. New PO form opens
3. PO Number auto-generated (e.g., PO-2025-001)

#### Step 2: Select Supplier

**Choose Supplier:**
1. Click **Supplier** dropdown
2. Start typing supplier name
3. Select from filtered list
4. Or click **[+]** to add new supplier

**Supplier Details Auto-Load:**
- Supplier name and code
- Contact person
- Phone and email
- Physical address
- Payment terms (Net 30, Net 60, etc.)
- VAT number

💡 **Tip:** If supplier not in list, you can add them on-the-fly by clicking the **Add New Supplier** button.

#### Step 3: Set PO Header Information

**Required Fields:**
- **PO Date:** Defaults to today (can change if backdating)
- **Required Date:** When you need delivery
- **Delivery Location:** Select branch for delivery
- **Buyer:** Your name (auto-filled)
- **Payment Terms:** From supplier account or override

**Optional Fields:**
- **Reference:** Your internal reference number
- **Requisition Number:** If from requisition
- **Special Instructions:** Delivery notes, quality specs, etc.

#### Step 4: Add Products to Order

**Method A: Search and Add**
1. Click **Add Product** button
2. Search dialog opens
3. Type product name or code
4. Select product type:
   - Raw Material (ingredients)
   - External Product (ready-made for resale)
5. Select product from results
6. Click **Add**

**Method B: Quick Add from Catalog**
1. Click **Browse Catalog** button
2. Navigate categories
3. Double-click product to add

**Method C: Import from Requisition**
1. Click **Import from Requisition**
2. Select approved requisition
3. Products auto-populate
4. Adjust quantities if needed

**For Each Product Line:**
- **Product Code:** Auto-filled
- **Description:** Product name and specs
- **Unit of Measure:** Each, Kg, Litre, Box, etc.
- **Quantity:** Amount to order
- **Unit Price:** Price per unit (from last PO or enter manually)
- **Discount %:** If applicable
- **Line Total:** Auto-calculated (Qty × Price - Discount)
- **Expected Delivery:** Date (optional, per line)
- **Notes:** Special requirements for this item

**Product Classification:**
- System shows if item is Raw Material or External Product
- Important for correct inventory routing after receipt

#### Step 5: Review Totals

**System Calculates:**
- **Subtotal:** Sum of all line totals
- **Discount:** If overall discount applied
- **Delivery Charge:** If applicable
- **Subtotal after Discount:** Subtotal - Discount + Delivery
- **VAT (15%):** Calculated on subtotal
- **Total Amount:** Final amount payable

**Verify:**
- All quantities correct
- Prices match quotation
- VAT calculation correct
- Total matches supplier quote

#### Step 6: Add Terms and Conditions

1. Click **Terms** tab
2. Standard terms auto-loaded from supplier
3. Add special conditions if needed:
   - Quality specifications
   - Delivery requirements
   - Packaging requirements
   - Return policy
   - Penalties for late delivery

**Example Terms:**
- "Delivery must be made between 8 AM - 4 PM"
- "All products must have minimum 6 months shelf life"
- "Supplier responsible for damaged goods in transit"
- "Payment within 30 days of invoice date"

#### Step 7: Attach Supporting Documents

**Optional Attachments:**
- Supplier quotation (PDF)
- Product specifications
- Quality certificates
- Previous correspondence
- Requisition approval

**To Attach:**
1. Click **Attachments** tab
2. Click **Add Attachment**
3. Browse to file
4. Select file
5. Add description
6. Click **Upload**

#### Step 8: Save as Draft

**Before Submitting:**
1. Click **Save as Draft**
2. PO saved with status "Draft"
3. Can edit later
4. Not yet sent to supplier

**Draft POs:**
- Visible only to creator
- Can be edited freely
- Can be deleted
- Not counted in reporting

#### Step 9: Submit for Approval

**Approval Required If:**
- PO value > R5,000 (Stockroom Manager approval)
- PO value > R50,000 (Financial Manager approval)
- New supplier (always requires approval)
- Special terms negotiated

**Submit Process:**
1. Click **Submit for Approval**
2. Select approver from list
3. Add notes for approver
4. Click **Submit**
5. Email sent to approver
6. Status changes to "Pending Approval"

**Approval Workflow:**
1. Approver receives email notification
2. Approver reviews PO
3. Approver can:
   - Approve (PO proceeds)
   - Reject (returns to creator with reason)
   - Request Changes (creator must amend)

#### Step 10: Send to Supplier

**Once Approved:**
1. PO status changes to "Approved"
2. Click **Send to Supplier**
3. Choose send method:
   - **Email:** PDF attached (recommended)
   - **Fax:** Enter fax number
   - **Print:** Print and mail/courier

**Email Send:**
1. Select "Email"
2. Verify supplier email address
3. Edit email message if needed
4. Click **Send**
5. PDF generated and emailed
6. Status changes to "Sent to Supplier"
7. Copy saved in system

**Print Send:**
1. Select "Print"
2. PO prints on company letterhead
3. Print 3 copies:
   - Original: Mail to supplier
   - Copy 1: Stockroom file
   - Copy 2: Accounts Payable
4. Manually mark as "Sent"

#### Step 11: Track Order Status

**PO Status Flow:**
```
Draft → Pending Approval → Approved → Sent to Supplier → 
Order Confirmed → Partially Received → Fully Received → Closed
```

**Supplier Confirmation:**
1. Supplier receives PO
2. Supplier sends order confirmation
3. Open PO
4. Click **Record Confirmation**
5. Enter:
   - Confirmation number
   - Confirmed delivery date
   - Any changes to order
6. Status changes to "Order Confirmed"

**If Supplier Changes Order:**
- Review changes
- Accept or negotiate
- May need to amend PO
- Get new approval if value changes

### Managing Existing Purchase Orders

#### Viewing PO List

**Access PO List:**
1. Click **Stockroom** → **Purchase Orders** → **View All**
2. Grid shows all POs

**Grid Columns:**
- **PO Number:** Unique identifier
- **PO Date:** When created
- **Supplier:** Supplier name
- **Total Amount:** PO value
- **Status:** Current status
- **Required Date:** Expected delivery
- **Created By:** Who created
- **Actions:** Quick action buttons

**Filter Options:**
- By status
- By supplier
- By date range
- By value range
- By creator

**Sort Options:**
- Click column header to sort
- Ascending/descending toggle

#### Editing a Purchase Order

**Can Edit If:**
- Status is "Draft"
- Status is "Pending Approval" (if you're the creator)
- You have manager override permission

**Cannot Edit If:**
- Already sent to supplier
- Partially or fully received
- Closed

**To Edit:**
1. Open PO from list
2. Click **Edit** button
3. Make changes
4. Click **Save**
5. If already approved, may need re-approval

**To Amend Sent PO:**
1. Open PO
2. Click **Create Amendment**
3. Make changes
4. System creates PO Amendment document
5. Send amendment to supplier
6. Get supplier confirmation

#### Cancelling a Purchase Order

**When to Cancel:**
- Supplier cannot fulfill
- Requirements changed
- Found better supplier
- Budget constraints

**Cancel Process:**
1. Open PO
2. Click **Cancel PO**
3. Enter cancellation reason
4. If already sent to supplier:
   - System prompts to notify supplier
   - Email sent automatically
5. Confirm cancellation
6. Status changes to "Cancelled"
7. Stock not expected
8. Audit log entry created

**Effects of Cancellation:**
- PO marked cancelled
- Cannot be reopened
- Historical record preserved
- Supplier notified
- Requisition (if any) returns to pending

#### Closing a Purchase Order

**When to Close:**
- All items fully received
- All invoices matched
- No outstanding issues

**Close Process:**
1. Verify all GRVs completed
2. Verify all invoices processed
3. Open PO
4. Click **Close PO**
5. System checks:
   - All quantities received?
   - All invoices matched?
   - Any discrepancies resolved?
6. If all clear, PO closes
7. Status: "Closed"
8. Archived for reporting

**Cannot Close If:**
- Outstanding quantities
- Unmatched invoices
- Open disputes

### Purchase Order Reports

**Available Reports:**
1. **Outstanding POs:** All open purchase orders
2. **POs by Supplier:** Group by supplier
3. **POs by Value:** Sort by amount
4. **Overdue Deliveries:** Past required date
5. **PO Aging:** How long POs have been open
6. **Approval Queue:** POs awaiting approval

**Generate Report:**
1. Select report type
2. Set filters (date range, supplier, etc.)
3. Click **Generate**
4. View on screen
5. Print or export (PDF/Excel)

### Purchase Order Best Practices

✅ **DO:**
- Get competitive quotes before ordering
- Verify supplier details before sending
- Follow up on order confirmations
- Track delivery dates
- Keep all PO documentation
- Review outstanding POs weekly

❌ **DON'T:**
- Verbally commit without PO
- Accept deliveries without valid PO
- Skip approval process
- Ignore overdue orders
- Delete POs (cancel instead)
- Share supplier pricing publicly

---

## Inventory Management

### Purpose
Manage the stockroom catalog of raw materials and external products.

### Accessing Inventory Management

1. Click **Stockroom** → **Inventory Management** → **Add Inventory**
2. Inventory Catalog form opens

### Understanding Stockroom Inventory

**Two Inventory Types:**

1. **Raw Materials (Ingredients)**
   - Used in manufacturing
   - Examples: Flour, sugar, butter, eggs
   - Stored in: `Stockroom_Inventory` table
   - Classification: "Raw Material"
   - Issued to manufacturing via BOM

2. **External Products (Ready-Made)**
   - Purchased finished goods for resale
   - Examples: Coke, bread, milk
   - Move to: `Retail_Products_Inventory` table
   - Classification: "External Product"
   - Available immediately for sale

### Adding New Inventory Item

#### Step 1: Open Add Inventory Form

1. Click **Stockroom** → **Inventory Management** → **Add Inventory**
2. Product entry form opens

#### Step 2: Select Product Type

**Choose Classification:**
- **Raw Material:** For manufacturing ingredients
- **External Product:** For ready-made resale items

⚠️ **Important:** This determines inventory routing. Choose carefully!

#### Step 3: Enter Product Information

**Basic Information:**
- **Product Code/SKU:** Unique identifier
  * Auto-generated or manual entry
  * Example: RM-FLOUR-001 (Raw Material)
  * Example: EP-COKE-330 (External Product)

- **Product Name:** Descriptive name
  * Example: "Cake Flour - 12.5kg"
  * Example: "Coca-Cola 330ml Can"

- **Description:** Detailed description
  * Specifications
  * Brand
  * Size/weight
  * Any special characteristics

**Classification:**
- **Category:** Select from dropdown
  * Dairy, Bakery, Beverages, etc.
  * Or create new category

- **Subcategory:** Select subcategory
  * More specific classification
  * Example: Category=Dairy, Subcategory=Milk

- **Item Type:** Raw Material or External Product
  * Set in Step 2, confirm here

**Unit of Measure:**
- **Base UOM:** Primary unit (Each, Kg, Litre, Box)
- **Purchase UOM:** How you buy it (may differ)
  * Example: Base=Kg, Purchase=25kg Bag
- **Conversion Factor:** If UOMs differ
  * Example: 1 Bag = 25 Kg

#### Step 4: Set Pricing Information

**Cost Information:**
- **Standard Cost:** Average/standard cost per unit
- **Last Purchase Price:** Most recent price paid
- **Average Cost:** Weighted average (auto-calculated)

**Selling Price (for External Products):**
- **Retail Price:** Price to customers
- **Wholesale Price:** Price for wholesale customers
- **Markup %:** Percentage above cost

**Pricing Notes:**
- Raw materials don't have selling price (used internally)
- External products need selling price set
- System can auto-calculate markup

#### Step 5: Configure Stock Control

**Reorder Settings:**
- **Reorder Level:** Minimum quantity before reorder
  * Calculate: Average daily usage × Lead time + Safety stock
  * Example: 10kg/day × 7 days + 20kg safety = 90kg reorder level

- **Reorder Quantity:** How much to order when reordering
  * Economic Order Quantity (EOQ)
  * Or standard order size
  * Example: 250kg (10 bags of 25kg)

- **Maximum Stock Level:** Don't exceed this
  * Storage capacity limit
  * Prevents over-ordering
  * Example: 500kg maximum

**Lead Time:**
- **Supplier Lead Time:** Days from order to delivery
  * Used in reorder calculations
  * Example: 7 days

**Stock Control Method:**
- **FIFO:** First In, First Out (default for perishables)
- **LIFO:** Last In, First Out
- **Average Cost:** Weighted average

#### Step 6: Add Supplier Information

**Primary Supplier:**
- Select main supplier for this product
- Supplier's product code (if different from yours)
- Supplier's unit price
- Minimum order quantity
- Pack size

**Alternative Suppliers:**
- Add backup suppliers
- Useful if primary unavailable
- Compare pricing

**Supplier Details Stored:**
- Supplier name
- Supplier product code
- Last price
- Last order date
- Delivery performance

#### Step 7: Set Storage Requirements

**Storage Information:**
- **Storage Location:** Bin/shelf location in stockroom
  * Example: "Aisle 3, Shelf B"
  * Helps with picking

- **Storage Conditions:** Special requirements
  * Temperature controlled
  * Refrigerated
  * Frozen
  * Dry storage
  * Hazardous

- **Shelf Life:** Days before expiry (for perishables)
  * Example: 180 days for flour
  * System tracks expiry dates

#### Step 8: Add Product Image

**Upload Image:**
1. Click **Upload Image** button
2. Browse to image file
3. Select image (JPG, PNG)
4. Image uploads and displays
5. Used in:
   - Product catalog
   - POS system (for external products)
   - Reports

**Image Guidelines:**
- Clear product photo
- White or neutral background
- Square format preferred
- Max size: 2MB
- Resolution: 800x800 pixels minimum

#### Step 9: Set Tax Information

**VAT Settings:**
- **VAT Applicable:** Yes/No
- **VAT Rate:** 15% (standard SA rate)
- **VAT Code:** Standard/Zero-rated/Exempt

**Tax Category:**
- Standard rated (15%)
- Zero-rated (0% but VAT registered)
- Exempt (no VAT)

#### Step 10: Configure Additional Settings

**Batch/Lot Tracking:**
- [ ] Enable batch tracking
  * Track by batch/lot number
  * Important for quality control
  * Required for recalls

- [ ] Enable serial number tracking
  * Track individual items
  * For high-value items

**Expiry Date Tracking:**
- [ ] Track expiry dates
  * Essential for perishables
  * System alerts on approaching expiry
  * FIFO enforcement

**Quality Control:**
- [ ] Requires inspection on receipt
  * QC check before accepting
  * Sample testing
  * Certificate of Analysis required

#### Step 11: Save Product

1. Review all entered information
2. Verify product type correct (Raw Material vs External Product)
3. Click **Save**
4. Product added to catalog
5. Available for purchase orders
6. Confirmation message displays

**Post-Save:**
- Product appears in inventory catalog
- Available in PO product search
- Reorder alerts activated
- Can now receive stock

### Editing Inventory Items

**To Edit:**
1. Search for product in catalog
2. Double-click product row
3. Edit form opens
4. Make changes
5. Click **Save**

**Can Change:**
- Descriptions
- Pricing
- Reorder levels
- Supplier information
- Storage location

**Cannot Change:**
- Product code (permanent)
- Product type (Raw Material vs External Product)
- Creation date

⚠️ **Changing Product Type:** If you need to change Raw Material to External Product or vice versa, you must create a new product and deactivate the old one.

### Deactivating Products

**When to Deactivate:**
- Product discontinued
- Supplier no longer available
- Replaced by new product
- No longer used

**Deactivate Process:**
1. Open product
2. Click **Deactivate**
3. Enter reason
4. Confirm deactivation
5. Product marked inactive

**Effects:**
- Cannot create new POs for this product
- Existing stock remains
- Historical data preserved
- Can reactivate later if needed

### Bulk Import Products

**Import from Excel:**
1. Click **Import Products**
2. Download template file
3. Fill in product details in Excel
4. Upload completed file
5. System validates data
6. Review validation results
7. Confirm import
8. Products created in batch

**Template Columns:**
- Product Code
- Product Name
- Description
- Category
- Item Type (Raw Material/External Product)
- Unit of Measure
- Standard Cost
- Reorder Level
- Reorder Quantity
- Primary Supplier
- Storage Location

### Inventory Catalog Reports

**Available Reports:**
1. **Complete Catalog:** All products
2. **Raw Materials List:** Ingredients only
3. **External Products List:** Ready-made items only
4. **Low Stock Report:** Below reorder level
5. **Reorder Recommendations:** What to order
6. **Inactive Products:** Deactivated items
7. **Products by Supplier:** Group by supplier
8. **Products by Category:** Group by category

**Generate Report:**
1. Select report type
2. Set filters
3. Click **Generate**
4. View/Print/Export

---

## GRV Management

### Purpose
Record receipt of goods from suppliers and update inventory.

### Accessing GRV Management

1. Click **Stockroom** → **GRV Management**
2. GRV list opens

### What is a GRV?

**GRV = Goods Received Voucher**
- Official document recording goods receipt
- Links to Purchase Order
- Updates inventory quantities
- Required for invoice matching
- Creates audit trail

### GRV Process Overview

```
Delivery Arrives → Physical Inspection → Create GRV → 
Update Inventory → File Documentation → Invoice Matching
```

### Receiving Goods - Complete Process

#### Step 1: Delivery Arrives

**When Supplier Delivers:**
1. Driver arrives with goods
2. Request delivery note from driver
3. Check delivery note has:
   - Supplier name
   - PO number
   - List of items
   - Quantities
   - Delivery note number

**Initial Checks:**
- Is delivery expected? (check PO)
- Correct supplier?
- Correct delivery address?
- Delivery note matches PO?

#### Step 2: Open GRV Form

1. Click **Stockroom** → **GRV Management**
2. Click **New GRV** button
3. GRV form opens

#### Step 3: Link to Purchase Order

**Find PO:**
1. Enter PO number from delivery note
2. Or search by supplier name
3. Select correct PO from list
4. PO details load automatically

**PO Information Displayed:**
- Supplier name and details
- PO date and number
- Expected items and quantities
- Prices
- Total PO value

**Verify:**
- Supplier on delivery note matches PO
- Items match what was ordered
- Quantities reasonable

#### Step 4: Physical Inspection and Counting

**Count Quantities:**
1. Physically count each item delivered
2. Compare to delivery note
3. Compare to PO
4. Note any discrepancies

**Quality Inspection:**
1. **Check Packaging:**
   - Intact? No damage?
   - Properly sealed?
   - Labels correct?

2. **Check Product Quality:**
   - Correct product?
   - Correct brand/specification?
   - Acceptable condition?
   - No visible defects?

3. **Check Expiry Dates (for perishables):**
   - Minimum shelf life acceptable?
   - Example: Flour must have 6+ months
   - Reject if too close to expiry

4. **Check Batch Numbers:**
   - Batch/lot numbers recorded?
   - Certificates of Analysis provided (if required)?

5. **Temperature Check (for cold chain):**
   - Frozen items still frozen?
   - Chilled items at correct temperature?
   - Temperature log from truck?

**Take Photos:**
- Photograph any damage
- Photo of delivery note
- Photo of products
- Useful for disputes

#### Step 5: Record GRV Details

**GRV Header:**
- **GRV Number:** Auto-generated (e.g., GRV-2025-001)
- **GRV Date:** Today (or actual receipt date)
- **PO Number:** Linked PO (auto-filled)
- **Supplier:** From PO (auto-filled)
- **Delivery Note Number:** From supplier's delivery note
- **Received By:** Your name (auto-filled)
- **Carrier/Driver:** Delivery company or driver name
- **Vehicle Registration:** If applicable
- **Time Received:** Actual time of receipt

**For Each Line Item:**

| Field | Description | Example |
|-------|-------------|---------|
| Product Code | From PO | RM-FLOUR-001 |
| Description | Product name | Cake Flour 12.5kg |
| Ordered Qty | From PO | 100 bags |
| Delivered Qty | Actually arrived | 98 bags |
| Accepted Qty | What you're accepting | 95 bags |
| Rejected Qty | What you're rejecting | 3 bags (damaged) |
| Unit | Unit of measure | Bags |
| Batch/Lot No | From product label | LOT-2025-03-15 |
| Expiry Date | From product label | 15/09/2025 |
| Condition | Product state | Good / Damaged |
| Notes | Any observations | 3 bags torn packaging |

**Handling Discrepancies:**

*Short Delivery (less than ordered):*
1. Record actual quantity received
2. Note shortage in GRV notes
3. Options:
   - Wait for balance delivery
   - Cancel balance and amend PO
   - Claim shortage from supplier

*Over Delivery (more than ordered):*
1. Record actual quantity
2. Options:
   - Accept over-delivery (if needed and storage available)
   - Reject excess (driver takes back)
   - Contact supplier for instructions

*Wrong Items Delivered:*
1. Record as "Rejected"
2. Do not accept into stock
3. Driver must take back
4. Or arrange collection by supplier
5. Supplier to send correct items

*Damaged Goods:*
1. Take photos of damage
2. Note damage on delivery note
3. Get driver signature acknowledging damage
4. Record as "Rejected" in GRV
5. Driver takes back or leaves for supplier collection
6. Claim from supplier/carrier

#### Step 6: Complete GRV

**Review GRV:**
1. Check all quantities correct
2. Verify all discrepancies noted
3. Ensure batch numbers recorded
4. Photos attached if damage

**Driver Signature:**
1. Show driver the GRV
2. Point out any discrepancies
3. Get driver to sign GRV
4. Driver signature confirms:
   - Quantities delivered
   - Condition of goods
   - Any shortages/damage noted

**Post GRV:**
1. Click **Post GRV**
2. System performs checks:
   - All required fields completed?
   - Quantities reasonable?
   - Discrepancies explained?
3. If all OK, GRV posts
4. Status changes to "Posted"

**System Actions on Posting:**
1. **Updates Inventory:**
   - Raw Materials → Stockroom_Inventory table
   - External Products → Retail_Products_Inventory table
   - Quantities increased by accepted qty

2. **Creates Stock Movement:**
   - Movement type: "GRV Receipt"
   - Reference: GRV number
   - Quantity: Accepted qty
   - Cost: From PO
   - Date: GRV date

3. **Updates Purchase Order:**
   - PO quantities received updated
   - If fully received, PO status → "Fully Received"
   - If partially received, PO status → "Partially Received"

4. **Creates GL Journal Entry:**
   ```
   Debit:  Inventory Account (Stockroom or Retail)
   Credit: GRV Clearing Account
   Amount: Accepted Qty × Unit Cost
   ```

5. **Generates GRV Document:**
   - PDF created
   - Stored in system
   - Available for printing

#### Step 7: Print and File GRV

**Print GRV:**
1. Click **Print GRV**
2. Print 3 copies:
   - **Original:** Accounts Payable (for invoice matching)
   - **Copy 1:** Stockroom file
   - **Copy 2:** Supplier (if requested)

**File Documentation:**
1. Attach to GRV:
   - Supplier delivery note
   - Photos of any damage
   - Quality inspection report (if applicable)
   - Certificates of Analysis (if applicable)
2. File by GRV number
3. Keep for audit trail

#### Step 8: Store Goods

**Move to Storage:**
1. Transport goods to appropriate storage area
2. Organize by:
   - Product type
   - Expiry date (FIFO - First In First Out)
   - Batch number
3. Update bin location in system if needed

**Storage Best Practices:**
- FIFO: Oldest stock at front
- Clear labeling
- Batch numbers visible
- Expiry dates visible
- Proper storage conditions maintained
- Separate damaged/quarantine area

### Viewing GRV List

**Access GRV List:**
1. Click **Stockroom** → **GRV Management**
2. Grid shows all GRVs

**Grid Columns:**
- GRV Number
- GRV Date
- PO Number
- Supplier
- Total Value
- Status (Posted/Draft/Cancelled)
- Received By
- Invoice Matched (Yes/No)

**Filter Options:**
- By date range
- By supplier
- By PO number
- By status
- By received by

### Editing a GRV

**Can Edit If:**
- Status is "Draft"
- Not yet posted

**Cannot Edit If:**
- Already posted
- Invoice already matched

**To Edit Draft GRV:**
1. Open GRV from list
2. Click **Edit**
3. Make changes
4. Click **Save**

**To Correct Posted GRV:**
- Cannot edit directly
- Must create Stock Adjustment
- Or create GRV Reversal (with manager approval)

### Cancelling a GRV

**When to Cancel:**
- Created in error
- Delivery rejected completely
- Duplicate GRV

**Cancel Process:**
1. Open GRV
2. Click **Cancel GRV**
3. Enter cancellation reason
4. Manager approval required
5. Confirm cancellation
6. Status changes to "Cancelled"

**Effects:**
- Inventory not updated
- PO remains open
- Audit log entry created
- Cannot be uncancelled

### GRV Reports

**Available Reports:**
1. **Daily GRV Summary:** All GRVs for a day
2. **GRVs Pending Invoice:** Not yet matched to invoice
3. **Rejected Goods Report:** All rejections
4. **GRV by Supplier:** Group by supplier
5. **Receiving Efficiency:** Time metrics

**Generate Report:**
1. Select report type
2. Set date range
3. Set filters
4. Click **Generate**
5. View/Print/Export

### GRV Best Practices

✅ **DO:**
- Count all goods physically - never trust delivery note
- Inspect quality thoroughly
- Document all discrepancies with photos
- Get driver signature before they leave
- Process GRV same day as delivery
- Check expiry dates on perishables
- Record batch numbers accurately

❌ **DON'T:**
- Accept goods without proper PO
- Sign delivery note before verifying goods
- Accept damaged goods without noting it
- Skip quality inspection
- Delay GRV processing
- Accept deliveries outside business hours without authorization

---

## Supply Invoices

### Purpose
Match supplier invoices to GRVs and approve for payment.

### Menu: Supply Invoices

```
Supply Invoices
├── Capture Invoice
└── Edit Invoice
```

### Why Invoice Matching is Critical

**Three-Way Match:**
1. **Purchase Order:** What we ordered
2. **GRV:** What we received
3. **Supplier Invoice:** What supplier is charging

All three must match before payment approved.

**Benefits:**
- Ensures we only pay for goods actually received
- Verifies prices match PO
- Prevents duplicate payments
- Provides audit trail
- Controls cash flow

### Capturing Supplier Invoice

#### Step 1: Receive Invoice

**Invoice Arrives:**
- By email (PDF)
- By mail (paper)
- With delivery (attached to goods)

**Initial Check:**
- Is it a tax invoice? (must have VAT number)
- Is it addressed to correct company?
- Is there a PO number referenced?

#### Step 2: Open Capture Invoice Form

1. Click **Stockroom** → **Supply Invoices** → **Capture Invoice**
2. Invoice capture form opens

#### Step 3: Enter Invoice Header

**Invoice Details:**
- **Supplier:** Select from dropdown
- **Invoice Number:** From supplier invoice
- **Invoice Date:** Date on invoice
- **Invoice Amount:** Total from invoice
- **VAT Amount:** VAT from invoice
- **Due Date:** Based on payment terms
  * Net 30: Invoice date + 30 days
  * Net 60: Invoice date + 60 days
- **Tax Invoice:** Yes/No checkbox

**Payment Terms:**
- Loaded from supplier account
- Can override if different on this invoice
- Early payment discount noted if applicable

#### Step 4: Link to GRV

**Find Related GRV:**
1. Click **Link GRV** button
2. Search by:
   - GRV number (if known)
   - PO number (from invoice)
   - Date range
   - Supplier
3. Select the GRV(s) this invoice relates to
4. GRV details load

**Multiple GRVs:**
- One invoice may cover multiple GRVs
- Select all relevant GRVs
- System combines quantities

#### Step 5: Match Line Items

**System Displays Comparison Table:**

| Item | PO Qty | PO Price | GRV Qty | Invoice Qty | Invoice Price | Match? | Variance |
|------|--------|----------|---------|-------------|---------------|--------|----------|
| Flour 12.5kg | 100 | R150.00 | 95 | 95 | R150.00 | ✓ | - |
| Sugar 2kg | 50 | R25.00 | 48 | 48 | R25.50 | ✗ | R0.50 |

**For Each Line, Verify:**
1. **Quantity Match:**
   - Invoice qty should match GRV qty (not PO qty)
   - If GRV was short, invoice should reflect that

2. **Price Match:**
   - Invoice price should match PO price
   - Check for price increases

3. **Calculation Check:**
   - Line total = Qty × Price
   - Subtotal = Sum of line totals
   - VAT = Subtotal × 15%
   - Total = Subtotal + VAT

#### Step 6: Handle Variances

**Quantity Variance:**

*Invoice Qty > GRV Qty:*
- Supplier charging for more than delivered
- **Action:** Reject variance
- Request credit note from supplier
- Or query invoice

*Invoice Qty < GRV Qty:*
- Supplier charging for less than delivered
- **Action:** Accept (we benefit)
- Or query if seems wrong

**Price Variance:**

*Invoice Price > PO Price:*
- Unauthorized price increase
- **Action:** Query with supplier
- Check for price increase notification
- If authorized, accept
- If not, request credit note

*Invoice Price < PO Price:*
- Supplier giving discount
- **Action:** Accept (we benefit)
- Update PO price for future reference

**Calculation Errors:**
- Check all arithmetic
- Verify VAT calculation (15%)
- Check subtotals
- If errors found, return invoice to supplier

#### Step 7: Approval Decision

**If Everything Matches:**
1. All quantities match GRV
2. All prices match PO
3. Calculations correct
4. Click **Approve for Payment**
5. Status: "Approved"

**System Actions:**
1. Creates payment due entry
2. Updates GL:
   ```
   Debit:  GRV Clearing Account
   Credit: Accounts Payable
   Amount: Invoice total
   ```
3. Invoice enters payment queue
4. Will be paid per payment terms

**If Variances Exist:**
1. Click **Query Invoice**
2. Document all variances:
   - What doesn't match
   - Expected vs actual
   - Amount of variance
3. Select query reason:
   - Quantity discrepancy
   - Price discrepancy
   - Calculation error
   - Missing information
   - Other (specify)
4. Add detailed notes
5. Click **Send Query to Supplier**
6. Email sent to supplier
7. Status: "Queried"
8. Payment held until resolved

**If Invoice Rejected:**
1. Click **Reject Invoice**
2. Enter rejection reason:
   - No matching GRV
   - No matching PO
   - Duplicate invoice
   - Incorrect amount
   - Other (specify)
3. Add notes
4. Click **Confirm Rejection**
5. Invoice returned to supplier
6. Request correct invoice
7. Status: "Rejected"

#### Step 8: Attach Invoice Document

**Upload Invoice:**
1. Click **Attachments** tab
2. Click **Add Attachment**
3. Browse to invoice file (PDF/image)
4. Select file
5. Click **Upload**
6. Invoice stored in system

**Benefits:**
- Quick reference
- Audit trail
- No paper filing needed
- Easy retrieval

### Editing Captured Invoice

**Access Edit:**
1. Click **Stockroom** → **Supply Invoices** → **Edit Invoice**
2. Search for invoice
3. Select invoice
4. Edit form opens

**Can Edit If:**
- Status is "Draft" or "Queried"
- Not yet approved for payment

**Cannot Edit If:**
- Already approved
- Payment processed
- Invoice closed

**To Edit:**
1. Open invoice
2. Click **Edit**
3. Make changes
4. Click **Save**
5. May need re-approval if amounts changed

### Invoice Query Resolution

**When Supplier Responds:**
1. Open queried invoice
2. Review supplier response
3. Options:
   - **Accept Explanation:** Approve invoice
   - **Request Credit Note:** Supplier issues credit
   - **Request Corrected Invoice:** Supplier reissues
   - **Escalate:** Manager involvement

**Credit Note Processing:**
1. Receive credit note from supplier
2. Link to original invoice
3. Reduce amount payable
4. Or offset against future invoices

### Invoice Matching Reports

**Available Reports:**
1. **Invoices Pending Matching:** Not yet processed
2. **Matched Invoices Pending Payment:** Approved, awaiting payment
3. **Invoice Variances Report:** All discrepancies
4. **Supplier Invoice Aging:** How long invoices outstanding
5. **Query Status Report:** All queried invoices

### Invoice Matching Best Practices

✅ **DO:**
- Match invoices within 24 hours of receipt
- Query variances immediately
- Keep all documentation together
- Follow up on outstanding queries
- Take early payment discounts when offered
- Verify tax invoice requirements

❌ **DON'T:**
- Approve invoice without GRV
- Pay invoices with unresolved variances
- Pay duplicate invoices
- Skip the three-way match
- Ignore small variances (they add up)

---

## Inter-Branch Transfer

### Purpose
Transfer stock between branches to balance inventory levels.

### Menu: Inter-Branch Transfer

```
Inter-Branch Transfer
├── Requests List
└── Fulfil Transfers
```

### Understanding Inter-Branch Transfers

**Why Transfer Stock:**
- One branch has excess, another has shortage
- Seasonal demand variations
- New branch opening needs stock
- Emergency stock requirements
- Balance inventory across network

**Transfer Types:**
1. **Requested Transfer:** Receiving branch requests stock
2. **Initiated Transfer:** Sending branch offers stock
3. **Emergency Transfer:** Urgent requirement

### Creating Transfer Request

#### Step 1: Access Requests List

1. Click **Stockroom** → **Inter-Branch Transfer** → **Requests List**
2. Transfer request form opens

#### Step 2: Create New Request

1. Click **New Request** button
2. Request form opens

#### Step 3: Enter Request Details

**Header Information:**
- **Request Number:** Auto-generated (e.g., TR-REQ-2025-001)
- **Request Date:** Today
- **Requesting Branch:** Your branch (auto-filled)
- **Requested From:** Select source branch
  * Or select "Any Branch" if flexible
- **Required Date:** When you need the stock
- **Priority:** Normal/Urgent/Emergency
- **Reason:** Why you need the stock

**Request Lines:**
1. Click **Add Product**
2. Search for product
3. Select product
4. Enter:
   - **Quantity Requested:** How much you need
   - **Current Stock Level:** Your current stock
   - **Reason:** Why you need it
5. Repeat for all products

#### Step 4: Submit Request

1. Review all items
2. Click **Submit Request**
3. Request sent to:
   - Specified branch (if selected)
   - All branches (if "Any Branch")
4. Email notification sent
5. Status: "Pending Approval"

### Fulfilling Transfer Requests

#### Step 1: View Pending Requests

1. Click **Stockroom** → **Inter-Branch Transfer** → **Fulfil Transfers**
2. List shows all pending requests for your branch

**Grid Shows:**
- Request number
- Requesting branch
- Request date
- Required date
- Priority
- Products requested
- Status

#### Step 2: Review Request

1. Select request from list
2. Click **View Details**
3. Review:
   - What products requested
   - Quantities needed
   - When needed
   - Why needed

**Check Your Stock:**
- Do you have the requested items?
- Can you spare the quantity?
- Will it affect your own operations?

#### Step 3: Approve or Reject

**To Approve:**
1. Click **Approve Request**
2. Confirm quantities available
3. Set dispatch date
4. Click **Confirm**
5. Status: "Approved"
6. Proceed to create transfer

**To Partially Approve:**
1. Click **Partial Approval**
2. Adjust quantities you can provide
3. Add notes explaining partial fulfillment
4. Click **Confirm**
5. Requesting branch notified

**To Reject:**
1. Click **Reject Request**
2. Select reason:
   - Insufficient stock
   - Stock needed for own operations
   - Product not available
   - Other (specify)
3. Add notes
4. Click **Confirm**
5. Requesting branch notified
6. They can request from another branch

#### Step 4: Create Transfer Document

**Once Approved:**
1. Click **Create Transfer**
2. Transfer form opens with request details pre-filled

**Transfer Header:**
- **Transfer Number:** Auto-generated (e.g., JHB-iTrans-001)
  * Format: FromBranchPrefix-iTrans-Number
- **Transfer Date:** Today
- **From Branch:** Your branch
- **To Branch:** Requesting branch
- **Expected Delivery Date:** When they'll receive
- **Courier/Driver:** Who will transport
- **Vehicle Reg:** If applicable

**Transfer Lines:**
- Products from request
- Quantities approved
- Unit cost (for accounting)
- Total value

#### Step 5: Print Transfer Documentation

**Print Transfer Note:**
1. Click **Print Transfer Note**
2. Print 3 copies:
   - **Copy 1:** Stays with sending branch
   - **Copy 2:** Travels with goods
   - **Copy 3:** For receiving branch

**Transfer Note Contains:**
- Transfer number
- From/To branches
- Date
- Product list with quantities
- Signatures section
- Instructions

#### Step 6: Dispatch Goods

**Prepare Goods:**
1. Pick products from stock
2. Pack securely
3. Label clearly with transfer number
4. Attach Copy 2 of transfer note

**Update System:**
1. Click **Mark as Dispatched**
2. Enter:
   - Dispatch date and time
   - Courier/driver name
   - Vehicle registration
   - Estimated arrival time
3. Click **Confirm**
4. Status: "In Transit"

**Inventory Impact (Sending Branch):**
```
Debit:  Inter-Branch Debtors (Receivable)
Credit: Inventory Account
Amount: Quantity × Cost
```
- Stock reduced immediately
- Receivable created (inter-branch owing)

#### Step 7: Receive Goods (Receiving Branch)

**When Goods Arrive:**
1. Open **Inter-Branch Transfer** → **Requests List**
2. Click **Pending Receipts** tab
3. Select incoming transfer
4. Click **Receive Transfer**

**Physical Verification:**
1. Check goods against transfer note
2. Count quantities
3. Inspect condition
4. Note any discrepancies

**Record Receipt:**
For each line item:
- **Ordered Qty:** From transfer note
- **Received Qty:** Actually arrived
- **Condition:** Good/Damaged
- **Notes:** Any issues

**Complete Receipt:**
1. If all correct, click **Accept Transfer**
2. If discrepancies:
   - Note variances
   - Take photos
   - Contact sending branch
   - Manager approval for acceptance
3. Click **Complete Receipt**
4. Status: "Completed"

**Inventory Impact (Receiving Branch):**
```
Debit:  Inventory Account
Credit: Inter-Branch Creditors (Payable)
Amount: Quantity × Cost
```
- Stock increased
- Payable created (inter-branch owing)

#### Step 8: Reconciliation

**Inter-Branch Reconciliation:**
- Both branches have matching entries
- Debtors at sending branch = Creditors at receiving branch
- Same transfer number for reconciliation
- Monthly reconciliation process
- Discrepancies investigated and resolved

### Transfer Reports

**Available Reports:**
1. **Pending Transfer Requests:** All open requests
2. **In-Transit Transfers:** Currently being transported
3. **Completed Transfers:** Historical transfers
4. **Inter-Branch Reconciliation:** Debtors vs Creditors
5. **Transfer Performance:** Speed and accuracy metrics

### Inter-Branch Transfer Best Practices

✅ **DO:**
- Verify stock availability before approving
- Pack goods securely
- Use proper courier/transport
- Verify goods on receipt
- Report discrepancies immediately
- Reconcile inter-branch accounts monthly

❌ **DON'T:**
- Transfer stock you need yourself
- Send damaged goods
- Skip documentation
- Accept transfers without verification
- Delay receipt processing
- Ignore reconciliation differences

---

## Reports

### Menu: Reports

```
Reports
├── Stock Movement Report
└── Cross-Branch Lookup
```

### Stock Movement Report

#### Purpose
Track all stock movements in and out of stockroom.

#### Accessing Report

1. Click **Stockroom** → **Reports** → **Stock Movement Report**
2. Report parameters form opens

#### Report Parameters

**Filters:**
- **Date Range:** From date to To date
- **Branch:** Select branch or All Branches
- **Product:** Specific product or All Products
- **Movement Type:** Filter by type:
  * GRV Receipt
  * Issue to Manufacturing
  * Transfer Out
  * Transfer In
  * Adjustment
  * Return
  * All Types
- **Category:** Filter by product category

#### Report Columns

- **Date:** Movement date
- **Movement Type:** Type of transaction
- **Reference:** Document number (GRV, Transfer, etc.)
- **Product Code:** Product identifier
- **Product Name:** Product description
- **Quantity:** Amount moved (+ or -)
- **Unit:** Unit of measure
- **Cost:** Unit cost
- **Total Value:** Qty × Cost
- **Balance:** Running balance
- **Branch:** Which branch
- **User:** Who processed

#### Using the Report

**Analysis:**
- Track product usage patterns
- Identify fast/slow movers
- Verify stock accuracy
- Investigate discrepancies
- Plan reorders

**Export Options:**
- PDF for printing
- Excel for analysis
- CSV for import to other systems

### Cross-Branch Lookup

#### Purpose
View stock levels across all branches for a product.

#### Accessing Report

1. Click **Stockroom** → **Reports** → **Cross-Branch Lookup**
2. Lookup form opens

#### Using Cross-Branch Lookup

**Search for Product:**
1. Enter product code or name
2. Click **Search**
3. Results show stock at all branches

**Report Shows:**

| Branch | Qty on Hand | Reorder Level | Status | Last Movement | Available for Transfer |
|--------|-------------|---------------|--------|---------------|------------------------|
| JHB Main | 150 | 100 | ✓ OK | 2 days ago | 50 |
| CPT Waterfront | 45 | 100 | ⚠️ Low | 1 day ago | 0 |
| DBN Central | 200 | 100 | ✓ OK | 3 days ago | 100 |

**Status Indicators:**
- ✓ **OK:** Above reorder level
- ⚠️ **Low:** Below reorder level
- ✗ **Out:** Zero stock

**Available for Transfer:**
- Quantity that can be transferred without going below reorder level
- Helps identify which branch can supply others

**Actions:**
- Click branch to see detailed stock info
- Click **Request Transfer** to initiate transfer
- Export report for planning

#### Use Cases

**Scenario 1: Stock Shortage**
- Your branch running low on product
- Check cross-branch lookup
- See which branches have excess
- Request transfer from branch with most available

**Scenario 2: Reorder Planning**
- Check total stock across all branches
- Decide if company-wide reorder needed
- Or just transfer between branches

**Scenario 3: Stock Balancing**
- Identify branches with excess
- Identify branches with shortage
- Plan transfers to balance network

---

## Stockroom Module Summary

### Key Takeaways

✅ **Purchase Orders**
- Create POs for raw materials and external products
- Get approvals based on value
- Track order status
- Manage supplier relationships

✅ **Inventory Management**
- Maintain product catalog
- Distinguish Raw Materials vs External Products
- Set reorder levels
- Track costs and pricing

✅ **GRV Management**
- Receive goods from suppliers
- Inspect quality
- Update inventory
- Document discrepancies

✅ **Supply Invoices**
- Match invoices to GRVs
- Three-way match process
- Query variances
- Approve for payment

✅ **Inter-Branch Transfer**
- Balance stock across branches
- Request and fulfill transfers
- Track in-transit goods
- Reconcile inter-branch accounts

✅ **Reports**
- Stock movement tracking
- Cross-branch visibility
- Analysis and planning

### Common Tasks Quick Reference

| Task | Steps |
|------|-------|
| Create PO | Stockroom → Purchase Orders → Create PO |
| Add Product | Stockroom → Inventory Management → Add Inventory |
| Receive Goods | Stockroom → GRV Management → New GRV |
| Capture Invoice | Stockroom → Supply Invoices → Capture Invoice |
| Request Transfer | Stockroom → Inter-Branch Transfer → Requests List |
| View Stock Movements | Stockroom → Reports → Stock Movement Report |

### Critical Reminders

⚠️ **Product Classification:**
- Raw Materials go to Stockroom_Inventory
- External Products go to Retail_Products_Inventory
- Choose correctly when adding products!

⚠️ **Three-Way Match:**
- PO + GRV + Invoice must match
- Don't skip this process
- Prevents payment errors

⚠️ **FIFO:**
- First In, First Out for perishables
- Check expiry dates
- Rotate stock properly

### Support and Help

**Need Help?**
- Press F1 for context-sensitive help
- Check [User Manual Index](USER_MANUAL_00_INDEX.md)
- Contact Stockroom Manager
- IT Support: support@ovendelights.co.za

---

**Next Module:** [Manufacturing Management](USER_MANUAL_04_MANUFACTURING.md)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026

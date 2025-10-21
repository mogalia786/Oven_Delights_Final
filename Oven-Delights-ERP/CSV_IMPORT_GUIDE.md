# CSV Import Feature Guide

## Overview
The Utilities menu provides CSV import functionality for bulk importing Products and Suppliers into the ERP system.

## Features

### 🎯 Smart Column Mapping
- **Auto-detection**: Automatically matches CSV column headers to database fields
- **Case-insensitive**: Handles variations like "Company Name", "CompanyName", "company_name"
- **Multiple variations**: Recognizes common field name variations
- **Manual override**: Adjust mappings via dropdown menus if auto-detection is incorrect

### 📊 Preview Before Import
- View first 10 rows of data
- See column mappings before importing
- Adjust mappings as needed

### ✅ Data Validation
- Duplicate detection (skips existing records)
- Field length validation (auto-truncates)
- Row-level error handling (continues on errors)
- Detailed import summary

---

## Import Suppliers

### Access
**Utilities → Import Suppliers from CSV**

### CSV Format

#### Required Field
- **CompanyName** (required)

#### Optional Fields
- ContactPerson
- Email
- Phone
- Address
- City
- PostalCode
- Country
- VATNumber
- IsActive (1 = active, 0 = inactive)

### Recognized Column Name Variations

| Database Field | Recognized Variations |
|----------------|----------------------|
| CompanyName | CompanyName, Company Name, Company, Supplier Name, Name |
| ContactPerson | ContactPerson, Contact Person, Contact, Contact Name |
| Email | Email, E-mail, EmailAddress, Email Address |
| Phone | Phone, Telephone, Tel, PhoneNumber, Phone Number, Mobile |
| Address | Address, Street Address, Physical Address |
| City | City, Town |
| PostalCode | PostalCode, Postal Code, Zip, ZipCode, Zip Code, Post Code |
| Country | Country |
| VATNumber | VATNumber, VAT Number, VAT, TaxNumber, Tax Number |
| IsActive | IsActive, Active, Status |

### Example CSV

```csv
Company Name,Contact Person,Email,Phone,Postal Code,Country
ABC Suppliers,John Smith,john@abc.com,011-123-4567,2000,South Africa
XYZ Trading,Jane Doe,jane@xyz.com,011-987-6543,2001,South Africa
```

### Field Limits
- CompanyName: 255 chars
- ContactPerson: 100 chars
- Email: 100 chars
- Phone: 50 chars
- Address: 200 chars
- City: 100 chars
- PostalCode: 20 chars
- Country: 100 chars
- VATNumber: 50 chars

---

## Import Products

### Access
**Utilities → Import Products from CSV**

### CSV Format

#### Required Fields
- **ProductCode** (required, unique)
- **ProductName** (required)

#### Optional Fields
- CategoryID
- ItemType (internal/external)
- LastPaidPrice
- AverageCost
- ReorderLevel
- ReorderQuantity
- IsActive (1 = active, 0 = inactive)

### Example CSV

```csv
ProductCode,ProductName,CategoryID,ItemType,LastPaidPrice,AverageCost,ReorderLevel,ReorderQuantity,IsActive
BREAD001,White Bread,5,external,12.50,12.00,50,100,1
FLOUR001,Cake Flour,3,internal,45.00,43.50,20,50,1
```

---

## Import Process

### Step 1: Select CSV File
1. Click **Browse** button
2. Select your CSV file
3. File path will be displayed

### Step 2: Preview Data
1. Click **Preview Data** button
2. Review first 10 rows in the grid
3. Check the **Column Mapping** section below the grid
4. Adjust any incorrect mappings using the dropdowns

### Step 3: Import
1. Click **Import Products** or **Import Suppliers**
2. Confirm the import action
3. Wait for completion message
4. Review import summary:
   - Number of records imported
   - Number of records skipped (duplicates/errors)

---

## Tips & Best Practices

### ✅ Do's
- Use descriptive column headers that match database fields
- Include header row in your CSV
- Test with a small sample first
- Review the preview before importing
- Keep field values within size limits

### ❌ Don'ts
- Don't include duplicate records (they'll be skipped)
- Don't exceed field length limits (will be truncated)
- Don't use special characters in CSV delimiters
- Don't import without previewing first

---

## Troubleshooting

### Issue: Columns not mapping correctly
**Solution**: Use the dropdown menus in the Column Mapping section to manually map columns

### Issue: Records being skipped
**Reasons**:
- Duplicate ProductCode/CompanyName already exists
- Required fields are empty
- Data validation errors

**Solution**: Check the skipped count in the summary and review your CSV data

### Issue: Field truncation
**Reason**: Field values exceed database column size limits

**Solution**: Data is automatically truncated to fit. Review field limits above.

---

## Technical Notes

### Duplicate Detection
- **Suppliers**: Checked by CompanyName
- **Products**: Checked by ProductCode

### Error Handling
- Row-level errors don't stop the entire import
- Failed rows are counted as "skipped"
- Errors are logged to debug output

### Performance
- Imports process one row at a time
- Large files (1000+ rows) may take a few minutes
- Progress is shown in the status label

---

## Support

For issues or questions:
1. Check this guide first
2. Review the import summary for specific errors
3. Contact your system administrator
4. Check debug output for detailed error messages

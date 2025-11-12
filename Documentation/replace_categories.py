import csv

# Read categories and create lookup dictionary
categories = {}
with open(r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\sql category data.csv', 'r', encoding='utf-8-sig') as f:
    reader = csv.reader(f)
    for row in reader:
        if len(row) >= 2 and row[1].strip():
            category_name = row[1].strip().lower()
            category_id = row[0].strip()
            categories[category_name] = category_id

print(f"Loaded {len(categories)} categories")

# Read products and replace category names with IDs
products = []
not_found = set()
with open(r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_NEW_2025.csv', 'r', encoding='utf-8-sig') as f:
    reader = csv.reader(f)
    header = next(reader)
    products.append(header)
    
    for row in reader:
        if len(row) >= 6:
            category_name = row[3].strip().lower()
            category_id = categories.get(category_name, '')
            
            if not category_id and category_name:
                not_found.add(row[3].strip())
            
            # Replace category name with ID
            new_row = [row[0], row[1], row[2], category_id, row[4], row[5]]
            products.append(new_row)

# Write new CSV with category IDs
with open(r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_WITH_CATEGORY_IDS.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerows(products)

print(f"\nCreated ITEM_LIST_WITH_CATEGORY_IDS.csv with {len(products)-1} products")

if not_found:
    print(f"\nWarning: {len(not_found)} category names not found in database:")
    for cat in sorted(not_found):
        print(f"  - {cat}")

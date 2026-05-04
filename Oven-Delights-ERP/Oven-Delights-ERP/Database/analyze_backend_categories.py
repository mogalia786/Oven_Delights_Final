import csv
from collections import defaultdict

backend_csv = r"C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Copy of ITEM LIST NEW 2025 updated_Back End.csv"

# Read CSV
with open(backend_csv, 'r', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    rows = list(reader)

print(f"Total Backend products: {len(rows)}")

# Analyze structure
categories = defaultdict(lambda: {'subcategories': set(), 'item_types': set(), 'count': 0})

for row in rows:
    main_cat = (row['Main Category'] or '').strip()
    sub_cat = (row['Sub Category'] or '').strip()
    item_type = (row['item catergory'] or '').strip()
    
    if main_cat:
        categories[main_cat]['subcategories'].add(sub_cat)
        categories[main_cat]['item_types'].add(item_type)
        categories[main_cat]['count'] += 1

print(f"\n{'='*80}")
print(f"BACK END - MAIN CATEGORIES BREAKDOWN")
print(f"{'='*80}\n")

for main_cat in sorted(categories.keys()):
    data = categories[main_cat]
    print(f"\n{main_cat} ({data['count']} products)")
    print(f"  Item Types: {', '.join(sorted(data['item_types']))}")
    print(f"  Subcategories ({len(data['subcategories'])}):")
    for sub in sorted(data['subcategories']):
        if sub:
            # Count products in this subcategory
            count = sum(1 for r in rows if r['Main Category'].strip() == main_cat and r['Sub Category'].strip() == sub)
            print(f"    - {sub} ({count} products)")

# Analyze item_catergory distribution
print(f"\n{'='*80}")
print(f"BACK END - ITEM CATEGORY (internal/external) DISTRIBUTION")
print(f"{'='*80}\n")

item_type_counts = defaultdict(int)
for row in rows:
    item_type = (row['item catergory'] or '').strip()
    item_type_counts[item_type] += 1

for item_type, count in sorted(item_type_counts.items()):
    print(f"  {item_type}: {count} products")

# Show which main categories have internal vs external
print(f"\n{'='*80}")
print(f"BACK END - POS VISIBILITY RECOMMENDATION")
print(f"{'='*80}\n")

for main_cat in sorted(categories.keys()):
    data = categories[main_cat]
    types = ', '.join(sorted(data['item_types']))
    
    # Determine POS visibility
    has_internal = 'internal' in data['item_types']
    has_external = 'external' in data['item_types']
    
    if has_internal and not has_external:
        visibility = "POS: MAYBE (internal - check if for manufacturing or retail)"
    elif has_external and not has_internal:
        visibility = "POS: NO (external consumables/ingredients)"
    elif has_internal and has_external:
        visibility = "POS: PARTIAL (mixed - need rules)"
    else:
        visibility = "POS: UNKNOWN"
    
    print(f"{main_cat:40} | Types: {types:20} | {visibility}")

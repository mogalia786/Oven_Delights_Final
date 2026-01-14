-- =============================================
-- PREPARED SUB-RECIPE INVENTORY SYSTEM
-- Complete Implementation Guide
-- =============================================

/*
BUSINESS WORKFLOW:
==================

1. MANAGER REQUESTS PRODUCTION (Re-Order Book Manager)
   - Manager can request either:
     a) Product manufacturing (e.g., Chocolate Cake)
     b) Sub-recipe preparation (e.g., Chocolate Batter)
   - Two separate dropdowns in Re-Order Book Manager

2. BAKER PRODUCES SUB-RECIPES AHEAD OF TIME (Baker Dashboard)
   - Baker sees sub-recipe requests
   - Manufactures sub-recipes
   - System deducts ingredients from manufacturing stock
   - Sub-recipes added to inventory with timestamp
   - Batch number generated: SR-BranchPrefix-YYYYMMDD-HHMMSS

3. SMART BOM CALCULATION (When Product Requested)
   - System checks sub-recipe inventory first
   - Example: Cake needs 3x Chocolate Batter
     * 2x in inventory (prepared earlier)
     * BOM requests ingredients for only 1x Chocolate Batter
   - Net requirement = Total needed - Available in inventory

4. PRODUCT MANUFACTURING (Baker Dashboard)
   - Baker manufactures product
   - System consumes sub-recipes from inventory (FIFO - oldest first)
   - Remaining ingredients deducted from manufacturing stock
   - Product added to retail inventory

5. INVENTORY REPORT (Management)
   - Color-coded freshness:
     * 0-24 hours: Dark Green (VeryFresh)
     * 24-48 hours: Green (Fresh)
     * 48-72 hours: Light Green (Good)
     * 72-120 hours: Yellow (Aging)
     * 120-168 hours: Orange (Old)
     * >168 hours: Red (VeryOld)

DEPLOYMENT STEPS:
=================

1. Run database scripts in order:
   a) CREATE_SUBRECIPE_INVENTORY_SYSTEM.sql
   b) sp_GetAvailableSubRecipeInventory.sql
   c) sp_GetSmartBOMWithInventoryCheck.sql
   d) sp_AddSubRecipeToInventory.sql
   e) sp_ConsumeSubRecipeFromInventory.sql
   f) sp_GetSubRecipeInventoryReport.sql

2. Update forms:
   a) ReOrderBookManagerForm.vb - Add sub-recipe dropdown
   b) BakerDashboardForm.vb - Add sub-recipe production
   c) Create SubRecipeInventoryReportForm.vb - Color-coded report

3. Test workflow:
   a) Request sub-recipe production
   b) Baker produces sub-recipe
   c) Verify inventory updated
   d) Request product manufacturing
   e) Verify smart BOM calculation
   f) Baker manufactures product
   g) Verify sub-recipes consumed from inventory

TABLES CREATED:
===============

1. Demo_SubRecipe_Inventory
   - Stores prepared sub-recipes with timestamps
   - Tracks status (Available, Consumed, Expired)
   - FIFO consumption (oldest first)

2. Demo_SubRecipe_Consumption_Log
   - Tracks which products used which sub-recipes
   - Full audit trail

STORED PROCEDURES:
==================

1. sp_GetAvailableSubRecipeInventory
   - Returns available sub-recipes with freshness indicators
   - Color-coded for UI

2. sp_GetSmartBOMWithInventoryCheck
   - Checks sub-recipe inventory first
   - Calculates net ingredient requirements
   - Returns consolidated BOM

3. sp_AddSubRecipeToInventory
   - Adds sub-recipe to inventory
   - Deducts ingredients from manufacturing stock
   - Generates batch number

4. sp_ConsumeSubRecipeFromInventory
   - Consumes sub-recipes (FIFO)
   - Logs consumption
   - Updates inventory status

5. sp_GetSubRecipeInventoryReport
   - Color-coded freshness report
   - Management dashboard

COLOR CODING:
=============

FreshnessLevel | ColorCode   | RGB           | Age Range
---------------|-------------|---------------|------------------
VeryFresh      | DarkGreen   | 0,100,0       | 0-24 hours
Fresh          | Green       | 0,128,0       | 24-48 hours
Good           | LightGreen  | 144,238,144   | 48-72 hours
Aging          | Yellow      | 255,255,0     | 72-120 hours (3-5 days)
Old            | Orange      | 255,165,0     | 120-168 hours (5-7 days)
VeryOld        | Red         | 255,0,0       | >168 hours (>7 days)

EXAMPLE SCENARIO:
=================

Product: Chocolate Cake
Sub-recipes needed: 3x Chocolate Batter

Step 1: Check inventory
- 2x Chocolate Batter in stock (manufactured 2 days ago - Green)

Step 2: Smart BOM calculation
- Total needed: 3x
- In stock: 2x
- Net requirement: 1x
- BOM requests ingredients for 1x Chocolate Batter only

Step 3: Baker manufactures
- Uses 2x from inventory (FIFO - oldest first)
- Manufactures 1x fresh
- Total: 3x Chocolate Batter used for cake

Step 4: Inventory updated
- 2x consumed from inventory
- Consumption logged with product details

BENEFITS:
=========

1. Faster product manufacturing
2. Better inventory management
3. Reduced waste (FIFO consumption)
4. Full traceability (batch numbers, timestamps)
5. Visual freshness indicators
6. Optimized ingredient usage

*/

-- Run these scripts in order:

-- 1. Create tables
-- Already in CREATE_SUBRECIPE_INVENTORY_SYSTEM.sql

-- 2. Create stored procedures
-- Already in individual sp_*.sql files

-- 3. Verify deployment
SELECT 'Tables created' AS Status
WHERE EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Demo_SubRecipe_Inventory')
  AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Demo_SubRecipe_Consumption_Log')

SELECT 'Stored procedures created' AS Status
WHERE EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_GetAvailableSubRecipeInventory')
  AND EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_GetSmartBOMWithInventoryCheck')
  AND EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_AddSubRecipeToInventory')
  AND EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_ConsumeSubRecipeFromInventory')
  AND EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_GetSubRecipeInventoryReport')

PRINT 'Prepared Sub-Recipe Inventory System - Implementation Guide Complete'
GO

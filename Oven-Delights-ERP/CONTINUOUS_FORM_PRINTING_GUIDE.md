# Oven Delights Continuous Form Printing Guide

## Overview
This guide explains how to print custom orders on pre-printed continuous forms using a dot matrix printer.

## Files Created
1. **OvenDelightsOrderFormPrinter.vb** - Main printer class with positioning logic
2. **TestOrderFormPrintForm.vb** - Test utility to calibrate positions
3. **MainDashboard.vb** - Added menu item: Utilities > Test Order Form Printer

## How to Use

### Step 1: Access the Test Printer
1. Run your ERP application
2. Go to **Utilities > Test Order Form Printer**

### Step 2: Print Test Grid
1. Load your pre-printed form into the dot matrix printer
2. Click **"1. Print Test Grid"**
3. The grid will print with coordinate markers every 50 units (0.5 inch)
4. Use this to measure exact positions of each field on your form

### Step 3: Adjust Coordinates
1. Open `Services\OvenDelightsOrderFormPrinter.vb`
2. In the `PrintPage` method, adjust the X and Y coordinates for each field
3. Example:
   ```vb
   ' If "Account Number" field is at 2cm from left, 6cm from top:
   ' X = 2 × 39.37 = 79 units
   ' Y = 6 × 39.37 = 236 units
   g.DrawString(_orderData.AccountNumber, regularFont, Brushes.Black, 79, 236)
   ```

### Step 4: Test Print Sample Order
1. Click **"2. Print Sample Order"**
2. Verify alignment with your pre-printed form
3. Repeat Steps 3-4 until perfect alignment

### Step 5: Integrate with POS
Once calibrated, integrate the printer into your POS order collection workflow:

```vb
' In your order collection form:
Private Sub PrintOrderForm(orderNumber As String)
    Try
        ' Load order data from database
        Dim orderData As New OrderFormData()
        
        ' Populate from POS_CustomOrders table
        Using conn As New SqlConnection(connectionString)
            conn.Open()
            Dim sql = "SELECT * FROM POS_CustomOrders WHERE OrderNumber = @OrderNumber"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@OrderNumber", orderNumber)
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        orderData.OrderNumber = reader("OrderNumber").ToString()
                        orderData.CustomerName = reader("CustomerName").ToString()
                        orderData.CollectionDate = CDate(reader("CollectionDate"))
                        ' ... populate other fields
                    End If
                End Using
            End Using
        End Using
        
        ' Print the form
        Dim printer As New OvenDelightsOrderFormPrinter(orderData)
        printer.Print()
        
    Catch ex As Exception
        MessageBox.Show("Print error: " & ex.Message)
    End Try
End Sub
```

## Coordinate Reference

### Current Positions (adjust as needed):
- **Account Number**: X=65, Y=245
- **Customer Name**: X=65, Y=270
- **Telephone**: X=65, Y=295
- **Cell Number**: X=65, Y=320
- **Cake Colour**: X=470, Y=245
- **Cake Picture**: X=470, Y=270
- **Collection Date**: X=470, Y=295
- **Collection Day**: X=470, Y=320
- **Collection Time**: X=470, Y=345
- **Collection Point**: X=65, Y=380
- **Order Number**: X=240, Y=380
- **Order Date**: X=400, Y=380
- **Order Taken By**: X=550, Y=380
- **Line Items Start**: Y=430, Line Height=25
- **Invoice Total**: X=700 (right-aligned), Y=630
- **Deposit Paid**: X=700 (right-aligned), Y=655
- **Balance Owing**: X=700 (right-aligned), Y=680

## Unit Conversion
- **1 inch = 100 units**
- **1 cm = 39.37 units**
- **1 mm = 3.937 units**

## Tips
1. **Margins**: Set to 0 for pre-printed forms
2. **Paper Size**: Measure your form and set exact dimensions
3. **Font Size**: Use 9pt Arial for most fields, 8pt for small text
4. **Right-Align Numbers**: Use `MeasureString()` to calculate width, then subtract from right edge
5. **Test Often**: Print test grids frequently when adjusting positions
6. **Save Coordinates**: Document working coordinates in this file

## Troubleshooting

### Text prints too high/low
- Adjust Y coordinate in increments of 10-20 units
- Remember: Larger Y = lower on page

### Text prints too far left/right
- Adjust X coordinate in increments of 10-20 units
- Remember: Larger X = further right

### Text is cut off
- Check paper size settings match your actual form
- Verify printer margins are set to 0

### Printer not found
- Ensure dot matrix printer is installed and set as default
- Check printer name in PrintDialog

## Database Integration

The printer expects data from `POS_CustomOrders` table:
- OrderNumber
- CustomerName
- Telephone
- CellNumber
- CollectionDate
- CollectionPoint
- OrderTakenBy
- ManufacturingInstructions (contains cake details)
- Items from `POS_CustomOrderItems`

## Next Steps
1. Test with actual forms
2. Fine-tune coordinates
3. Add to F12 Order Collection workflow
4. Train staff on form loading

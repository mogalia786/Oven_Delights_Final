Imports System.Drawing
Imports System.Drawing.Printing

Namespace Services
    ''' <summary>
    ''' Prints custom orders on pre-printed Oven Delights continuous forms
    ''' Form size: Approximately 8.5" x 11" (850 x 1100 units in 1/100th inch)
    ''' </summary>
    Public Class OvenDelightsOrderFormPrinter
        Private ReadOnly _orderData As OrderFormData
        
        Public Sub New(orderData As OrderFormData)
            _orderData = orderData
        End Sub
        
        Public Sub Print()
            Dim printDoc As New PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintPage
            
            ' Configure for continuous form printing
            printDoc.DefaultPageSettings.Margins = New Margins(0, 0, 0, 0)
            
            ' Set paper size (adjust based on your actual form size)
            Dim paperSize As New PaperSize("Oven Delights Order Form", 850, 1100)
            printDoc.DefaultPageSettings.PaperSize = paperSize
            
            ' Show print dialog to select printer
            Dim printDialog As New PrintDialog()
            printDialog.Document = printDoc
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
            End If
        End Sub
        
        Private Sub PrintPage(sender As Object, e As PrintPageEventArgs)
            Dim g As Graphics = e.Graphics
            
            ' Define fonts for different sections
            Dim regularFont As New Font("Arial", 9, FontStyle.Regular)
            Dim boldFont As New Font("Arial", 9, FontStyle.Bold)
            Dim smallFont As New Font("Arial", 8, FontStyle.Regular)
            
            ' ===== CUSTOMER INFORMATION SECTION (Top Left) =====
            ' Account Number (below "PLEASE USE ACCOUNT NO AS REFERENCE")
            g.DrawString(_orderData.AccountNumber, regularFont, Brushes.Black, 65, 245)
            
            ' Name
            g.DrawString(_orderData.CustomerName, regularFont, Brushes.Black, 65, 270)
            
            ' Telephone
            g.DrawString(_orderData.Telephone, regularFont, Brushes.Black, 65, 295)
            
            ' Cell Number
            g.DrawString(_orderData.CellNumber, regularFont, Brushes.Black, 65, 320)
            
            ' ===== CAKE DETAILS SECTION (Top Right) =====
            ' Cake Colour
            g.DrawString(_orderData.CakeColour, regularFont, Brushes.Black, 470, 245)
            
            ' Cake Picture (WhatsApp indicator)
            g.DrawString(_orderData.CakePicture, regularFont, Brushes.Black, 470, 270)
            
            ' Collection Date
            g.DrawString(_orderData.CollectionDate.ToString("dd/MM/yyyy"), regularFont, Brushes.Black, 470, 295)
            
            ' Collection Day
            g.DrawString(_orderData.CollectionDay, regularFont, Brushes.Black, 470, 320)
            
            ' Collection Time
            g.DrawString(_orderData.CollectionTime, regularFont, Brushes.Black, 470, 345)
            
            ' ===== ORDER HEADER SECTION =====
            ' Collection Point
            g.DrawString(_orderData.CollectionPoint, regularFont, Brushes.Black, 65, 380)
            
            ' Order Number
            g.DrawString(_orderData.OrderNumber, boldFont, Brushes.Black, 240, 380)
            
            ' Date
            g.DrawString(_orderData.OrderDate.ToString("yyyy/MM/dd"), regularFont, Brushes.Black, 400, 380)
            
            ' Order Taken By
            g.DrawString(_orderData.OrderTakenBy, regularFont, Brushes.Black, 550, 380)
            
            ' ===== LINE ITEMS SECTION =====
            Dim yPos As Integer = 430 ' Starting Y position for first line item
            Dim lineHeight As Integer = 25 ' Height between lines
            Dim maxLines As Integer = 6 ' Maximum lines that fit on form
            
            Dim lineCount As Integer = 0
            For Each item In _orderData.LineItems
                If lineCount >= maxLines Then Exit For
                
                ' Item Description (left column)
                g.DrawString(item.Description, regularFont, Brushes.Black, 65, yPos)
                
                ' Quantity Required (center-left column)
                g.DrawString(item.Quantity.ToString("0.00"), regularFont, Brushes.Black, 280, yPos)
                
                ' Unit Price (center-right column)
                g.DrawString(item.UnitPrice.ToString("N2"), regularFont, Brushes.Black, 400, yPos)
                
                ' Total Price (right column) - right-aligned
                Dim totalText As String = item.TotalPrice.ToString("N2")
                Dim textSize As SizeF = g.MeasureString(totalText, regularFont)
                g.DrawString(totalText, regularFont, Brushes.Black, 700 - textSize.Width, yPos)
                
                yPos += lineHeight
                lineCount += 1
            Next
            
            ' ===== TOTALS SECTION (Bottom Right) =====
            ' Invoice Total
            Dim invoiceTotalText As String = _orderData.InvoiceTotal.ToString("N2")
            Dim invoiceSize As SizeF = g.MeasureString(invoiceTotalText, boldFont)
            g.DrawString(invoiceTotalText, boldFont, Brushes.Black, 700 - invoiceSize.Width, 630)
            
            ' Deposit Paid
            Dim depositText As String = _orderData.DepositPaid.ToString("N2")
            Dim depositSize As SizeF = g.MeasureString(depositText, regularFont)
            g.DrawString(depositText, regularFont, Brushes.Black, 700 - depositSize.Width, 655)
            
            ' Balance Owing
            Dim balanceText As String = _orderData.BalanceOwing.ToString("N2")
            Dim balanceSize As SizeF = g.MeasureString(balanceText, boldFont)
            g.DrawString(balanceText, boldFont, Brushes.Black, 700 - balanceSize.Width, 680)
            
            ' No more pages
            e.HasMorePages = False
        End Sub
        
        ''' <summary>
        ''' Prints a test grid to help measure exact positions on the form
        ''' </summary>
        Public Sub PrintTestGrid()
            Dim printDoc As New PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintTestGridPage
            
            printDoc.DefaultPageSettings.Margins = New Margins(0, 0, 0, 0)
            Dim paperSize As New PaperSize("Test Grid", 850, 1100)
            printDoc.DefaultPageSettings.PaperSize = paperSize
            
            Dim printDialog As New PrintDialog()
            printDialog.Document = printDoc
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
            End If
        End Sub
        
        Private Sub PrintTestGridPage(sender As Object, e As PrintPageEventArgs)
            Dim g As Graphics = e.Graphics
            Dim font As New Font("Arial", 7)
            
            ' Draw vertical grid lines every 50 units (0.5 inch)
            For x As Integer = 0 To 850 Step 50
                g.DrawLine(Pens.LightGray, x, 0, x, 1100)
                g.DrawString(x.ToString(), font, Brushes.Red, x + 2, 5)
            Next
            
            ' Draw horizontal grid lines every 50 units
            For y As Integer = 0 To 1100 Step 50
                g.DrawLine(Pens.LightGray, 0, y, 850, y)
                g.DrawString(y.ToString(), font, Brushes.Red, 5, y + 2)
            Next
            
            e.HasMorePages = False
        End Sub
    End Class
    
    ''' <summary>
    ''' Data structure for Oven Delights order form
    ''' </summary>
    Public Class OrderFormData
        ' Customer Information
        Public Property AccountNumber As String
        Public Property CustomerName As String
        Public Property Telephone As String
        Public Property CellNumber As String
        
        ' Cake Details
        Public Property CakeColour As String
        Public Property CakePicture As String ' e.g., "WhatsApp: Yes"
        Public Property CollectionDate As Date
        Public Property CollectionDay As String ' e.g., "Saturday"
        Public Property CollectionTime As String ' e.g., "15:30"
        
        ' Order Header
        Public Property CollectionPoint As String ' e.g., "Ayesha Centre"
        Public Property OrderNumber As String
        Public Property OrderDate As Date
        Public Property OrderTakenBy As String
        
        ' Line Items
        Public Property LineItems As List(Of OrderLineItem)
        
        ' Totals
        Public Property InvoiceTotal As Decimal
        Public Property DepositPaid As Decimal
        Public Property BalanceOwing As Decimal
        
        Public Sub New()
            LineItems = New List(Of OrderLineItem)()
        End Sub
    End Class
    
    ''' <summary>
    ''' Line item for order form
    ''' </summary>
    Public Class OrderLineItem
        Public Property Description As String
        Public Property Quantity As Decimal
        Public Property UnitPrice As Decimal
        Public Property TotalPrice As Decimal
    End Class
End Namespace

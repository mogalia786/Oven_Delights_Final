Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Namespace Manufacturing
    Public Class BOMRequisitionForm
        Inherits Form
        
        Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private reOrderBookID As Integer
        Private requisitionText As String = ""
        Private scaledBOMService As New ScaledBOMService()
        
        Public Sub New(reOrderBookID As Integer)
            Me.reOrderBookID = reOrderBookID
            InitializeComponent()
            GenerateRequisition()
        End Sub
        
        Private Sub InitializeComponent()
            Me.Text = "BOM Requisition Preview"
            Me.Size = New Size(900, 700)
            Me.StartPosition = FormStartPosition.CenterParent
            
            Dim rtb As New RichTextBox()
            rtb.Name = "rtbRequisition"
            rtb.Dock = DockStyle.Fill
            rtb.Font = New Font("Courier New", 10)
            rtb.ReadOnly = True
            
            Dim btnPrint As New Button()
            btnPrint.Name = "btnPrint"
            btnPrint.Text = "Print Requisition"
            btnPrint.Dock = DockStyle.Bottom
            btnPrint.Height = 50
            btnPrint.Font = New Font("Arial", 12, FontStyle.Bold)
            AddHandler btnPrint.Click, AddressOf BtnPrint_Click
            
            Me.Controls.Add(rtb)
            Me.Controls.Add(btnPrint)
        End Sub
        
        Private Sub GenerateRequisition()
            Dim sb As New System.Text.StringBuilder()
            
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Get header info
                    Dim cmdHeader As New SqlCommand(
                        "SELECT rb.ReOrderNumber, u.FirstName + ' ' + u.LastName AS BakerName, rb.OrderDate " &
                        "FROM ReOrderBooks rb " &
                        "LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID " &
                        "WHERE rb.ReOrderBookID = @ReOrderBookID", conn)
                    cmdHeader.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                    
                    Dim readerHeader = cmdHeader.ExecuteReader()
                    Dim reOrderNumber As String = ""
                    Dim bakerName As String = ""
                    Dim orderDate As DateTime = DateTime.Now
                    
                    If readerHeader.Read() Then
                        reOrderNumber = readerHeader("ReOrderNumber").ToString()
                        bakerName = readerHeader("BakerName").ToString()
                        orderDate = Convert.ToDateTime(readerHeader("OrderDate"))
                    End If
                    readerHeader.Close()
                    
                    ' Build header
                    sb.AppendLine("═══════════════════════════════════════════════════════════════")
                    sb.AppendLine("                    OVEN DELIGHTS")
                    sb.AppendLine("              BOM REQUISITION TO STOCKROOM")
                    sb.AppendLine("═══════════════════════════════════════════════════════════════")
                    sb.AppendLine()
                    sb.AppendLine($"Order Number:  {reOrderNumber}")
                    sb.AppendLine($"Baker:         {bakerName}")
                    sb.AppendLine($"Date:          {orderDate:dd/MM/yyyy HH:mm}")
                    sb.AppendLine()
                    sb.AppendLine("───────────────────────────────────────────────────────────────")
                    sb.AppendLine("PRODUCTS REQUESTED:")
                    sb.AppendLine("───────────────────────────────────────────────────────────────")
                    
                    ' Get products
                    Dim cmdProducts As New SqlCommand(
                        "SELECT rbl.ProductID, p.Name AS ProductName, rbl.QuantityOrdered " &
                        "FROM ReOrderBookLines rbl " &
                        "INNER JOIN Demo_Retail_Product p ON rbl.ProductID = p.ProductID " &
                        "WHERE rbl.ReOrderBookID = @ReOrderBookID " &
                        "ORDER BY rbl.LineNumber", conn)
                    cmdProducts.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                    
                    Dim readerProducts = cmdProducts.ExecuteReader()
                    Dim productList As New List(Of (ProductID As Integer, ProductName As String, Qty As Decimal))
                    
                    While readerProducts.Read()
                        productList.Add((
                            readerProducts.GetInt32(0),
                            readerProducts.GetString(1),
                            readerProducts.GetDecimal(2)
                        ))
                    End While
                    readerProducts.Close()
                    
                    ' Aggregate ingredients
                    Dim aggregatedItems As New Dictionary(Of String, (Qty As Decimal, Unit As String))
                    
                    ' Process each product using NEW Recipe Management system
                    For Each product In productList
                        sb.AppendLine()
                        sb.AppendLine($"► {product.ProductName} (Quantity: {product.Qty})")
                        
                        Try
                            ' Get scaled BOM from new Recipe Management system
                            Dim bomItems = scaledBOMService.GetScaledBOM(product.ProductID, product.Qty)
                            
                            If bomItems.Count = 0 Then
                                sb.AppendLine("   (No recipe found for this product)")
                                Continue For
                            End If
                            
                            ' Show batch info
                            Dim batchQty = bomItems.First().RecipeBatchQty
                            Dim scalingFactor = bomItems.First().ScalingFactor
                            sb.AppendLine($"   Recipe Batch: {batchQty} | Scaling Factor: {scalingFactor:N4}")
                            sb.AppendLine()
                            
                            ' List ingredients with scaled quantities
                            For Each item In bomItems
                                sb.AppendLine($"   • {item.ItemName} - {item.Quantity:N3} {item.UnitOfMeasure} ({item.ItemType})")
                                
                                ' Aggregate for total summary
                                Dim key = $"{item.ItemName}|{item.UnitOfMeasure}"
                                If aggregatedItems.ContainsKey(key) Then
                                    Dim existing = aggregatedItems(key)
                                    aggregatedItems(key) = (existing.Qty + item.Quantity, item.UnitOfMeasure)
                                Else
                                    aggregatedItems(key) = (item.Quantity, item.UnitOfMeasure)
                                End If
                                
                                ' Save to database for stockroom fulfillment
                                Dim cmdInsertLine As New SqlCommand(
                                    "INSERT INTO ReOrderBOMRequisition (ReOrderLineID, ItemID, ItemName, ItemType, Quantity, UnitOfMeasure, CostPerUnit, TotalCost) " &
                                    "SELECT rbl.ReOrderLineID, @ItemID, @ItemName, @ItemType, @Quantity, @UnitOfMeasure, @CostPerUnit, @TotalCost " &
                                    "FROM ReOrderBookLines rbl " &
                                    "WHERE rbl.ReOrderBookID = @ReOrderBookID AND rbl.ProductID = @ProductID", conn)
                                cmdInsertLine.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                                cmdInsertLine.Parameters.AddWithValue("@ProductID", product.ProductID)
                                cmdInsertLine.Parameters.AddWithValue("@ItemID", item.ItemID)
                                cmdInsertLine.Parameters.AddWithValue("@ItemName", item.ItemName)
                                cmdInsertLine.Parameters.AddWithValue("@ItemType", item.ItemType)
                                cmdInsertLine.Parameters.AddWithValue("@Quantity", item.Quantity)
                                cmdInsertLine.Parameters.AddWithValue("@UnitOfMeasure", item.UnitOfMeasure)
                                cmdInsertLine.Parameters.AddWithValue("@CostPerUnit", item.CostPerUnit)
                                cmdInsertLine.Parameters.AddWithValue("@TotalCost", item.TotalCost)
                                cmdInsertLine.ExecuteNonQuery()
                            Next
                            
                        Catch ex As Exception
                            sb.AppendLine($"   ERROR: {ex.Message}")
                        End Try
                    Next
                    
                    ' Summary
                    sb.AppendLine()
                    sb.AppendLine("═══════════════════════════════════════════════════════════════")
                    sb.AppendLine("TOTAL INGREDIENTS REQUIRED:")
                    sb.AppendLine("═══════════════════════════════════════════════════════════════")
                    
                    ' Save fulfillment items for stockroom
                    Dim cmdDeleteOld As New SqlCommand("DELETE FROM BOMRequisitionFulfillment WHERE ReOrderBookID = @ReOrderBookID", conn)
                    cmdDeleteOld.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                    cmdDeleteOld.ExecuteNonQuery()
                    
                    For Each item In aggregatedItems.OrderBy(Function(x) x.Key)
                        Dim parts = item.Key.Split("|"c)
                        sb.AppendLine($"• {parts(0)} - {item.Value.Qty:N2} {item.Value.Unit}")
                        
                        ' Save to fulfillment table
                        Dim cmdInsert As New SqlCommand(
                            "INSERT INTO BOMRequisitionFulfillment (ReOrderBookID, IngredientName, QuantityRequired, UnitOfMeasure) " &
                            "VALUES (@ReOrderBookID, @IngredientName, @QuantityRequired, @UnitOfMeasure)", conn)
                        cmdInsert.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                        cmdInsert.Parameters.AddWithValue("@IngredientName", parts(0))
                        cmdInsert.Parameters.AddWithValue("@QuantityRequired", item.Value.Qty)
                        cmdInsert.Parameters.AddWithValue("@UnitOfMeasure", item.Value.Unit)
                        cmdInsert.ExecuteNonQuery()
                    Next
                    
                    ' Mark re-order book as posted
                    Dim cmdUpdate As New SqlCommand(
                        "UPDATE ReOrderBooks SET Status = 'Posted', PostedDate = GETDATE() WHERE ReOrderBookID = @ReOrderBookID", conn)
                    cmdUpdate.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                    cmdUpdate.ExecuteNonQuery()
                    
                    sb.AppendLine()
                    sb.AppendLine("───────────────────────────────────────────────────────────────")
                    sb.AppendLine("STOCKROOM INSTRUCTIONS:")
                    sb.AppendLine("1. Review all ingredients listed above")
                    sb.AppendLine("2. Check stock availability")
                    sb.AppendLine("3. Create Purchase Orders for missing items")
                    sb.AppendLine("4. Fulfill when ready")
                    sb.AppendLine("═══════════════════════════════════════════════════════════════")
                End Using
                
                requisitionText = sb.ToString()
                Dim rtb = CType(Me.Controls("rtbRequisition"), RichTextBox)
                rtb.Text = requisitionText
                
            Catch ex As Exception
                MessageBox.Show("Error generating requisition: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
            Try
                Dim printDoc As New PrintDocument()
                AddHandler printDoc.PrintPage, AddressOf PrintPage
                printDoc.Print()
                MessageBox.Show("Requisition printed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.Close()
            Catch ex As Exception
                MessageBox.Show("Error printing: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub PrintPage(sender As Object, e As PrintPageEventArgs)
            e.Graphics.DrawString(requisitionText, New Font("Courier New", 9), Brushes.Black, 50, 50)
            e.HasMorePages = False
        End Sub
    End Class
End Namespace

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
        Private subRecipeChoices As New Dictionary(Of Integer, Boolean) ' ItemID -> UseStock (True/False)
        
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
                    
                    ' Get branch ID for sub-recipe stock checking
                    Dim branchID As Integer = AppSession.CurrentUser.BranchID
                    
                    ' Check for sub-recipes in BOM and prompt user
                    Dim subRecipeStockInfo As New List(Of (ItemID As Integer, ItemName As String, Required As Decimal, Available As Decimal))
                    
                    For Each product In productList
                        Dim bomItems = scaledBOMService.GetScaledBOM(product.ProductID, product.Qty)
                        For Each item In bomItems
                            If item.ItemType.ToLower().Contains("sub") AndAlso item.ItemType.ToLower().Contains("recipe") Then
                                ' Check stock availability
                                Dim cmdCheckStock As New SqlCommand(
                                    "SELECT ISNULL(SUM(Quantity), 0) FROM Demo_SubRecipe_Inventory " &
                                    "WHERE SubRecipeID = @SubRecipeID AND BranchID = @BranchID AND Status = 'Available'", conn)
                                cmdCheckStock.Parameters.AddWithValue("@SubRecipeID", item.ItemID)
                                cmdCheckStock.Parameters.AddWithValue("@BranchID", branchID)
                                Dim availableStock = Convert.ToDecimal(cmdCheckStock.ExecuteScalar())
                                
                                If availableStock > 0 Then
                                    ' Find if already added
                                    Dim existing = subRecipeStockInfo.FirstOrDefault(Function(x) x.ItemID = item.ItemID)
                                    If existing.ItemID = 0 Then
                                        subRecipeStockInfo.Add((item.ItemID, item.ItemName, item.Quantity, availableStock))
                                    Else
                                        ' Update required quantity
                                        Dim idx = subRecipeStockInfo.IndexOf(existing)
                                        subRecipeStockInfo(idx) = (existing.ItemID, existing.ItemName, existing.Required + item.Quantity, existing.Available)
                                    End If
                                End If
                            End If
                        Next
                    Next
                    
                    ' Prompt user for each sub-recipe with available stock
                    For Each subRecipe In subRecipeStockInfo
                        Dim promptMessage As String
                        If subRecipe.Available >= subRecipe.Required Then
                            promptMessage = $"You have {subRecipe.Available} {subRecipe.ItemName} in stock." & vbCrLf &
                                          $"You need {subRecipe.Required}." & vbCrLf & vbCrLf &
                                          $"Do you want to use from stock?" & vbCrLf &
                                          $"(If YES: Sub-recipe ingredients will be EXCLUDED from requisition)" & vbCrLf &
                                          $"(If NO: Request fresh ingredients for all {subRecipe.Required})"
                        Else
                            promptMessage = $"You have {subRecipe.Available} {subRecipe.ItemName} in stock." & vbCrLf &
                                          $"You need {subRecipe.Required}." & vbCrLf & vbCrLf &
                                          $"Do you want to use the {subRecipe.Available} from stock?" & vbCrLf &
                                          $"(If YES: Ingredients for only {subRecipe.Required - subRecipe.Available} will be requested)" & vbCrLf &
                                          $"(If NO: Request fresh ingredients for all {subRecipe.Required})"
                        End If
                        
                        Dim result = MessageBox.Show(promptMessage, "Use Sub-Recipe Stock?", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                        subRecipeChoices(subRecipe.ItemID) = (result = DialogResult.Yes)
                    Next
                    
                    ' Aggregate ingredients
                    Dim aggregatedItems As New Dictionary(Of String, (Qty As Decimal, Unit As String))
                    
                    ' Build a list of sub-recipe IDs that will use stock (to exclude their ingredients)
                    Dim subRecipesUsingStock As New HashSet(Of Integer)
                    For Each choice In subRecipeChoices
                        If choice.Value = True Then
                            subRecipesUsingStock.Add(choice.Key)
                        End If
                    Next
                    
                    ' Get mapping of which ingredients belong to which sub-recipes
                    Dim subRecipeIngredients As New Dictionary(Of Integer, List(Of Integer)) ' SubRecipeID -> List of IngredientIDs
                    For Each subRecipeID In subRecipesUsingStock
                        Dim cmdGetIngredients As New SqlCommand(
                            "SELECT IngredientID FROM Demo_SubRecipe_Ingredients WHERE SubRecipeID = @SubRecipeID AND IsActive = 1", conn)
                        cmdGetIngredients.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                        Dim ingredientReader = cmdGetIngredients.ExecuteReader()
                        Dim ingredientList As New List(Of Integer)
                        While ingredientReader.Read()
                            ingredientList.Add(ingredientReader.GetInt32(0))
                        End While
                        ingredientReader.Close()
                        subRecipeIngredients(subRecipeID) = ingredientList
                    Next
                    
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
                                Dim isSubRecipe = item.ItemType.ToLower().Contains("sub") AndAlso item.ItemType.ToLower().Contains("recipe")
                                Dim useStock = isSubRecipe AndAlso subRecipeChoices.ContainsKey(item.ItemID) AndAlso subRecipeChoices(item.ItemID)
                                
                                ' Check if this ingredient belongs to a sub-recipe that's using stock
                                Dim isIngredientOfStockSubRecipe = False
                                If item.ItemType.ToLower() = "ingredient" Then
                                    For Each kvp In subRecipeIngredients
                                        If kvp.Value.Contains(item.ItemID) Then
                                            isIngredientOfStockSubRecipe = True
                                            Exit For
                                        End If
                                    Next
                                End If
                                
                                ' Calculate adjusted quantity if using stock
                                Dim adjustedQty = item.Quantity
                                Dim displayNote = ""
                                
                                If useStock Then
                                    ' Sub-recipe using stock
                                    Dim cmdStock As New SqlCommand(
                                        "SELECT ISNULL(SUM(Quantity), 0) FROM Demo_SubRecipe_Inventory " &
                                        "WHERE SubRecipeID = @SubRecipeID AND BranchID = @BranchID AND Status = 'Available'", conn)
                                    cmdStock.Parameters.AddWithValue("@SubRecipeID", item.ItemID)
                                    cmdStock.Parameters.AddWithValue("@BranchID", branchID)
                                    Dim availableStock = Convert.ToDecimal(cmdStock.ExecuteScalar())
                                    
                                    If availableStock >= item.Quantity Then
                                        adjustedQty = 0 ' Exclude completely
                                        displayNote = " [USING STOCK - EXCLUDED]"
                                    Else
                                        adjustedQty = item.Quantity - availableStock ' Partial
                                        displayNote = $" [USING {availableStock} FROM STOCK - REQUESTING {adjustedQty}]"
                                    End If
                                ElseIf isIngredientOfStockSubRecipe Then
                                    ' Ingredient belongs to a sub-recipe using stock - exclude it
                                    adjustedQty = 0
                                    displayNote = " [EXCLUDED - Sub-recipe using stock]"
                                End If
                                
                                sb.AppendLine($"   • {item.ItemName} - {item.Quantity:N3} {item.UnitOfMeasure} ({item.ItemType}){displayNote}")
                                
                                ' Only aggregate if not completely excluded
                                If adjustedQty > 0 Then
                                    Dim key = $"{item.ItemName}|{item.UnitOfMeasure}"
                                    If aggregatedItems.ContainsKey(key) Then
                                        Dim existing = aggregatedItems(key)
                                        aggregatedItems(key) = (existing.Qty + adjustedQty, item.UnitOfMeasure)
                                    Else
                                        aggregatedItems(key) = (adjustedQty, item.UnitOfMeasure)
                                    End If
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
                    
                    ' Save sub-recipe usage choices to database for production completion
                    For Each choice In subRecipeChoices
                        Dim cmdSaveChoice As New SqlCommand(
                            "INSERT INTO ReOrderBook_SubRecipeUsage (ReOrderBookID, SubRecipeID, UseStock) " &
                            "VALUES (@ReOrderBookID, @SubRecipeID, @UseStock)", conn)
                        cmdSaveChoice.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                        cmdSaveChoice.Parameters.AddWithValue("@SubRecipeID", choice.Key)
                        cmdSaveChoice.Parameters.AddWithValue("@UseStock", choice.Value)
                        cmdSaveChoice.ExecuteNonQuery()
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
                    sb.AppendLine()
                    sb.AppendLine()
                    sb.AppendLine("BAKER DETAILS:")
                    sb.AppendLine($"Name: {bakerName}")
                    sb.AppendLine($"Requested Date/Time: {orderDate:dd/MM/yyyy HH:mm}")
                    sb.AppendLine()
                    sb.AppendLine("Baker Signature: _______________________________")
                    sb.AppendLine()
                    sb.AppendLine()
                    sb.AppendLine("STOCKROOM MANAGER ACKNOWLEDGEMENT:")
                    sb.AppendLine()
                    sb.AppendLine("Manager Signature: _______________________________")
                    sb.AppendLine()
                    sb.AppendLine("Time Received: _______________________________")
                    sb.AppendLine()
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

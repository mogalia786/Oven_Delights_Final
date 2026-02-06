Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing.Printing

Public Class PurchaseOrderViewerForm
    Inherits Form
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private purchaseOrderId As Integer = 0
    Private printDocument As New PrintDocument()
    Private printFont As Font
    Private printY As Integer = 0
    Private printPageNumber As Integer = 0
    
    Public Sub New(poId As Integer)
        purchaseOrderId = poId
        InitializeComponent()
        Me.Text = "Purchase Order Viewer"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        AddHandler printDocument.PrintPage, AddressOf PrintDocument_PrintPage
        AddHandler Me.Load, AddressOf PurchaseOrderViewerForm_Load
    End Sub
    
    Private Sub PurchaseOrderViewerForm_Load(sender As Object, e As EventArgs)
        LoadPurchaseOrder()
    End Sub
    
    Private Sub InitializeComponent()
        ' Main panel
        Dim pnlMain As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(15)
        }
        
        ' Header group
        Dim grpHeader As New GroupBox With {
            .Text = "Purchase Order Details",
            .Dock = DockStyle.Top,
            .Height = 200,
            .Padding = New Padding(10)
        }
        
        ' Header fields
        Dim lblPONumber As New Label With {.Text = "PO Number:", .Location = New Point(20, 30), .AutoSize = True}
        Dim txtPONumber As New TextBox With {.Name = "txtPONumber", .Location = New Point(150, 27), .Width = 200, .ReadOnly = True, .Font = New Font("Segoe UI", 10, FontStyle.Bold)}
        
        Dim lblSupplier As New Label With {.Text = "Supplier:", .Location = New Point(400, 30), .AutoSize = True}
        Dim txtSupplier As New TextBox With {.Name = "txtSupplier", .Location = New Point(480, 27), .Width = 300, .ReadOnly = True}
        
        Dim lblOrderDate As New Label With {.Text = "Order Date:", .Location = New Point(20, 60), .AutoSize = True}
        Dim txtOrderDate As New TextBox With {.Name = "txtOrderDate", .Location = New Point(150, 57), .Width = 150, .ReadOnly = True}
        
        Dim lblExpectedDate As New Label With {.Text = "Expected Date:", .Location = New Point(400, 60), .AutoSize = True}
        Dim txtExpectedDate As New TextBox With {.Name = "txtExpectedDate", .Location = New Point(520, 57), .Width = 150, .ReadOnly = True}
        
        Dim lblBranch As New Label With {.Text = "Branch:", .Location = New Point(20, 90), .AutoSize = True}
        Dim txtBranch As New TextBox With {.Name = "txtBranch", .Location = New Point(150, 87), .Width = 200, .ReadOnly = True}
        
        Dim lblStatus As New Label With {.Text = "Status:", .Location = New Point(400, 90), .AutoSize = True}
        Dim txtStatus As New TextBox With {.Name = "txtStatus", .Location = New Point(480, 87), .Width = 120, .ReadOnly = True}
        
        Dim lblInvoice As New Label With {.Text = "Linked Invoice:", .Location = New Point(620, 90), .AutoSize = True}
        Dim txtInvoice As New TextBox With {.Name = "txtInvoice", .Location = New Point(730, 87), .Width = 150, .ReadOnly = True}
        
        Dim lblSubTotal As New Label With {.Text = "Sub Total:", .Location = New Point(20, 120), .AutoSize = True}
        Dim txtSubTotal As New TextBox With {.Name = "txtSubTotal", .Location = New Point(150, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblVAT As New Label With {.Text = "VAT:", .Location = New Point(300, 120), .AutoSize = True}
        Dim txtVAT As New TextBox With {.Name = "txtVAT", .Location = New Point(350, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblTotal As New Label With {.Text = "Total:", .Location = New Point(500, 120), .AutoSize = True}
        Dim txtTotal As New TextBox With {.Name = "txtTotal", .Location = New Point(560, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 10, FontStyle.Bold)}
        
        Dim lblNotes As New Label With {.Text = "Notes:", .Location = New Point(20, 150), .AutoSize = True}
        Dim txtNotes As New TextBox With {.Name = "txtNotes", .Location = New Point(150, 147), .Width = 600, .Height = 40, .ReadOnly = True, .Multiline = True}
        
        Dim lblInfo As New Label With {
            .Text = "Note: Totals shown are based on ORDERED quantities. Invoice totals may differ if partial quantities were received.",
            .Location = New Point(20, 175),
            .Width = 750,
            .ForeColor = Color.DarkBlue,
            .Font = New Font("Segoe UI", 8, FontStyle.Italic)
        }
        
        grpHeader.Controls.AddRange({lblPONumber, txtPONumber, lblSupplier, txtSupplier, lblOrderDate, txtOrderDate,
                                     lblExpectedDate, txtExpectedDate, lblBranch, txtBranch, lblStatus, txtStatus,
                                     lblInvoice, txtInvoice, lblSubTotal, txtSubTotal, lblVAT, txtVAT, lblTotal, txtTotal, lblNotes, txtNotes, lblInfo})
        
        ' Lines group
        Dim grpLines As New GroupBox With {
            .Text = "Purchase Order Lines",
            .Dock = DockStyle.Fill,
            .Padding = New Padding(10)
        }
        
        Dim dgvLines As New DataGridView With {
            .Name = "dgvLines",
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
        }
        
        grpLines.Controls.Add(dgvLines)
        
        ' Buttons panel
        Dim pnlButtons As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .Padding = New Padding(10)
        }
        
        Dim btnPrint As New Button With {
            .Text = "Print Purchase Order",
            .Location = New Point(10, 15),
            .Width = 150,
            .Height = 35,
            .BackColor = Color.Green,
            .ForeColor = Color.White
        }
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        
        Dim btnClose As New Button With {
            .Text = "Close",
            .Location = New Point(170, 15),
            .Width = 100,
            .Height = 35
        }
        AddHandler btnClose.Click, Sub() Me.Close()
        
        pnlButtons.Controls.AddRange({btnPrint, btnClose})
        
        ' Add to main panel
        pnlMain.Controls.AddRange({grpLines, grpHeader})
        
        ' Add to form
        Me.Controls.AddRange({pnlMain, pnlButtons})
    End Sub
    
    Private Sub LoadPurchaseOrder()
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                
                ' Load PO header
                Dim sql = "SELECT po.PurchaseOrderID, po.PONumber, po.OrderDate, po.RequiredDate, po.DeliveryDate, " &
                         "po.SubTotal, po.VATAmount, po.TotalAmount, po.Status, po.Notes, " &
                         "s.CompanyName, b.BranchName, " &
                         "COALESCE((SELECT TOP 1 InvoiceNumber FROM SupplierInvoices WHERE PurchaseOrderID = po.PurchaseOrderID), " &
                         "(SELECT TOP 1 DeliveryNote FROM GoodsReceivedNotes WHERE PurchaseOrderID = po.PurchaseOrderID), " &
                         "'Not Invoiced') AS LinkedInvoice " &
                         "FROM PurchaseOrders po " &
                         "INNER JOIN Suppliers s ON s.SupplierID = po.SupplierID " &
                         "LEFT JOIN Branches b ON b.BranchID = po.BranchID " &
                         "WHERE po.PurchaseOrderID = @POID"
                
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@POID", purchaseOrderId)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            DirectCast(Me.Controls.Find("txtPONumber", True)(0), TextBox).Text = reader("PONumber").ToString()
                            DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox).Text = reader("CompanyName").ToString()
                            DirectCast(Me.Controls.Find("txtOrderDate", True)(0), TextBox).Text = Convert.ToDateTime(reader("OrderDate")).ToString("dd MMM yyyy")
                            
                            ' Use DeliveryDate if available, otherwise RequiredDate
                            Dim expectedDate As String = "N/A"
                            If Not IsDBNull(reader("DeliveryDate")) Then
                                expectedDate = Convert.ToDateTime(reader("DeliveryDate")).ToString("dd MMM yyyy")
                            ElseIf Not IsDBNull(reader("RequiredDate")) Then
                                expectedDate = Convert.ToDateTime(reader("RequiredDate")).ToString("dd MMM yyyy")
                            End If
                            DirectCast(Me.Controls.Find("txtExpectedDate", True)(0), TextBox).Text = expectedDate
                            
                            DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox).Text = If(IsDBNull(reader("BranchName")), "N/A", reader("BranchName").ToString())
                            DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox).Text = reader("Status").ToString()
                            DirectCast(Me.Controls.Find("txtInvoice", True)(0), TextBox).Text = reader("LinkedInvoice").ToString()
                            DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("SubTotal")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Text = Convert.ToDecimal(reader("VATAmount")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("TotalAmount")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtNotes", True)(0), TextBox).Text = If(IsDBNull(reader("Notes")), "", reader("Notes").ToString())
                        Else
                            MessageBox.Show("Purchase Order not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            Me.Close()
                            Return
                        End If
                    End Using
                End Using
                
                ' Load PO lines
                Dim linesSql = "SELECT pol.POLineID, pol.ItemSource, " &
                              "CASE " &
                              "  WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName " &
                              "  WHEN p.ProductID IS NOT NULL THEN p.Name " &
                              "  ELSE 'Unknown Item' " &
                              "END AS Description, " &
                              "pol.OrderedQuantity, pol.UnitCost, pol.LineTotal " &
                              "FROM PurchaseOrderLines pol " &
                              "INNER JOIN PurchaseOrders po ON pol.PurchaseOrderID = po.PurchaseOrderID " &
                              "LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID " &
                              "LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID AND p.BranchID = po.BranchID " &
                              "WHERE pol.PurchaseOrderID = @POID " &
                              "ORDER BY pol.POLineID"
                
                Using cmd As New SqlCommand(linesSql, con)
                    cmd.Parameters.AddWithValue("@POID", purchaseOrderId)
                    
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    
                    Dim dgvLinesArray = Me.Controls.Find("dgvLines", True)
                    If dgvLinesArray.Length = 0 Then
                        MessageBox.Show("DataGridView control not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Me.Close()
                        Return
                    End If
                    
                    Dim dgvLines = DirectCast(dgvLinesArray(0), DataGridView)
                    dgvLines.DataSource = dt
                    
                    If dgvLines.Columns.Count > 0 Then
                        dgvLines.Columns("POLineID").Visible = False
                        dgvLines.Columns("ItemSource").HeaderText = "Type"
                        dgvLines.Columns("ItemSource").Width = 80
                        dgvLines.Columns("Description").HeaderText = "Description"
                        dgvLines.Columns("OrderedQuantity").HeaderText = "Quantity"
                        dgvLines.Columns("OrderedQuantity").DefaultCellStyle.Format = "N4"
                        dgvLines.Columns("OrderedQuantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvLines.Columns("UnitCost").HeaderText = "Unit Cost"
                        dgvLines.Columns("UnitCost").DefaultCellStyle.Format = "N4"
                        dgvLines.Columns("UnitCost").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvLines.Columns("LineTotal").HeaderText = "Total"
                        dgvLines.Columns("LineTotal").DefaultCellStyle.Format = "N4"
                        dgvLines.Columns("LineTotal").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error loading Purchase Order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.Close()
        End Try
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            printFont = New Font("Arial", 10)
            printPageNumber = 0
            
            Dim preview As New PrintPreviewDialog With {
                .Document = printDocument,
                .WindowState = FormWindowState.Maximized
            }
            preview.ShowDialog()
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        printY = 50
        printPageNumber += 1
        
        Dim titleFont As New Font("Arial", 16, FontStyle.Bold)
        Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
        Dim normalFont As New Font("Arial", 10)
        Dim smallFont As New Font("Arial", 8)
        
        ' Company header
        e.Graphics.DrawString("OVEN DELIGHTS", titleFont, Brushes.Black, 50, printY)
        printY += 30
        e.Graphics.DrawString("PURCHASE ORDER", headerFont, Brushes.Black, 50, printY)
        printY += 40
        
        ' PO details
        Dim txtPONumber = DirectCast(Me.Controls.Find("txtPONumber", True)(0), TextBox)
        Dim txtSupplier = DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox)
        Dim txtOrderDate = DirectCast(Me.Controls.Find("txtOrderDate", True)(0), TextBox)
        Dim txtExpectedDate = DirectCast(Me.Controls.Find("txtExpectedDate", True)(0), TextBox)
        Dim txtBranch = DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox)
        Dim txtStatus = DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox)
        Dim txtNotes = DirectCast(Me.Controls.Find("txtNotes", True)(0), TextBox)
        
        e.Graphics.DrawString($"PO Number: {txtPONumber.Text}", normalFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString($"Date: {txtOrderDate.Text}", normalFont, Brushes.Black, 500, printY)
        printY += 25
        
        e.Graphics.DrawString($"Supplier: {txtSupplier.Text}", normalFont, Brushes.Black, 50, printY)
        printY += 25
        
        e.Graphics.DrawString($"Branch: {txtBranch.Text}", normalFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString($"Expected: {txtExpectedDate.Text}", normalFont, Brushes.Black, 500, printY)
        printY += 25
        
        e.Graphics.DrawString($"Status: {txtStatus.Text}", normalFont, Brushes.Black, 400, printY)
        Dim txtInvoice = DirectCast(Me.Controls.Find("txtInvoice", True)(0), TextBox)
        e.Graphics.DrawString($"Linked Invoice: {txtInvoice.Text}", normalFont, Brushes.Black, 550, printY)
        printY += 25
        
        If Not String.IsNullOrWhiteSpace(txtNotes.Text) Then
            e.Graphics.DrawString($"Notes: {txtNotes.Text}", normalFont, Brushes.Black, 50, printY)
            printY += 25
        End If
        
        printY += 15
        
        ' Line items header
        e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
        printY += 5
        
        e.Graphics.DrawString("Description", headerFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString("Quantity", headerFont, Brushes.Black, 500, printY)
        e.Graphics.DrawString("Unit Cost", headerFont, Brushes.Black, 600, printY)
        e.Graphics.DrawString("Total", headerFont, Brushes.Black, 710, printY)
        printY += 25
        
        e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
        printY += 10
        
        ' Line items
        Dim dgvLines = DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView)
        For Each row As DataGridViewRow In dgvLines.Rows
            If Not row.IsNewRow Then
                Dim description As String = If(row.Cells("Description").Value, "").ToString()
                
                ' Truncate long descriptions
                If description.Length > 60 Then
                    description = description.Substring(0, 57) & "..."
                End If
                
                e.Graphics.DrawString(description, normalFont, Brushes.Black, 50, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("OrderedQuantity").Value).ToString("N4"), normalFont, Brushes.Black, 500, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("UnitCost").Value).ToString("N4"), normalFont, Brushes.Black, 600, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("LineTotal").Value).ToString("N4"), normalFont, Brushes.Black, 710, printY)
                printY += 20
            End If
        Next
        
        printY += 10
        e.Graphics.DrawLine(Pens.Black, 50, printY, 780, printY)
        printY += 20
        
        ' Totals - Right aligned with proper labels
        Dim txtSubTotal = DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox)
        Dim txtVAT = DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox)
        Dim txtTotal = DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox)
        
        ' Total Excl VAT
        e.Graphics.DrawString("Total Excl VAT:", normalFont, Brushes.Black, 580, printY)
        e.Graphics.DrawString($"R {txtSubTotal.Text}", normalFont, Brushes.Black, 710, printY)
        printY += 25
        
        ' VAT Amount
        e.Graphics.DrawString("VAT (15%):", normalFont, Brushes.Black, 580, printY)
        e.Graphics.DrawString($"R {txtVAT.Text}", normalFont, Brushes.Black, 710, printY)
        printY += 25
        
        ' Draw line before total
        e.Graphics.DrawLine(Pens.Black, 580, printY, 780, printY)
        printY += 10
        
        ' Total Incl VAT
        e.Graphics.DrawString("Total Incl VAT:", headerFont, Brushes.Black, 580, printY)
        e.Graphics.DrawString($"R {txtTotal.Text}", headerFont, Brushes.Black, 710, printY)
        
        ' Footer
        printY = 1050
        e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, 50, printY)
        e.Graphics.DrawString($"Page {printPageNumber}", smallFont, Brushes.Gray, 700, printY)
        
        e.HasMorePages = False
    End Sub
End Class

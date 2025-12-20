Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Text
Imports System.Windows.Forms

Public Class UserDefinedOrderDetailsDialog
    Inherits Form

    Private _connectionString As String
    Private _orderID As Integer
    Private _orderData As DataRow

    ' UI Controls
    Private txtOrderInfo As TextBox
    Private dgvItems As DataGridView
    Private btnPrint As Button
    Private btnPrintPreview As Button
    Private btnClose As Button

    Public Sub New(connectionString As String, orderID As Integer)
        MyBase.New()
        _connectionString = connectionString
        _orderID = orderID

        InitializeComponent()
        LoadOrderDetails()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "User Defined Order Details"
        Me.Size = New Size(900, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.White

        Dim yPos As Integer = 20

        ' Header
        Dim lblHeader As New Label With {
            .Text = "USER DEFINED ORDER DETAILS",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#E67E22"),
            .Location = New Point(20, yPos),
            .Size = New Size(850, 35),
            .TextAlign = ContentAlignment.MiddleCenter
        }
        Me.Controls.Add(lblHeader)
        yPos += 50

        ' Order info panel - SCROLLABLE TEXTBOX
        txtOrderInfo = New TextBox With {
            .Location = New Point(20, yPos),
            .Size = New Size(850, 250),
            .Font = New Font("Segoe UI", 9),
            .BorderStyle = BorderStyle.FixedSingle,
            .BackColor = Color.White,
            .Multiline = True,
            .ScrollBars = ScrollBars.Vertical,
            .ReadOnly = True,
            .WordWrap = True
        }
        Me.Controls.Add(txtOrderInfo)
        yPos += 260

        ' Items grid
        Dim lblItems As New Label With {
            .Text = "Order Items:",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(20, yPos),
            .Size = New Size(200, 25)
        }
        Me.Controls.Add(lblItems)
        yPos += 30

        dgvItems = New DataGridView With {
            .Location = New Point(20, yPos),
            .Size = New Size(850, 250),
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.Fixed3D
        }
        Me.Controls.Add(dgvItems)
        yPos += 260

        ' Buttons
        btnPrintPreview = New Button With {
            .Text = "Print Preview",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(230, yPos),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnPrintPreview.FlatAppearance.BorderSize = 0
        AddHandler btnPrintPreview.Click, AddressOf BtnPrintPreview_Click

        btnPrint = New Button With {
            .Text = "Print Order",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(400, yPos),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf BtnPrint_Click

        btnClose = New Button With {
            .Text = "Close",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(570, yPos),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf BtnClose_Click

        Me.Controls.AddRange({btnPrintPreview, btnPrint, btnClose})
    End Sub

    Private Sub LoadOrderDetails()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Load order header
                Dim sql = "SELECT * FROM POS_UserDefinedOrders WHERE UserDefinedOrderID = @OrderID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@OrderID", _orderID)
                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    If dt.Rows.Count > 0 Then
                        _orderData = dt.Rows(0)
                        DisplayOrderInfo()
                    End If
                End Using

                ' Load order items
                Dim itemsSql = "SELECT ProductName AS Product, Quantity AS Qty, UnitPrice AS Price, LineTotal AS Total FROM POS_UserDefinedOrderItems WHERE UserDefinedOrderID = @OrderID"
                Using cmdItems As New SqlCommand(itemsSql, conn)
                    cmdItems.Parameters.AddWithValue("@OrderID", _orderID)
                    Dim adapterItems As New SqlDataAdapter(cmdItems)
                    Dim dtItems As New DataTable()
                    adapterItems.Fill(dtItems)
                    dgvItems.DataSource = dtItems
                End Using
            End Using

        Catch ex As Exception
            MessageBox.Show($"Error loading order details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub DisplayOrderInfo()
        If _orderData Is Nothing Then Return

        Dim info As New StringBuilder()
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"ORDER NUMBER: {_orderData("OrderNumber")}")
        info.AppendLine($"BRANCH: {_orderData("BranchName")}")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"")
        info.AppendLine($"Order Date: {CDate(_orderData("OrderDate")):dd/MM/yyyy} at {CType(_orderData("OrderTime"), TimeSpan):hh\:mm}")
        info.AppendLine($"Cashier: {_orderData("CashierName")}")
        info.AppendLine($"")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"CUSTOMER INFORMATION:")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"Name: {_orderData("CustomerName")} {If(IsDBNull(_orderData("CustomerSurname")), "", _orderData("CustomerSurname"))}")
        info.AppendLine($"Phone: {_orderData("CustomerCellNumber")}")
        info.AppendLine($"")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"COLLECTION / PICKUP DETAILS:")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"Pickup Date: {CDate(_orderData("CollectionDate")):dd/MM/yyyy}")
        info.AppendLine($"Pickup Time: {CType(_orderData("CollectionTime"), TimeSpan):hh\:mm}")
        info.AppendLine($"Pickup Day: {_orderData("CollectionDay")}")
        info.AppendLine($"")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"ORDER SPECIFICATIONS:")
        info.AppendLine($"═══════════════════════════════════════════════════════")

        If Not IsDBNull(_orderData("CakeColour")) AndAlso Not String.IsNullOrWhiteSpace(_orderData("CakeColour").ToString()) Then
            info.AppendLine($"Cake Colour: {_orderData("CakeColour")}")
        Else
            info.AppendLine($"Cake Colour: Not specified")
        End If

        If Not IsDBNull(_orderData("CakeImage")) AndAlso Not String.IsNullOrWhiteSpace(_orderData("CakeImage").ToString()) Then
            info.AppendLine($"Cake Image/Picture: {_orderData("CakeImage")}")
        Else
            info.AppendLine($"Cake Image/Picture: Not specified")
        End If

        If Not IsDBNull(_orderData("SpecialRequest")) AndAlso Not String.IsNullOrWhiteSpace(_orderData("SpecialRequest").ToString()) Then
            info.AppendLine($"Special Instructions: {_orderData("SpecialRequest")}")
        Else
            info.AppendLine($"Special Instructions: None")
        End If

        info.AppendLine($"")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"PAYMENT INFORMATION:")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"Total Amount: R {CDec(_orderData("TotalAmount")):N2}")
        info.AppendLine($"Payment Method: {_orderData("PaymentMethod")}")
        info.AppendLine($"Amount Paid: R {CDec(_orderData("AmountPaid")):N2}")
        info.AppendLine($"")
        info.AppendLine($"═══════════════════════════════════════════════════════")
        info.AppendLine($"ORDER STATUS: {_orderData("Status")}")
        info.AppendLine($"═══════════════════════════════════════════════════════")

        If Not IsDBNull(_orderData("CompletedDate")) Then
            info.AppendLine($"")
            info.AppendLine($"Completed: {CDate(_orderData("CompletedDate")):dd/MM/yyyy HH:mm:ss}")
            info.AppendLine($"Completed By: {_orderData("CompletedBy")}")
        End If

        If Not IsDBNull(_orderData("PickedUpDateTime")) Then
            info.AppendLine($"")
            info.AppendLine($"Picked Up: {CDate(_orderData("PickedUpDateTime")):dd/MM/yyyy HH:mm:ss}")
            info.AppendLine($"Picked Up By: {_orderData("PickedUpBy")}")
        End If

        txtOrderInfo.Text = info.ToString()
    End Sub

    Private Sub BtnPrintPreview_Click(sender As Object, e As EventArgs)
        Try
            Dim printDoc As New PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintOrderPage
            
            Dim preview As New PrintPreviewDialog With {
                .Document = printDoc,
                .Width = 800,
                .Height = 600,
                .StartPosition = FormStartPosition.CenterParent
            }
            preview.ShowDialog(Me)
        Catch ex As Exception
            MessageBox.Show($"Error showing print preview: {ex.Message}", "Print Preview Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
        Try
            PrintOrder()
        Catch ex As Exception
            MessageBox.Show($"Error printing order: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PrintOrder()
        Dim printDoc As New PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf PrintOrderPage
        printDoc.Print()
    End Sub

    Private Sub PrintOrderPage(sender As Object, e As PrintPageEventArgs)
            Dim fontBold As New Font("Courier New", 8, FontStyle.Bold)
            Dim fontLarge As New Font("Courier New", 11, FontStyle.Bold)
            Dim yPos As Single = 50
            Dim leftMargin As Single = 50

            ' Header
            e.Graphics.DrawString("USER DEFINED ORDER", fontLarge, Brushes.Black, leftMargin, yPos)
            yPos += 30

            e.Graphics.DrawString("========================================", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 20

            ' Order details
            e.Graphics.DrawString($"Order Number: {_orderData("OrderNumber")}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"Branch: {_orderData("BranchName")}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"Order Date: {CDate(_orderData("OrderDate")):dd/MM/yyyy} {CType(_orderData("OrderTime"), TimeSpan):hh\:mm}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 25

            ' Customer info
            e.Graphics.DrawString("CUSTOMER:", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"{_orderData("CustomerName")} {If(IsDBNull(_orderData("CustomerSurname")), "", _orderData("CustomerSurname"))}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"Phone: {_orderData("CustomerCellNumber")}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 25

            ' Collection details
            e.Graphics.DrawString("COLLECTION:", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"Date: {CDate(_orderData("CollectionDate")):dd/MM/yyyy}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18
            e.Graphics.DrawString($"Time: {CType(_orderData("CollectionTime"), TimeSpan):hh\:mm}", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 25

            ' Order details
            If Not IsDBNull(_orderData("CakeColour")) OrElse Not IsDBNull(_orderData("SpecialRequest")) Then
                e.Graphics.DrawString("ORDER DETAILS:", fontBold, Brushes.Black, leftMargin, yPos)
                yPos += 18

                If Not IsDBNull(_orderData("CakeColour")) Then
                    e.Graphics.DrawString($"Cake Colour: {_orderData("CakeColour")}", fontBold, Brushes.Black, leftMargin, yPos)
                    yPos += 18
                End If

                If Not IsDBNull(_orderData("CakeImage")) Then
                    e.Graphics.DrawString($"Cake Picture: {_orderData("CakeImage")}", fontBold, Brushes.Black, leftMargin, yPos)
                    yPos += 18
                End If

                If Not IsDBNull(_orderData("SpecialRequest")) Then
                    e.Graphics.DrawString($"Special Request: {_orderData("SpecialRequest")}", fontBold, Brushes.Black, leftMargin, yPos)
                    yPos += 18
                End If

                yPos += 10
            End If

            e.Graphics.DrawString("========================================", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 20

            ' Items
            e.Graphics.DrawString("ITEMS:", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 18

            Dim itemsTable = CType(dgvItems.DataSource, DataTable)
            For Each row As DataRow In itemsTable.Rows
                Dim line = $"{row("Product")} x{row("Qty")} @ R{CDec(row("Price")):N2} = R{CDec(row("Total")):N2}"
                e.Graphics.DrawString(line, fontBold, Brushes.Black, leftMargin, yPos)
                yPos += 18
            Next

            yPos += 10
            e.Graphics.DrawString("========================================", fontBold, Brushes.Black, leftMargin, yPos)
            yPos += 20

            e.Graphics.DrawString($"TOTAL: R {CDec(_orderData("TotalAmount")):N2}", fontLarge, Brushes.Black, leftMargin, yPos)
            yPos += 25

            e.Graphics.DrawString($"Status: {_orderData("Status")}", fontBold, Brushes.Black, leftMargin, yPos)
    End Sub

    Private Sub BtnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class

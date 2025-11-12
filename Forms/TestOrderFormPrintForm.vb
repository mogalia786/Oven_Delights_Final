Imports System.Windows.Forms
Imports Oven_Delights_ERP.Services

Public Class TestOrderFormPrintForm
    Inherits Form
    
    Private btnPrintTestGrid As Button
    Private btnPrintSampleOrder As Button
    Private lblInstructions As Label
    
    Public Sub New()
        InitializeComponent()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Test Order Form Printer"
        Me.Size = New Size(500, 300)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        
        ' Instructions
        lblInstructions = New Label()
        lblInstructions.Text = "Step 1: Print Test Grid to measure exact positions" & vbCrLf & vbCrLf &
                               "Step 2: Adjust coordinates in OvenDelightsOrderFormPrinter.vb" & vbCrLf & vbCrLf &
                               "Step 3: Print Sample Order to verify alignment"
        lblInstructions.Location = New Point(20, 20)
        lblInstructions.Size = New Size(450, 100)
        lblInstructions.Font = New Font("Segoe UI", 10)
        Me.Controls.Add(lblInstructions)
        
        ' Print Test Grid Button
        btnPrintTestGrid = New Button()
        btnPrintTestGrid.Text = "1. Print Test Grid"
        btnPrintTestGrid.Location = New Point(20, 140)
        btnPrintTestGrid.Size = New Size(200, 40)
        btnPrintTestGrid.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnPrintTestGrid.Click, AddressOf BtnPrintTestGrid_Click
        Me.Controls.Add(btnPrintTestGrid)
        
        ' Print Sample Order Button
        btnPrintSampleOrder = New Button()
        btnPrintSampleOrder.Text = "2. Print Sample Order"
        btnPrintSampleOrder.Location = New Point(260, 140)
        btnPrintSampleOrder.Size = New Size(200, 40)
        btnPrintSampleOrder.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnPrintSampleOrder.Click, AddressOf BtnPrintSampleOrder_Click
        Me.Controls.Add(btnPrintSampleOrder)
        
        ' Close Button
        Dim btnClose As New Button()
        btnClose.Text = "Close"
        btnClose.Location = New Point(180, 210)
        btnClose.Size = New Size(120, 35)
        btnClose.DialogResult = DialogResult.Cancel
        Me.Controls.Add(btnClose)
        Me.CancelButton = btnClose
    End Sub
    
    Private Sub BtnPrintTestGrid_Click(sender As Object, e As EventArgs)
        Try
            MessageBox.Show("Place your pre-printed form in the printer." & vbCrLf & vbCrLf &
                          "The test grid will show coordinates to help you measure field positions." & vbCrLf & vbCrLf &
                          "Grid lines are every 50 units (0.5 inch).",
                          "Print Test Grid", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            Dim printer As New OvenDelightsOrderFormPrinter(Nothing)
            printer.PrintTestGrid()
            
        Catch ex As Exception
            MessageBox.Show("Error printing test grid: " & ex.Message, "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnPrintSampleOrder_Click(sender As Object, e As EventArgs)
        Try
            ' Create sample order data
            Dim orderData As New OrderFormData()
            
            ' Customer Information
            orderData.AccountNumber = "3RA-MANO"
            orderData.CustomerName = "RAJEH MANOO"
            orderData.Telephone = "0314019523"
            orderData.CellNumber = "0823952581"
            
            ' Cake Details
            orderData.CakeColour = "RED/WHITE"
            orderData.CakePicture = "WhatsApp: Yes"
            orderData.CollectionDate = New Date(2025, 10, 4)
            orderData.CollectionDay = "Saturday"
            orderData.CollectionTime = "15:30"
            
            ' Order Header
            orderData.CollectionPoint = "Ayesha Centre"
            orderData.OrderNumber = "O-HORD14766"
            orderData.OrderDate = New Date(2025, 10, 3)
            orderData.OrderTakenBy = "Crystal"
            
            ' Line Items
            orderData.LineItems.Add(New OrderLineItem() With {
                .Description = "3D Tilaknagar (FDL)",
                .Quantity = 1.0D,
                .UnitPrice = 560.0D,
                .TotalPrice = 560.0D
            })
            
            orderData.LineItems.Add(New OrderLineItem() With {
                .Description = "Picture",
                .Quantity = 1.0D,
                .UnitPrice = 0.0D,
                .TotalPrice = 0.0D
            })
            
            ' Totals
            orderData.InvoiceTotal = 560.0D
            orderData.DepositPaid = 0.0D
            orderData.BalanceOwing = 560.0D
            
            MessageBox.Show("Place your pre-printed form in the printer." & vbCrLf & vbCrLf &
                          "This will print sample order data at the measured positions.",
                          "Print Sample Order", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            Dim printer As New OvenDelightsOrderFormPrinter(orderData)
            printer.Print()
            
        Catch ex As Exception
            MessageBox.Show("Error printing sample order: " & ex.Message, "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class

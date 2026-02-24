<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class CancelOrderForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.grpOrderLookup = New System.Windows.Forms.GroupBox()
        Me.btnLoadOrder = New System.Windows.Forms.Button()
        Me.txtOrderNumber = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.grpOrderDetails = New System.Windows.Forms.GroupBox()
        Me.txtOrderStatus = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.txtOrderDate = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtCustomerPhone = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.txtCustomerName = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.grpCancellation = New System.Windows.Forms.GroupBox()
        Me.lblRefundAmount = New System.Windows.Forms.Label()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.lblCancellationFee = New System.Windows.Forms.Label()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.lblPaymentMethod = New System.Windows.Forms.Label()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.lblDepositAmount = New System.Windows.Forms.Label()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.numCancellationFee = New System.Windows.Forms.NumericUpDown()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.cboCancellationFee = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.btnProcessCancellation = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        Me.grpOrderLookup.SuspendLayout()
        Me.grpOrderDetails.SuspendLayout()
        Me.grpCancellation.SuspendLayout()
        CType(Me.numCancellationFee, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(900, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(262, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "CANCEL CAKE ORDER"
        '
        'grpOrderLookup
        '
        Me.grpOrderLookup.Controls.Add(Me.btnLoadOrder)
        Me.grpOrderLookup.Controls.Add(Me.txtOrderNumber)
        Me.grpOrderLookup.Controls.Add(Me.Label1)
        Me.grpOrderLookup.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpOrderLookup.Location = New System.Drawing.Point(20, 80)
        Me.grpOrderLookup.Name = "grpOrderLookup"
        Me.grpOrderLookup.Size = New System.Drawing.Size(860, 80)
        Me.grpOrderLookup.TabIndex = 1
        Me.grpOrderLookup.TabStop = False
        Me.grpOrderLookup.Text = "Order Lookup"
        '
        'btnLoadOrder
        '
        Me.btnLoadOrder.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnLoadOrder.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnLoadOrder.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnLoadOrder.ForeColor = System.Drawing.Color.White
        Me.btnLoadOrder.Location = New System.Drawing.Point(520, 30)
        Me.btnLoadOrder.Name = "btnLoadOrder"
        Me.btnLoadOrder.Size = New System.Drawing.Size(120, 35)
        Me.btnLoadOrder.TabIndex = 2
        Me.btnLoadOrder.Text = "Load Order"
        Me.btnLoadOrder.UseVisualStyleBackColor = False
        '
        'txtOrderNumber
        '
        Me.txtOrderNumber.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtOrderNumber.Location = New System.Drawing.Point(150, 33)
        Me.txtOrderNumber.Name = "txtOrderNumber"
        Me.txtOrderNumber.Size = New System.Drawing.Size(350, 27)
        Me.txtOrderNumber.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label1.Location = New System.Drawing.Point(20, 36)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(103, 19)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Order Number:"
        '
        'grpOrderDetails
        '
        Me.grpOrderDetails.Controls.Add(Me.txtOrderStatus)
        Me.grpOrderDetails.Controls.Add(Me.Label6)
        Me.grpOrderDetails.Controls.Add(Me.txtOrderDate)
        Me.grpOrderDetails.Controls.Add(Me.Label5)
        Me.grpOrderDetails.Controls.Add(Me.txtCustomerPhone)
        Me.grpOrderDetails.Controls.Add(Me.Label4)
        Me.grpOrderDetails.Controls.Add(Me.txtCustomerName)
        Me.grpOrderDetails.Controls.Add(Me.Label3)
        Me.grpOrderDetails.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpOrderDetails.Location = New System.Drawing.Point(20, 175)
        Me.grpOrderDetails.Name = "grpOrderDetails"
        Me.grpOrderDetails.Size = New System.Drawing.Size(860, 150)
        Me.grpOrderDetails.TabIndex = 2
        Me.grpOrderDetails.TabStop = False
        Me.grpOrderDetails.Text = "Order Details"
        '
        'txtOrderStatus
        '
        Me.txtOrderStatus.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtOrderStatus.Location = New System.Drawing.Point(580, 75)
        Me.txtOrderStatus.Name = "txtOrderStatus"
        Me.txtOrderStatus.ReadOnly = True
        Me.txtOrderStatus.Size = New System.Drawing.Size(250, 25)
        Me.txtOrderStatus.TabIndex = 7
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label6.Location = New System.Drawing.Point(450, 78)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(92, 19)
        Me.Label6.TabIndex = 6
        Me.Label6.Text = "Order Status:"
        '
        'txtOrderDate
        '
        Me.txtOrderDate.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtOrderDate.Location = New System.Drawing.Point(580, 35)
        Me.txtOrderDate.Name = "txtOrderDate"
        Me.txtOrderDate.ReadOnly = True
        Me.txtOrderDate.Size = New System.Drawing.Size(250, 25)
        Me.txtOrderDate.TabIndex = 5
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label5.Location = New System.Drawing.Point(450, 38)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(83, 19)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "Order Date:"
        '
        'txtCustomerPhone
        '
        Me.txtCustomerPhone.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtCustomerPhone.Location = New System.Drawing.Point(150, 75)
        Me.txtCustomerPhone.Name = "txtCustomerPhone"
        Me.txtCustomerPhone.ReadOnly = True
        Me.txtCustomerPhone.Size = New System.Drawing.Size(250, 25)
        Me.txtCustomerPhone.TabIndex = 3
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label4.Location = New System.Drawing.Point(20, 78)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(51, 19)
        Me.Label4.TabIndex = 2
        Me.Label4.Text = "Phone:"
        '
        'txtCustomerName
        '
        Me.txtCustomerName.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtCustomerName.Location = New System.Drawing.Point(150, 35)
        Me.txtCustomerName.Name = "txtCustomerName"
        Me.txtCustomerName.ReadOnly = True
        Me.txtCustomerName.Size = New System.Drawing.Size(250, 25)
        Me.txtCustomerName.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label3.Location = New System.Drawing.Point(20, 38)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(112, 19)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Customer Name:"
        '
        'grpCancellation
        '
        Me.grpCancellation.Controls.Add(Me.lblRefundAmount)
        Me.grpCancellation.Controls.Add(Me.Label12)
        Me.grpCancellation.Controls.Add(Me.lblCancellationFee)
        Me.grpCancellation.Controls.Add(Me.Label10)
        Me.grpCancellation.Controls.Add(Me.lblPaymentMethod)
        Me.grpCancellation.Controls.Add(Me.Label9)
        Me.grpCancellation.Controls.Add(Me.lblDepositAmount)
        Me.grpCancellation.Controls.Add(Me.Label7)
        Me.grpCancellation.Controls.Add(Me.numCancellationFee)
        Me.grpCancellation.Controls.Add(Me.Label8)
        Me.grpCancellation.Controls.Add(Me.cboCancellationFee)
        Me.grpCancellation.Controls.Add(Me.Label2)
        Me.grpCancellation.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpCancellation.Location = New System.Drawing.Point(20, 340)
        Me.grpCancellation.Name = "grpCancellation"
        Me.grpCancellation.Size = New System.Drawing.Size(860, 220)
        Me.grpCancellation.TabIndex = 3
        Me.grpCancellation.TabStop = False
        Me.grpCancellation.Text = "Cancellation Details"
        '
        'lblRefundAmount
        '
        Me.lblRefundAmount.AutoSize = True
        Me.lblRefundAmount.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblRefundAmount.ForeColor = System.Drawing.Color.Green
        Me.lblRefundAmount.Location = New System.Drawing.Point(650, 170)
        Me.lblRefundAmount.Name = "lblRefundAmount"
        Me.lblRefundAmount.Size = New System.Drawing.Size(73, 25)
        Me.lblRefundAmount.TabIndex = 11
        Me.lblRefundAmount.Text = "R 0.00"
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.Label12.Location = New System.Drawing.Point(450, 172)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(135, 21)
        Me.Label12.TabIndex = 10
        Me.Label12.Text = "Refund Amount:"
        '
        'lblCancellationFee
        '
        Me.lblCancellationFee.AutoSize = True
        Me.lblCancellationFee.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblCancellationFee.Location = New System.Drawing.Point(650, 130)
        Me.lblCancellationFee.Name = "lblCancellationFee"
        Me.lblCancellationFee.Size = New System.Drawing.Size(54, 20)
        Me.lblCancellationFee.TabIndex = 9
        Me.lblCancellationFee.Text = "R 0.00"
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label10.Location = New System.Drawing.Point(450, 131)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(118, 19)
        Me.Label10.TabIndex = 8
        Me.Label10.Text = "Cancellation Fee:"
        '
        'lblPaymentMethod
        '
        Me.lblPaymentMethod.AutoSize = True
        Me.lblPaymentMethod.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblPaymentMethod.Location = New System.Drawing.Point(650, 90)
        Me.lblPaymentMethod.Name = "lblPaymentMethod"
        Me.lblPaymentMethod.Size = New System.Drawing.Size(37, 20)
        Me.lblPaymentMethod.TabIndex = 7
        Me.lblPaymentMethod.Text = "N/A"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label9.Location = New System.Drawing.Point(450, 91)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(121, 19)
        Me.Label9.TabIndex = 6
        Me.Label9.Text = "Payment Method:"
        '
        'lblDepositAmount
        '
        Me.lblDepositAmount.AutoSize = True
        Me.lblDepositAmount.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblDepositAmount.Location = New System.Drawing.Point(650, 50)
        Me.lblDepositAmount.Name = "lblDepositAmount"
        Me.lblDepositAmount.Size = New System.Drawing.Size(54, 20)
        Me.lblDepositAmount.TabIndex = 5
        Me.lblDepositAmount.Text = "R 0.00"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label7.Location = New System.Drawing.Point(450, 51)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(115, 19)
        Me.Label7.TabIndex = 4
        Me.Label7.Text = "Deposit Amount:"
        '
        'numCancellationFee
        '
        Me.numCancellationFee.DecimalPlaces = 2
        Me.numCancellationFee.Enabled = False
        Me.numCancellationFee.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.numCancellationFee.Location = New System.Drawing.Point(200, 85)
        Me.numCancellationFee.Maximum = New Decimal(New Integer() {10000, 0, 0, 0})
        Me.numCancellationFee.Name = "numCancellationFee"
        Me.numCancellationFee.Size = New System.Drawing.Size(200, 27)
        Me.numCancellationFee.TabIndex = 3
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label8.Location = New System.Drawing.Point(20, 88)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(90, 19)
        Me.Label8.TabIndex = 2
        Me.Label8.Text = "Fee Amount:"
        '
        'cboCancellationFee
        '
        Me.cboCancellationFee.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCancellationFee.Enabled = False
        Me.cboCancellationFee.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.cboCancellationFee.FormattingEnabled = True
        Me.cboCancellationFee.Location = New System.Drawing.Point(200, 40)
        Me.cboCancellationFee.Name = "cboCancellationFee"
        Me.cboCancellationFee.Size = New System.Drawing.Size(200, 25)
        Me.cboCancellationFee.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label2.Location = New System.Drawing.Point(20, 43)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(118, 19)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Cancellation Fee:"
        '
        'btnProcessCancellation
        '
        Me.btnProcessCancellation.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.btnProcessCancellation.Enabled = False
        Me.btnProcessCancellation.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnProcessCancellation.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.btnProcessCancellation.ForeColor = System.Drawing.Color.White
        Me.btnProcessCancellation.Location = New System.Drawing.Point(550, 580)
        Me.btnProcessCancellation.Name = "btnProcessCancellation"
        Me.btnProcessCancellation.Size = New System.Drawing.Size(200, 45)
        Me.btnProcessCancellation.TabIndex = 4
        Me.btnProcessCancellation.Text = "Process Cancellation"
        Me.btnProcessCancellation.UseVisualStyleBackColor = False
        '
        'btnClose
        '
        Me.btnClose.BackColor = System.Drawing.Color.Gray
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(770, 580)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(110, 45)
        Me.btnClose.TabIndex = 5
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'CancelOrderForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 650)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.btnProcessCancellation)
        Me.Controls.Add(Me.grpCancellation)
        Me.Controls.Add(Me.grpOrderDetails)
        Me.Controls.Add(Me.grpOrderLookup)
        Me.Controls.Add(Me.pnlTop)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CancelOrderForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Cancel Cake Order"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.grpOrderLookup.ResumeLayout(False)
        Me.grpOrderLookup.PerformLayout()
        Me.grpOrderDetails.ResumeLayout(False)
        Me.grpOrderDetails.PerformLayout()
        Me.grpCancellation.ResumeLayout(False)
        Me.grpCancellation.PerformLayout()
        CType(Me.numCancellationFee, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents grpOrderLookup As GroupBox
    Friend WithEvents btnLoadOrder As Button
    Friend WithEvents txtOrderNumber As TextBox
    Friend WithEvents Label1 As Label
    Friend WithEvents grpOrderDetails As GroupBox
    Friend WithEvents txtOrderStatus As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents txtOrderDate As TextBox
    Friend WithEvents Label5 As Label
    Friend WithEvents txtCustomerPhone As TextBox
    Friend WithEvents Label4 As Label
    Friend WithEvents txtCustomerName As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents grpCancellation As GroupBox
    Friend WithEvents lblRefundAmount As Label
    Friend WithEvents Label12 As Label
    Friend WithEvents lblCancellationFee As Label
    Friend WithEvents Label10 As Label
    Friend WithEvents lblPaymentMethod As Label
    Friend WithEvents Label9 As Label
    Friend WithEvents lblDepositAmount As Label
    Friend WithEvents Label7 As Label
    Friend WithEvents numCancellationFee As NumericUpDown
    Friend WithEvents Label8 As Label
    Friend WithEvents cboCancellationFee As ComboBox
    Friend WithEvents Label2 As Label
    Friend WithEvents btnProcessCancellation As Button
    Friend WithEvents btnClose As Button
End Class

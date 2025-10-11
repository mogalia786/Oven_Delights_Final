<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class InvoiceGRVForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
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
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.cboSupplier = New System.Windows.Forms.ComboBox()
        Me.lblPO = New System.Windows.Forms.Label()
        Me.cboPO = New System.Windows.Forms.ComboBox()
        Me.lblDeliveryNote = New System.Windows.Forms.Label()
        Me.txtDeliveryNote = New System.Windows.Forms.TextBox()
        Me.lblReceived = New System.Windows.Forms.Label()
        Me.dtpReceived = New System.Windows.Forms.DateTimePicker()
        Me.dgvLines = New System.Windows.Forms.DataGridView()
        Me.pnlBottom = New System.Windows.Forms.Panel()
        Me.lblSubTotal = New System.Windows.Forms.Label()
        Me.txtSubTotal = New System.Windows.Forms.TextBox()
        Me.lblVAT = New System.Windows.Forms.Label()
        Me.txtVAT = New System.Windows.Forms.TextBox()
        Me.lblTotal = New System.Windows.Forms.Label()
        Me.txtTotal = New System.Windows.Forms.TextBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.Controls.Add(Me.dtpReceived)
        Me.pnlTop.Controls.Add(Me.lblReceived)
        Me.pnlTop.Controls.Add(Me.txtDeliveryNote)
        Me.pnlTop.Controls.Add(Me.lblDeliveryNote)
        Me.pnlTop.Controls.Add(Me.cboPO)
        Me.pnlTop.Controls.Add(Me.lblPO)
        Me.pnlTop.Controls.Add(Me.cboSupplier)
        Me.pnlTop.Controls.Add(Me.lblSupplier)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1200, 80)
        Me.pnlTop.TabIndex = 0
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(12, 15)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 0
        Me.lblSupplier.Text = "Supplier:"
        '
        'cboSupplier
        '
        Me.cboSupplier.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSupplier.FormattingEnabled = True
        Me.cboSupplier.Location = New System.Drawing.Point(66, 12)
        Me.cboSupplier.Name = "cboSupplier"
        Me.cboSupplier.Size = New System.Drawing.Size(200, 21)
        Me.cboSupplier.TabIndex = 1
        '
        'lblPO
        '
        Me.lblPO.AutoSize = True
        Me.lblPO.Location = New System.Drawing.Point(280, 15)
        Me.lblPO.Name = "lblPO"
        Me.lblPO.Size = New System.Drawing.Size(25, 13)
        Me.lblPO.TabIndex = 2
        Me.lblPO.Text = "PO:"
        '
        'cboPO
        '
        Me.cboPO.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPO.FormattingEnabled = True
        Me.cboPO.Location = New System.Drawing.Point(311, 12)
        Me.cboPO.Name = "cboPO"
        Me.cboPO.Size = New System.Drawing.Size(150, 21)
        Me.cboPO.TabIndex = 3
        '
        'lblDeliveryNote
        '
        Me.lblDeliveryNote.AutoSize = True
        Me.lblDeliveryNote.Location = New System.Drawing.Point(12, 45)
        Me.lblDeliveryNote.Name = "lblDeliveryNote"
        Me.lblDeliveryNote.Size = New System.Drawing.Size(75, 13)
        Me.lblDeliveryNote.TabIndex = 4
        Me.lblDeliveryNote.Text = "Delivery Note:"
        '
        'txtDeliveryNote
        '
        Me.txtDeliveryNote.Location = New System.Drawing.Point(93, 42)
        Me.txtDeliveryNote.Name = "txtDeliveryNote"
        Me.txtDeliveryNote.Size = New System.Drawing.Size(173, 20)
        Me.txtDeliveryNote.TabIndex = 5
        '
        'lblReceived
        '
        Me.lblReceived.AutoSize = True
        Me.lblReceived.Location = New System.Drawing.Point(280, 45)
        Me.lblReceived.Name = "lblReceived"
        Me.lblReceived.Size = New System.Drawing.Size(56, 13)
        Me.lblReceived.TabIndex = 6
        Me.lblReceived.Text = "Received:"
        '
        'dtpReceived
        '
        Me.dtpReceived.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpReceived.Location = New System.Drawing.Point(342, 42)
        Me.dtpReceived.Name = "dtpReceived"
        Me.dtpReceived.Size = New System.Drawing.Size(119, 20)
        Me.dtpReceived.TabIndex = 7
        '
        'dgvLines
        '
        Me.dgvLines.AllowUserToAddRows = False
        Me.dgvLines.AllowUserToDeleteRows = False
        Me.dgvLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvLines.Location = New System.Drawing.Point(0, 80)
        Me.dgvLines.Name = "dgvLines"
        Me.dgvLines.Size = New System.Drawing.Size(1200, 470)
        Me.dgvLines.TabIndex = 1
        '
        'pnlBottom
        '
        Me.pnlBottom.Controls.Add(Me.btnCancel)
        Me.pnlBottom.Controls.Add(Me.btnSave)
        Me.pnlBottom.Controls.Add(Me.txtTotal)
        Me.pnlBottom.Controls.Add(Me.lblTotal)
        Me.pnlBottom.Controls.Add(Me.txtVAT)
        Me.pnlBottom.Controls.Add(Me.lblVAT)
        Me.pnlBottom.Controls.Add(Me.txtSubTotal)
        Me.pnlBottom.Controls.Add(Me.lblSubTotal)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 550)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(1200, 50)
        Me.pnlBottom.TabIndex = 2
        '
        'lblSubTotal
        '
        Me.lblSubTotal.AutoSize = True
        Me.lblSubTotal.Location = New System.Drawing.Point(800, 18)
        Me.lblSubTotal.Name = "lblSubTotal"
        Me.lblSubTotal.Size = New System.Drawing.Size(56, 13)
        Me.lblSubTotal.TabIndex = 0
        Me.lblSubTotal.Text = "Sub Total:"
        '
        'txtSubTotal
        '
        Me.txtSubTotal.Location = New System.Drawing.Point(862, 15)
        Me.txtSubTotal.Name = "txtSubTotal"
        Me.txtSubTotal.ReadOnly = True
        Me.txtSubTotal.Size = New System.Drawing.Size(80, 20)
        Me.txtSubTotal.TabIndex = 1
        Me.txtSubTotal.Text = "0.00"
        Me.txtSubTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblVAT
        '
        Me.lblVAT.AutoSize = True
        Me.lblVAT.Location = New System.Drawing.Point(948, 18)
        Me.lblVAT.Name = "lblVAT"
        Me.lblVAT.Size = New System.Drawing.Size(31, 13)
        Me.lblVAT.TabIndex = 2
        Me.lblVAT.Text = "VAT:"
        '
        'txtVAT
        '
        Me.txtVAT.Location = New System.Drawing.Point(985, 15)
        Me.txtVAT.Name = "txtVAT"
        Me.txtVAT.ReadOnly = True
        Me.txtVAT.Size = New System.Drawing.Size(80, 20)
        Me.txtVAT.TabIndex = 3
        Me.txtVAT.Text = "0.00"
        Me.txtVAT.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblTotal
        '
        Me.lblTotal.AutoSize = True
        Me.lblTotal.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotal.Location = New System.Drawing.Point(1071, 18)
        Me.lblTotal.Name = "lblTotal"
        Me.lblTotal.Size = New System.Drawing.Size(39, 13)
        Me.lblTotal.TabIndex = 4
        Me.lblTotal.Text = "Total:"
        '
        'txtTotal
        '
        Me.txtTotal.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTotal.Location = New System.Drawing.Point(1116, 15)
        Me.txtTotal.Name = "txtTotal"
        Me.txtTotal.ReadOnly = True
        Me.txtTotal.Size = New System.Drawing.Size(80, 20)
        Me.txtTotal.TabIndex = 5
        Me.txtTotal.Text = "0.00"
        Me.txtTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(12, 13)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(100, 25)
        Me.btnSave.TabIndex = 6
        Me.btnSave.Text = "Save GRV"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(118, 13)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 25)
        Me.btnCancel.TabIndex = 7
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'InvoiceGRVForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 600)
        Me.Controls.Add(Me.dgvLines)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "InvoiceGRVForm"
        Me.Text = "Invoice & GRV Processing"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBottom.ResumeLayout(False)
        Me.pnlBottom.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblSupplier As Label
    Friend WithEvents cboSupplier As ComboBox
    Friend WithEvents lblPO As Label
    Friend WithEvents cboPO As ComboBox
    Friend WithEvents lblDeliveryNote As Label
    Friend WithEvents txtDeliveryNote As TextBox
    Friend WithEvents lblReceived As Label
    Friend WithEvents dtpReceived As DateTimePicker
    Friend WithEvents dgvLines As DataGridView
    Friend WithEvents pnlBottom As Panel
    Friend WithEvents lblSubTotal As Label
    Friend WithEvents txtSubTotal As TextBox
    Friend WithEvents lblVAT As Label
    Friend WithEvents txtVAT As TextBox
    Friend WithEvents lblTotal As Label
    Friend WithEvents txtTotal As TextBox
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button

End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class InvoiceCaptureForm
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
        Me.components = New System.ComponentModel.Container()
        Me.dgvLines = New System.Windows.Forms.DataGridView()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.cboSupplier = New System.Windows.Forms.ComboBox()
        Me.lblPO = New System.Windows.Forms.Label()
        Me.cboPO = New System.Windows.Forms.ComboBox()
        Me.lblDeliveryNote = New System.Windows.Forms.Label()
        Me.txtDeliveryNote = New System.Windows.Forms.TextBox()
        Me.lblDate = New System.Windows.Forms.Label()
        Me.dtpReceived = New System.Windows.Forms.DateTimePicker()
        Me.lblSubTotal = New System.Windows.Forms.Label()
        Me.txtSubTotal = New System.Windows.Forms.TextBox()
        Me.lblVat = New System.Windows.Forms.Label()
        Me.txtVat = New System.Windows.Forms.TextBox()
        Me.lblTotal = New System.Windows.Forms.Label()
        Me.txtTotal = New System.Windows.Forms.TextBox()
        CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
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
        Me.cboSupplier.Location = New System.Drawing.Point(80, 12)
        Me.cboSupplier.Name = "cboSupplier"
        Me.cboSupplier.Size = New System.Drawing.Size(200, 21)
        Me.cboSupplier.TabIndex = 1
        '
        'lblPO
        '
        Me.lblPO.AutoSize = True
        Me.lblPO.Location = New System.Drawing.Point(300, 15)
        Me.lblPO.Name = "lblPO"
        Me.lblPO.Size = New System.Drawing.Size(25, 13)
        Me.lblPO.TabIndex = 2
        Me.lblPO.Text = "PO:"
        '
        'cboPO
        '
        Me.cboPO.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPO.FormattingEnabled = True
        Me.cboPO.Location = New System.Drawing.Point(330, 12)
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
        Me.txtDeliveryNote.Location = New System.Drawing.Point(100, 42)
        Me.txtDeliveryNote.Name = "txtDeliveryNote"
        Me.txtDeliveryNote.Size = New System.Drawing.Size(150, 20)
        Me.txtDeliveryNote.TabIndex = 5
        '
        'lblDate
        '
        Me.lblDate.AutoSize = True
        Me.lblDate.Location = New System.Drawing.Point(270, 45)
        Me.lblDate.Name = "lblDate"
        Me.lblDate.Size = New System.Drawing.Size(33, 13)
        Me.lblDate.TabIndex = 6
        Me.lblDate.Text = "Date:"
        '
        'dtpReceived
        '
        Me.dtpReceived.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpReceived.Location = New System.Drawing.Point(310, 42)
        Me.dtpReceived.Name = "dtpReceived"
        Me.dtpReceived.Size = New System.Drawing.Size(100, 20)
        Me.dtpReceived.TabIndex = 7
        '
        'dgvLines
        '
        Me.dgvLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLines.Location = New System.Drawing.Point(12, 80)
        Me.dgvLines.Name = "dgvLines"
        Me.dgvLines.Size = New System.Drawing.Size(1200, 400)
        Me.dgvLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvLines.AllowUserToAddRows = False
        Me.dgvLines.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter
        Me.dgvLines.TabIndex = 8
        '
        'lblSubTotal
        '
        Me.lblSubTotal.AutoSize = True
        Me.lblSubTotal.Location = New System.Drawing.Point(600, 500)
        Me.lblSubTotal.Name = "lblSubTotal"
        Me.lblSubTotal.Size = New System.Drawing.Size(56, 13)
        Me.lblSubTotal.TabIndex = 9
        Me.lblSubTotal.Text = "Sub Total:"
        '
        'txtSubTotal
        '
        Me.txtSubTotal.Location = New System.Drawing.Point(670, 497)
        Me.txtSubTotal.Name = "txtSubTotal"
        Me.txtSubTotal.ReadOnly = True
        Me.txtSubTotal.Size = New System.Drawing.Size(100, 20)
        Me.txtSubTotal.TabIndex = 10
        Me.txtSubTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblVat
        '
        Me.lblVat.AutoSize = True
        Me.lblVat.Location = New System.Drawing.Point(600, 525)
        Me.lblVat.Name = "lblVat"
        Me.lblVat.Size = New System.Drawing.Size(31, 13)
        Me.lblVat.TabIndex = 11
        Me.lblVat.Text = "VAT:"
        '
        'txtVat
        '
        Me.txtVat.Location = New System.Drawing.Point(670, 522)
        Me.txtVat.Name = "txtVat"
        Me.txtVat.ReadOnly = True
        Me.txtVat.Size = New System.Drawing.Size(100, 20)
        Me.txtVat.TabIndex = 12
        Me.txtVat.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblTotal
        '
        Me.lblTotal.AutoSize = True
        Me.lblTotal.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotal.Location = New System.Drawing.Point(600, 550)
        Me.lblTotal.Name = "lblTotal"
        Me.lblTotal.Size = New System.Drawing.Size(39, 13)
        Me.lblTotal.TabIndex = 13
        Me.lblTotal.Text = "Total:"
        '
        'txtTotal
        '
        Me.txtTotal.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTotal.Location = New System.Drawing.Point(670, 547)
        Me.txtTotal.Name = "txtTotal"
        Me.txtTotal.ReadOnly = True
        Me.txtTotal.Size = New System.Drawing.Size(100, 20)
        Me.txtTotal.TabIndex = 14
        Me.txtTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'btnSave
        '
        Me.btnSave.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(600, 580)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(80, 30)
        Me.btnSave.TabIndex = 15
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCancel.ForeColor = System.Drawing.Color.White
        Me.btnCancel.Location = New System.Drawing.Point(690, 580)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 30)
        Me.btnCancel.TabIndex = 16
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'InvoiceCaptureForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(800, 620)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.txtTotal)
        Me.Controls.Add(Me.lblTotal)
        Me.Controls.Add(Me.txtVat)
        Me.Controls.Add(Me.lblVat)
        Me.Controls.Add(Me.txtSubTotal)
        Me.Controls.Add(Me.lblSubTotal)
        Me.Controls.Add(Me.dgvLines)
        Me.Controls.Add(Me.dtpReceived)
        Me.Controls.Add(Me.lblDate)
        Me.Controls.Add(Me.txtDeliveryNote)
        Me.Controls.Add(Me.lblDeliveryNote)
        Me.Controls.Add(Me.cboPO)
        Me.Controls.Add(Me.lblPO)
        Me.Controls.Add(Me.cboSupplier)
        Me.Controls.Add(Me.lblSupplier)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MaximizeBox = True
        Me.MinimizeBox = True
        Me.Name = "InvoiceCaptureForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Invoice Capture - Supplier Invoice Processing"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents dgvLines As System.Windows.Forms.DataGridView
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents lblSupplier As System.Windows.Forms.Label
    Friend WithEvents cboSupplier As System.Windows.Forms.ComboBox
    Friend WithEvents lblPO As System.Windows.Forms.Label
    Friend WithEvents cboPO As System.Windows.Forms.ComboBox
    Friend WithEvents lblDeliveryNote As System.Windows.Forms.Label
    Friend WithEvents txtDeliveryNote As System.Windows.Forms.TextBox
    Friend WithEvents lblDate As System.Windows.Forms.Label
    Friend WithEvents dtpReceived As System.Windows.Forms.DateTimePicker
    Friend WithEvents lblSubTotal As System.Windows.Forms.Label
    Friend WithEvents txtSubTotal As System.Windows.Forms.TextBox
    Friend WithEvents lblVat As System.Windows.Forms.Label
    Friend WithEvents txtVat As System.Windows.Forms.TextBox
    Friend WithEvents lblTotal As System.Windows.Forms.Label
    Friend WithEvents txtTotal As System.Windows.Forms.TextBox

End Class
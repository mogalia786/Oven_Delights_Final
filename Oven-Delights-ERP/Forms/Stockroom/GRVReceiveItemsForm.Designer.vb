<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GRVReceiveItemsForm
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
        Me.lblGRVNumber = New System.Windows.Forms.Label()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.lblDeliveryDate = New System.Windows.Forms.Label()
        Me.txtGRVNumber = New System.Windows.Forms.TextBox()
        Me.txtSupplier = New System.Windows.Forms.TextBox()
        Me.dtpDeliveryDate = New System.Windows.Forms.DateTimePicker()
        Me.dgvItems = New System.Windows.Forms.DataGridView()
        Me.btnReceiveAll = New System.Windows.Forms.Button()
        Me.btnReceiveSelected = New System.Windows.Forms.Button()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        CType(Me.dgvItems, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlHeader.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblGRVNumber
        '
        Me.lblGRVNumber.AutoSize = True
        Me.lblGRVNumber.Location = New System.Drawing.Point(20, 23)
        Me.lblGRVNumber.Name = "lblGRVNumber"
        Me.lblGRVNumber.Size = New System.Drawing.Size(75, 13)
        Me.lblGRVNumber.TabIndex = 0
        Me.lblGRVNumber.Text = "GRV Number:"
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(300, 23)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 1
        Me.lblSupplier.Text = "Supplier:"
        '
        'lblDeliveryDate
        '
        Me.lblDeliveryDate.AutoSize = True
        Me.lblDeliveryDate.Location = New System.Drawing.Point(20, 53)
        Me.lblDeliveryDate.Name = "lblDeliveryDate"
        Me.lblDeliveryDate.Size = New System.Drawing.Size(75, 13)
        Me.lblDeliveryDate.TabIndex = 2
        Me.lblDeliveryDate.Text = "Delivery Date:"
        '
        'txtGRVNumber
        '
        Me.txtGRVNumber.Location = New System.Drawing.Point(100, 20)
        Me.txtGRVNumber.Name = "txtGRVNumber"
        Me.txtGRVNumber.ReadOnly = True
        Me.txtGRVNumber.Size = New System.Drawing.Size(150, 20)
        Me.txtGRVNumber.TabIndex = 3
        '
        'txtSupplier
        '
        Me.txtSupplier.Location = New System.Drawing.Point(360, 20)
        Me.txtSupplier.Name = "txtSupplier"
        Me.txtSupplier.ReadOnly = True
        Me.txtSupplier.Size = New System.Drawing.Size(200, 20)
        Me.txtSupplier.TabIndex = 4
        '
        'dtpDeliveryDate
        '
        Me.dtpDeliveryDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpDeliveryDate.Location = New System.Drawing.Point(100, 50)
        Me.dtpDeliveryDate.Name = "dtpDeliveryDate"
        Me.dtpDeliveryDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpDeliveryDate.TabIndex = 5
        '
        'dgvItems
        '
        Me.dgvItems.AllowUserToAddRows = False
        Me.dgvItems.AllowUserToDeleteRows = False
        Me.dgvItems.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvItems.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvItems.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvItems.Location = New System.Drawing.Point(0, 120)
        Me.dgvItems.MultiSelect = True
        Me.dgvItems.Name = "dgvItems"
        Me.dgvItems.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvItems.Size = New System.Drawing.Size(800, 280)
        Me.dgvItems.TabIndex = 6
        '
        'btnReceiveAll
        '
        Me.btnReceiveAll.Location = New System.Drawing.Point(10, 10)
        Me.btnReceiveAll.Name = "btnReceiveAll"
        Me.btnReceiveAll.Size = New System.Drawing.Size(90, 23)
        Me.btnReceiveAll.TabIndex = 7
        Me.btnReceiveAll.Text = "Receive All"
        Me.btnReceiveAll.UseVisualStyleBackColor = True
        '
        'btnReceiveSelected
        '
        Me.btnReceiveSelected.Location = New System.Drawing.Point(106, 10)
        Me.btnReceiveSelected.Name = "btnReceiveSelected"
        Me.btnReceiveSelected.Size = New System.Drawing.Size(110, 23)
        Me.btnReceiveSelected.TabIndex = 8
        Me.btnReceiveSelected.Text = "Receive Selected"
        Me.btnReceiveSelected.UseVisualStyleBackColor = True
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(634, 10)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(75, 23)
        Me.btnSave.TabIndex = 9
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(715, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 10
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(100, 80)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtNotes.Size = New System.Drawing.Size(460, 30)
        Me.txtNotes.TabIndex = 11
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(20, 83)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(38, 13)
        Me.lblNotes.TabIndex = 12
        Me.lblNotes.Text = "Notes:"
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblGRVNumber)
        Me.pnlHeader.Controls.Add(Me.lblNotes)
        Me.pnlHeader.Controls.Add(Me.txtGRVNumber)
        Me.pnlHeader.Controls.Add(Me.txtNotes)
        Me.pnlHeader.Controls.Add(Me.lblSupplier)
        Me.pnlHeader.Controls.Add(Me.txtSupplier)
        Me.pnlHeader.Controls.Add(Me.lblDeliveryDate)
        Me.pnlHeader.Controls.Add(Me.dtpDeliveryDate)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(800, 120)
        Me.pnlHeader.TabIndex = 13
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnReceiveAll)
        Me.pnlButtons.Controls.Add(Me.btnReceiveSelected)
        Me.pnlButtons.Controls.Add(Me.btnSave)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 400)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 50)
        Me.pnlButtons.TabIndex = 14
        '
        'GRVReceiveItemsForm
        '
        Me.AcceptButton = Me.btnSave
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.dgvItems)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "GRVReceiveItemsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Receive GRV Items"
        CType(Me.dgvItems, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents lblGRVNumber As Label
    Friend WithEvents lblSupplier As Label
    Friend WithEvents lblDeliveryDate As Label
    Friend WithEvents txtGRVNumber As TextBox
    Friend WithEvents txtSupplier As TextBox
    Friend WithEvents dtpDeliveryDate As DateTimePicker
    Friend WithEvents dgvItems As DataGridView
    Friend WithEvents btnReceiveAll As Button
    Friend WithEvents btnReceiveSelected As Button
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents lblNotes As Label
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents pnlButtons As Panel

End Class

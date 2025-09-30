<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GRVInvoiceMatchForm
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
        Me.lblGRVInfo = New System.Windows.Forms.Label()
        Me.lblInvoiceInfo = New System.Windows.Forms.Label()
        Me.txtInvoiceNumber = New System.Windows.Forms.TextBox()
        Me.dtpInvoiceDate = New System.Windows.Forms.DateTimePicker()
        Me.txtInvoiceAmount = New System.Windows.Forms.TextBox()
        Me.dgvGRVLines = New System.Windows.Forms.DataGridView()
        Me.dgvInvoiceLines = New System.Windows.Forms.DataGridView()
        Me.btnMatch = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblInvoiceNumber = New System.Windows.Forms.Label()
        Me.lblInvoiceDate = New System.Windows.Forms.Label()
        Me.lblInvoiceAmount = New System.Windows.Forms.Label()
        Me.lblGRVLines = New System.Windows.Forms.Label()
        Me.lblInvoiceLines = New System.Windows.Forms.Label()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.pnlInvoiceInfo = New System.Windows.Forms.Panel()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlGRVLines = New System.Windows.Forms.Panel()
        Me.pnlInvoiceLines = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        CType(Me.dgvGRVLines, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvInvoiceLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlHeader.SuspendLayout()
        Me.pnlInvoiceInfo.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.pnlGRVLines.SuspendLayout()
        Me.pnlInvoiceLines.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblGRVInfo
        '
        Me.lblGRVInfo.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblGRVInfo.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lblGRVInfo.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGRVInfo.Location = New System.Drawing.Point(0, 0)
        Me.lblGRVInfo.Name = "lblGRVInfo"
        Me.lblGRVInfo.Size = New System.Drawing.Size(800, 40)
        Me.lblGRVInfo.TabIndex = 0
        Me.lblGRVInfo.Text = "GRV Information"
        Me.lblGRVInfo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblInvoiceInfo
        '
        Me.lblInvoiceInfo.AutoSize = True
        Me.lblInvoiceInfo.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblInvoiceInfo.Location = New System.Drawing.Point(10, 10)
        Me.lblInvoiceInfo.Name = "lblInvoiceInfo"
        Me.lblInvoiceInfo.Size = New System.Drawing.Size(115, 15)
        Me.lblInvoiceInfo.TabIndex = 1
        Me.lblInvoiceInfo.Text = "Invoice Information"
        '
        'txtInvoiceNumber
        '
        Me.txtInvoiceNumber.Location = New System.Drawing.Point(120, 40)
        Me.txtInvoiceNumber.Name = "txtInvoiceNumber"
        Me.txtInvoiceNumber.Size = New System.Drawing.Size(150, 20)
        Me.txtInvoiceNumber.TabIndex = 2
        '
        'dtpInvoiceDate
        '
        Me.dtpInvoiceDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpInvoiceDate.Location = New System.Drawing.Point(350, 40)
        Me.dtpInvoiceDate.Name = "dtpInvoiceDate"
        Me.dtpInvoiceDate.Size = New System.Drawing.Size(120, 20)
        Me.dtpInvoiceDate.TabIndex = 3
        '
        'txtInvoiceAmount
        '
        Me.txtInvoiceAmount.Location = New System.Drawing.Point(550, 40)
        Me.txtInvoiceAmount.Name = "txtInvoiceAmount"
        Me.txtInvoiceAmount.Size = New System.Drawing.Size(120, 20)
        Me.txtInvoiceAmount.TabIndex = 4
        Me.txtInvoiceAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'dgvGRVLines
        '
        Me.dgvGRVLines.AllowUserToAddRows = False
        Me.dgvGRVLines.AllowUserToDeleteRows = False
        Me.dgvGRVLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvGRVLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvGRVLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvGRVLines.Location = New System.Drawing.Point(0, 25)
        Me.dgvGRVLines.Name = "dgvGRVLines"
        Me.dgvGRVLines.ReadOnly = True
        Me.dgvGRVLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvGRVLines.Size = New System.Drawing.Size(390, 200)
        Me.dgvGRVLines.TabIndex = 5
        '
        'dgvInvoiceLines
        '
        Me.dgvInvoiceLines.AllowUserToAddRows = False
        Me.dgvInvoiceLines.AllowUserToDeleteRows = False
        Me.dgvInvoiceLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvInvoiceLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvInvoiceLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvInvoiceLines.Location = New System.Drawing.Point(0, 25)
        Me.dgvInvoiceLines.Name = "dgvInvoiceLines"
        Me.dgvInvoiceLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvInvoiceLines.Size = New System.Drawing.Size(400, 200)
        Me.dgvInvoiceLines.TabIndex = 6
        '
        'btnMatch
        '
        Me.btnMatch.Location = New System.Drawing.Point(634, 10)
        Me.btnMatch.Name = "btnMatch"
        Me.btnMatch.Size = New System.Drawing.Size(75, 23)
        Me.btnMatch.TabIndex = 7
        Me.btnMatch.Text = "Match"
        Me.btnMatch.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(715, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblInvoiceNumber
        '
        Me.lblInvoiceNumber.AutoSize = True
        Me.lblInvoiceNumber.Location = New System.Drawing.Point(20, 43)
        Me.lblInvoiceNumber.Name = "lblInvoiceNumber"
        Me.lblInvoiceNumber.Size = New System.Drawing.Size(87, 13)
        Me.lblInvoiceNumber.TabIndex = 9
        Me.lblInvoiceNumber.Text = "Invoice Number:"
        '
        'lblInvoiceDate
        '
        Me.lblInvoiceDate.AutoSize = True
        Me.lblInvoiceDate.Location = New System.Drawing.Point(280, 43)
        Me.lblInvoiceDate.Name = "lblInvoiceDate"
        Me.lblInvoiceDate.Size = New System.Drawing.Size(73, 13)
        Me.lblInvoiceDate.TabIndex = 10
        Me.lblInvoiceDate.Text = "Invoice Date:"
        '
        'lblInvoiceAmount
        '
        Me.lblInvoiceAmount.AutoSize = True
        Me.lblInvoiceAmount.Location = New System.Drawing.Point(480, 43)
        Me.lblInvoiceAmount.Name = "lblInvoiceAmount"
        Me.lblInvoiceAmount.Size = New System.Drawing.Size(84, 13)
        Me.lblInvoiceAmount.TabIndex = 11
        Me.lblInvoiceAmount.Text = "Invoice Amount:"
        '
        'lblGRVLines
        '
        Me.lblGRVLines.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblGRVLines.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblGRVLines.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGRVLines.Location = New System.Drawing.Point(0, 0)
        Me.lblGRVLines.Name = "lblGRVLines"
        Me.lblGRVLines.Size = New System.Drawing.Size(390, 25)
        Me.lblGRVLines.TabIndex = 12
        Me.lblGRVLines.Text = "GRV Lines"
        Me.lblGRVLines.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblInvoiceLines
        '
        Me.lblInvoiceLines.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblInvoiceLines.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblInvoiceLines.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblInvoiceLines.Location = New System.Drawing.Point(0, 0)
        Me.lblInvoiceLines.Name = "lblInvoiceLines"
        Me.lblInvoiceLines.Size = New System.Drawing.Size(400, 25)
        Me.lblInvoiceLines.TabIndex = 13
        Me.lblInvoiceLines.Text = "Invoice Lines"
        Me.lblInvoiceLines.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblGRVInfo)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(800, 40)
        Me.pnlHeader.TabIndex = 14
        '
        'pnlInvoiceInfo
        '
        Me.pnlInvoiceInfo.Controls.Add(Me.lblInvoiceInfo)
        Me.pnlInvoiceInfo.Controls.Add(Me.lblInvoiceAmount)
        Me.pnlInvoiceInfo.Controls.Add(Me.lblInvoiceNumber)
        Me.pnlInvoiceInfo.Controls.Add(Me.txtInvoiceAmount)
        Me.pnlInvoiceInfo.Controls.Add(Me.lblInvoiceDate)
        Me.pnlInvoiceInfo.Controls.Add(Me.dtpInvoiceDate)
        Me.pnlInvoiceInfo.Controls.Add(Me.txtInvoiceNumber)
        Me.pnlInvoiceInfo.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlInvoiceInfo.Location = New System.Drawing.Point(0, 40)
        Me.pnlInvoiceInfo.Name = "pnlInvoiceInfo"
        Me.pnlInvoiceInfo.Size = New System.Drawing.Size(800, 80)
        Me.pnlInvoiceInfo.TabIndex = 15
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.pnlGRVLines)
        Me.pnlMain.Controls.Add(Me.pnlInvoiceLines)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 120)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(800, 225)
        Me.pnlMain.TabIndex = 16
        '
        'pnlGRVLines
        '
        Me.pnlGRVLines.Controls.Add(Me.dgvGRVLines)
        Me.pnlGRVLines.Controls.Add(Me.lblGRVLines)
        Me.pnlGRVLines.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlGRVLines.Location = New System.Drawing.Point(0, 0)
        Me.pnlGRVLines.Name = "pnlGRVLines"
        Me.pnlGRVLines.Size = New System.Drawing.Size(390, 225)
        Me.pnlGRVLines.TabIndex = 17
        '
        'pnlInvoiceLines
        '
        Me.pnlInvoiceLines.Controls.Add(Me.dgvInvoiceLines)
        Me.pnlInvoiceLines.Controls.Add(Me.lblInvoiceLines)
        Me.pnlInvoiceLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlInvoiceLines.Location = New System.Drawing.Point(390, 0)
        Me.pnlInvoiceLines.Name = "pnlInvoiceLines"
        Me.pnlInvoiceLines.Size = New System.Drawing.Size(400, 225)
        Me.pnlInvoiceLines.TabIndex = 18
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnMatch)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 345)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 43)
        Me.pnlButtons.TabIndex = 19
        '
        'GRVInvoiceMatchForm
        '
        Me.AcceptButton = Me.btnMatch
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(800, 388)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlInvoiceInfo)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "GRVInvoiceMatchForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "GRV Invoice Matching"
        CType(Me.dgvGRVLines, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgvInvoiceLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlInvoiceInfo.ResumeLayout(False)
        Me.pnlInvoiceInfo.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.pnlGRVLines.ResumeLayout(False)
        Me.pnlInvoiceLines.ResumeLayout(False)
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents lblGRVInfo As Label
    Friend WithEvents lblInvoiceInfo As Label
    Friend WithEvents txtInvoiceNumber As TextBox
    Friend WithEvents dtpInvoiceDate As DateTimePicker
    Friend WithEvents txtInvoiceAmount As TextBox
    Friend WithEvents dgvGRVLines As DataGridView
    Friend WithEvents dgvInvoiceLines As DataGridView
    Friend WithEvents btnMatch As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblInvoiceNumber As Label
    Friend WithEvents lblInvoiceDate As Label
    Friend WithEvents lblInvoiceAmount As Label
    Friend WithEvents lblGRVLines As Label
    Friend WithEvents lblInvoiceLines As Label
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents pnlInvoiceInfo As Panel
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlGRVLines As Panel
    Friend WithEvents pnlInvoiceLines As Panel
    Friend WithEvents pnlButtons As Panel

End Class

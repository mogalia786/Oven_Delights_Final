Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class FNBTransactionViewerForm
    Inherits Form

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

    Private components As System.ComponentModel.IContainer

    Friend WithEvents dgvBatches As DataGridView
    Friend WithEvents dgvTransactions As DataGridView
    Friend WithEvents dtpFromDate As DateTimePicker
    Friend WithEvents dtpToDate As DateTimePicker
    Friend WithEvents cboStatus As ComboBox
    Friend WithEvents btnRefresh As Button
    Friend WithEvents btnCheckStatus As Button
    Friend WithEvents btnViewDetails As Button
    Friend WithEvents lblFromDate As Label
    Friend WithEvents lblToDate As Label
    Friend WithEvents lblStatus As Label
    Friend WithEvents lblBatches As Label
    Friend WithEvents lblTransactions As Label
    Friend WithEvents lblRecordCount As Label
    Friend WithEvents lblTransactionCount As Label
    Friend WithEvents splitContainer As SplitContainer

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.dgvBatches = New System.Windows.Forms.DataGridView()
        Me.dgvTransactions = New System.Windows.Forms.DataGridView()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.cboStatus = New System.Windows.Forms.ComboBox()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnCheckStatus = New System.Windows.Forms.Button()
        Me.btnViewDetails = New System.Windows.Forms.Button()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.lblStatus = New System.Windows.Forms.Label()
        Me.lblBatches = New System.Windows.Forms.Label()
        Me.lblTransactions = New System.Windows.Forms.Label()
        Me.lblRecordCount = New System.Windows.Forms.Label()
        Me.lblTransactionCount = New System.Windows.Forms.Label()
        Me.splitContainer = New System.Windows.Forms.SplitContainer()
        CType(Me.dgvBatches, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvTransactions, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.splitContainer, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.splitContainer.Panel1.SuspendLayout()
        Me.splitContainer.Panel2.SuspendLayout()
        Me.splitContainer.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblFromDate
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(12, 15)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(56, 13)
        Me.lblFromDate.TabIndex = 0
        Me.lblFromDate.Text = "From Date"
        '
        'dtpFromDate
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpFromDate.Location = New System.Drawing.Point(74, 12)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.Size = New System.Drawing.Size(100, 20)
        Me.dtpFromDate.TabIndex = 1
        '
        'lblToDate
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(190, 15)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(46, 13)
        Me.lblToDate.TabIndex = 2
        Me.lblToDate.Text = "To Date"
        '
        'dtpToDate
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpToDate.Location = New System.Drawing.Point(242, 12)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.Size = New System.Drawing.Size(100, 20)
        Me.dtpToDate.TabIndex = 3
        '
        'lblStatus
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Location = New System.Drawing.Point(360, 15)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(37, 13)
        Me.lblStatus.TabIndex = 4
        Me.lblStatus.Text = "Status"
        '
        'cboStatus
        Me.cboStatus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboStatus.FormattingEnabled = True
        Me.cboStatus.Items.AddRange(New Object() {"All", "Pending", "ACCP", "ACSC", "RJCT", "PDNG"})
        Me.cboStatus.Location = New System.Drawing.Point(403, 12)
        Me.cboStatus.Name = "cboStatus"
        Me.cboStatus.Size = New System.Drawing.Size(100, 21)
        Me.cboStatus.TabIndex = 5
        '
        'btnRefresh
        Me.btnRefresh.Location = New System.Drawing.Point(520, 10)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 6
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        '
        'btnCheckStatus
        Me.btnCheckStatus.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnCheckStatus.ForeColor = System.Drawing.Color.White
        Me.btnCheckStatus.Location = New System.Drawing.Point(601, 10)
        Me.btnCheckStatus.Name = "btnCheckStatus"
        Me.btnCheckStatus.Size = New System.Drawing.Size(100, 23)
        Me.btnCheckStatus.TabIndex = 7
        Me.btnCheckStatus.Text = "Check Status"
        Me.btnCheckStatus.UseVisualStyleBackColor = False
        '
        'splitContainer
        Me.splitContainer.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.splitContainer.Location = New System.Drawing.Point(12, 45)
        Me.splitContainer.Name = "splitContainer"
        Me.splitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'splitContainer.Panel1
        Me.splitContainer.Panel1.Controls.Add(Me.lblBatches)
        Me.splitContainer.Panel1.Controls.Add(Me.lblRecordCount)
        Me.splitContainer.Panel1.Controls.Add(Me.dgvBatches)
        '
        'splitContainer.Panel2
        Me.splitContainer.Panel2.Controls.Add(Me.lblTransactions)
        Me.splitContainer.Panel2.Controls.Add(Me.lblTransactionCount)
        Me.splitContainer.Panel2.Controls.Add(Me.btnViewDetails)
        Me.splitContainer.Panel2.Controls.Add(Me.dgvTransactions)
        Me.splitContainer.Size = New System.Drawing.Size(1160, 593)
        Me.splitContainer.SplitterDistance = 280
        Me.splitContainer.TabIndex = 8
        '
        'lblBatches
        Me.lblBatches.AutoSize = True
        Me.lblBatches.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblBatches.Location = New System.Drawing.Point(3, 5)
        Me.lblBatches.Name = "lblBatches"
        Me.lblBatches.Size = New System.Drawing.Size(116, 15)
        Me.lblBatches.TabIndex = 0
        Me.lblBatches.Text = "Payment Batches"
        '
        'lblRecordCount
        Me.lblRecordCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRecordCount.Location = New System.Drawing.Point(900, 5)
        Me.lblRecordCount.Name = "lblRecordCount"
        Me.lblRecordCount.Size = New System.Drawing.Size(257, 15)
        Me.lblRecordCount.TabIndex = 1
        Me.lblRecordCount.Text = "Batches: 0"
        Me.lblRecordCount.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'dgvBatches
        Me.dgvBatches.AllowUserToAddRows = False
        Me.dgvBatches.AllowUserToDeleteRows = False
        Me.dgvBatches.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvBatches.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvBatches.Location = New System.Drawing.Point(3, 25)
        Me.dgvBatches.MultiSelect = False
        Me.dgvBatches.Name = "dgvBatches"
        Me.dgvBatches.ReadOnly = True
        Me.dgvBatches.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvBatches.Size = New System.Drawing.Size(1154, 252)
        Me.dgvBatches.TabIndex = 2
        '
        'lblTransactions
        Me.lblTransactions.AutoSize = True
        Me.lblTransactions.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTransactions.Location = New System.Drawing.Point(3, 5)
        Me.lblTransactions.Name = "lblTransactions"
        Me.lblTransactions.Size = New System.Drawing.Size(87, 15)
        Me.lblTransactions.TabIndex = 0
        Me.lblTransactions.Text = "Transactions"
        '
        'lblTransactionCount
        Me.lblTransactionCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblTransactionCount.Location = New System.Drawing.Point(800, 5)
        Me.lblTransactionCount.Name = "lblTransactionCount"
        Me.lblTransactionCount.Size = New System.Drawing.Size(257, 15)
        Me.lblTransactionCount.TabIndex = 1
        Me.lblTransactionCount.Text = "Transactions: 0"
        Me.lblTransactionCount.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'btnViewDetails
        Me.btnViewDetails.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnViewDetails.Location = New System.Drawing.Point(1063, 0)
        Me.btnViewDetails.Name = "btnViewDetails"
        Me.btnViewDetails.Size = New System.Drawing.Size(94, 23)
        Me.btnViewDetails.TabIndex = 2
        Me.btnViewDetails.Text = "View Details"
        Me.btnViewDetails.UseVisualStyleBackColor = True
        '
        'dgvTransactions
        Me.dgvTransactions.AllowUserToAddRows = False
        Me.dgvTransactions.AllowUserToDeleteRows = False
        Me.dgvTransactions.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvTransactions.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvTransactions.Location = New System.Drawing.Point(3, 25)
        Me.dgvTransactions.MultiSelect = False
        Me.dgvTransactions.Name = "dgvTransactions"
        Me.dgvTransactions.ReadOnly = True
        Me.dgvTransactions.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvTransactions.Size = New System.Drawing.Size(1154, 281)
        Me.dgvTransactions.TabIndex = 3
        '
        'FNBTransactionViewerForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1184, 650)
        Me.Controls.Add(Me.splitContainer)
        Me.Controls.Add(Me.btnCheckStatus)
        Me.Controls.Add(Me.btnRefresh)
        Me.Controls.Add(Me.cboStatus)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.dtpToDate)
        Me.Controls.Add(Me.lblToDate)
        Me.Controls.Add(Me.dtpFromDate)
        Me.Controls.Add(Me.lblFromDate)
        Me.Name = "FNBTransactionViewerForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "FNB Payment Transactions - SANDBOX MODE"
        CType(Me.dgvBatches, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgvTransactions, System.ComponentModel.ISupportInitialize).EndInit()
        Me.splitContainer.Panel1.ResumeLayout(False)
        Me.splitContainer.Panel1.PerformLayout()
        Me.splitContainer.Panel2.ResumeLayout(False)
        Me.splitContainer.Panel2.PerformLayout()
        CType(Me.splitContainer, System.ComponentModel.ISupportInitialize).EndInit()
        Me.splitContainer.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
End Class

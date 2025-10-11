Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class AccountLedgerForm
        Inherits System.Windows.Forms.Form

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

        <System.Diagnostics.DebuggerStepThrough()>
        Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.pnlFilters = New System.Windows.Forms.Panel()
        Me.lblAccount = New System.Windows.Forms.Label()
        Me.cboAccount = New System.Windows.Forms.ComboBox()
        Me.lblAccountName = New System.Windows.Forms.Label()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnExport = New System.Windows.Forms.Button()
        Me.dgvLedger = New System.Windows.Forms.DataGridView()
        Me.pnlBottom = New System.Windows.Forms.Panel()
        Me.lblOpeningBalance = New System.Windows.Forms.Label()
        Me.lblTotalDebits = New System.Windows.Forms.Label()
        Me.lblTotalCredits = New System.Windows.Forms.Label()
        Me.lblClosingBalance = New System.Windows.Forms.Label()
        Me.lblTransactionCount = New System.Windows.Forms.Label()
        Me.pnlTop.SuspendLayout()
        Me.pnlFilters.SuspendLayout()
        CType(Me.dgvLedger, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.Navy
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Controls.Add(Me.btnClose)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1200, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(186, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Account Ledger"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1120, 12)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(68, 36)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'pnlFilters
        '
        Me.pnlFilters.BackColor = System.Drawing.Color.WhiteSmoke
        Me.pnlFilters.Controls.Add(Me.lblAccount)
        Me.pnlFilters.Controls.Add(Me.cboAccount)
        Me.pnlFilters.Controls.Add(Me.lblAccountName)
        Me.pnlFilters.Controls.Add(Me.lblFromDate)
        Me.pnlFilters.Controls.Add(Me.dtpFromDate)
        Me.pnlFilters.Controls.Add(Me.lblToDate)
        Me.pnlFilters.Controls.Add(Me.dtpToDate)
        Me.pnlFilters.Controls.Add(Me.lblBranch)
        Me.pnlFilters.Controls.Add(Me.cboBranch)
        Me.pnlFilters.Controls.Add(Me.btnRefresh)
        Me.pnlFilters.Controls.Add(Me.btnExport)
        Me.pnlFilters.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlFilters.Location = New System.Drawing.Point(0, 60)
        Me.pnlFilters.Name = "pnlFilters"
        Me.pnlFilters.Size = New System.Drawing.Size(1200, 100)
        Me.pnlFilters.TabIndex = 1
        '
        'lblAccount
        '
        Me.lblAccount.AutoSize = True
        Me.lblAccount.Location = New System.Drawing.Point(12, 15)
        Me.lblAccount.Name = "lblAccount"
        Me.lblAccount.Size = New System.Drawing.Size(55, 15)
        Me.lblAccount.TabIndex = 0
        Me.lblAccount.Text = "Account:"
        '
        'cboAccount
        '
        Me.cboAccount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboAccount.FormattingEnabled = True
        Me.cboAccount.Location = New System.Drawing.Point(12, 33)
        Me.cboAccount.Name = "cboAccount"
        Me.cboAccount.Size = New System.Drawing.Size(400, 23)
        Me.cboAccount.TabIndex = 1
        '
        'lblAccountName
        '
        Me.lblAccountName.AutoSize = True
        Me.lblAccountName.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblAccountName.Location = New System.Drawing.Point(12, 65)
        Me.lblAccountName.Name = "lblAccountName"
        Me.lblAccountName.Size = New System.Drawing.Size(109, 19)
        Me.lblAccountName.TabIndex = 2
        Me.lblAccountName.Text = "Account Name"
        '
        'lblFromDate
        '
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(430, 15)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(63, 15)
        Me.lblFromDate.TabIndex = 3
        Me.lblFromDate.Text = "From Date:"
        '
        'dtpFromDate
        '
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpFromDate.Location = New System.Drawing.Point(430, 33)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.ShowCheckBox = True
        Me.dtpFromDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpFromDate.TabIndex = 4
        '
        'lblToDate
        '
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(598, 15)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(51, 15)
        Me.lblToDate.TabIndex = 5
        Me.lblToDate.Text = "To Date:"
        '
        'dtpToDate
        '
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpToDate.Location = New System.Drawing.Point(598, 33)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.ShowCheckBox = True
        Me.dtpToDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpToDate.TabIndex = 6
        '
        'lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(766, 15)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 7
        Me.lblBranch.Text = "Branch:"
        '
        'cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(766, 33)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 23)
        Me.cboBranch.TabIndex = 8
        '
        'btnRefresh
        '
        Me.btnRefresh.BackColor = System.Drawing.Color.Green
        Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRefresh.ForeColor = System.Drawing.Color.White
        Me.btnRefresh.Location = New System.Drawing.Point(430, 60)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(100, 32)
        Me.btnRefresh.TabIndex = 9
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = False
        '
        'btnExport
        '
        Me.btnExport.BackColor = System.Drawing.Color.DarkOrange
        Me.btnExport.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnExport.ForeColor = System.Drawing.Color.White
        Me.btnExport.Location = New System.Drawing.Point(544, 60)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(100, 32)
        Me.btnExport.TabIndex = 10
        Me.btnExport.Text = "Export Excel"
        Me.btnExport.UseVisualStyleBackColor = False
        '
        'dgvLedger
        '
        Me.dgvLedger.AllowUserToAddRows = False
        Me.dgvLedger.AllowUserToDeleteRows = False
        Me.dgvLedger.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvLedger.BackgroundColor = System.Drawing.Color.White
        Me.dgvLedger.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLedger.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvLedger.Location = New System.Drawing.Point(0, 160)
        Me.dgvLedger.Name = "dgvLedger"
        Me.dgvLedger.ReadOnly = True
        Me.dgvLedger.RowTemplate.Height = 25
        Me.dgvLedger.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvLedger.Size = New System.Drawing.Size(1200, 390)
        Me.dgvLedger.TabIndex = 2
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.Color.LightSteelBlue
        Me.pnlBottom.Controls.Add(Me.lblOpeningBalance)
        Me.pnlBottom.Controls.Add(Me.lblTotalDebits)
        Me.pnlBottom.Controls.Add(Me.lblTotalCredits)
        Me.pnlBottom.Controls.Add(Me.lblClosingBalance)
        Me.pnlBottom.Controls.Add(Me.lblTransactionCount)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 550)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(1200, 60)
        Me.pnlBottom.TabIndex = 3
        '
        'lblOpeningBalance
        '
        Me.lblOpeningBalance.AutoSize = True
        Me.lblOpeningBalance.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblOpeningBalance.Location = New System.Drawing.Point(12, 10)
        Me.lblOpeningBalance.Name = "lblOpeningBalance"
        Me.lblOpeningBalance.Size = New System.Drawing.Size(154, 19)
        Me.lblOpeningBalance.TabIndex = 0
        Me.lblOpeningBalance.Text = "Opening Balance: 0.00"
        '
        'lblTotalDebits
        '
        Me.lblTotalDebits.AutoSize = True
        Me.lblTotalDebits.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalDebits.Location = New System.Drawing.Point(12, 35)
        Me.lblTotalDebits.Name = "lblTotalDebits"
        Me.lblTotalDebits.Size = New System.Drawing.Size(122, 19)
        Me.lblTotalDebits.TabIndex = 1
        Me.lblTotalDebits.Text = "Total Debits: 0.00"
        '
        'lblTotalCredits
        '
        Me.lblTotalCredits.AutoSize = True
        Me.lblTotalCredits.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalCredits.Location = New System.Drawing.Point(250, 35)
        Me.lblTotalCredits.Name = "lblTotalCredits"
        Me.lblTotalCredits.Size = New System.Drawing.Size(129, 19)
        Me.lblTotalCredits.TabIndex = 2
        Me.lblTotalCredits.Text = "Total Credits: 0.00"
        '
        'lblClosingBalance
        '
        Me.lblClosingBalance.AutoSize = True
        Me.lblClosingBalance.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblClosingBalance.Location = New System.Drawing.Point(500, 10)
        Me.lblClosingBalance.Name = "lblClosingBalance"
        Me.lblClosingBalance.Size = New System.Drawing.Size(151, 19)
        Me.lblClosingBalance.TabIndex = 3
        Me.lblClosingBalance.Text = "Closing Balance: 0.00"
        '
        'lblTransactionCount
        '
        Me.lblTransactionCount.AutoSize = True
        Me.lblTransactionCount.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblTransactionCount.Location = New System.Drawing.Point(500, 35)
        Me.lblTransactionCount.Name = "lblTransactionCount"
        Me.lblTransactionCount.Size = New System.Drawing.Size(116, 19)
        Me.lblTransactionCount.TabIndex = 4
        Me.lblTransactionCount.Text = "Transactions: 0"
        '
        'AccountLedgerForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 610)
        Me.Controls.Add(Me.dgvLedger)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.pnlFilters)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "AccountLedgerForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Account Ledger"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlFilters.ResumeLayout(False)
        Me.pnlFilters.PerformLayout()
        CType(Me.dgvLedger, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBottom.ResumeLayout(False)
        Me.pnlBottom.PerformLayout()
        Me.ResumeLayout(False)

        End Sub

        Friend WithEvents pnlTop As Panel
        Friend WithEvents lblTitle As Label
        Friend WithEvents btnClose As Button
        Friend WithEvents pnlFilters As Panel
        Friend WithEvents lblAccount As Label
        Friend WithEvents cboAccount As ComboBox
        Friend WithEvents lblAccountName As Label
        Friend WithEvents lblFromDate As Label
        Friend WithEvents dtpFromDate As DateTimePicker
        Friend WithEvents lblToDate As Label
        Friend WithEvents dtpToDate As DateTimePicker
        Friend WithEvents lblBranch As Label
        Friend WithEvents cboBranch As ComboBox
        Friend WithEvents btnRefresh As Button
        Friend WithEvents btnExport As Button
        Friend WithEvents dgvLedger As DataGridView
        Friend WithEvents pnlBottom As Panel
        Friend WithEvents lblOpeningBalance As Label
        Friend WithEvents lblTotalDebits As Label
        Friend WithEvents lblTotalCredits As Label
        Friend WithEvents lblClosingBalance As Label
        Friend WithEvents lblTransactionCount As Label
    End Class
End Namespace

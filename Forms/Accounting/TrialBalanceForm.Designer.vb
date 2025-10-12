Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class TrialBalanceForm
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
        Me.btnClose = New System.Windows.Forms.Button()
        Me.pnlFilters = New System.Windows.Forms.Panel()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblAccountType = New System.Windows.Forms.Label()
        Me.cboAccountType = New System.Windows.Forms.ComboBox()
        Me.chkShowZero = New System.Windows.Forms.CheckBox()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnExport = New System.Windows.Forms.Button()
        Me.dgvTrialBalance = New System.Windows.Forms.DataGridView()
        Me.pnlBottom = New System.Windows.Forms.Panel()
        Me.lblTotalDebit = New System.Windows.Forms.Label()
        Me.lblTotalCredit = New System.Windows.Forms.Label()
        Me.lblDifference = New System.Windows.Forms.Label()
        Me.pnlTop.SuspendLayout()
        Me.pnlFilters.SuspendLayout()
        CType(Me.dgvTrialBalance, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.lblTitle.Size = New System.Drawing.Size(165, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Trial Balance"
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
        Me.pnlFilters.Controls.Add(Me.lblFromDate)
        Me.pnlFilters.Controls.Add(Me.dtpFromDate)
        Me.pnlFilters.Controls.Add(Me.lblToDate)
        Me.pnlFilters.Controls.Add(Me.dtpToDate)
        Me.pnlFilters.Controls.Add(Me.lblBranch)
        Me.pnlFilters.Controls.Add(Me.cboBranch)
        Me.pnlFilters.Controls.Add(Me.lblAccountType)
        Me.pnlFilters.Controls.Add(Me.cboAccountType)
        Me.pnlFilters.Controls.Add(Me.chkShowZero)
        Me.pnlFilters.Controls.Add(Me.btnRefresh)
        Me.pnlFilters.Controls.Add(Me.btnExport)
        Me.pnlFilters.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlFilters.Location = New System.Drawing.Point(0, 60)
        Me.pnlFilters.Name = "pnlFilters"
        Me.pnlFilters.Size = New System.Drawing.Size(1200, 80)
        Me.pnlFilters.TabIndex = 1
        '
        'lblFromDate
        '
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(12, 15)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(63, 15)
        Me.lblFromDate.TabIndex = 0
        Me.lblFromDate.Text = "From Date:"
        '
        'dtpFromDate
        '
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpFromDate.Location = New System.Drawing.Point(12, 33)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.ShowCheckBox = True
        Me.dtpFromDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpFromDate.TabIndex = 1
        '
        'lblToDate
        '
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(180, 15)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(51, 15)
        Me.lblToDate.TabIndex = 2
        Me.lblToDate.Text = "To Date:"
        '
        'dtpToDate
        '
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpToDate.Location = New System.Drawing.Point(180, 33)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.ShowCheckBox = True
        Me.dtpToDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpToDate.TabIndex = 3
        '
        'lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(348, 15)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 4
        Me.lblBranch.Text = "Branch:"
        '
        'cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(348, 33)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 23)
        Me.cboBranch.TabIndex = 5
        '
        'lblAccountType
        '
        Me.lblAccountType.AutoSize = True
        Me.lblAccountType.Location = New System.Drawing.Point(566, 15)
        Me.lblAccountType.Name = "lblAccountType"
        Me.lblAccountType.Size = New System.Drawing.Size(82, 15)
        Me.lblAccountType.TabIndex = 6
        Me.lblAccountType.Text = "Account Type:"
        '
        'cboAccountType
        '
        Me.cboAccountType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboAccountType.FormattingEnabled = True
        Me.cboAccountType.Location = New System.Drawing.Point(566, 33)
        Me.cboAccountType.Name = "cboAccountType"
        Me.cboAccountType.Size = New System.Drawing.Size(150, 23)
        Me.cboAccountType.TabIndex = 7
        '
        'chkShowZero
        '
        Me.chkShowZero.AutoSize = True
        Me.chkShowZero.Location = New System.Drawing.Point(734, 35)
        Me.chkShowZero.Name = "chkShowZero"
        Me.chkShowZero.Size = New System.Drawing.Size(128, 19)
        Me.chkShowZero.TabIndex = 8
        Me.chkShowZero.Text = "Show Zero Balances"
        Me.chkShowZero.UseVisualStyleBackColor = True
        '
        'btnRefresh
        '
        Me.btnRefresh.BackColor = System.Drawing.Color.Green
        Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRefresh.ForeColor = System.Drawing.Color.White
        Me.btnRefresh.Location = New System.Drawing.Point(880, 28)
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
        Me.btnExport.Location = New System.Drawing.Point(994, 28)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(100, 32)
        Me.btnExport.TabIndex = 10
        Me.btnExport.Text = "Export Excel"
        Me.btnExport.UseVisualStyleBackColor = False
        '
        'dgvTrialBalance
        '
        Me.dgvTrialBalance.AllowUserToAddRows = False
        Me.dgvTrialBalance.AllowUserToDeleteRows = False
        Me.dgvTrialBalance.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvTrialBalance.BackgroundColor = System.Drawing.Color.White
        Me.dgvTrialBalance.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvTrialBalance.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvTrialBalance.Location = New System.Drawing.Point(0, 140)
        Me.dgvTrialBalance.Name = "dgvTrialBalance"
        Me.dgvTrialBalance.ReadOnly = True
        Me.dgvTrialBalance.RowTemplate.Height = 25
        Me.dgvTrialBalance.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvTrialBalance.Size = New System.Drawing.Size(1200, 460)
        Me.dgvTrialBalance.TabIndex = 2
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.Color.LightSteelBlue
        Me.pnlBottom.Controls.Add(Me.lblTotalDebit)
        Me.pnlBottom.Controls.Add(Me.lblTotalCredit)
        Me.pnlBottom.Controls.Add(Me.lblDifference)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 600)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(1200, 50)
        Me.pnlBottom.TabIndex = 3
        '
        'lblTotalDebit
        '
        Me.lblTotalDebit.AutoSize = True
        Me.lblTotalDebit.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalDebit.Location = New System.Drawing.Point(12, 14)
        Me.lblTotalDebit.Name = "lblTotalDebit"
        Me.lblTotalDebit.Size = New System.Drawing.Size(145, 21)
        Me.lblTotalDebit.TabIndex = 0
        Me.lblTotalDebit.Text = "Total Debit: 0.00"
        '
        'lblTotalCredit
        '
        Me.lblTotalCredit.AutoSize = True
        Me.lblTotalCredit.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalCredit.Location = New System.Drawing.Point(300, 14)
        Me.lblTotalCredit.Name = "lblTotalCredit"
        Me.lblTotalCredit.Size = New System.Drawing.Size(152, 21)
        Me.lblTotalCredit.TabIndex = 1
        Me.lblTotalCredit.Text = "Total Credit: 0.00"
        '
        'lblDifference
        '
        Me.lblDifference.AutoSize = True
        Me.lblDifference.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblDifference.Location = New System.Drawing.Point(600, 14)
        Me.lblDifference.Name = "lblDifference"
        Me.lblDifference.Size = New System.Drawing.Size(143, 21)
        Me.lblDifference.TabIndex = 2
        Me.lblDifference.Text = "Difference: 0.00"
        '
        'TrialBalanceForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 650)
        Me.Controls.Add(Me.dgvTrialBalance)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.pnlFilters)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "TrialBalanceForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Trial Balance"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlFilters.ResumeLayout(False)
        Me.pnlFilters.PerformLayout()
        CType(Me.dgvTrialBalance, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBottom.ResumeLayout(False)
        Me.pnlBottom.PerformLayout()
        Me.ResumeLayout(False)

        End Sub

        Friend WithEvents pnlTop As Panel
        Friend WithEvents lblTitle As Label
        Friend WithEvents btnClose As Button
        Friend WithEvents pnlFilters As Panel
        Friend WithEvents lblFromDate As Label
        Friend WithEvents dtpFromDate As DateTimePicker
        Friend WithEvents lblToDate As Label
        Friend WithEvents dtpToDate As DateTimePicker
        Friend WithEvents lblBranch As Label
        Friend WithEvents cboBranch As ComboBox
        Friend WithEvents lblAccountType As Label
        Friend WithEvents cboAccountType As ComboBox
        Friend WithEvents chkShowZero As CheckBox
        Friend WithEvents btnRefresh As Button
        Friend WithEvents btnExport As Button
        Friend WithEvents dgvTrialBalance As DataGridView
        Friend WithEvents pnlBottom As Panel
        Friend WithEvents lblTotalDebit As Label
        Friend WithEvents lblTotalCredit As Label
        Friend WithEvents lblDifference As Label
    End Class
End Namespace

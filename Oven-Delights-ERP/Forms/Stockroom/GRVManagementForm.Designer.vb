<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GRVManagementForm
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
        Me.dgvGRVs = New System.Windows.Forms.DataGridView()
        Me.btnCreateGRV = New System.Windows.Forms.Button()
        Me.btnReceiveItems = New System.Windows.Forms.Button()
        Me.btnMatchInvoice = New System.Windows.Forms.Button()
        Me.btnCompleteGRV = New System.Windows.Forms.Button()
        Me.btnCreateCreditNote = New System.Windows.Forms.Button()
        Me.btnViewCreditNotes = New System.Windows.Forms.Button()
        Me.btnViewDetails = New System.Windows.Forms.Button()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.cboStatus = New System.Windows.Forms.ComboBox()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.lblStatus = New System.Windows.Forms.Label()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.txtSearch = New System.Windows.Forms.TextBox()
        Me.lblSearch = New System.Windows.Forms.Label()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlFilters = New System.Windows.Forms.Panel()
        CType(Me.dgvGRVs, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlTop.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.pnlFilters.SuspendLayout()
        Me.SuspendLayout()
        '
        'dgvGRVs
        '
        Me.dgvGRVs.AllowUserToAddRows = False
        Me.dgvGRVs.AllowUserToDeleteRows = False
        Me.dgvGRVs.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvGRVs.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvGRVs.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvGRVs.Location = New System.Drawing.Point(0, 100)
        Me.dgvGRVs.MultiSelect = False
        Me.dgvGRVs.Name = "dgvGRVs"
        Me.dgvGRVs.ReadOnly = True
        Me.dgvGRVs.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvGRVs.Size = New System.Drawing.Size(800, 350)
        Me.dgvGRVs.TabIndex = 0
        '
        'btnCreateGRV
        '
        Me.btnCreateGRV.Location = New System.Drawing.Point(10, 10)
        Me.btnCreateGRV.Name = "btnCreateGRV"
        Me.btnCreateGRV.Size = New System.Drawing.Size(90, 23)
        Me.btnCreateGRV.TabIndex = 1
        Me.btnCreateGRV.Text = "Create GRV"
        Me.btnCreateGRV.UseVisualStyleBackColor = True
        '
        'btnReceiveItems
        '
        Me.btnReceiveItems.Location = New System.Drawing.Point(106, 10)
        Me.btnReceiveItems.Name = "btnReceiveItems"
        Me.btnReceiveItems.Size = New System.Drawing.Size(90, 23)
        Me.btnReceiveItems.TabIndex = 2
        Me.btnReceiveItems.Text = "Receive Items"
        Me.btnReceiveItems.UseVisualStyleBackColor = True
        '
        'btnMatchInvoice
        '
        Me.btnMatchInvoice.Location = New System.Drawing.Point(202, 10)
        Me.btnMatchInvoice.Name = "btnMatchInvoice"
        Me.btnMatchInvoice.Size = New System.Drawing.Size(90, 23)
        Me.btnMatchInvoice.TabIndex = 3
        Me.btnMatchInvoice.Text = "Match Invoice"
        Me.btnMatchInvoice.UseVisualStyleBackColor = True
        '
        'btnCompleteGRV
        '
        Me.btnCompleteGRV.Location = New System.Drawing.Point(298, 10)
        Me.btnCompleteGRV.Name = "btnCompleteGRV"
        Me.btnCompleteGRV.Size = New System.Drawing.Size(90, 23)
        Me.btnCompleteGRV.TabIndex = 4
        Me.btnCompleteGRV.Text = "Complete GRV"
        Me.btnCompleteGRV.UseVisualStyleBackColor = True
        '
        'btnCreateCreditNote
        '
        Me.btnCreateCreditNote.Location = New System.Drawing.Point(394, 10)
        Me.btnCreateCreditNote.Name = "btnCreateCreditNote"
        Me.btnCreateCreditNote.Size = New System.Drawing.Size(90, 23)
        Me.btnCreateCreditNote.TabIndex = 5
        Me.btnCreateCreditNote.Text = "Credit Note"
        Me.btnCreateCreditNote.UseVisualStyleBackColor = True
        '
        'btnViewCreditNotes
        '
        Me.btnViewCreditNotes.Location = New System.Drawing.Point(490, 10)
        Me.btnViewCreditNotes.Name = "btnViewCreditNotes"
        Me.btnViewCreditNotes.Size = New System.Drawing.Size(90, 23)
        Me.btnViewCreditNotes.TabIndex = 6
        Me.btnViewCreditNotes.Text = "View Credits"
        Me.btnViewCreditNotes.UseVisualStyleBackColor = True
        Me.btnViewCreditNotes.Visible = False
        '
        'btnViewDetails
        '
        Me.btnViewDetails.Location = New System.Drawing.Point(586, 10)
        Me.btnViewDetails.Name = "btnViewDetails"
        Me.btnViewDetails.Size = New System.Drawing.Size(90, 23)
        Me.btnViewDetails.TabIndex = 7
        Me.btnViewDetails.Text = "View Details"
        Me.btnViewDetails.UseVisualStyleBackColor = True
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(682, 10)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 8
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        '
        'cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(750, 10)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(120, 21)
        Me.cboBranch.TabIndex = 9
        '
        'lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(700, 13)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(44, 13)
        Me.lblBranch.TabIndex = 10
        Me.lblBranch.Text = "Branch:"
        '
        'cboStatus
        '
        Me.cboStatus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboStatus.FormattingEnabled = True
        Me.cboStatus.Location = New System.Drawing.Point(60, 10)
        Me.cboStatus.Name = "cboStatus"
        Me.cboStatus.Size = New System.Drawing.Size(120, 21)
        Me.cboStatus.TabIndex = 6
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Location = New System.Drawing.Point(10, 13)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(40, 13)
        Me.lblStatus.TabIndex = 7
        Me.lblStatus.Text = "Status:"
        '
        'dtpFromDate
        '
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpFromDate.Location = New System.Drawing.Point(240, 10)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.Size = New System.Drawing.Size(100, 20)
        Me.dtpFromDate.TabIndex = 8
        '
        'dtpToDate
        '
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpToDate.Location = New System.Drawing.Point(380, 10)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.Size = New System.Drawing.Size(100, 20)
        Me.dtpToDate.TabIndex = 9
        '
        'lblFromDate
        '
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(190, 13)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(33, 13)
        Me.lblFromDate.TabIndex = 10
        Me.lblFromDate.Text = "From:"
        '
        'lblToDate
        '
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(350, 13)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(23, 13)
        Me.lblToDate.TabIndex = 11
        Me.lblToDate.Text = "To:"
        '
        'txtSearch
        '
        Me.txtSearch.Location = New System.Drawing.Point(540, 10)
        Me.txtSearch.Name = "txtSearch"
        Me.txtSearch.Size = New System.Drawing.Size(200, 20)
        Me.txtSearch.TabIndex = 12
        '
        'lblSearch
        '
        Me.lblSearch.AutoSize = True
        Me.lblSearch.Location = New System.Drawing.Point(490, 13)
        Me.lblSearch.Name = "lblSearch"
        Me.lblSearch.Size = New System.Drawing.Size(44, 13)
        Me.lblSearch.TabIndex = 13
        Me.lblSearch.Text = "Search:"
        '
        'pnlTop
        '
        Me.pnlTop.Controls.Add(Me.pnlButtons)
        Me.pnlTop.Controls.Add(Me.pnlFilters)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(800, 100)
        Me.pnlTop.TabIndex = 14
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnCreateGRV)
        Me.pnlButtons.Controls.Add(Me.btnReceiveItems)
        Me.pnlButtons.Controls.Add(Me.btnMatchInvoice)
        Me.pnlButtons.Controls.Add(Me.btnCompleteGRV)
        Me.pnlButtons.Controls.Add(Me.btnCreateCreditNote)
        Me.pnlButtons.Controls.Add(Me.btnViewCreditNotes)
        Me.pnlButtons.Controls.Add(Me.btnViewDetails)
        Me.pnlButtons.Controls.Add(Me.btnRefresh)
        Me.pnlButtons.Controls.Add(Me.cboBranch)
        Me.pnlButtons.Controls.Add(Me.lblBranch)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlButtons.Location = New System.Drawing.Point(0, 0)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 43)
        Me.pnlButtons.TabIndex = 15
        '
        'pnlFilters
        '
        Me.pnlFilters.Controls.Add(Me.lblStatus)
        Me.pnlFilters.Controls.Add(Me.lblSearch)
        Me.pnlFilters.Controls.Add(Me.cboStatus)
        Me.pnlFilters.Controls.Add(Me.txtSearch)
        Me.pnlFilters.Controls.Add(Me.dtpFromDate)
        Me.pnlFilters.Controls.Add(Me.lblToDate)
        Me.pnlFilters.Controls.Add(Me.dtpToDate)
        Me.pnlFilters.Controls.Add(Me.lblFromDate)
        Me.pnlFilters.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlFilters.Location = New System.Drawing.Point(0, 43)
        Me.pnlFilters.Name = "pnlFilters"
        Me.pnlFilters.Size = New System.Drawing.Size(800, 57)
        Me.pnlFilters.TabIndex = 16
        '
        'GRVManagementForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.dgvGRVs)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "GRVManagementForm"
        Me.Text = "GRV Management"
        CType(Me.dgvGRVs, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlTop.ResumeLayout(False)
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlFilters.ResumeLayout(False)
        Me.pnlFilters.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents dgvGRVs As DataGridView
    Friend WithEvents btnCreateGRV As Button
    Friend WithEvents btnReceiveItems As Button
    Friend WithEvents btnMatchInvoice As Button
    Friend WithEvents btnCompleteGRV As Button
    Friend WithEvents btnCreateCreditNote As Button
    Friend WithEvents btnViewCreditNotes As Button
    Friend WithEvents btnViewDetails As Button
    Friend WithEvents btnRefresh As Button
    Friend WithEvents cboStatus As ComboBox
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents lblBranch As Label
    Friend WithEvents lblStatus As Label
    Friend WithEvents dtpFromDate As DateTimePicker
    Friend WithEvents dtpToDate As DateTimePicker
    Friend WithEvents lblFromDate As Label
    Friend WithEvents lblToDate As Label
    Friend WithEvents txtSearch As TextBox
    Friend WithEvents lblSearch As Label
    Friend WithEvents pnlTop As Panel
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents pnlFilters As Panel

End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class InternalOrdersForm
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
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.dgvOrders = New System.Windows.Forms.DataGridView()
        Me.btnCreateOrder = New System.Windows.Forms.Button()
        Me.btnViewOrder = New System.Windows.Forms.Button()
        Me.btnFulfillOrder = New System.Windows.Forms.Button()
        Me.btnCancelOrder = New System.Windows.Forms.Button()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.cboStatus = New System.Windows.Forms.ComboBox()
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
        CType(Me.dgvOrders, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlTop.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.pnlFilters.SuspendLayout()
        Me.SuspendLayout()
        '
        'dgvOrders
        '
        Me.dgvOrders.AllowUserToAddRows = False
        Me.dgvOrders.AllowUserToDeleteRows = False
        Me.dgvOrders.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvOrders.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvOrders.Location = New System.Drawing.Point(0, 100)
        Me.dgvOrders.MultiSelect = False
        Me.dgvOrders.Name = "dgvOrders"
        Me.dgvOrders.ReadOnly = True
        Me.dgvOrders.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvOrders.Size = New System.Drawing.Size(800, 350)
        Me.dgvOrders.TabIndex = 0
        '
        'btnCreateOrder
        '
        Me.btnCreateOrder.Location = New System.Drawing.Point(10, 10)
        Me.btnCreateOrder.Name = "btnCreateOrder"
        Me.btnCreateOrder.Size = New System.Drawing.Size(90, 23)
        Me.btnCreateOrder.TabIndex = 1
        Me.btnCreateOrder.Text = "Create Order"
        Me.btnCreateOrder.UseVisualStyleBackColor = True
        '
        'btnViewOrder
        '
        Me.btnViewOrder.Location = New System.Drawing.Point(106, 10)
        Me.btnViewOrder.Name = "btnViewOrder"
        Me.btnViewOrder.Size = New System.Drawing.Size(75, 23)
        Me.btnViewOrder.TabIndex = 2
        Me.btnViewOrder.Text = "View"
        Me.btnViewOrder.UseVisualStyleBackColor = True
        '
        'btnFulfillOrder
        '
        Me.btnFulfillOrder.Location = New System.Drawing.Point(187, 10)
        Me.btnFulfillOrder.Name = "btnFulfillOrder"
        Me.btnFulfillOrder.Size = New System.Drawing.Size(75, 23)
        Me.btnFulfillOrder.TabIndex = 3
        Me.btnFulfillOrder.Text = "Fulfill"
        Me.btnFulfillOrder.UseVisualStyleBackColor = True
        '
        'btnCancelOrder
        '
        Me.btnCancelOrder.Location = New System.Drawing.Point(268, 10)
        Me.btnCancelOrder.Name = "btnCancelOrder"
        Me.btnCancelOrder.Size = New System.Drawing.Size(75, 23)
        Me.btnCancelOrder.TabIndex = 4
        Me.btnCancelOrder.Text = "Cancel"
        Me.btnCancelOrder.UseVisualStyleBackColor = True
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(349, 10)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 5
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
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
        Me.pnlButtons.Controls.Add(Me.btnCreateOrder)
        Me.pnlButtons.Controls.Add(Me.btnViewOrder)
        Me.pnlButtons.Controls.Add(Me.btnFulfillOrder)
        Me.pnlButtons.Controls.Add(Me.btnCancelOrder)
        Me.pnlButtons.Controls.Add(Me.btnRefresh)
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
        'InternalOrdersForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.dgvOrders)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "InternalOrdersForm"
        Me.Text = "Internal Orders"
        CType(Me.dgvOrders, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlTop.ResumeLayout(False)
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlFilters.ResumeLayout(False)
        Me.pnlFilters.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Private Sub btnFulfillOrder_Click(sender As Object, e As EventArgs) Handles btnFulfillOrder.Click

    End Sub

    Friend WithEvents dgvOrders As DataGridView
    Friend WithEvents btnCreateOrder As Button
    Friend WithEvents btnViewOrder As Button
    Friend WithEvents btnFulfillOrder As Button
    Friend WithEvents btnCancelOrder As Button
    Friend WithEvents btnRefresh As Button
    Friend WithEvents cboStatus As ComboBox
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

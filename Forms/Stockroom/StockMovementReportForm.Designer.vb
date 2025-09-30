<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StockMovementReportForm
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
        Me.dgvMovements = New System.Windows.Forms.DataGridView()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.cboMovementType = New System.Windows.Forms.ComboBox()
        Me.cboProduct = New System.Windows.Forms.ComboBox()
        Me.btnGenerate = New System.Windows.Forms.Button()
        Me.btnExport = New System.Windows.Forms.Button()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.lblMovementType = New System.Windows.Forms.Label()
        Me.lblProduct = New System.Windows.Forms.Label()
        Me.txtTotalIn = New System.Windows.Forms.TextBox()
        Me.txtTotalOut = New System.Windows.Forms.TextBox()
        Me.txtNetMovement = New System.Windows.Forms.TextBox()
        Me.lblTotalIn = New System.Windows.Forms.Label()
        Me.lblTotalOut = New System.Windows.Forms.Label()
        Me.lblNetMovement = New System.Windows.Forms.Label()
        Me.pnlFilters = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlSummary = New System.Windows.Forms.Panel()
        CType(Me.dgvMovements, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlFilters.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.pnlSummary.SuspendLayout()
        Me.SuspendLayout()
        '
        'dgvMovements
        '
        Me.dgvMovements.AllowUserToAddRows = False
        Me.dgvMovements.AllowUserToDeleteRows = False
        Me.dgvMovements.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvMovements.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvMovements.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvMovements.Location = New System.Drawing.Point(0, 100)
        Me.dgvMovements.MultiSelect = False
        Me.dgvMovements.Name = "dgvMovements"
        Me.dgvMovements.ReadOnly = True
        Me.dgvMovements.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvMovements.Size = New System.Drawing.Size(800, 300)
        Me.dgvMovements.TabIndex = 0
        '
        'dtpFromDate
        '
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpFromDate.Location = New System.Drawing.Point(80, 20)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.Size = New System.Drawing.Size(120, 20)
        Me.dtpFromDate.TabIndex = 1
        '
        'dtpToDate
        '
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpToDate.Location = New System.Drawing.Point(250, 20)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.Size = New System.Drawing.Size(120, 20)
        Me.dtpToDate.TabIndex = 2
        '
        'cboMovementType
        '
        Me.cboMovementType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboMovementType.FormattingEnabled = True
        Me.cboMovementType.Location = New System.Drawing.Point(80, 50)
        Me.cboMovementType.Name = "cboMovementType"
        Me.cboMovementType.Size = New System.Drawing.Size(150, 21)
        Me.cboMovementType.TabIndex = 3
        '
        'cboProduct
        '
        Me.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboProduct.FormattingEnabled = True
        Me.cboProduct.Location = New System.Drawing.Point(290, 50)
        Me.cboProduct.Name = "cboProduct"
        Me.cboProduct.Size = New System.Drawing.Size(200, 21)
        Me.cboProduct.TabIndex = 4
        '
        'btnGenerate
        '
        Me.btnGenerate.Location = New System.Drawing.Point(520, 20)
        Me.btnGenerate.Name = "btnGenerate"
        Me.btnGenerate.Size = New System.Drawing.Size(75, 23)
        Me.btnGenerate.TabIndex = 5
        Me.btnGenerate.Text = "Generate"
        Me.btnGenerate.UseVisualStyleBackColor = True
        '
        'btnExport
        '
        Me.btnExport.Location = New System.Drawing.Point(10, 10)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(75, 23)
        Me.btnExport.TabIndex = 6
        Me.btnExport.Text = "Export"
        Me.btnExport.UseVisualStyleBackColor = True
        '
        'btnPrint
        '
        Me.btnPrint.Location = New System.Drawing.Point(91, 10)
        Me.btnPrint.Name = "btnPrint"
        Me.btnPrint.Size = New System.Drawing.Size(75, 23)
        Me.btnPrint.TabIndex = 7
        Me.btnPrint.Text = "Print"
        Me.btnPrint.UseVisualStyleBackColor = True
        '
        'lblFromDate
        '
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(20, 23)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(33, 13)
        Me.lblFromDate.TabIndex = 8
        Me.lblFromDate.Text = "From:"
        '
        'lblToDate
        '
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(210, 23)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(23, 13)
        Me.lblToDate.TabIndex = 9
        Me.lblToDate.Text = "To:"
        '
        'lblMovementType
        '
        Me.lblMovementType.AutoSize = True
        Me.lblMovementType.Location = New System.Drawing.Point(20, 53)
        Me.lblMovementType.Name = "lblMovementType"
        Me.lblMovementType.Size = New System.Drawing.Size(34, 13)
        Me.lblMovementType.TabIndex = 10
        Me.lblMovementType.Text = "Type:"
        '
        'lblProduct
        '
        Me.lblProduct.AutoSize = True
        Me.lblProduct.Location = New System.Drawing.Point(240, 53)
        Me.lblProduct.Name = "lblProduct"
        Me.lblProduct.Size = New System.Drawing.Size(47, 13)
        Me.lblProduct.TabIndex = 11
        Me.lblProduct.Text = "Product:"
        '
        'txtTotalIn
        '
        Me.txtTotalIn.Location = New System.Drawing.Point(80, 10)
        Me.txtTotalIn.Name = "txtTotalIn"
        Me.txtTotalIn.ReadOnly = True
        Me.txtTotalIn.Size = New System.Drawing.Size(100, 20)
        Me.txtTotalIn.TabIndex = 12
        Me.txtTotalIn.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtTotalOut
        '
        Me.txtTotalOut.Location = New System.Drawing.Point(250, 10)
        Me.txtTotalOut.Name = "txtTotalOut"
        Me.txtTotalOut.ReadOnly = True
        Me.txtTotalOut.Size = New System.Drawing.Size(100, 20)
        Me.txtTotalOut.TabIndex = 13
        Me.txtTotalOut.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtNetMovement
        '
        Me.txtNetMovement.Location = New System.Drawing.Point(450, 10)
        Me.txtNetMovement.Name = "txtNetMovement"
        Me.txtNetMovement.ReadOnly = True
        Me.txtNetMovement.Size = New System.Drawing.Size(100, 20)
        Me.txtNetMovement.TabIndex = 14
        Me.txtNetMovement.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblTotalIn
        '
        Me.lblTotalIn.AutoSize = True
        Me.lblTotalIn.Location = New System.Drawing.Point(20, 13)
        Me.lblTotalIn.Name = "lblTotalIn"
        Me.lblTotalIn.Size = New System.Drawing.Size(48, 13)
        Me.lblTotalIn.TabIndex = 15
        Me.lblTotalIn.Text = "Total In:"
        '
        'lblTotalOut
        '
        Me.lblTotalOut.AutoSize = True
        Me.lblTotalOut.Location = New System.Drawing.Point(190, 13)
        Me.lblTotalOut.Name = "lblTotalOut"
        Me.lblTotalOut.Size = New System.Drawing.Size(55, 13)
        Me.lblTotalOut.TabIndex = 16
        Me.lblTotalOut.Text = "Total Out:"
        '
        'lblNetMovement
        '
        Me.lblNetMovement.AutoSize = True
        Me.lblNetMovement.Location = New System.Drawing.Point(370, 13)
        Me.lblNetMovement.Name = "lblNetMovement"
        Me.lblNetMovement.Size = New System.Drawing.Size(80, 13)
        Me.lblNetMovement.TabIndex = 17
        Me.lblNetMovement.Text = "Net Movement:"
        '
        'pnlFilters
        '
        Me.pnlFilters.Controls.Add(Me.lblFromDate)
        Me.pnlFilters.Controls.Add(Me.dtpFromDate)
        Me.pnlFilters.Controls.Add(Me.lblToDate)
        Me.pnlFilters.Controls.Add(Me.dtpToDate)
        Me.pnlFilters.Controls.Add(Me.lblMovementType)
        Me.pnlFilters.Controls.Add(Me.cboMovementType)
        Me.pnlFilters.Controls.Add(Me.lblProduct)
        Me.pnlFilters.Controls.Add(Me.cboProduct)
        Me.pnlFilters.Controls.Add(Me.btnGenerate)
        Me.pnlFilters.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlFilters.Location = New System.Drawing.Point(0, 0)
        Me.pnlFilters.Name = "pnlFilters"
        Me.pnlFilters.Size = New System.Drawing.Size(800, 100)
        Me.pnlFilters.TabIndex = 18
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnExport)
        Me.pnlButtons.Controls.Add(Me.btnPrint)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 440)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 43)
        Me.pnlButtons.TabIndex = 19
        '
        'pnlSummary
        '
        Me.pnlSummary.Controls.Add(Me.lblTotalIn)
        Me.pnlSummary.Controls.Add(Me.txtTotalIn)
        Me.pnlSummary.Controls.Add(Me.lblTotalOut)
        Me.pnlSummary.Controls.Add(Me.txtTotalOut)
        Me.pnlSummary.Controls.Add(Me.lblNetMovement)
        Me.pnlSummary.Controls.Add(Me.txtNetMovement)
        Me.pnlSummary.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlSummary.Location = New System.Drawing.Point(0, 400)
        Me.pnlSummary.Name = "pnlSummary"
        Me.pnlSummary.Size = New System.Drawing.Size(800, 40)
        Me.pnlSummary.TabIndex = 20
        '
        'StockMovementReportForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 483)
        Me.Controls.Add(Me.dgvMovements)
        Me.Controls.Add(Me.pnlSummary)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlFilters)
        Me.Name = "StockMovementReportForm"
        Me.Text = "Stock Movement Report"
        CType(Me.dgvMovements, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlFilters.ResumeLayout(False)
        Me.pnlFilters.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlSummary.ResumeLayout(False)
        Me.pnlSummary.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents dgvMovements As DataGridView
    Friend WithEvents dtpFromDate As DateTimePicker
    Friend WithEvents dtpToDate As DateTimePicker
    Friend WithEvents cboMovementType As ComboBox
    Friend WithEvents cboProduct As ComboBox
    Friend WithEvents btnGenerate As Button
    Friend WithEvents btnExport As Button
    Friend WithEvents btnPrint As Button
    Friend WithEvents lblFromDate As Label
    Friend WithEvents lblToDate As Label
    Friend WithEvents lblMovementType As Label
    Friend WithEvents lblProduct As Label
    Friend WithEvents txtTotalIn As TextBox
    Friend WithEvents txtTotalOut As TextBox
    Friend WithEvents txtNetMovement As TextBox
    Friend WithEvents lblTotalIn As Label
    Friend WithEvents lblTotalOut As Label
    Friend WithEvents lblNetMovement As Label
    Friend WithEvents pnlFilters As Panel
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents pnlSummary As Panel

End Class

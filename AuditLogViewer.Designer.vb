<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class AuditLogViewer
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents dgvAuditLog As System.Windows.Forms.DataGridView
    Friend WithEvents lblFromDate As System.Windows.Forms.Label
    Friend WithEvents dtpFromDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents lblToDate As System.Windows.Forms.Label
    Friend WithEvents dtpToDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents lblAction As System.Windows.Forms.Label
    Friend WithEvents cboAction As System.Windows.Forms.ComboBox
    Friend WithEvents lblUserFilter As System.Windows.Forms.Label
    Friend WithEvents txtUserFilter As System.Windows.Forms.TextBox
    Friend WithEvents btnFilter As System.Windows.Forms.Button
    Friend WithEvents btnRefresh As System.Windows.Forms.Button
    Friend WithEvents btnExportCSV As System.Windows.Forms.Button
    Friend WithEvents btnExportPDF As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.dgvAuditLog = New System.Windows.Forms.DataGridView()
        Me.lblFromDate = New System.Windows.Forms.Label()
        Me.dtpFromDate = New System.Windows.Forms.DateTimePicker()
        Me.lblToDate = New System.Windows.Forms.Label()
        Me.dtpToDate = New System.Windows.Forms.DateTimePicker()
        Me.lblAction = New System.Windows.Forms.Label()
        Me.cboAction = New System.Windows.Forms.ComboBox()
        Me.lblUserFilter = New System.Windows.Forms.Label()
        Me.txtUserFilter = New System.Windows.Forms.TextBox()
        Me.btnFilter = New System.Windows.Forms.Button()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnExportCSV = New System.Windows.Forms.Button()
        Me.btnExportPDF = New System.Windows.Forms.Button()
        CType(Me.dgvAuditLog, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        
        ' Filter Panel
        Me.lblFromDate.AutoSize = True
        Me.lblFromDate.Location = New System.Drawing.Point(20, 20)
        Me.lblFromDate.Name = "lblFromDate"
        Me.lblFromDate.Size = New System.Drawing.Size(79, 17)
        Me.lblFromDate.TabIndex = 0
        Me.lblFromDate.Text = "From Date:"
        
        Me.dtpFromDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpFromDate.Location = New System.Drawing.Point(105, 17)
        Me.dtpFromDate.Name = "dtpFromDate"
        Me.dtpFromDate.Size = New System.Drawing.Size(120, 22)
        Me.dtpFromDate.TabIndex = 1
        
        Me.lblToDate.AutoSize = True
        Me.lblToDate.Location = New System.Drawing.Point(240, 20)
        Me.lblToDate.Name = "lblToDate"
        Me.lblToDate.Size = New System.Drawing.Size(63, 17)
        Me.lblToDate.TabIndex = 2
        Me.lblToDate.Text = "To Date:"
        
        Me.dtpToDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpToDate.Location = New System.Drawing.Point(309, 17)
        Me.dtpToDate.Name = "dtpToDate"
        Me.dtpToDate.Size = New System.Drawing.Size(120, 22)
        Me.dtpToDate.TabIndex = 3
        
        Me.lblAction.AutoSize = True
        Me.lblAction.Location = New System.Drawing.Point(450, 20)
        Me.lblAction.Name = "lblAction"
        Me.lblAction.Size = New System.Drawing.Size(52, 17)
        Me.lblAction.TabIndex = 4
        Me.lblAction.Text = "Action:"
        
        Me.cboAction.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboAction.FormattingEnabled = True
        Me.cboAction.Location = New System.Drawing.Point(508, 17)
        Me.cboAction.Name = "cboAction"
        Me.cboAction.Size = New System.Drawing.Size(150, 24)
        Me.cboAction.TabIndex = 5
        
        Me.lblUserFilter.AutoSize = True
        Me.lblUserFilter.Location = New System.Drawing.Point(20, 55)
        Me.lblUserFilter.Name = "lblUserFilter"
        Me.lblUserFilter.Size = New System.Drawing.Size(42, 17)
        Me.lblUserFilter.TabIndex = 6
        Me.lblUserFilter.Text = "User:"
        
        Me.txtUserFilter.Location = New System.Drawing.Point(68, 52)
        Me.txtUserFilter.Name = "txtUserFilter"
        Me.txtUserFilter.Size = New System.Drawing.Size(150, 22)
        Me.txtUserFilter.TabIndex = 7
        
        Me.btnFilter.Location = New System.Drawing.Point(240, 50)
        Me.btnFilter.Name = "btnFilter"
        Me.btnFilter.Size = New System.Drawing.Size(80, 26)
        Me.btnFilter.TabIndex = 8
        Me.btnFilter.Text = "Filter"
        Me.btnFilter.UseVisualStyleBackColor = True
        
        Me.btnRefresh.Location = New System.Drawing.Point(330, 50)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(80, 26)
        Me.btnRefresh.TabIndex = 9
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        
        Me.btnExportCSV.Location = New System.Drawing.Point(450, 50)
        Me.btnExportCSV.Name = "btnExportCSV"
        Me.btnExportCSV.Size = New System.Drawing.Size(100, 26)
        Me.btnExportCSV.TabIndex = 10
        Me.btnExportCSV.Text = "Export CSV"
        Me.btnExportCSV.UseVisualStyleBackColor = True
        
        Me.btnExportPDF.Location = New System.Drawing.Point(560, 50)
        Me.btnExportPDF.Name = "btnExportPDF"
        Me.btnExportPDF.Size = New System.Drawing.Size(100, 26)
        Me.btnExportPDF.TabIndex = 11
        Me.btnExportPDF.Text = "Export PDF"
        Me.btnExportPDF.UseVisualStyleBackColor = True
        
        ' DataGridView
        Me.dgvAuditLog.AllowUserToAddRows = False
        Me.dgvAuditLog.AllowUserToDeleteRows = False
        Me.dgvAuditLog.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvAuditLog.Location = New System.Drawing.Point(20, 90)
        Me.dgvAuditLog.Name = "dgvAuditLog"
        Me.dgvAuditLog.ReadOnly = True
        Me.dgvAuditLog.RowTemplate.Height = 24
        Me.dgvAuditLog.Size = New System.Drawing.Size(1000, 450)
        Me.dgvAuditLog.TabIndex = 12
        
        ' AuditLogViewer
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1050, 560)
        Me.Controls.Add(Me.dgvAuditLog)
        Me.Controls.Add(Me.btnExportPDF)
        Me.Controls.Add(Me.btnExportCSV)
        Me.Controls.Add(Me.btnRefresh)
        Me.Controls.Add(Me.btnFilter)
        Me.Controls.Add(Me.txtUserFilter)
        Me.Controls.Add(Me.lblUserFilter)
        Me.Controls.Add(Me.cboAction)
        Me.Controls.Add(Me.lblAction)
        Me.Controls.Add(Me.dtpToDate)
        Me.Controls.Add(Me.lblToDate)
        Me.Controls.Add(Me.dtpFromDate)
        Me.Controls.Add(Me.lblFromDate)
        Me.Name = "AuditLogViewer"
        Me.Text = "Audit Log Viewer"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        CType(Me.dgvAuditLog, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class

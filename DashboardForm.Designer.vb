<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class DashboardForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents pnlDashboardButtons As Panel
    Friend WithEvents btnRetailDashboard As Button
    Friend WithEvents btnManufacturerDashboard As Button
    Friend WithEvents btnStockroomDashboard As Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlDashboardButtons = New System.Windows.Forms.Panel()
        Me.btnRetailDashboard = New System.Windows.Forms.Button()
        Me.btnManufacturerDashboard = New System.Windows.Forms.Button()
        Me.btnStockroomDashboard = New System.Windows.Forms.Button()
        Me.pnlDashboardButtons.SuspendLayout()
        Me.SuspendLayout()
        ' 
        ' pnlDashboardButtons
        ' 
        Me.pnlDashboardButtons.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(73, Byte), Integer), CType(CType(94, Byte), Integer))
        Me.pnlDashboardButtons.Controls.Add(Me.btnStockroomDashboard)
        Me.pnlDashboardButtons.Controls.Add(Me.btnManufacturerDashboard)
        Me.pnlDashboardButtons.Controls.Add(Me.btnRetailDashboard)
        Me.pnlDashboardButtons.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlDashboardButtons.Location = New System.Drawing.Point(0, 0)
        Me.pnlDashboardButtons.Name = "pnlDashboardButtons"
        Me.pnlDashboardButtons.Size = New System.Drawing.Size(1200, 80)
        Me.pnlDashboardButtons.TabIndex = 0
        ' 
        ' btnRetailDashboard
        ' 
        Me.btnRetailDashboard.BackColor = System.Drawing.Color.FromArgb(CType(CType(46, Byte), Integer), CType(CType(204, Byte), Integer), CType(CType(113, Byte), Integer))
        Me.btnRetailDashboard.Dock = System.Windows.Forms.DockStyle.Left
        Me.btnRetailDashboard.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRetailDashboard.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.btnRetailDashboard.ForeColor = System.Drawing.Color.White
        Me.btnRetailDashboard.Location = New System.Drawing.Point(0, 0)
        Me.btnRetailDashboard.Name = "btnRetailDashboard"
        Me.btnRetailDashboard.Size = New System.Drawing.Size(400, 80)
        Me.btnRetailDashboard.TabIndex = 0
        Me.btnRetailDashboard.Text = "RETAIL DASHBOARD"
        Me.btnRetailDashboard.UseVisualStyleBackColor = False
        ' 
        ' btnManufacturerDashboard
        ' 
        Me.btnManufacturerDashboard.BackColor = System.Drawing.Color.FromArgb(CType(CType(241, Byte), Integer), CType(CType(196, Byte), Integer), CType(CType(15, Byte), Integer))
        Me.btnManufacturerDashboard.Dock = System.Windows.Forms.DockStyle.Left
        Me.btnManufacturerDashboard.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnManufacturerDashboard.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.btnManufacturerDashboard.ForeColor = System.Drawing.Color.Black
        Me.btnManufacturerDashboard.Location = New System.Drawing.Point(400, 0)
        Me.btnManufacturerDashboard.Name = "btnManufacturerDashboard"
        Me.btnManufacturerDashboard.Size = New System.Drawing.Size(400, 80)
        Me.btnManufacturerDashboard.TabIndex = 1
        Me.btnManufacturerDashboard.Text = "MANUFACTURER DASHBOARD"
        Me.btnManufacturerDashboard.UseVisualStyleBackColor = False
        ' 
        ' btnStockroomDashboard
        ' 
        Me.btnStockroomDashboard.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnStockroomDashboard.Dock = System.Windows.Forms.DockStyle.Left
        Me.btnStockroomDashboard.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnStockroomDashboard.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.btnStockroomDashboard.ForeColor = System.Drawing.Color.White
        Me.btnStockroomDashboard.Location = New System.Drawing.Point(800, 0)
        Me.btnStockroomDashboard.Name = "btnStockroomDashboard"
        Me.btnStockroomDashboard.Size = New System.Drawing.Size(400, 80)
        Me.btnStockroomDashboard.TabIndex = 2
        Me.btnStockroomDashboard.Text = "STOCKROOM DASHBOARD"
        Me.btnStockroomDashboard.UseVisualStyleBackColor = False
        ' 
        ' DashboardForm
        ' 
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 800)
        Me.Controls.Add(Me.pnlDashboardButtons)
        Me.Name = "DashboardForm"
        Me.Text = "ERP Dashboard - Analytics & Charts"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.pnlDashboardButtons.ResumeLayout(False)
        Me.ResumeLayout(False)
    End Sub
End Class

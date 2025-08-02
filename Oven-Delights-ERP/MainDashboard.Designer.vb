<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class MainDashboard
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
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.AdministratorToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.StockroomToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ManufacturingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RetailToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AccountingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.EcommerceToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ReportingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.BrandingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AdministratorToolStripMenuItem, Me.StockroomToolStripMenuItem, Me.ManufacturingToolStripMenuItem, Me.RetailToolStripMenuItem, Me.AccountingToolStripMenuItem, Me.EcommerceToolStripMenuItem, Me.ReportingToolStripMenuItem, Me.BrandingToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(1200, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'AdministratorToolStripMenuItem
        '
        Me.AdministratorToolStripMenuItem.Name = "AdministratorToolStripMenuItem"
        Me.AdministratorToolStripMenuItem.Size = New System.Drawing.Size(92, 20)
        Me.AdministratorToolStripMenuItem.Text = "Administrator"
        '
        'StockroomToolStripMenuItem
        '
        Me.StockroomToolStripMenuItem.Name = "StockroomToolStripMenuItem"
        Me.StockroomToolStripMenuItem.Size = New System.Drawing.Size(78, 20)
        Me.StockroomToolStripMenuItem.Text = "Stockroom"
        '
        'ManufacturingToolStripMenuItem
        '
        Me.ManufacturingToolStripMenuItem.Name = "ManufacturingToolStripMenuItem"
        Me.ManufacturingToolStripMenuItem.Size = New System.Drawing.Size(101, 20)
        Me.ManufacturingToolStripMenuItem.Text = "Manufacturing"
        '
        'RetailToolStripMenuItem
        '
        Me.RetailToolStripMenuItem.Name = "RetailToolStripMenuItem"
        Me.RetailToolStripMenuItem.Size = New System.Drawing.Size(49, 20)
        Me.RetailToolStripMenuItem.Text = "Retail"
        '
        'AccountingToolStripMenuItem
        '
        Me.AccountingToolStripMenuItem.Name = "AccountingToolStripMenuItem"
        Me.AccountingToolStripMenuItem.Size = New System.Drawing.Size(81, 20)
        Me.AccountingToolStripMenuItem.Text = "Accounting"
        '
        'EcommerceToolStripMenuItem
        '
        Me.EcommerceToolStripMenuItem.Name = "EcommerceToolStripMenuItem"
        Me.EcommerceToolStripMenuItem.Size = New System.Drawing.Size(84, 20)
        Me.EcommerceToolStripMenuItem.Text = "E-commerce"
        '
        'ReportingToolStripMenuItem
        '
        Me.ReportingToolStripMenuItem.Name = "ReportingToolStripMenuItem"
        Me.ReportingToolStripMenuItem.Size = New System.Drawing.Size(71, 20)
        Me.ReportingToolStripMenuItem.Text = "Reporting"
        '
        'BrandingToolStripMenuItem
        '
        Me.BrandingToolStripMenuItem.Name = "BrandingToolStripMenuItem"
        Me.BrandingToolStripMenuItem.Size = New System.Drawing.Size(69, 20)
        Me.BrandingToolStripMenuItem.Text = "Branding"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(38, 20)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'MainDashboard
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 800)
        Me.Controls.Add(Me.MenuStrip1)
        Me.IsMdiContainer = True
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainDashboard"
        Me.Text = "Oven Delights ERP - Main Dashboard"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents MenuStrip1 As MenuStrip
    Friend WithEvents AdministratorToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents StockroomToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ManufacturingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents RetailToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents AccountingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents EcommerceToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ReportingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents BrandingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As ToolStripMenuItem
End Class

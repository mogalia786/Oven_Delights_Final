' MainDashboard.Designer.vb
' UI layout for the main dashboard form
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class MainDashboard
    Inherits System.Windows.Forms.Form
    Private components As System.ComponentModel.IContainer
    
    Friend WithEvents MenuStrip1 As MenuStrip
    Friend WithEvents mnuManufacturing As ToolStripMenuItem
    Friend WithEvents mnuOrders As ToolStripMenuItem
    Friend WithEvents mnuNewOrders As ToolStripMenuItem
    Friend WithEvents mnuReadyOrders As ToolStripMenuItem
    Friend WithEvents mnuAllOrders As ToolStripMenuItem
    
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.mnuManufacturing = New System.Windows.Forms.ToolStripMenuItem()
        Me.mnuOrders = New System.Windows.Forms.ToolStripMenuItem()
        Me.mnuNewOrders = New System.Windows.Forms.ToolStripMenuItem()
        Me.mnuReadyOrders = New System.Windows.Forms.ToolStripMenuItem()
        Me.mnuAllOrders = New System.Windows.Forms.ToolStripMenuItem()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuManufacturing})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(900, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'mnuManufacturing
        '
        Me.mnuManufacturing.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuOrders})
        Me.mnuManufacturing.Name = "mnuManufacturing"
        Me.mnuManufacturing.Size = New System.Drawing.Size(97, 20)
        Me.mnuManufacturing.Text = "Manufacturing"
        '
        'mnuOrders
        '
        Me.mnuOrders.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuNewOrders, Me.mnuReadyOrders, Me.mnuAllOrders})
        Me.mnuOrders.Name = "mnuOrders"
        Me.mnuOrders.Size = New System.Drawing.Size(180, 22)
        Me.mnuOrders.Text = "Orders"
        '
        'mnuNewOrders
        '
        Me.mnuNewOrders.Name = "mnuNewOrders"
        Me.mnuNewOrders.Size = New System.Drawing.Size(180, 22)
        Me.mnuNewOrders.Text = "New Orders"
        '
        'mnuReadyOrders
        '
        Me.mnuReadyOrders.Name = "mnuReadyOrders"
        Me.mnuReadyOrders.Size = New System.Drawing.Size(180, 22)
        Me.mnuReadyOrders.Text = "Ready Orders"
        '
        'mnuAllOrders
        '
        Me.mnuAllOrders.Name = "mnuAllOrders"
        Me.mnuAllOrders.Size = New System.Drawing.Size(180, 22)
        Me.mnuAllOrders.Text = "All Orders"
        ' 
        ' MainDashboard
        ' 
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 600)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "MainDashboard"
        Me.Text = "Oven Delights ERP - Dashboard"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class

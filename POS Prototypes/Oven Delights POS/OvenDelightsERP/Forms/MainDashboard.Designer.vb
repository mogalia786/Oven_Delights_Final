Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainDashboard
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
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainDashboard))
        Me.menuStrip = New System.Windows.Forms.MenuStrip()
        Me.statusStrip = New System.Windows.Forms.StatusStrip()
        Me.panelHeader = New System.Windows.Forms.Panel()
        Me.lblWelcome = New System.Windows.Forms.Label()
        Me.lblUserInfo = New System.Windows.Forms.Label()
        Me.btnLogout = New System.Windows.Forms.Button()
        Me.panelSidebar = New System.Windows.Forms.Panel()
        Me.panelMain = New System.Windows.Forms.Panel()
        Me.panelHeader.SuspendLayout()
        Me.SuspendLayout()
        '
        'menuStrip
        '
        Me.menuStrip.BackColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.menuStrip.Location = New System.Drawing.Point(0, 0)
        Me.menuStrip.Name = "menuStrip"
        Me.menuStrip.Size = New System.Drawing.Size(1280, 24)
        Me.menuStrip.TabIndex = 0
        Me.menuStrip.Text = "MenuStrip1"
        '
        'statusStrip
        '
        Me.statusStrip.BackColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.statusStrip.Location = New System.Drawing.Point(0, 700)
        Me.statusStrip.Name = "statusStrip"
        Me.statusStrip.Size = New System.Drawing.Size(1280, 22)
        Me.statusStrip.TabIndex = 1
        Me.statusStrip.Text = "StatusStrip1"
        '
        'panelHeader
        '
        Me.panelHeader.BackColor = System.Drawing.Color.White
        Me.panelHeader.Controls.Add(Me.lblWelcome)
        Me.panelHeader.Controls.Add(Me.lblUserInfo)
        Me.panelHeader.Controls.Add(Me.btnLogout)
        Me.panelHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.panelHeader.Location = New System.Drawing.Point(0, 24)
        Me.panelHeader.Name = "panelHeader"
        Me.panelHeader.Size = New System.Drawing.Size(1280, 80)
        Me.panelHeader.TabIndex = 2
        '
        'lblWelcome
        '
        Me.lblWelcome.AutoSize = True
        Me.lblWelcome.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblWelcome.ForeColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.lblWelcome.Location = New System.Drawing.Point(30, 15)
        Me.lblWelcome.Name = "lblWelcome"
        Me.lblWelcome.Size = New System.Drawing.Size(0, 32)
        Me.lblWelcome.TabIndex = 0
        '
        'lblUserInfo
        '
        Me.lblUserInfo.AutoSize = True
        Me.lblUserInfo.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.lblUserInfo.ForeColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.lblUserInfo.Location = New System.Drawing.Point(30, 45)
        Me.lblUserInfo.Name = "lblUserInfo"
        Me.lblUserInfo.Size = New System.Drawing.Size(0, 19)
        Me.lblUserInfo.TabIndex = 1
        '
        'btnLogout
        '
        Me.btnLogout.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnLogout.BackColor = System.Drawing.Color.FromArgb(CType(CType(220, Byte), Integer), CType(CType(53, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnLogout.FlatAppearance.BorderSize = 0
        Me.btnLogout.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnLogout.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnLogout.ForeColor = System.Drawing.Color.White
        Me.btnLogout.Location = New System.Drawing.Point(1150, 22)
        Me.btnLogout.Name = "btnLogout"
        Me.btnLogout.Size = New System.Drawing.Size(100, 35)
        Me.btnLogout.TabIndex = 2
        Me.btnLogout.Text = "🚪 Logout"
        Me.btnLogout.UseVisualStyleBackColor = False
        '
        'panelSidebar
        '
        Me.panelSidebar.BackColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.panelSidebar.Dock = System.Windows.Forms.DockStyle.Left
        Me.panelSidebar.Location = New System.Drawing.Point(0, 104)
        Me.panelSidebar.Name = "panelSidebar"
        Me.panelSidebar.Size = New System.Drawing.Size(200, 596)
        Me.panelSidebar.TabIndex = 3
        '
        'panelMain
        '
        Me.panelMain.BackColor = System.Drawing.Color.White
        Me.panelMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.panelMain.Location = New System.Drawing.Point(200, 104)
        Me.panelMain.Name = "panelMain"
        Me.panelMain.Size = New System.Drawing.Size(1080, 596)
        Me.panelMain.TabIndex = 4
        '
        'MainDashboard
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.FromArgb(CType(CType(240, Byte), Integer), CType(CType(244, Byte), Integer), CType(CType(248, Byte), Integer))
        Me.ClientSize = New System.Drawing.Size(1280, 722)
        Me.Controls.Add(Me.panelMain)
        Me.Controls.Add(Me.panelSidebar)
        Me.Controls.Add(Me.panelHeader)
        Me.Controls.Add(Me.statusStrip)
        Me.Controls.Add(Me.menuStrip)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.menuStrip
        Me.Name = "MainDashboard"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Oven Delights ERP - Administrator Dashboard"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.panelHeader.ResumeLayout(False)
        Me.panelHeader.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents menuStrip As MenuStrip
    Friend WithEvents statusStrip As StatusStrip
    Friend WithEvents panelHeader As Panel
    Friend WithEvents lblWelcome As Label
    Friend WithEvents lblUserInfo As Label
    Friend WithEvents btnLogout As Button
    Friend WithEvents panelSidebar As Panel
    Friend WithEvents panelMain As Panel
Friend WithEvents btnUserManagement As Button
Friend WithEvents btnBranchManagement As Button
Friend WithEvents btnAuditLog As Button
Friend WithEvents btnSystemSettings As Button

' Added dashboard controls
Friend WithEvents webBrowserCharts As System.Windows.Forms.WebBrowser
Friend WithEvents btnReports As System.Windows.Forms.Button
Friend WithEvents cardTotalUsers As System.Windows.Forms.Panel
Friend WithEvents cardActiveUsers As System.Windows.Forms.Panel
Friend WithEvents cardTotalBranches As System.Windows.Forms.Panel
Friend WithEvents cardActiveSessions As System.Windows.Forms.Panel
End Class

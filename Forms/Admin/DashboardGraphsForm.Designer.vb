Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class DashboardGraphsForm
    Inherits Form

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

    Friend WithEvents pnlRoot As Panel

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlRoot = New System.Windows.Forms.Panel()
        Me.SuspendLayout()
        '
        'pnlRoot
        '
        Me.pnlRoot.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRoot.Location = New System.Drawing.Point(0, 0)
        Me.pnlRoot.Name = "pnlRoot"
        Me.pnlRoot.Size = New System.Drawing.Size(800, 450)
        Me.pnlRoot.TabIndex = 0
        '
        'DashboardGraphsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.pnlRoot)
        Me.Name = "DashboardGraphsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Dashboard Graphs"
        Me.ResumeLayout(False)

    End Sub
End Class

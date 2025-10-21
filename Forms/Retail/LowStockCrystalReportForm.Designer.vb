Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class LowStockCrystalReportForm
    Inherits Form

    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    Private components As System.ComponentModel.IContainer
    Friend WithEvents pnlHost As Panel

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlHost = New System.Windows.Forms.Panel()
        Me.SuspendLayout()
        '
        'pnlHost
        '
        Me.pnlHost.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlHost.Location = New System.Drawing.Point(0, 0)
        Me.pnlHost.Name = "pnlHost"
        Me.pnlHost.Size = New System.Drawing.Size(900, 600)
        Me.pnlHost.TabIndex = 0
        '
        'LowStockCrystalReportForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 600)
        Me.Controls.Add(Me.pnlHost)
        Me.Name = "LowStockCrystalReportForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Low Stock (Crystal)"
        Me.ResumeLayout(False)
    End Sub
End Class

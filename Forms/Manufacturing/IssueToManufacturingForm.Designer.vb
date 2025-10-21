<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class IssueToManufacturingForm
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
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.btnIssue = New System.Windows.Forms.Button()
        Me.dgvMaterials = New System.Windows.Forms.DataGridView()
        Me.pnlTop.SuspendLayout()
        CType(Me.dgvMaterials, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.FromArgb(CType(CType(183, Byte), Integer), CType(CType(58, Byte), Integer), CType(CType(46, Byte), Integer))
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Controls.Add(Me.btnClose)
        Me.pnlTop.Controls.Add(Me.btnIssue)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1000, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 17)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(280, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Issue Materials to Manufacturing"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(880, 12)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(100, 36)
        Me.btnClose.TabIndex = 2
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'btnIssue
        '
        Me.btnIssue.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnIssue.BackColor = System.Drawing.Color.FromArgb(CType(CType(40, Byte), Integer), CType(CType(167, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnIssue.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnIssue.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnIssue.ForeColor = System.Drawing.Color.White
        Me.btnIssue.Location = New System.Drawing.Point(750, 12)
        Me.btnIssue.Name = "btnIssue"
        Me.btnIssue.Size = New System.Drawing.Size(120, 36)
        Me.btnIssue.TabIndex = 1
        Me.btnIssue.Text = "Issue to Mfg"
        Me.btnIssue.UseVisualStyleBackColor = False
        '
        'dgvMaterials
        '
        Me.dgvMaterials.AllowUserToAddRows = False
        Me.dgvMaterials.AllowUserToDeleteRows = False
        Me.dgvMaterials.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvMaterials.BackgroundColor = System.Drawing.Color.White
        Me.dgvMaterials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvMaterials.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvMaterials.Location = New System.Drawing.Point(0, 60)
        Me.dgvMaterials.Name = "dgvMaterials"
        Me.dgvMaterials.RowTemplate.Height = 25
        Me.dgvMaterials.Size = New System.Drawing.Size(1000, 540)
        Me.dgvMaterials.TabIndex = 1
        '
        'IssueToManufacturingForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1000, 600)
        Me.Controls.Add(Me.dgvMaterials)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "IssueToManufacturingForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Issue to Manufacturing"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        CType(Me.dgvMaterials, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents btnIssue As Button
    Friend WithEvents dgvMaterials As DataGridView
End Class

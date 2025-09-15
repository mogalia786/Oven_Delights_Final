Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BankStatementImportForm
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

    Friend WithEvents btnBrowse As Button
    Friend WithEvents btnValidate As Button
    Friend WithEvents btnApplyRules As Button
    Friend WithEvents btnMap As Button
    Friend WithEvents btnPost As Button
    Friend WithEvents txtFile As TextBox
    Friend WithEvents dgvPreview As DataGridView
    Friend WithEvents chkApproved As CheckBox

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.btnBrowse = New System.Windows.Forms.Button()
        Me.btnValidate = New System.Windows.Forms.Button()
        Me.btnApplyRules = New System.Windows.Forms.Button()
        Me.btnMap = New System.Windows.Forms.Button()
        Me.btnPost = New System.Windows.Forms.Button()
        Me.txtFile = New System.Windows.Forms.TextBox()
        Me.dgvPreview = New System.Windows.Forms.DataGridView()
        Me.chkApproved = New System.Windows.Forms.CheckBox()
        CType(Me.dgvPreview, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'txtFile
        '
        Me.txtFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtFile.Location = New System.Drawing.Point(12, 12)
        Me.txtFile.Name = "txtFile"
        Me.txtFile.ReadOnly = True
        Me.txtFile.Size = New System.Drawing.Size(560, 20)
        Me.txtFile.TabIndex = 0
        '
        'btnBrowse
        '
        Me.btnBrowse.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnBrowse.Location = New System.Drawing.Point(578, 10)
        Me.btnBrowse.Name = "btnBrowse"
        Me.btnBrowse.Size = New System.Drawing.Size(75, 23)
        Me.btnBrowse.TabIndex = 1
        Me.btnBrowse.Text = "Browse"
        Me.btnBrowse.UseVisualStyleBackColor = True
        '
        'btnValidate
        '
        Me.btnValidate.Location = New System.Drawing.Point(12, 45)
        Me.btnValidate.Name = "btnValidate"
        Me.btnValidate.Size = New System.Drawing.Size(75, 23)
        Me.btnValidate.TabIndex = 2
        Me.btnValidate.Text = "Validate"
        Me.btnValidate.UseVisualStyleBackColor = True
        '
        'btnApplyRules
        '
        Me.btnApplyRules.Location = New System.Drawing.Point(93, 45)
        Me.btnApplyRules.Name = "btnApplyRules"
        Me.btnApplyRules.Size = New System.Drawing.Size(90, 23)
        Me.btnApplyRules.TabIndex = 3
        Me.btnApplyRules.Text = "Apply Rules"
        Me.btnApplyRules.UseVisualStyleBackColor = True
        '
        'btnMap
        '
        Me.btnMap.Location = New System.Drawing.Point(189, 45)
        Me.btnMap.Name = "btnMap"
        Me.btnMap.Size = New System.Drawing.Size(110, 23)
        Me.btnMap.TabIndex = 4
        Me.btnMap.Text = "Map to Ledgers"
        Me.btnMap.UseVisualStyleBackColor = True
        '
        'btnPost
        '
        Me.btnPost.Location = New System.Drawing.Point(305, 45)
        Me.btnPost.Name = "btnPost"
        Me.btnPost.Size = New System.Drawing.Size(75, 23)
        Me.btnPost.TabIndex = 5
        Me.btnPost.Text = "Post"
        Me.btnPost.UseVisualStyleBackColor = True
        '
        'dgvPreview
        '
        Me.dgvPreview.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvPreview.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvPreview.Location = New System.Drawing.Point(12, 74)
        Me.dgvPreview.Name = "dgvPreview"
        Me.dgvPreview.Size = New System.Drawing.Size(641, 364)
        Me.dgvPreview.TabIndex = 5

        'chkApproved
        '
        Me.chkApproved.AutoSize = True
        Me.chkApproved.Location = New System.Drawing.Point(400, 49)
        Me.chkApproved.Name = "chkApproved"
        Me.chkApproved.Size = New System.Drawing.Size(152, 17)
        Me.chkApproved.TabIndex = 6
        Me.chkApproved.Text = "Approved by Accountant"
        Me.chkApproved.UseVisualStyleBackColor = True
        '
        'BankStatementImportForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(665, 450)
        Me.Controls.Add(Me.dgvPreview)
        Me.Controls.Add(Me.chkApproved)
        Me.Controls.Add(Me.btnPost)
        Me.Controls.Add(Me.btnMap)
        Me.Controls.Add(Me.btnApplyRules)
        Me.Controls.Add(Me.btnValidate)
        Me.Controls.Add(Me.btnBrowse)
        Me.Controls.Add(Me.txtFile)
        Me.Name = "BankStatementImportForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Bank Statement Import"
        CType(Me.dgvPreview, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
End Class

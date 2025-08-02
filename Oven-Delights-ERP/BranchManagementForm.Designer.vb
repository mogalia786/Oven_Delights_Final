<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BranchManagementForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents dgvBranches As System.Windows.Forms.DataGridView
    Friend WithEvents btnAddBranch As System.Windows.Forms.Button
    Friend WithEvents btnEditBranch As System.Windows.Forms.Button
    Friend WithEvents btnDeleteBranch As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.dgvBranches = New System.Windows.Forms.DataGridView()
        Me.btnAddBranch = New System.Windows.Forms.Button()
        Me.btnEditBranch = New System.Windows.Forms.Button()
        Me.btnDeleteBranch = New System.Windows.Forms.Button()
        CType(Me.dgvBranches, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        ' 
        ' dgvBranches
        ' 
        Me.dgvBranches.AllowUserToAddRows = False
        Me.dgvBranches.AllowUserToDeleteRows = False
        Me.dgvBranches.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvBranches.Location = New System.Drawing.Point(20, 20)
        Me.dgvBranches.Name = "dgvBranches"
        Me.dgvBranches.ReadOnly = True
        Me.dgvBranches.RowTemplate.Height = 24
        Me.dgvBranches.Size = New System.Drawing.Size(700, 350)
        Me.dgvBranches.TabIndex = 0
        ' 
        ' btnAddBranch
        ' 
        Me.btnAddBranch.Location = New System.Drawing.Point(740, 20)
        Me.btnAddBranch.Name = "btnAddBranch"
        Me.btnAddBranch.Size = New System.Drawing.Size(120, 32)
        Me.btnAddBranch.TabIndex = 1
        Me.btnAddBranch.Text = "Add Branch"
        Me.btnAddBranch.UseVisualStyleBackColor = True
        ' 
        ' btnEditBranch
        ' 
        Me.btnEditBranch.Location = New System.Drawing.Point(740, 70)
        Me.btnEditBranch.Name = "btnEditBranch"
        Me.btnEditBranch.Size = New System.Drawing.Size(120, 32)
        Me.btnEditBranch.TabIndex = 2
        Me.btnEditBranch.Text = "Edit Branch"
        Me.btnEditBranch.UseVisualStyleBackColor = True
        ' 
        ' btnDeleteBranch
        ' 
        Me.btnDeleteBranch.Location = New System.Drawing.Point(740, 120)
        Me.btnDeleteBranch.Name = "btnDeleteBranch"
        Me.btnDeleteBranch.Size = New System.Drawing.Size(120, 32)
        Me.btnDeleteBranch.TabIndex = 3
        Me.btnDeleteBranch.Text = "Delete Branch"
        Me.btnDeleteBranch.UseVisualStyleBackColor = True
        ' 
        ' BranchManagementForm
        ' 
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 400)
        Me.Controls.Add(Me.btnDeleteBranch)
        Me.Controls.Add(Me.btnEditBranch)
        Me.Controls.Add(Me.btnAddBranch)
        Me.Controls.Add(Me.dgvBranches)
        Me.Name = "BranchManagementForm"
        Me.Text = "Branch Management"
        CType(Me.dgvBranches, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
    End Sub
End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BranchManagementForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents dgvBranches As System.Windows.Forms.DataGridView
    Friend WithEvents btnAddBranch As System.Windows.Forms.Button
    Friend WithEvents btnEditBranch As System.Windows.Forms.Button
    Friend WithEvents btnDeleteBranch As System.Windows.Forms.Button
    Friend WithEvents btnRefresh As System.Windows.Forms.Button
    Friend WithEvents txtSearch As System.Windows.Forms.TextBox
    Friend WithEvents lblSearch As System.Windows.Forms.Label

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.dgvBranches = New System.Windows.Forms.DataGridView()
        Me.btnAddBranch = New System.Windows.Forms.Button()
        Me.btnEditBranch = New System.Windows.Forms.Button()
        Me.btnDeleteBranch = New System.Windows.Forms.Button()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.txtSearch = New System.Windows.Forms.TextBox()
        Me.lblSearch = New System.Windows.Forms.Label()
        CType(Me.dgvBranches, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        ' 
        ' dgvBranches
        ' 
        Me.dgvBranches.AllowUserToAddRows = False
        Me.dgvBranches.AllowUserToDeleteRows = False
        Me.dgvBranches.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvBranches.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvBranches.Location = New System.Drawing.Point(20, 70)
        Me.dgvBranches.Name = "dgvBranches"
        Me.dgvBranches.ReadOnly = True
        Me.dgvBranches.RowTemplate.Height = 28
        Me.dgvBranches.Size = New System.Drawing.Size(1140, 560)
        Me.dgvBranches.TabIndex = 0
        ' 
        ' btnAddBranch
        ' 
        Me.btnAddBranch.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnAddBranch.Location = New System.Drawing.Point(880, 20)
        Me.btnAddBranch.Name = "btnAddBranch"
        Me.btnAddBranch.Size = New System.Drawing.Size(130, 36)
        Me.btnAddBranch.TabIndex = 1
        Me.btnAddBranch.Text = "Add Branch"
        Me.btnAddBranch.BackColor = System.Drawing.Color.SeaGreen
        Me.btnAddBranch.ForeColor = System.Drawing.Color.White
        Me.btnAddBranch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        ' 
        ' btnEditBranch
        ' 
        Me.btnEditBranch.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnEditBranch.Location = New System.Drawing.Point(1020, 20)
        Me.btnEditBranch.Name = "btnEditBranch"
        Me.btnEditBranch.Size = New System.Drawing.Size(140, 36)
        Me.btnEditBranch.TabIndex = 2
        Me.btnEditBranch.Text = "Edit Branch"
        Me.btnEditBranch.BackColor = System.Drawing.Color.DodgerBlue
        Me.btnEditBranch.ForeColor = System.Drawing.Color.White
        Me.btnEditBranch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        ' 
        ' btnDeleteBranch
        ' 
        Me.btnDeleteBranch.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnDeleteBranch.Location = New System.Drawing.Point(740, 20)
        Me.btnDeleteBranch.Name = "btnDeleteBranch"
        Me.btnDeleteBranch.Size = New System.Drawing.Size(130, 36)
        Me.btnDeleteBranch.TabIndex = 3
        Me.btnDeleteBranch.Text = "Delete Branch"
        Me.btnDeleteBranch.BackColor = System.Drawing.Color.IndianRed
        Me.btnDeleteBranch.ForeColor = System.Drawing.Color.White
        Me.btnDeleteBranch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        ' 
        ' btnRefresh
        ' 
        Me.btnRefresh.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnRefresh.Location = New System.Drawing.Point(20, 20)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(120, 36)
        Me.btnRefresh.TabIndex = 4
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.BackColor = System.Drawing.Color.Gray
        Me.btnRefresh.ForeColor = System.Drawing.Color.White
        Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        ' 
        ' txtSearch
        ' 
        Me.txtSearch.Location = New System.Drawing.Point(160, 26)
        Me.txtSearch.Name = "txtSearch"
        Me.txtSearch.Size = New System.Drawing.Size(300, 22)
        Me.txtSearch.TabIndex = 5
        ' 
        ' lblSearch
        ' 
        Me.lblSearch.AutoSize = True
        Me.lblSearch.Location = New System.Drawing.Point(160, 6)
        Me.lblSearch.Name = "lblSearch"
        Me.lblSearch.Size = New System.Drawing.Size(53, 17)
        Me.lblSearch.TabIndex = 6
        Me.lblSearch.Text = "Search:"
        ' 
        ' BranchManagementForm
        ' 
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1180, 650)
        Me.Controls.Add(Me.lblSearch)
        Me.Controls.Add(Me.txtSearch)
        Me.Controls.Add(Me.btnRefresh)
        Me.Controls.Add(Me.btnDeleteBranch)
        Me.Controls.Add(Me.btnEditBranch)
        Me.Controls.Add(Me.btnAddBranch)
        Me.Controls.Add(Me.dgvBranches)
        Me.Name = "BranchManagementForm"
        Me.Text = "Branch Management"
        CType(Me.dgvBranches, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class UserManagementForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents dgvUsers As System.Windows.Forms.DataGridView
    Friend WithEvents btnAddUser As System.Windows.Forms.Button
    Friend WithEvents btnEditUser As System.Windows.Forms.Button
    Friend WithEvents btnDeleteUser As System.Windows.Forms.Button
    Friend WithEvents txtSearch As System.Windows.Forms.TextBox
    Friend WithEvents btnSearch As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.dgvUsers = New System.Windows.Forms.DataGridView()
        Me.btnAddUser = New System.Windows.Forms.Button()
        Me.btnEditUser = New System.Windows.Forms.Button()
        Me.btnDeleteUser = New System.Windows.Forms.Button()
        Me.txtSearch = New System.Windows.Forms.TextBox()
        Me.btnSearch = New System.Windows.Forms.Button()
        CType(Me.dgvUsers, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        ' 
        ' dgvUsers
        ' 
        Me.dgvUsers.AllowUserToAddRows = False
        Me.dgvUsers.AllowUserToDeleteRows = False
        Me.dgvUsers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvUsers.Location = New System.Drawing.Point(20, 60)
        Me.dgvUsers.Name = "dgvUsers"
        Me.dgvUsers.ReadOnly = True
        Me.dgvUsers.RowTemplate.Height = 24
        Me.dgvUsers.Size = New System.Drawing.Size(700, 350)
        Me.dgvUsers.TabIndex = 0
        ' 
        ' btnAddUser
        ' 
        Me.btnAddUser.Location = New System.Drawing.Point(740, 60)
        Me.btnAddUser.Name = "btnAddUser"
        Me.btnAddUser.Size = New System.Drawing.Size(120, 32)
        Me.btnAddUser.TabIndex = 1
        Me.btnAddUser.Text = "Add User"
        Me.btnAddUser.UseVisualStyleBackColor = True
        ' 
        ' btnEditUser
        ' 
        Me.btnEditUser.Location = New System.Drawing.Point(740, 110)
        Me.btnEditUser.Name = "btnEditUser"
        Me.btnEditUser.Size = New System.Drawing.Size(120, 32)
        Me.btnEditUser.TabIndex = 2
        Me.btnEditUser.Text = "Edit User"
        Me.btnEditUser.UseVisualStyleBackColor = True
        ' 
        ' btnDeleteUser
        ' 
        Me.btnDeleteUser.Location = New System.Drawing.Point(740, 160)
        Me.btnDeleteUser.Name = "btnDeleteUser"
        Me.btnDeleteUser.Size = New System.Drawing.Size(120, 32)
        Me.btnDeleteUser.TabIndex = 3
        Me.btnDeleteUser.Text = "Delete User"
        Me.btnDeleteUser.UseVisualStyleBackColor = True
        ' 
        ' txtSearch
        ' 
        Me.txtSearch.Location = New System.Drawing.Point(20, 20)
        Me.txtSearch.Name = "txtSearch"
        Me.txtSearch.Size = New System.Drawing.Size(300, 22)
        Me.txtSearch.TabIndex = 4
        ' 
        ' btnSearch
        ' 
        Me.btnSearch.Location = New System.Drawing.Point(340, 18)
        Me.btnSearch.Name = "btnSearch"
        Me.btnSearch.Size = New System.Drawing.Size(90, 26)
        Me.btnSearch.TabIndex = 5
        Me.btnSearch.Text = "Search"
        Me.btnSearch.UseVisualStyleBackColor = True
        ' 
        ' UserManagementForm
        ' 
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 450)
        Me.Controls.Add(Me.btnSearch)
        Me.Controls.Add(Me.txtSearch)
        Me.Controls.Add(Me.btnDeleteUser)
        Me.Controls.Add(Me.btnEditUser)
        Me.Controls.Add(Me.btnAddUser)
        Me.Controls.Add(Me.dgvUsers)
        Me.Name = "UserManagementForm"
        Me.Text = "User Management"
        CType(Me.dgvUsers, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class

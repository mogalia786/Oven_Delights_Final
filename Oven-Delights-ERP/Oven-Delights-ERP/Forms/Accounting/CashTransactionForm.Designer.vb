Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class CashTransactionForm
        Inherits System.Windows.Forms.Form

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

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.lblReference = New System.Windows.Forms.Label()
        Me.txtReference = New System.Windows.Forms.TextBox()
        Me.lblPayee = New System.Windows.Forms.Label()
        Me.txtPayee = New System.Windows.Forms.TextBox()
        Me.lblAmount = New System.Windows.Forms.Label()
        Me.nudAmount = New System.Windows.Forms.NumericUpDown()
        Me.lblDescription = New System.Windows.Forms.Label()
        Me.txtDescription = New System.Windows.Forms.TextBox()
        Me.lblCategory = New System.Windows.Forms.Label()
        Me.cboCategory = New System.Windows.Forms.ComboBox()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        CType(Me.nudAmount, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.Navy
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(500, 50)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(199, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Cash Transaction"
        '
        'lblReference
        '
        Me.lblReference.AutoSize = True
        Me.lblReference.Location = New System.Drawing.Point(20, 70)
        Me.lblReference.Name = "lblReference"
        Me.lblReference.Size = New System.Drawing.Size(92, 15)
        Me.lblReference.TabIndex = 1
        Me.lblReference.Text = "Reference No:"
        '
        'txtReference
        '
        Me.txtReference.Location = New System.Drawing.Point(150, 67)
        Me.txtReference.Name = "txtReference"
        Me.txtReference.ReadOnly = True
        Me.txtReference.Size = New System.Drawing.Size(150, 23)
        Me.txtReference.TabIndex = 2
        '
        'lblPayee
        '
        Me.lblPayee.AutoSize = True
        Me.lblPayee.Location = New System.Drawing.Point(20, 110)
        Me.lblPayee.Name = "lblPayee"
        Me.lblPayee.Size = New System.Drawing.Size(42, 15)
        Me.lblPayee.TabIndex = 3
        Me.lblPayee.Text = "Payee:"
        '
        'txtPayee
        '
        Me.txtPayee.Location = New System.Drawing.Point(150, 107)
        Me.txtPayee.Name = "txtPayee"
        Me.txtPayee.Size = New System.Drawing.Size(320, 23)
        Me.txtPayee.TabIndex = 4
        '
        'lblAmount
        '
        Me.lblAmount.AutoSize = True
        Me.lblAmount.Location = New System.Drawing.Point(20, 150)
        Me.lblAmount.Name = "lblAmount"
        Me.lblAmount.Size = New System.Drawing.Size(54, 15)
        Me.lblAmount.TabIndex = 5
        Me.lblAmount.Text = "Amount:"
        '
        'nudAmount
        '
        Me.nudAmount.DecimalPlaces = 2
        Me.nudAmount.Location = New System.Drawing.Point(150, 148)
        Me.nudAmount.Maximum = New Decimal(New Integer() {1000000, 0, 0, 0})
        Me.nudAmount.Name = "nudAmount"
        Me.nudAmount.Size = New System.Drawing.Size(150, 23)
        Me.nudAmount.TabIndex = 6
        Me.nudAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        Me.nudAmount.ThousandsSeparator = True
        '
        'lblDescription
        '
        Me.lblDescription.AutoSize = True
        Me.lblDescription.Location = New System.Drawing.Point(20, 190)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.Size = New System.Drawing.Size(70, 15)
        Me.lblDescription.TabIndex = 7
        Me.lblDescription.Text = "Description:"
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(150, 187)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.Size = New System.Drawing.Size(320, 60)
        Me.txtDescription.TabIndex = 8
        '
        'lblCategory
        '
        Me.lblCategory.AutoSize = True
        Me.lblCategory.Location = New System.Drawing.Point(20, 270)
        Me.lblCategory.Name = "lblCategory"
        Me.lblCategory.Size = New System.Drawing.Size(58, 15)
        Me.lblCategory.TabIndex = 9
        Me.lblCategory.Text = "Category:"
        '
        'cboCategory
        '
        Me.cboCategory.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCategory.FormattingEnabled = True
        Me.cboCategory.Location = New System.Drawing.Point(150, 267)
        Me.cboCategory.Name = "cboCategory"
        Me.cboCategory.Size = New System.Drawing.Size(320, 23)
        Me.cboCategory.TabIndex = 10
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(20, 310)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(41, 15)
        Me.lblNotes.TabIndex = 11
        Me.lblNotes.Text = "Notes:"
        '
        'txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(150, 307)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.Size = New System.Drawing.Size(320, 60)
        Me.txtNotes.TabIndex = 12
        '
        'btnSave
        '
        Me.btnSave.BackColor = System.Drawing.Color.Green
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(150, 390)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(150, 40)
        Me.btnSave.TabIndex = 13
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.Color.Gray
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCancel.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnCancel.ForeColor = System.Drawing.Color.White
        Me.btnCancel.Location = New System.Drawing.Point(320, 390)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(150, 40)
        Me.btnCancel.TabIndex = 14
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'CashTransactionForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(500, 450)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.txtNotes)
        Me.Controls.Add(Me.lblNotes)
        Me.Controls.Add(Me.cboCategory)
        Me.Controls.Add(Me.lblCategory)
        Me.Controls.Add(Me.txtDescription)
        Me.Controls.Add(Me.lblDescription)
        Me.Controls.Add(Me.nudAmount)
        Me.Controls.Add(Me.lblAmount)
        Me.Controls.Add(Me.txtPayee)
        Me.Controls.Add(Me.lblPayee)
        Me.Controls.Add(Me.txtReference)
        Me.Controls.Add(Me.lblReference)
        Me.Controls.Add(Me.pnlTop)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CashTransactionForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Cash Transaction"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        CType(Me.nudAmount, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents lblReference As Label
    Friend WithEvents txtReference As TextBox
    Friend WithEvents lblPayee As Label
    Friend WithEvents txtPayee As TextBox
    Friend WithEvents lblAmount As Label
    Friend WithEvents nudAmount As NumericUpDown
    Friend WithEvents lblDescription As Label
    Friend WithEvents txtDescription As TextBox
    Friend WithEvents lblCategory As Label
    Friend WithEvents cboCategory As ComboBox
    Friend WithEvents lblNotes As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    End Class
End Namespace

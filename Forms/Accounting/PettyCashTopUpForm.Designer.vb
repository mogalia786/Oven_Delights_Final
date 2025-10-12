Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class PettyCashTopUpForm
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
            Me.lblCurrentBalance = New System.Windows.Forms.Label()
            Me.lblAmount = New System.Windows.Forms.Label()
            Me.nudAmount = New System.Windows.Forms.NumericUpDown()
            Me.lblReason = New System.Windows.Forms.Label()
            Me.txtReason = New System.Windows.Forms.TextBox()
            Me.lblNote = New System.Windows.Forms.Label()
            Me.btnTopUp = New System.Windows.Forms.Button()
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
            Me.pnlTop.Size = New System.Drawing.Size(450, 50)
            Me.pnlTop.TabIndex = 0
            '
            'lblTitle
            '
            Me.lblTitle.AutoSize = True
            Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
            Me.lblTitle.ForeColor = System.Drawing.Color.White
            Me.lblTitle.Location = New System.Drawing.Point(12, 12)
            Me.lblTitle.Name = "lblTitle"
            Me.lblTitle.Size = New System.Drawing.Size(174, 25)
            Me.lblTitle.TabIndex = 0
            Me.lblTitle.Text = "Petty Cash Top Up"
            '
            'lblCurrentBalance
            '
            Me.lblCurrentBalance.AutoSize = True
            Me.lblCurrentBalance.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblCurrentBalance.Location = New System.Drawing.Point(20, 70)
            Me.lblCurrentBalance.Name = "lblCurrentBalance"
            Me.lblCurrentBalance.Size = New System.Drawing.Size(223, 19)
            Me.lblCurrentBalance.TabIndex = 1
            Me.lblCurrentBalance.Text = "Current Petty Cash Balance: R 0"
            '
            'lblAmount
            '
            Me.lblAmount.AutoSize = True
            Me.lblAmount.Location = New System.Drawing.Point(20, 110)
            Me.lblAmount.Name = "lblAmount"
            Me.lblAmount.Size = New System.Drawing.Size(92, 15)
            Me.lblAmount.TabIndex = 2
            Me.lblAmount.Text = "Top Up Amount:"
            '
            'nudAmount
            '
            Me.nudAmount.DecimalPlaces = 2
            Me.nudAmount.Location = New System.Drawing.Point(150, 108)
            Me.nudAmount.Maximum = New Decimal(New Integer() {10000, 0, 0, 0})
            Me.nudAmount.Name = "nudAmount"
            Me.nudAmount.Size = New System.Drawing.Size(150, 23)
            Me.nudAmount.TabIndex = 3
            Me.nudAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
            Me.nudAmount.ThousandsSeparator = True
            '
            'lblReason
            '
            Me.lblReason.AutoSize = True
            Me.lblReason.Location = New System.Drawing.Point(20, 150)
            Me.lblReason.Name = "lblReason"
            Me.lblReason.Size = New System.Drawing.Size(47, 15)
            Me.lblReason.TabIndex = 4
            Me.lblReason.Text = "Reason:"
            '
            'txtReason
            '
            Me.txtReason.Location = New System.Drawing.Point(20, 168)
            Me.txtReason.Multiline = True
            Me.txtReason.Name = "txtReason"
            Me.txtReason.Size = New System.Drawing.Size(410, 80)
            Me.txtReason.TabIndex = 5
            '
            'lblNote
            '
            Me.lblNote.AutoSize = True
            Me.lblNote.ForeColor = System.Drawing.Color.Gray
            Me.lblNote.Location = New System.Drawing.Point(20, 255)
            Me.lblNote.Name = "lblNote"
            Me.lblNote.Size = New System.Drawing.Size(350, 15)
            Me.lblNote.TabIndex = 6
            Me.lblNote.Text = "This will transfer cash from Main Cash Book to Petty Cash Book."
            '
            'btnTopUp
            '
            Me.btnTopUp.BackColor = System.Drawing.Color.Green
            Me.btnTopUp.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnTopUp.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnTopUp.ForeColor = System.Drawing.Color.White
            Me.btnTopUp.Location = New System.Drawing.Point(150, 290)
            Me.btnTopUp.Name = "btnTopUp"
            Me.btnTopUp.Size = New System.Drawing.Size(120, 35)
            Me.btnTopUp.TabIndex = 7
            Me.btnTopUp.Text = "Top Up"
            Me.btnTopUp.UseVisualStyleBackColor = False
            '
            'btnCancel
            '
            Me.btnCancel.BackColor = System.Drawing.Color.Gray
            Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnCancel.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnCancel.ForeColor = System.Drawing.Color.White
            Me.btnCancel.Location = New System.Drawing.Point(290, 290)
            Me.btnCancel.Name = "btnCancel"
            Me.btnCancel.Size = New System.Drawing.Size(120, 35)
            Me.btnCancel.TabIndex = 8
            Me.btnCancel.Text = "Cancel"
            Me.btnCancel.UseVisualStyleBackColor = False
            '
            'PettyCashTopUpForm
            '
            Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
            Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
            Me.ClientSize = New System.Drawing.Size(450, 340)
            Me.Controls.Add(Me.btnCancel)
            Me.Controls.Add(Me.btnTopUp)
            Me.Controls.Add(Me.lblNote)
            Me.Controls.Add(Me.txtReason)
            Me.Controls.Add(Me.lblReason)
            Me.Controls.Add(Me.nudAmount)
            Me.Controls.Add(Me.lblAmount)
            Me.Controls.Add(Me.lblCurrentBalance)
            Me.Controls.Add(Me.pnlTop)
            Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.Name = "PettyCashTopUpForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
            Me.Text = "Petty Cash Top Up"
            Me.pnlTop.ResumeLayout(False)
            Me.pnlTop.PerformLayout()
            CType(Me.nudAmount, System.ComponentModel.ISupportInitialize).EndInit()
            Me.ResumeLayout(False)
            Me.PerformLayout()

        End Sub

        Friend WithEvents pnlTop As Panel
        Friend WithEvents lblTitle As Label
        Friend WithEvents lblCurrentBalance As Label
        Friend WithEvents lblAmount As Label
        Friend WithEvents nudAmount As NumericUpDown
        Friend WithEvents lblReason As Label
        Friend WithEvents txtReason As TextBox
        Friend WithEvents lblNote As Label
        Friend WithEvents btnTopUp As Button
        Friend WithEvents btnCancel As Button
    End Class
End Namespace

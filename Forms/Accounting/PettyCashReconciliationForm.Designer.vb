Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class PettyCashReconciliationForm
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
            Me.grpExpected = New System.Windows.Forms.GroupBox()
            Me.lblOpeningFloat = New System.Windows.Forms.Label()
            Me.lblTotalExpenses = New System.Windows.Forms.Label()
            Me.lblExpectedCash = New System.Windows.Forms.Label()
            Me.lblActualCash = New System.Windows.Forms.Label()
            Me.nudActualCash = New System.Windows.Forms.NumericUpDown()
            Me.lblNote = New System.Windows.Forms.Label()
            Me.lblVariance = New System.Windows.Forms.Label()
            Me.pnlVarianceReason = New System.Windows.Forms.Panel()
            Me.lblVarianceNote = New System.Windows.Forms.Label()
            Me.txtVarianceReason = New System.Windows.Forms.TextBox()
            Me.btnSave = New System.Windows.Forms.Button()
            Me.btnCancel = New System.Windows.Forms.Button()
            Me.pnlTop.SuspendLayout()
            Me.grpExpected.SuspendLayout()
            CType(Me.nudActualCash, System.ComponentModel.ISupportInitialize).BeginInit()
            Me.pnlVarianceReason.SuspendLayout()
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
            Me.lblTitle.Size = New System.Drawing.Size(265, 25)
            Me.lblTitle.TabIndex = 0
            Me.lblTitle.Text = "Petty Cash Reconciliation"
            '
            'grpExpected
            '
            Me.grpExpected.Controls.Add(Me.lblOpeningFloat)
            Me.grpExpected.Controls.Add(Me.lblTotalExpenses)
            Me.grpExpected.Controls.Add(Me.lblExpectedCash)
            Me.grpExpected.Location = New System.Drawing.Point(20, 70)
            Me.grpExpected.Name = "grpExpected"
            Me.grpExpected.Size = New System.Drawing.Size(460, 100)
            Me.grpExpected.TabIndex = 1
            Me.grpExpected.TabStop = False
            Me.grpExpected.Text = "Expected Balance"
            '
            'lblOpeningFloat
            '
            Me.lblOpeningFloat.AutoSize = True
            Me.lblOpeningFloat.Location = New System.Drawing.Point(10, 25)
            Me.lblOpeningFloat.Name = "lblOpeningFloat"
            Me.lblOpeningFloat.Size = New System.Drawing.Size(122, 15)
            Me.lblOpeningFloat.TabIndex = 0
            Me.lblOpeningFloat.Text = "Opening Float: R 0.00"
            '
            'lblTotalExpenses
            '
            Me.lblTotalExpenses.AutoSize = True
            Me.lblTotalExpenses.Location = New System.Drawing.Point(10, 50)
            Me.lblTotalExpenses.Name = "lblTotalExpenses"
            Me.lblTotalExpenses.Size = New System.Drawing.Size(155, 15)
            Me.lblTotalExpenses.TabIndex = 1
            Me.lblTotalExpenses.Text = "Less: Total Expenses: R 0.00"
            '
            'lblExpectedCash
            '
            Me.lblExpectedCash.AutoSize = True
            Me.lblExpectedCash.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblExpectedCash.Location = New System.Drawing.Point(10, 75)
            Me.lblExpectedCash.Name = "lblExpectedCash"
            Me.lblExpectedCash.Size = New System.Drawing.Size(152, 19)
            Me.lblExpectedCash.TabIndex = 2
            Me.lblExpectedCash.Text = "Expected Cash: R 0.00"
            '
            'lblActualCash
            '
            Me.lblActualCash.AutoSize = True
            Me.lblActualCash.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblActualCash.Location = New System.Drawing.Point(20, 190)
            Me.lblActualCash.Name = "lblActualCash"
            Me.lblActualCash.Size = New System.Drawing.Size(187, 19)
            Me.lblActualCash.TabIndex = 2
            Me.lblActualCash.Text = "Actual Cash Counted (R):"
            '
            'nudActualCash
            '
            Me.nudActualCash.DecimalPlaces = 2
            Me.nudActualCash.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
            Me.nudActualCash.Location = New System.Drawing.Point(220, 186)
            Me.nudActualCash.Maximum = New Decimal(New Integer() {100000, 0, 0, 0})
            Me.nudActualCash.Name = "nudActualCash"
            Me.nudActualCash.Size = New System.Drawing.Size(150, 29)
            Me.nudActualCash.TabIndex = 3
            Me.nudActualCash.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
            Me.nudActualCash.ThousandsSeparator = True
            '
            'lblNote
            '
            Me.lblNote.AutoSize = True
            Me.lblNote.ForeColor = System.Drawing.Color.Gray
            Me.lblNote.Location = New System.Drawing.Point(20, 220)
            Me.lblNote.Name = "lblNote"
            Me.lblNote.Size = New System.Drawing.Size(350, 15)
            Me.lblNote.TabIndex = 4
            Me.lblNote.Text = "Count all cash remaining + verify all vouchers have receipts"
            '
            'lblVariance
            '
            Me.lblVariance.AutoSize = True
            Me.lblVariance.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
            Me.lblVariance.Location = New System.Drawing.Point(20, 250)
            Me.lblVariance.Name = "lblVariance"
            Me.lblVariance.Size = New System.Drawing.Size(119, 20)
            Me.lblVariance.TabIndex = 5
            Me.lblVariance.Text = "Variance: R 0.00"
            '
            'pnlVarianceReason
            '
            Me.pnlVarianceReason.Controls.Add(Me.lblVarianceNote)
            Me.pnlVarianceReason.Controls.Add(Me.txtVarianceReason)
            Me.pnlVarianceReason.Location = New System.Drawing.Point(20, 280)
            Me.pnlVarianceReason.Name = "pnlVarianceReason"
            Me.pnlVarianceReason.Size = New System.Drawing.Size(460, 120)
            Me.pnlVarianceReason.TabIndex = 6
            Me.pnlVarianceReason.Visible = False
            '
            'lblVarianceNote
            '
            Me.lblVarianceNote.AutoSize = True
            Me.lblVarianceNote.Location = New System.Drawing.Point(3, 5)
            Me.lblVarianceNote.Name = "lblVarianceNote"
            Me.lblVarianceNote.Size = New System.Drawing.Size(116, 15)
            Me.lblVarianceNote.TabIndex = 0
            Me.lblVarianceNote.Text = "Reason (Mandatory):"
            '
            'txtVarianceReason
            '
            Me.txtVarianceReason.Location = New System.Drawing.Point(3, 25)
            Me.txtVarianceReason.Multiline = True
            Me.txtVarianceReason.Name = "txtVarianceReason"
            Me.txtVarianceReason.Size = New System.Drawing.Size(450, 90)
            Me.txtVarianceReason.TabIndex = 1
            '
            'btnSave
            '
            Me.btnSave.BackColor = System.Drawing.Color.Green
            Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnSave.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnSave.ForeColor = System.Drawing.Color.White
            Me.btnSave.Location = New System.Drawing.Point(200, 420)
            Me.btnSave.Name = "btnSave"
            Me.btnSave.Size = New System.Drawing.Size(130, 35)
            Me.btnSave.TabIndex = 7
            Me.btnSave.Text = "Save && Close"
            Me.btnSave.UseVisualStyleBackColor = False
            '
            'btnCancel
            '
            Me.btnCancel.BackColor = System.Drawing.Color.Gray
            Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnCancel.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnCancel.ForeColor = System.Drawing.Color.White
            Me.btnCancel.Location = New System.Drawing.Point(350, 420)
            Me.btnCancel.Name = "btnCancel"
            Me.btnCancel.Size = New System.Drawing.Size(130, 35)
            Me.btnCancel.TabIndex = 8
            Me.btnCancel.Text = "Cancel"
            Me.btnCancel.UseVisualStyleBackColor = False
            '
            'PettyCashReconciliationForm
            '
            Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
            Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
            Me.ClientSize = New System.Drawing.Size(500, 470)
            Me.Controls.Add(Me.btnCancel)
            Me.Controls.Add(Me.btnSave)
            Me.Controls.Add(Me.pnlVarianceReason)
            Me.Controls.Add(Me.lblVariance)
            Me.Controls.Add(Me.lblNote)
            Me.Controls.Add(Me.nudActualCash)
            Me.Controls.Add(Me.lblActualCash)
            Me.Controls.Add(Me.grpExpected)
            Me.Controls.Add(Me.pnlTop)
            Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.Name = "PettyCashReconciliationForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
            Me.Text = "Petty Cash Reconciliation"
            Me.pnlTop.ResumeLayout(False)
            Me.pnlTop.PerformLayout()
            Me.grpExpected.ResumeLayout(False)
            Me.grpExpected.PerformLayout()
            CType(Me.nudActualCash, System.ComponentModel.ISupportInitialize).EndInit()
            Me.pnlVarianceReason.ResumeLayout(False)
            Me.pnlVarianceReason.PerformLayout()
            Me.ResumeLayout(False)
            Me.PerformLayout()

        End Sub

        Friend WithEvents pnlTop As Panel
        Friend WithEvents lblTitle As Label
        Friend WithEvents grpExpected As GroupBox
        Friend WithEvents lblOpeningFloat As Label
        Friend WithEvents lblTotalExpenses As Label
        Friend WithEvents lblExpectedCash As Label
        Friend WithEvents lblActualCash As Label
        Friend WithEvents nudActualCash As NumericUpDown
        Friend WithEvents lblNote As Label
        Friend WithEvents lblVariance As Label
        Friend WithEvents pnlVarianceReason As Panel
        Friend WithEvents lblVarianceNote As Label
        Friend WithEvents txtVarianceReason As TextBox
        Friend WithEvents btnSave As Button
        Friend WithEvents btnCancel As Button
    End Class
End Namespace

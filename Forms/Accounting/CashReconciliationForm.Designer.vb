Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class CashReconciliationForm
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
        Me.lblOpeningBalance = New System.Windows.Forms.Label()
        Me.lblTotalReceipts = New System.Windows.Forms.Label()
        Me.lblTotalPayments = New System.Windows.Forms.Label()
        Me.lblExpectedClosing = New System.Windows.Forms.Label()
        Me.grpPhysicalCount = New System.Windows.Forms.GroupBox()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.nud200 = New System.Windows.Forms.NumericUpDown()
        Me.lblR200 = New System.Windows.Forms.Label()
        Me.nud100 = New System.Windows.Forms.NumericUpDown()
        Me.lblR100 = New System.Windows.Forms.Label()
        Me.nud50 = New System.Windows.Forms.NumericUpDown()
        Me.lblR50 = New System.Windows.Forms.Label()
        Me.nud20 = New System.Windows.Forms.NumericUpDown()
        Me.lblR20 = New System.Windows.Forms.Label()
        Me.nud10 = New System.Windows.Forms.NumericUpDown()
        Me.lblR10 = New System.Windows.Forms.Label()
        Me.lblCoins = New System.Windows.Forms.Label()
        Me.nud5 = New System.Windows.Forms.NumericUpDown()
        Me.lblR5 = New System.Windows.Forms.Label()
        Me.nud2 = New System.Windows.Forms.NumericUpDown()
        Me.lblR2 = New System.Windows.Forms.Label()
        Me.nud1 = New System.Windows.Forms.NumericUpDown()
        Me.lblR1 = New System.Windows.Forms.Label()
        Me.nud50c = New System.Windows.Forms.NumericUpDown()
        Me.lbl50c = New System.Windows.Forms.Label()
        Me.nud20c = New System.Windows.Forms.NumericUpDown()
        Me.lbl20c = New System.Windows.Forms.Label()
        Me.nud10c = New System.Windows.Forms.NumericUpDown()
        Me.lbl10c = New System.Windows.Forms.Label()
        Me.lblPhysicalCount = New System.Windows.Forms.Label()
        Me.lblVariance = New System.Windows.Forms.Label()
        Me.pnlVarianceReason = New System.Windows.Forms.Panel()
        Me.lblVarianceNote = New System.Windows.Forms.Label()
        Me.txtVarianceReason = New System.Windows.Forms.TextBox()
        Me.chkManagerApproval = New System.Windows.Forms.CheckBox()
        Me.lblManagerNote = New System.Windows.Forms.Label()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        Me.grpExpected.SuspendLayout()
        Me.grpPhysicalCount.SuspendLayout()
        CType(Me.nud200, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud100, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud50, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud20, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud10, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud5, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud50c, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud20c, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud10c, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.pnlTop.Size = New System.Drawing.Size(700, 50)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(198, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Cash Reconciliation"
        '
        'grpExpected
        '
        Me.grpExpected.Controls.Add(Me.lblOpeningBalance)
        Me.grpExpected.Controls.Add(Me.lblTotalReceipts)
        Me.grpExpected.Controls.Add(Me.lblTotalPayments)
        Me.grpExpected.Controls.Add(Me.lblExpectedClosing)
        Me.grpExpected.Location = New System.Drawing.Point(12, 60)
        Me.grpExpected.Name = "grpExpected"
        Me.grpExpected.Size = New System.Drawing.Size(330, 140)
        Me.grpExpected.TabIndex = 1
        Me.grpExpected.TabStop = False
        Me.grpExpected.Text = "Expected Balance"
        '
        'lblOpeningBalance
        '
        Me.lblOpeningBalance.AutoSize = True
        Me.lblOpeningBalance.Location = New System.Drawing.Point(10, 25)
        Me.lblOpeningBalance.Name = "lblOpeningBalance"
        Me.lblOpeningBalance.Size = New System.Drawing.Size(130, 15)
        Me.lblOpeningBalance.TabIndex = 0
        Me.lblOpeningBalance.Text = "Opening Balance: R 0.00"
        '
        'lblTotalReceipts
        '
        Me.lblTotalReceipts.AutoSize = True
        Me.lblTotalReceipts.Location = New System.Drawing.Point(10, 50)
        Me.lblTotalReceipts.Name = "lblTotalReceipts"
        Me.lblTotalReceipts.Size = New System.Drawing.Size(141, 15)
        Me.lblTotalReceipts.TabIndex = 1
        Me.lblTotalReceipts.Text = "Add: Total Receipts: R 0.00"
        '
        'lblTotalPayments
        '
        Me.lblTotalPayments.AutoSize = True
        Me.lblTotalPayments.Location = New System.Drawing.Point(10, 75)
        Me.lblTotalPayments.Name = "lblTotalPayments"
        Me.lblTotalPayments.Size = New System.Drawing.Size(150, 15)
        Me.lblTotalPayments.TabIndex = 2
        Me.lblTotalPayments.Text = "Less: Total Payments: R 0.00"
        '
        'lblExpectedClosing
        '
        Me.lblExpectedClosing.AutoSize = True
        Me.lblExpectedClosing.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblExpectedClosing.Location = New System.Drawing.Point(10, 105)
        Me.lblExpectedClosing.Name = "lblExpectedClosing"
        Me.lblExpectedClosing.Size = New System.Drawing.Size(177, 20)
        Me.lblExpectedClosing.TabIndex = 3
        Me.lblExpectedClosing.Text = "Expected Closing: R 0.00"
        '
        'grpPhysicalCount
        '
        Me.grpPhysicalCount.Controls.Add(Me.lblNotes)
        Me.grpPhysicalCount.Controls.Add(Me.nud200)
        Me.grpPhysicalCount.Controls.Add(Me.lblR200)
        Me.grpPhysicalCount.Controls.Add(Me.nud100)
        Me.grpPhysicalCount.Controls.Add(Me.lblR100)
        Me.grpPhysicalCount.Controls.Add(Me.nud50)
        Me.grpPhysicalCount.Controls.Add(Me.lblR50)
        Me.grpPhysicalCount.Controls.Add(Me.nud20)
        Me.grpPhysicalCount.Controls.Add(Me.lblR20)
        Me.grpPhysicalCount.Controls.Add(Me.nud10)
        Me.grpPhysicalCount.Controls.Add(Me.lblR10)
        Me.grpPhysicalCount.Controls.Add(Me.lblCoins)
        Me.grpPhysicalCount.Controls.Add(Me.nud5)
        Me.grpPhysicalCount.Controls.Add(Me.lblR5)
        Me.grpPhysicalCount.Controls.Add(Me.nud2)
        Me.grpPhysicalCount.Controls.Add(Me.lblR2)
        Me.grpPhysicalCount.Controls.Add(Me.nud1)
        Me.grpPhysicalCount.Controls.Add(Me.lblR1)
        Me.grpPhysicalCount.Controls.Add(Me.nud50c)
        Me.grpPhysicalCount.Controls.Add(Me.lbl50c)
        Me.grpPhysicalCount.Controls.Add(Me.nud20c)
        Me.grpPhysicalCount.Controls.Add(Me.lbl20c)
        Me.grpPhysicalCount.Controls.Add(Me.nud10c)
        Me.grpPhysicalCount.Controls.Add(Me.lbl10c)
        Me.grpPhysicalCount.Controls.Add(Me.lblPhysicalCount)
        Me.grpPhysicalCount.Location = New System.Drawing.Point(358, 60)
        Me.grpPhysicalCount.Name = "grpPhysicalCount"
        Me.grpPhysicalCount.Size = New System.Drawing.Size(330, 380)
        Me.grpPhysicalCount.TabIndex = 2
        Me.grpPhysicalCount.TabStop = False
        Me.grpPhysicalCount.Text = "Physical Count"
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblNotes.Location = New System.Drawing.Point(10, 25)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(44, 15)
        Me.lblNotes.TabIndex = 0
        Me.lblNotes.Text = "NOTES"
        '
        'nud200
        Me.nud200.Location = New System.Drawing.Point(80, 45)
        Me.nud200.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud200.Name = "nud200"
        Me.nud200.Size = New System.Drawing.Size(60, 23)
        Me.nud200.TabIndex = 1
        '
        'lblR200
        '
        Me.lblR200.AutoSize = True
        Me.lblR200.Location = New System.Drawing.Point(10, 47)
        Me.lblR200.Name = "lblR200"
        Me.lblR200.Size = New System.Drawing.Size(60, 15)
        Me.lblR200.TabIndex = 2
        Me.lblR200.Text = "R200 x"
        '
        'nud100
        Me.nud100.Location = New System.Drawing.Point(80, 70)
        Me.nud100.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud100.Name = "nud100"
        Me.nud100.Size = New System.Drawing.Size(60, 23)
        Me.nud100.TabIndex = 3
        '
        'lblR100
        Me.lblR100.AutoSize = True
        Me.lblR100.Location = New System.Drawing.Point(10, 72)
        Me.lblR100.Name = "lblR100"
        Me.lblR100.Text = "R100 x"
        '
        'nud50
        Me.nud50.Location = New System.Drawing.Point(80, 95)
        Me.nud50.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud50.Name = "nud50"
        Me.nud50.Size = New System.Drawing.Size(60, 23)
        Me.nud50.TabIndex = 4
        '
        'lblR50
        Me.lblR50.AutoSize = True
        Me.lblR50.Location = New System.Drawing.Point(10, 97)
        Me.lblR50.Name = "lblR50"
        Me.lblR50.Text = "R50 x"
        '
        'nud20
        Me.nud20.Location = New System.Drawing.Point(80, 120)
        Me.nud20.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud20.Name = "nud20"
        Me.nud20.Size = New System.Drawing.Size(60, 23)
        Me.nud20.TabIndex = 5
        '
        'lblR20
        Me.lblR20.AutoSize = True
        Me.lblR20.Location = New System.Drawing.Point(10, 122)
        Me.lblR20.Name = "lblR20"
        Me.lblR20.Text = "R20 x"
        '
        'nud10
        Me.nud10.Location = New System.Drawing.Point(80, 145)
        Me.nud10.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud10.Name = "nud10"
        Me.nud10.Size = New System.Drawing.Size(60, 23)
        Me.nud10.TabIndex = 6
        '
        'lblR10
        Me.lblR10.AutoSize = True
        Me.lblR10.Location = New System.Drawing.Point(10, 147)
        Me.lblR10.Name = "lblR10"
        Me.lblR10.Text = "R10 x"
        '
        'lblCoins
        Me.lblCoins.AutoSize = True
        Me.lblCoins.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblCoins.Location = New System.Drawing.Point(10, 180)
        Me.lblCoins.Name = "lblCoins"
        Me.lblCoins.Text = "COINS"
        '
        'nud5
        Me.nud5.Location = New System.Drawing.Point(80, 200)
        Me.nud5.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud5.Name = "nud5"
        Me.nud5.Size = New System.Drawing.Size(60, 23)
        Me.nud5.TabIndex = 7
        '
        'lblR5
        Me.lblR5.AutoSize = True
        Me.lblR5.Location = New System.Drawing.Point(10, 202)
        Me.lblR5.Name = "lblR5"
        Me.lblR5.Text = "R5 x"
        '
        'nud2
        Me.nud2.Location = New System.Drawing.Point(80, 225)
        Me.nud2.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud2.Name = "nud2"
        Me.nud2.Size = New System.Drawing.Size(60, 23)
        Me.nud2.TabIndex = 8
        '
        'lblR2
        Me.lblR2.AutoSize = True
        Me.lblR2.Location = New System.Drawing.Point(10, 227)
        Me.lblR2.Name = "lblR2"
        Me.lblR2.Text = "R2 x"
        '
        'nud1
        Me.nud1.Location = New System.Drawing.Point(80, 250)
        Me.nud1.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud1.Name = "nud1"
        Me.nud1.Size = New System.Drawing.Size(60, 23)
        Me.nud1.TabIndex = 9
        '
        'lblR1
        Me.lblR1.AutoSize = True
        Me.lblR1.Location = New System.Drawing.Point(10, 252)
        Me.lblR1.Name = "lblR1"
        Me.lblR1.Text = "R1 x"
        '
        'nud50c
        Me.nud50c.DecimalPlaces = 1
        Me.nud50c.Increment = New Decimal(New Integer() {5, 0, 0, 65536})
        Me.nud50c.Location = New System.Drawing.Point(80, 275)
        Me.nud50c.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud50c.Name = "nud50c"
        Me.nud50c.Size = New System.Drawing.Size(60, 23)
        Me.nud50c.TabIndex = 10
        '
        'lbl50c
        Me.lbl50c.AutoSize = True
        Me.lbl50c.Location = New System.Drawing.Point(10, 277)
        Me.lbl50c.Name = "lbl50c"
        Me.lbl50c.Text = "50c x"
        '
        'nud20c
        Me.nud20c.DecimalPlaces = 1
        Me.nud20c.Increment = New Decimal(New Integer() {2, 0, 0, 65536})
        Me.nud20c.Location = New System.Drawing.Point(80, 300)
        Me.nud20c.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud20c.Name = "nud20c"
        Me.nud20c.Size = New System.Drawing.Size(60, 23)
        Me.nud20c.TabIndex = 11
        '
        'lbl20c
        Me.lbl20c.AutoSize = True
        Me.lbl20c.Location = New System.Drawing.Point(10, 302)
        Me.lbl20c.Name = "lbl20c"
        Me.lbl20c.Text = "20c x"
        '
        'nud10c
        Me.nud10c.DecimalPlaces = 1
        Me.nud10c.Increment = New Decimal(New Integer() {1, 0, 0, 65536})
        Me.nud10c.Location = New System.Drawing.Point(80, 325)
        Me.nud10c.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nud10c.Name = "nud10c"
        Me.nud10c.Size = New System.Drawing.Size(60, 23)
        Me.nud10c.TabIndex = 12
        '
        'lbl10c
        Me.lbl10c.AutoSize = True
        Me.lbl10c.Location = New System.Drawing.Point(10, 327)
        Me.lbl10c.Name = "lbl10c"
        Me.lbl10c.Text = "10c x"
        '
        'lblPhysicalCount
        '
        Me.lblPhysicalCount.AutoSize = True
        Me.lblPhysicalCount.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblPhysicalCount.Location = New System.Drawing.Point(10, 345)
        Me.lblPhysicalCount.Name = "lblPhysicalCount"
        Me.lblPhysicalCount.Size = New System.Drawing.Size(153, 20)
        Me.lblPhysicalCount.TabIndex = 24
        Me.lblPhysicalCount.Text = "Total Counted: R 0.00"
        '
        'lblVariance
        '
        Me.lblVariance.AutoSize = True
        Me.lblVariance.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblVariance.Location = New System.Drawing.Point(12, 220)
        Me.lblVariance.Name = "lblVariance"
        Me.lblVariance.Size = New System.Drawing.Size(124, 21)
        Me.lblVariance.TabIndex = 3
        Me.lblVariance.Text = "Variance: R 0.00"
        '
        'pnlVarianceReason
        '
        Me.pnlVarianceReason.Controls.Add(Me.lblVarianceNote)
        Me.pnlVarianceReason.Controls.Add(Me.txtVarianceReason)
        Me.pnlVarianceReason.Controls.Add(Me.chkManagerApproval)
        Me.pnlVarianceReason.Controls.Add(Me.lblManagerNote)
        Me.pnlVarianceReason.Location = New System.Drawing.Point(12, 260)
        Me.pnlVarianceReason.Name = "pnlVarianceReason"
        Me.pnlVarianceReason.Size = New System.Drawing.Size(330, 180)
        Me.pnlVarianceReason.TabIndex = 4
        Me.pnlVarianceReason.Visible = False
        '
        'lblVarianceNote
        '
        Me.lblVarianceNote.AutoSize = True
        Me.lblVarianceNote.Location = New System.Drawing.Point(3, 10)
        Me.lblVarianceNote.Name = "lblVarianceNote"
        Me.lblVarianceNote.Size = New System.Drawing.Size(116, 15)
        Me.lblVarianceNote.TabIndex = 0
        Me.lblVarianceNote.Text = "Reason (Mandatory):"
        '
        'txtVarianceReason
        '
        Me.txtVarianceReason.Location = New System.Drawing.Point(3, 30)
        Me.txtVarianceReason.Multiline = True
        Me.txtVarianceReason.Name = "txtVarianceReason"
        Me.txtVarianceReason.Size = New System.Drawing.Size(320, 80)
        Me.txtVarianceReason.TabIndex = 1
        '
        'chkManagerApproval
        '
        Me.chkManagerApproval.AutoSize = True
        Me.chkManagerApproval.Location = New System.Drawing.Point(3, 120)
        Me.chkManagerApproval.Name = "chkManagerApproval"
        Me.chkManagerApproval.Size = New System.Drawing.Size(185, 19)
        Me.chkManagerApproval.TabIndex = 2
        Me.chkManagerApproval.Text = "Manager Approval Confirmed"
        Me.chkManagerApproval.UseVisualStyleBackColor = True
        '
        'lblManagerNote
        '
        Me.lblManagerNote.AutoSize = True
        Me.lblManagerNote.ForeColor = System.Drawing.Color.Red
        Me.lblManagerNote.Location = New System.Drawing.Point(3, 145)
        Me.lblManagerNote.Name = "lblManagerNote"
        Me.lblManagerNote.Size = New System.Drawing.Size(202, 15)
        Me.lblManagerNote.TabIndex = 3
        Me.lblManagerNote.Text = "⚠️ Manager approval required"
        '
        'btnSave
        '
        Me.btnSave.BackColor = System.Drawing.Color.Green
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(358, 460)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(150, 40)
        Me.btnSave.TabIndex = 5
        Me.btnSave.Text = "Save && Close"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.Color.Gray
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCancel.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnCancel.ForeColor = System.Drawing.Color.White
        Me.btnCancel.Location = New System.Drawing.Point(538, 460)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(150, 40)
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'CashReconciliationForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(700, 520)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.pnlVarianceReason)
        Me.Controls.Add(Me.lblVariance)
        Me.Controls.Add(Me.grpPhysicalCount)
        Me.Controls.Add(Me.grpExpected)
        Me.Controls.Add(Me.pnlTop)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CashReconciliationForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Cash Reconciliation"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.grpExpected.ResumeLayout(False)
        Me.grpExpected.PerformLayout()
        Me.grpPhysicalCount.ResumeLayout(False)
        Me.grpPhysicalCount.PerformLayout()
        CType(Me.nud200, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud100, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud50, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud20, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud10, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud5, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud50c, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud20c, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud10c, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlVarianceReason.ResumeLayout(False)
        Me.pnlVarianceReason.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents grpExpected As GroupBox
    Friend WithEvents lblOpeningBalance As Label
    Friend WithEvents lblTotalReceipts As Label
    Friend WithEvents lblTotalPayments As Label
    Friend WithEvents lblExpectedClosing As Label
    Friend WithEvents grpPhysicalCount As GroupBox
    Friend WithEvents lblNotes As Label
    Friend WithEvents nud200 As NumericUpDown
    Friend WithEvents lblR200 As Label
    Friend WithEvents nud100 As NumericUpDown
    Friend WithEvents lblR100 As Label
    Friend WithEvents nud50 As NumericUpDown
    Friend WithEvents lblR50 As Label
    Friend WithEvents nud20 As NumericUpDown
    Friend WithEvents lblR20 As Label
    Friend WithEvents nud10 As NumericUpDown
    Friend WithEvents lblR10 As Label
    Friend WithEvents lblCoins As Label
    Friend WithEvents nud5 As NumericUpDown
    Friend WithEvents lblR5 As Label
    Friend WithEvents nud2 As NumericUpDown
    Friend WithEvents lblR2 As Label
    Friend WithEvents nud1 As NumericUpDown
    Friend WithEvents lblR1 As Label
    Friend WithEvents nud50c As NumericUpDown
    Friend WithEvents lbl50c As Label
    Friend WithEvents nud20c As NumericUpDown
    Friend WithEvents lbl20c As Label
    Friend WithEvents nud10c As NumericUpDown
    Friend WithEvents lbl10c As Label
    Friend WithEvents lblPhysicalCount As Label
    Friend WithEvents lblVariance As Label
    Friend WithEvents pnlVarianceReason As Panel
    Friend WithEvents lblVarianceNote As Label
    Friend WithEvents txtVarianceReason As TextBox
    Friend WithEvents chkManagerApproval As CheckBox
    Friend WithEvents lblManagerNote As Label
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    End Class
End Namespace

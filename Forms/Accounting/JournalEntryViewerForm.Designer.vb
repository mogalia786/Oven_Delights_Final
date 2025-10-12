Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class JournalEntryViewerForm
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
            Me.btnClose = New System.Windows.Forms.Button()
            Me.pnlHeader = New System.Windows.Forms.Panel()
            Me.lblJournalNumber = New System.Windows.Forms.Label()
            Me.lblJournalDate = New System.Windows.Forms.Label()
            Me.lblReference = New System.Windows.Forms.Label()
            Me.lblDescription = New System.Windows.Forms.Label()
            Me.lblBranch = New System.Windows.Forms.Label()
            Me.lblStatus = New System.Windows.Forms.Label()
            Me.dgvLines = New System.Windows.Forms.DataGridView()
            Me.pnlBottom = New System.Windows.Forms.Panel()
            Me.lblTotalDebit = New System.Windows.Forms.Label()
            Me.lblTotalCredit = New System.Windows.Forms.Label()
            Me.lblBalanced = New System.Windows.Forms.Label()
            Me.btnPrint = New System.Windows.Forms.Button()
            Me.pnlTop.SuspendLayout()
            Me.pnlHeader.SuspendLayout()
            CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).BeginInit()
            Me.pnlBottom.SuspendLayout()
            Me.SuspendLayout()
            '
            'pnlTop
            '
            Me.pnlTop.BackColor = System.Drawing.Color.Navy
            Me.pnlTop.Controls.Add(Me.lblTitle)
            Me.pnlTop.Controls.Add(Me.btnClose)
            Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
            Me.pnlTop.Location = New System.Drawing.Point(0, 0)
            Me.pnlTop.Name = "pnlTop"
            Me.pnlTop.Size = New System.Drawing.Size(800, 50)
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
            Me.lblTitle.Text = "Journal Entry Viewer"
            '
            'btnClose
            '
            Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
            Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnClose.ForeColor = System.Drawing.Color.White
            Me.btnClose.Location = New System.Drawing.Point(720, 10)
            Me.btnClose.Name = "btnClose"
            Me.btnClose.Size = New System.Drawing.Size(68, 30)
            Me.btnClose.TabIndex = 1
            Me.btnClose.Text = "Close"
            Me.btnClose.UseVisualStyleBackColor = False
            '
            'pnlHeader
            '
            Me.pnlHeader.BackColor = System.Drawing.Color.WhiteSmoke
            Me.pnlHeader.Controls.Add(Me.lblJournalNumber)
            Me.pnlHeader.Controls.Add(Me.lblJournalDate)
            Me.pnlHeader.Controls.Add(Me.lblReference)
            Me.pnlHeader.Controls.Add(Me.lblDescription)
            Me.pnlHeader.Controls.Add(Me.lblBranch)
            Me.pnlHeader.Controls.Add(Me.lblStatus)
            Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
            Me.pnlHeader.Location = New System.Drawing.Point(0, 50)
            Me.pnlHeader.Name = "pnlHeader"
            Me.pnlHeader.Padding = New System.Windows.Forms.Padding(10)
            Me.pnlHeader.Size = New System.Drawing.Size(800, 100)
            Me.pnlHeader.TabIndex = 1
            '
            'lblJournalNumber
            '
            Me.lblJournalNumber.AutoSize = True
            Me.lblJournalNumber.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblJournalNumber.Location = New System.Drawing.Point(10, 10)
            Me.lblJournalNumber.Name = "lblJournalNumber"
            Me.lblJournalNumber.Size = New System.Drawing.Size(80, 19)
            Me.lblJournalNumber.TabIndex = 0
            Me.lblJournalNumber.Text = "Journal #:"
            '
            'lblJournalDate
            '
            Me.lblJournalDate.AutoSize = True
            Me.lblJournalDate.Location = New System.Drawing.Point(200, 12)
            Me.lblJournalDate.Name = "lblJournalDate"
            Me.lblJournalDate.Size = New System.Drawing.Size(34, 15)
            Me.lblJournalDate.TabIndex = 1
            Me.lblJournalDate.Text = "Date:"
            '
            'lblReference
            '
            Me.lblReference.AutoSize = True
            Me.lblReference.Location = New System.Drawing.Point(10, 35)
            Me.lblReference.Name = "lblReference"
            Me.lblReference.Size = New System.Drawing.Size(62, 15)
            Me.lblReference.TabIndex = 2
            Me.lblReference.Text = "Reference:"
            '
            'lblDescription
            '
            Me.lblDescription.AutoSize = True
            Me.lblDescription.Location = New System.Drawing.Point(10, 55)
            Me.lblDescription.Name = "lblDescription"
            Me.lblDescription.Size = New System.Drawing.Size(70, 15)
            Me.lblDescription.TabIndex = 3
            Me.lblDescription.Text = "Description:"
            '
            'lblBranch
            '
            Me.lblBranch.AutoSize = True
            Me.lblBranch.Location = New System.Drawing.Point(10, 75)
            Me.lblBranch.Name = "lblBranch"
            Me.lblBranch.Size = New System.Drawing.Size(47, 15)
            Me.lblBranch.TabIndex = 4
            Me.lblBranch.Text = "Branch:"
            '
            'lblStatus
            '
            Me.lblStatus.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.lblStatus.AutoSize = True
            Me.lblStatus.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblStatus.Location = New System.Drawing.Point(680, 10)
            Me.lblStatus.Name = "lblStatus"
            Me.lblStatus.Size = New System.Drawing.Size(52, 19)
            Me.lblStatus.TabIndex = 5
            Me.lblStatus.Text = "Status"
            '
            'dgvLines
            '
            Me.dgvLines.AllowUserToAddRows = False
            Me.dgvLines.AllowUserToDeleteRows = False
            Me.dgvLines.BackgroundColor = System.Drawing.Color.White
            Me.dgvLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
            Me.dgvLines.Dock = System.Windows.Forms.DockStyle.Fill
            Me.dgvLines.Location = New System.Drawing.Point(0, 150)
            Me.dgvLines.Name = "dgvLines"
            Me.dgvLines.ReadOnly = True
            Me.dgvLines.RowTemplate.Height = 25
            Me.dgvLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
            Me.dgvLines.Size = New System.Drawing.Size(800, 250)
            Me.dgvLines.TabIndex = 2
            '
            'pnlBottom
            '
            Me.pnlBottom.BackColor = System.Drawing.Color.LightSteelBlue
            Me.pnlBottom.Controls.Add(Me.lblTotalDebit)
            Me.pnlBottom.Controls.Add(Me.lblTotalCredit)
            Me.pnlBottom.Controls.Add(Me.lblBalanced)
            Me.pnlBottom.Controls.Add(Me.btnPrint)
            Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
            Me.pnlBottom.Location = New System.Drawing.Point(0, 400)
            Me.pnlBottom.Name = "pnlBottom"
            Me.pnlBottom.Size = New System.Drawing.Size(800, 50)
            Me.pnlBottom.TabIndex = 3
            '
            'lblTotalDebit
            '
            Me.lblTotalDebit.AutoSize = True
            Me.lblTotalDebit.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblTotalDebit.Location = New System.Drawing.Point(12, 15)
            Me.lblTotalDebit.Name = "lblTotalDebit"
            Me.lblTotalDebit.Size = New System.Drawing.Size(127, 19)
            Me.lblTotalDebit.TabIndex = 0
            Me.lblTotalDebit.Text = "Total Debit: R 0.00"
            '
            'lblTotalCredit
            '
            Me.lblTotalCredit.AutoSize = True
            Me.lblTotalCredit.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblTotalCredit.Location = New System.Drawing.Point(200, 15)
            Me.lblTotalCredit.Name = "lblTotalCredit"
            Me.lblTotalCredit.Size = New System.Drawing.Size(134, 19)
            Me.lblTotalCredit.TabIndex = 1
            Me.lblTotalCredit.Text = "Total Credit: R 0.00"
            '
            'lblBalanced
            '
            Me.lblBalanced.AutoSize = True
            Me.lblBalanced.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.lblBalanced.Location = New System.Drawing.Point(400, 15)
            Me.lblBalanced.Name = "lblBalanced"
            Me.lblBalanced.Size = New System.Drawing.Size(71, 19)
            Me.lblBalanced.TabIndex = 2
            Me.lblBalanced.Text = "Balanced"
            '
            'btnPrint
            '
            Me.btnPrint.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnPrint.BackColor = System.Drawing.Color.DarkOrange
            Me.btnPrint.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnPrint.ForeColor = System.Drawing.Color.White
            Me.btnPrint.Location = New System.Drawing.Point(680, 10)
            Me.btnPrint.Name = "btnPrint"
            Me.btnPrint.Size = New System.Drawing.Size(100, 30)
            Me.btnPrint.TabIndex = 3
            Me.btnPrint.Text = "Print"
            Me.btnPrint.UseVisualStyleBackColor = False
            '
            'JournalEntryViewerForm
            '
            Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
            Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
            Me.ClientSize = New System.Drawing.Size(800, 450)
            Me.Controls.Add(Me.dgvLines)
            Me.Controls.Add(Me.pnlBottom)
            Me.Controls.Add(Me.pnlHeader)
            Me.Controls.Add(Me.pnlTop)
            Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.Name = "JournalEntryViewerForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
            Me.Text = "Journal Entry Viewer"
            Me.pnlTop.ResumeLayout(False)
            Me.pnlTop.PerformLayout()
            Me.pnlHeader.ResumeLayout(False)
            Me.pnlHeader.PerformLayout()
            CType(Me.dgvLines, System.ComponentModel.ISupportInitialize).EndInit()
            Me.pnlBottom.ResumeLayout(False)
            Me.pnlBottom.PerformLayout()
            Me.ResumeLayout(False)

        End Sub

        Friend WithEvents pnlTop As Panel
        Friend WithEvents lblTitle As Label
        Friend WithEvents btnClose As Button
        Friend WithEvents pnlHeader As Panel
        Friend WithEvents lblJournalNumber As Label
        Friend WithEvents lblJournalDate As Label
        Friend WithEvents lblReference As Label
        Friend WithEvents lblDescription As Label
        Friend WithEvents lblBranch As Label
        Friend WithEvents lblStatus As Label
        Friend WithEvents dgvLines As DataGridView
        Friend WithEvents pnlBottom As Panel
        Friend WithEvents lblTotalDebit As Label
        Friend WithEvents lblTotalCredit As Label
        Friend WithEvents lblBalanced As Label
        Friend WithEvents btnPrint As Button
    End Class
End Namespace

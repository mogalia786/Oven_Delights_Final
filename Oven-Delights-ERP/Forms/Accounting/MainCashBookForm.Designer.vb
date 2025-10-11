Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class MainCashBookForm
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
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.lblCashBook = New System.Windows.Forms.Label()
        Me.cboCashBook = New System.Windows.Forms.ComboBox()
        Me.lblDate = New System.Windows.Forms.Label()
        Me.dtpDate = New System.Windows.Forms.DateTimePicker()
        Me.lblOpeningBalance = New System.Windows.Forms.Label()
        Me.lblStatus = New System.Windows.Forms.Label()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlReceipts = New System.Windows.Forms.Panel()
        Me.lblReceipts = New System.Windows.Forms.Label()
        Me.btnNewReceipt = New System.Windows.Forms.Button()
        Me.dgvReceipts = New System.Windows.Forms.DataGridView()
        Me.lblTotalReceipts = New System.Windows.Forms.Label()
        Me.pnlPayments = New System.Windows.Forms.Panel()
        Me.lblPayments = New System.Windows.Forms.Label()
        Me.btnNewPayment = New System.Windows.Forms.Button()
        Me.dgvPayments = New System.Windows.Forms.DataGridView()
        Me.lblTotalPayments = New System.Windows.Forms.Label()
        Me.pnlBottom = New System.Windows.Forms.Panel()
        Me.lblExpectedClosing = New System.Windows.Forms.Label()
        Me.btnReconcile = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        Me.pnlHeader.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.pnlReceipts.SuspendLayout()
        CType(Me.dgvReceipts, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlPayments.SuspendLayout()
        CType(Me.dgvPayments, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.pnlTop.Size = New System.Drawing.Size(1200, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(210, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Main Cash Book"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1120, 12)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(68, 36)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'pnlHeader
        '
        Me.pnlHeader.BackColor = System.Drawing.Color.WhiteSmoke
        Me.pnlHeader.Controls.Add(Me.lblCashBook)
        Me.pnlHeader.Controls.Add(Me.cboCashBook)
        Me.pnlHeader.Controls.Add(Me.lblDate)
        Me.pnlHeader.Controls.Add(Me.dtpDate)
        Me.pnlHeader.Controls.Add(Me.lblOpeningBalance)
        Me.pnlHeader.Controls.Add(Me.lblStatus)
        Me.pnlHeader.Controls.Add(Me.btnRefresh)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 60)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(1200, 80)
        Me.pnlHeader.TabIndex = 1
        '
        'lblCashBook
        '
        Me.lblCashBook.AutoSize = True
        Me.lblCashBook.Location = New System.Drawing.Point(12, 15)
        Me.lblCashBook.Name = "lblCashBook"
        Me.lblCashBook.Size = New System.Drawing.Size(67, 15)
        Me.lblCashBook.TabIndex = 0
        Me.lblCashBook.Text = "Cash Book:"
        '
        'cboCashBook
        '
        Me.cboCashBook.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCashBook.FormattingEnabled = True
        Me.cboCashBook.Location = New System.Drawing.Point(12, 33)
        Me.cboCashBook.Name = "cboCashBook"
        Me.cboCashBook.Size = New System.Drawing.Size(250, 23)
        Me.cboCashBook.TabIndex = 1
        '
        'lblDate
        '
        Me.lblDate.AutoSize = True
        Me.lblDate.Location = New System.Drawing.Point(280, 15)
        Me.lblDate.Name = "lblDate"
        Me.lblDate.Size = New System.Drawing.Size(34, 15)
        Me.lblDate.TabIndex = 2
        Me.lblDate.Text = "Date:"
        '
        'dtpDate
        '
        Me.dtpDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpDate.Location = New System.Drawing.Point(280, 33)
        Me.dtpDate.Name = "dtpDate"
        Me.dtpDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpDate.TabIndex = 3
        '
        'lblOpeningBalance
        '
        Me.lblOpeningBalance.AutoSize = True
        Me.lblOpeningBalance.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblOpeningBalance.Location = New System.Drawing.Point(450, 33)
        Me.lblOpeningBalance.Name = "lblOpeningBalance"
        Me.lblOpeningBalance.Size = New System.Drawing.Size(183, 21)
        Me.lblOpeningBalance.TabIndex = 4
        Me.lblOpeningBalance.Text = "Opening Balance: R 0.00"
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.lblStatus.ForeColor = System.Drawing.Color.Blue
        Me.lblStatus.Location = New System.Drawing.Point(700, 35)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(95, 19)
        Me.lblStatus.TabIndex = 5
        Me.lblStatus.Text = "Status: Open"
        '
        'btnRefresh
        '
        Me.btnRefresh.BackColor = System.Drawing.Color.Green
        Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRefresh.ForeColor = System.Drawing.Color.White
        Me.btnRefresh.Location = New System.Drawing.Point(900, 28)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(100, 32)
        Me.btnRefresh.TabIndex = 6
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = False
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.pnlReceipts)
        Me.pnlMain.Controls.Add(Me.pnlPayments)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 140)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(1200, 410)
        Me.pnlMain.TabIndex = 2
        '
        'pnlReceipts
        '
        Me.pnlReceipts.Controls.Add(Me.lblReceipts)
        Me.pnlReceipts.Controls.Add(Me.btnNewReceipt)
        Me.pnlReceipts.Controls.Add(Me.dgvReceipts)
        Me.pnlReceipts.Controls.Add(Me.lblTotalReceipts)
        Me.pnlReceipts.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlReceipts.Location = New System.Drawing.Point(0, 0)
        Me.pnlReceipts.Name = "pnlReceipts"
        Me.pnlReceipts.Padding = New System.Windows.Forms.Padding(10)
        Me.pnlReceipts.Size = New System.Drawing.Size(590, 410)
        Me.pnlReceipts.TabIndex = 0
        '
        'lblReceipts
        '
        Me.lblReceipts.BackColor = System.Drawing.Color.Green
        Me.lblReceipts.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblReceipts.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblReceipts.ForeColor = System.Drawing.Color.White
        Me.lblReceipts.Location = New System.Drawing.Point(10, 10)
        Me.lblReceipts.Name = "lblReceipts"
        Me.lblReceipts.Padding = New System.Windows.Forms.Padding(5)
        Me.lblReceipts.Size = New System.Drawing.Size(570, 35)
        Me.lblReceipts.TabIndex = 0
        Me.lblReceipts.Text = "RECEIPTS (Money IN)"
        Me.lblReceipts.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnNewReceipt
        '
        Me.btnNewReceipt.BackColor = System.Drawing.Color.Green
        Me.btnNewReceipt.Dock = System.Windows.Forms.DockStyle.Top
        Me.btnNewReceipt.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnNewReceipt.ForeColor = System.Drawing.Color.White
        Me.btnNewReceipt.Location = New System.Drawing.Point(10, 45)
        Me.btnNewReceipt.Name = "btnNewReceipt"
        Me.btnNewReceipt.Size = New System.Drawing.Size(570, 32)
        Me.btnNewReceipt.TabIndex = 1
        Me.btnNewReceipt.Text = "+ New Receipt"
        Me.btnNewReceipt.UseVisualStyleBackColor = False
        '
        'dgvReceipts
        '
        Me.dgvReceipts.AllowUserToAddRows = False
        Me.dgvReceipts.AllowUserToDeleteRows = False
        Me.dgvReceipts.BackgroundColor = System.Drawing.Color.White
        Me.dgvReceipts.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvReceipts.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvReceipts.Location = New System.Drawing.Point(10, 77)
        Me.dgvReceipts.Name = "dgvReceipts"
        Me.dgvReceipts.ReadOnly = True
        Me.dgvReceipts.RowTemplate.Height = 25
        Me.dgvReceipts.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvReceipts.Size = New System.Drawing.Size(570, 283)
        Me.dgvReceipts.TabIndex = 2
        '
        'lblTotalReceipts
        '
        Me.lblTotalReceipts.BackColor = System.Drawing.Color.LightGreen
        Me.lblTotalReceipts.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.lblTotalReceipts.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalReceipts.Location = New System.Drawing.Point(10, 360)
        Me.lblTotalReceipts.Name = "lblTotalReceipts"
        Me.lblTotalReceipts.Padding = New System.Windows.Forms.Padding(5)
        Me.lblTotalReceipts.Size = New System.Drawing.Size(570, 40)
        Me.lblTotalReceipts.TabIndex = 3
        Me.lblTotalReceipts.Text = "Total Receipts: R 0.00"
        Me.lblTotalReceipts.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlPayments
        '
        Me.pnlPayments.Controls.Add(Me.lblPayments)
        Me.pnlPayments.Controls.Add(Me.btnNewPayment)
        Me.pnlPayments.Controls.Add(Me.dgvPayments)
        Me.pnlPayments.Controls.Add(Me.lblTotalPayments)
        Me.pnlPayments.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlPayments.Location = New System.Drawing.Point(590, 0)
        Me.pnlPayments.Name = "pnlPayments"
        Me.pnlPayments.Padding = New System.Windows.Forms.Padding(10)
        Me.pnlPayments.Size = New System.Drawing.Size(610, 410)
        Me.pnlPayments.TabIndex = 1
        '
        'lblPayments
        '
        Me.lblPayments.BackColor = System.Drawing.Color.Crimson
        Me.lblPayments.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblPayments.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblPayments.ForeColor = System.Drawing.Color.White
        Me.lblPayments.Location = New System.Drawing.Point(10, 10)
        Me.lblPayments.Name = "lblPayments"
        Me.lblPayments.Padding = New System.Windows.Forms.Padding(5)
        Me.lblPayments.Size = New System.Drawing.Size(590, 35)
        Me.lblPayments.TabIndex = 0
        Me.lblPayments.Text = "PAYMENTS (Money OUT)"
        Me.lblPayments.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnNewPayment
        '
        Me.btnNewPayment.BackColor = System.Drawing.Color.Crimson
        Me.btnNewPayment.Dock = System.Windows.Forms.DockStyle.Top
        Me.btnNewPayment.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnNewPayment.ForeColor = System.Drawing.Color.White
        Me.btnNewPayment.Location = New System.Drawing.Point(10, 45)
        Me.btnNewPayment.Name = "btnNewPayment"
        Me.btnNewPayment.Size = New System.Drawing.Size(590, 32)
        Me.btnNewPayment.TabIndex = 1
        Me.btnNewPayment.Text = "+ New Payment"
        Me.btnNewPayment.UseVisualStyleBackColor = False
        '
        'dgvPayments
        '
        Me.dgvPayments.AllowUserToAddRows = False
        Me.dgvPayments.AllowUserToDeleteRows = False
        Me.dgvPayments.BackgroundColor = System.Drawing.Color.White
        Me.dgvPayments.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvPayments.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvPayments.Location = New System.Drawing.Point(10, 77)
        Me.dgvPayments.Name = "dgvPayments"
        Me.dgvPayments.ReadOnly = True
        Me.dgvPayments.RowTemplate.Height = 25
        Me.dgvPayments.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvPayments.Size = New System.Drawing.Size(590, 283)
        Me.dgvPayments.TabIndex = 2
        '
        'lblTotalPayments
        '
        Me.lblTotalPayments.BackColor = System.Drawing.Color.LightCoral
        Me.lblTotalPayments.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.lblTotalPayments.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalPayments.Location = New System.Drawing.Point(10, 360)
        Me.lblTotalPayments.Name = "lblTotalPayments"
        Me.lblTotalPayments.Padding = New System.Windows.Forms.Padding(5)
        Me.lblTotalPayments.Size = New System.Drawing.Size(590, 40)
        Me.lblTotalPayments.TabIndex = 3
        Me.lblTotalPayments.Text = "Total Payments: R 0.00"
        Me.lblTotalPayments.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.Color.LightSteelBlue
        Me.pnlBottom.Controls.Add(Me.lblExpectedClosing)
        Me.pnlBottom.Controls.Add(Me.btnReconcile)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 550)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(1200, 60)
        Me.pnlBottom.TabIndex = 3
        '
        'lblExpectedClosing
        '
        Me.lblExpectedClosing.AutoSize = True
        Me.lblExpectedClosing.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblExpectedClosing.Location = New System.Drawing.Point(12, 18)
        Me.lblExpectedClosing.Name = "lblExpectedClosing"
        Me.lblExpectedClosing.Size = New System.Drawing.Size(224, 25)
        Me.lblExpectedClosing.TabIndex = 0
        Me.lblExpectedClosing.Text = "Expected Closing: R 0.00"
        '
        'btnReconcile
        '
        Me.btnReconcile.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnReconcile.BackColor = System.Drawing.Color.DarkOrange
        Me.btnReconcile.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnReconcile.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnReconcile.ForeColor = System.Drawing.Color.White
        Me.btnReconcile.Location = New System.Drawing.Point(1020, 12)
        Me.btnReconcile.Name = "btnReconcile"
        Me.btnReconcile.Size = New System.Drawing.Size(168, 36)
        Me.btnReconcile.TabIndex = 1
        Me.btnReconcile.Text = "Reconcile && Close"
        Me.btnReconcile.UseVisualStyleBackColor = False
        '
        'MainCashBookForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 610)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.pnlHeader)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "MainCashBookForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Main Cash Book"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.pnlReceipts.ResumeLayout(False)
        CType(Me.dgvReceipts, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlPayments.ResumeLayout(False)
        CType(Me.dgvPayments, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBottom.ResumeLayout(False)
        Me.pnlBottom.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents lblCashBook As Label
    Friend WithEvents cboCashBook As ComboBox
    Friend WithEvents lblDate As Label
    Friend WithEvents dtpDate As DateTimePicker
    Friend WithEvents lblOpeningBalance As Label
    Friend WithEvents lblStatus As Label
    Friend WithEvents btnRefresh As Button
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlReceipts As Panel
    Friend WithEvents lblReceipts As Label
    Friend WithEvents btnNewReceipt As Button
    Friend WithEvents dgvReceipts As DataGridView
    Friend WithEvents lblTotalReceipts As Label
    Friend WithEvents pnlPayments As Panel
    Friend WithEvents lblPayments As Label
    Friend WithEvents btnNewPayment As Button
    Friend WithEvents dgvPayments As DataGridView
    Friend WithEvents lblTotalPayments As Label
    Friend WithEvents pnlBottom As Panel
    Friend WithEvents lblExpectedClosing As Label
    Friend WithEvents btnReconcile As Button
    End Class
End Namespace

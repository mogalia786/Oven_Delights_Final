<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class POSForm
    Inherits System.Windows.Forms.Form

    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(disposing As Boolean)
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
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.pnlLeft = New System.Windows.Forms.Panel()
        Me.lblScan = New System.Windows.Forms.Label()
        Me.txtScanSKU = New System.Windows.Forms.TextBox()
        Me.btnLookup = New System.Windows.Forms.Button()
        Me.dgvProducts = New System.Windows.Forms.DataGridView()
        Me.pnlRight = New System.Windows.Forms.Panel()
        Me.lblCart = New System.Windows.Forms.Label()
        Me.dgvCart = New System.Windows.Forms.DataGridView()
        Me.pnlCartTotals = New System.Windows.Forms.Panel()
        Me.lblSubtotal = New System.Windows.Forms.Label()
        Me.lblVAT = New System.Windows.Forms.Label()
        Me.lblTotal = New System.Windows.Forms.Label()
        Me.txtSubtotal = New System.Windows.Forms.TextBox()
        Me.txtVAT = New System.Windows.Forms.TextBox()
        Me.txtTotal = New System.Windows.Forms.TextBox()
        Me.pnlTender = New System.Windows.Forms.Panel()
        Me.lblTender = New System.Windows.Forms.Label()
        Me.txtTenderAmount = New System.Windows.Forms.TextBox()
        Me.btnCash = New System.Windows.Forms.Button()
        Me.btnCard = New System.Windows.Forms.Button()
        Me.btnFinalizeSale = New System.Windows.Forms.Button()
        Me.btnClearCart = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        Me.pnlLeft.SuspendLayout()
        CType(Me.dgvProducts, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlRight.SuspendLayout()
        CType(Me.dgvCart, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlCartTotals.SuspendLayout()
        Me.pnlTender.SuspendLayout()
        Me.SuspendLayout()
        '
        ' pnlTop
        '
        Me.pnlTop.Controls.Add(Me.cboBranch)
        Me.pnlTop.Controls.Add(Me.lblBranch)
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1200, 60)
        Me.pnlTop.TabIndex = 0
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 16.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(12, 15)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(178, 30)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Point of Sale"
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(220, 22)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 1
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(273, 19)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 23)
        Me.cboBranch.TabIndex = 2
        '
        ' pnlLeft
        '
        Me.pnlLeft.Controls.Add(Me.dgvProducts)
        Me.pnlLeft.Controls.Add(Me.btnLookup)
        Me.pnlLeft.Controls.Add(Me.txtScanSKU)
        Me.pnlLeft.Controls.Add(Me.lblScan)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.Location = New System.Drawing.Point(0, 60)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(600, 540)
        Me.pnlLeft.TabIndex = 1
        '
        ' lblScan
        '
        Me.lblScan.AutoSize = True
        Me.lblScan.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblScan.Location = New System.Drawing.Point(12, 15)
        Me.lblScan.Name = "lblScan"
        Me.lblScan.Size = New System.Drawing.Size(140, 21)
        Me.lblScan.TabIndex = 0
        Me.lblScan.Text = "Scan / Enter SKU"
        '
        ' txtScanSKU
        '
        Me.txtScanSKU.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.txtScanSKU.Location = New System.Drawing.Point(12, 45)
        Me.txtScanSKU.Name = "txtScanSKU"
        Me.txtScanSKU.Size = New System.Drawing.Size(400, 32)
        Me.txtScanSKU.TabIndex = 1
        '
        ' btnLookup
        '
        Me.btnLookup.Location = New System.Drawing.Point(425, 45)
        Me.btnLookup.Name = "btnLookup"
        Me.btnLookup.Size = New System.Drawing.Size(100, 32)
        Me.btnLookup.TabIndex = 2
        Me.btnLookup.Text = "Lookup"
        Me.btnLookup.UseVisualStyleBackColor = True
        '
        ' dgvProducts
        '
        Me.dgvProducts.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvProducts.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvProducts.Location = New System.Drawing.Point(12, 90)
        Me.dgvProducts.Name = "dgvProducts"
        Me.dgvProducts.RowTemplate.Height = 25
        Me.dgvProducts.Size = New System.Drawing.Size(575, 435)
        Me.dgvProducts.TabIndex = 3
        '
        ' pnlRight
        '
        Me.pnlRight.Controls.Add(Me.pnlTender)
        Me.pnlRight.Controls.Add(Me.pnlCartTotals)
        Me.pnlRight.Controls.Add(Me.dgvCart)
        Me.pnlRight.Controls.Add(Me.lblCart)
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.Location = New System.Drawing.Point(600, 60)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(600, 540)
        Me.pnlRight.TabIndex = 2
        '
        ' lblCart
        '
        Me.lblCart.AutoSize = True
        Me.lblCart.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblCart.Location = New System.Drawing.Point(12, 15)
        Me.lblCart.Name = "lblCart"
        Me.lblCart.Size = New System.Drawing.Size(104, 21)
        Me.lblCart.TabIndex = 0
        Me.lblCart.Text = "Shopping Cart"
        '
        ' dgvCart
        '
        Me.dgvCart.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvCart.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvCart.Location = New System.Drawing.Point(12, 45)
        Me.dgvCart.Name = "dgvCart"
        Me.dgvCart.RowTemplate.Height = 25
        Me.dgvCart.Size = New System.Drawing.Size(575, 250)
        Me.dgvCart.TabIndex = 1
        '
        ' pnlCartTotals
        '
        Me.pnlCartTotals.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlCartTotals.Controls.Add(Me.txtTotal)
        Me.pnlCartTotals.Controls.Add(Me.txtVAT)
        Me.pnlCartTotals.Controls.Add(Me.txtSubtotal)
        Me.pnlCartTotals.Controls.Add(Me.lblTotal)
        Me.pnlCartTotals.Controls.Add(Me.lblVAT)
        Me.pnlCartTotals.Controls.Add(Me.lblSubtotal)
        Me.pnlCartTotals.Location = New System.Drawing.Point(12, 310)
        Me.pnlCartTotals.Name = "pnlCartTotals"
        Me.pnlCartTotals.Size = New System.Drawing.Size(575, 100)
        Me.pnlCartTotals.TabIndex = 2
        '
        ' lblSubtotal
        '
        Me.lblSubtotal.AutoSize = True
        Me.lblSubtotal.Location = New System.Drawing.Point(350, 15)
        Me.lblSubtotal.Name = "lblSubtotal"
        Me.lblSubtotal.Size = New System.Drawing.Size(54, 15)
        Me.lblSubtotal.TabIndex = 0
        Me.lblSubtotal.Text = "Subtotal:"
        '
        ' lblVAT
        '
        Me.lblVAT.AutoSize = True
        Me.lblVAT.Location = New System.Drawing.Point(350, 45)
        Me.lblVAT.Name = "lblVAT"
        Me.lblVAT.Size = New System.Drawing.Size(30, 15)
        Me.lblVAT.TabIndex = 1
        Me.lblVAT.Text = "VAT:"
        '
        ' lblTotal
        '
        Me.lblTotal.AutoSize = True
        Me.lblTotal.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTotal.Location = New System.Drawing.Point(350, 70)
        Me.lblTotal.Name = "lblTotal"
        Me.lblTotal.Size = New System.Drawing.Size(48, 21)
        Me.lblTotal.TabIndex = 2
        Me.lblTotal.Text = "Total:"
        '
        ' txtSubtotal
        '
        Me.txtSubtotal.Location = New System.Drawing.Point(420, 12)
        Me.txtSubtotal.Name = "txtSubtotal"
        Me.txtSubtotal.ReadOnly = True
        Me.txtSubtotal.Size = New System.Drawing.Size(120, 23)
        Me.txtSubtotal.TabIndex = 3
        Me.txtSubtotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        ' txtVAT
        '
        Me.txtVAT.Location = New System.Drawing.Point(420, 42)
        Me.txtVAT.Name = "txtVAT"
        Me.txtVAT.ReadOnly = True
        Me.txtVAT.Size = New System.Drawing.Size(120, 23)
        Me.txtVAT.TabIndex = 4
        Me.txtVAT.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        ' txtTotal
        '
        Me.txtTotal.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.txtTotal.Location = New System.Drawing.Point(420, 70)
        Me.txtTotal.Name = "txtTotal"
        Me.txtTotal.ReadOnly = True
        Me.txtTotal.Size = New System.Drawing.Size(120, 29)
        Me.txtTotal.TabIndex = 5
        Me.txtTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        ' pnlTender
        '
        Me.pnlTender.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlTender.Controls.Add(Me.btnClearCart)
        Me.pnlTender.Controls.Add(Me.btnFinalizeSale)
        Me.pnlTender.Controls.Add(Me.btnCard)
        Me.pnlTender.Controls.Add(Me.btnCash)
        Me.pnlTender.Controls.Add(Me.txtTenderAmount)
        Me.pnlTender.Controls.Add(Me.lblTender)
        Me.pnlTender.Location = New System.Drawing.Point(12, 425)
        Me.pnlTender.Name = "pnlTender"
        Me.pnlTender.Size = New System.Drawing.Size(575, 100)
        Me.pnlTender.TabIndex = 3
        '
        ' lblTender
        '
        Me.lblTender.AutoSize = True
        Me.lblTender.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTender.Location = New System.Drawing.Point(15, 15)
        Me.lblTender.Name = "lblTender"
        Me.lblTender.Size = New System.Drawing.Size(63, 21)
        Me.lblTender.TabIndex = 0
        Me.lblTender.Text = "Tender:"
        '
        ' txtTenderAmount
        '
        Me.txtTenderAmount.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.txtTenderAmount.Location = New System.Drawing.Point(90, 12)
        Me.txtTenderAmount.Name = "txtTenderAmount"
        Me.txtTenderAmount.Size = New System.Drawing.Size(150, 32)
        Me.txtTenderAmount.TabIndex = 1
        Me.txtTenderAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        ' btnCash
        '
        Me.btnCash.Location = New System.Drawing.Point(260, 12)
        Me.btnCash.Name = "btnCash"
        Me.btnCash.Size = New System.Drawing.Size(80, 32)
        Me.btnCash.TabIndex = 2
        Me.btnCash.Text = "Cash"
        Me.btnCash.UseVisualStyleBackColor = True
        '
        ' btnCard
        '
        Me.btnCard.Location = New System.Drawing.Point(350, 12)
        Me.btnCard.Name = "btnCard"
        Me.btnCard.Size = New System.Drawing.Size(80, 32)
        Me.btnCard.TabIndex = 3
        Me.btnCard.Text = "Card"
        Me.btnCard.UseVisualStyleBackColor = True
        '
        ' btnFinalizeSale
        '
        Me.btnFinalizeSale.BackColor = System.Drawing.Color.Green
        Me.btnFinalizeSale.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.btnFinalizeSale.ForeColor = System.Drawing.Color.White
        Me.btnFinalizeSale.Location = New System.Drawing.Point(15, 55)
        Me.btnFinalizeSale.Name = "btnFinalizeSale"
        Me.btnFinalizeSale.Size = New System.Drawing.Size(200, 40)
        Me.btnFinalizeSale.TabIndex = 4
        Me.btnFinalizeSale.Text = "Finalize Sale"
        Me.btnFinalizeSale.UseVisualStyleBackColor = False
        '
        ' btnClearCart
        '
        Me.btnClearCart.BackColor = System.Drawing.Color.Red
        Me.btnClearCart.ForeColor = System.Drawing.Color.White
        Me.btnClearCart.Location = New System.Drawing.Point(230, 55)
        Me.btnClearCart.Name = "btnClearCart"
        Me.btnClearCart.Size = New System.Drawing.Size(100, 40)
        Me.btnClearCart.TabIndex = 5
        Me.btnClearCart.Text = "Clear Cart"
        Me.btnClearCart.UseVisualStyleBackColor = False
        '
        ' POSForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 600)
        Me.Controls.Add(Me.pnlRight)
        Me.Controls.Add(Me.pnlLeft)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "POSForm"
        Me.Text = "Point of Sale"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlLeft.ResumeLayout(False)
        Me.pnlLeft.PerformLayout()
        CType(Me.dgvProducts, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlRight.ResumeLayout(False)
        Me.pnlRight.PerformLayout()
        CType(Me.dgvCart, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlCartTotals.ResumeLayout(False)
        Me.pnlCartTotals.PerformLayout()
        Me.pnlTender.ResumeLayout(False)
        Me.pnlTender.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents pnlLeft As Panel
    Friend WithEvents lblScan As Label
    Friend WithEvents txtScanSKU As TextBox
    Friend WithEvents btnLookup As Button
    Friend WithEvents dgvProducts As DataGridView
    Friend WithEvents pnlRight As Panel
    Friend WithEvents lblCart As Label
    Friend WithEvents dgvCart As DataGridView
    Friend WithEvents pnlCartTotals As Panel
    Friend WithEvents lblSubtotal As Label
    Friend WithEvents lblVAT As Label
    Friend WithEvents lblTotal As Label
    Friend WithEvents txtSubtotal As TextBox
    Friend WithEvents txtVAT As TextBox
    Friend WithEvents txtTotal As TextBox
    Friend WithEvents pnlTender As Panel
    Friend WithEvents lblTender As Label
    Friend WithEvents txtTenderAmount As TextBox
    Friend WithEvents btnCash As Button
    Friend WithEvents btnCard As Button
    Friend WithEvents btnFinalizeSale As Button
    Friend WithEvents btnClearCart As Button
End Class

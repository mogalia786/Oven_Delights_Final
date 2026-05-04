Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class FNBTransactionDetailsForm
    Inherits Form

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

    Friend WithEvents txtTransactionID As TextBox
    Friend WithEvents txtEndToEndID As TextBox
    Friend WithEvents txtBatchID As TextBox
    Friend WithEvents txtMessageID As TextBox
    Friend WithEvents txtInstructionID As TextBox
    Friend WithEvents txtCreditorName As TextBox
    Friend WithEvents txtCreditorAccount As TextBox
    Friend WithEvents txtCreditorBranch As TextBox
    Friend WithEvents txtAmount As TextBox
    Friend WithEvents txtCurrency As TextBox
    Friend WithEvents txtTransactionStatus As TextBox
    Friend WithEvents txtBatchStatus As TextBox
    Friend WithEvents txtRejectionCode As TextBox
    Friend WithEvents txtRejectionText As TextBox
    Friend WithEvents txtRemittanceRef As TextBox
    Friend WithEvents txtRemittanceRef20 As TextBox
    Friend WithEvents txtProofEmail As TextBox
    Friend WithEvents txtRequestedDate As TextBox
    Friend WithEvents txtCreatedDate As TextBox
    Friend WithEvents txtProcessedDate As TextBox
    Friend WithEvents txtDebtorAccount As TextBox
    Friend WithEvents txtSupplierName As TextBox
    Friend WithEvents txtJournalID As TextBox
    Friend WithEvents chkIsPosted As CheckBox
    Friend WithEvents dgvStatusHistory As DataGridView
    Friend WithEvents btnClose As Button
    Friend WithEvents grpTransaction As GroupBox
    Friend WithEvents grpCreditor As GroupBox
    Friend WithEvents grpStatus As GroupBox
    Friend WithEvents grpDates As GroupBox
    Friend WithEvents grpHistory As GroupBox

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.txtTransactionID = New System.Windows.Forms.TextBox()
        Me.txtEndToEndID = New System.Windows.Forms.TextBox()
        Me.txtBatchID = New System.Windows.Forms.TextBox()
        Me.txtMessageID = New System.Windows.Forms.TextBox()
        Me.txtInstructionID = New System.Windows.Forms.TextBox()
        Me.txtCreditorName = New System.Windows.Forms.TextBox()
        Me.txtCreditorAccount = New System.Windows.Forms.TextBox()
        Me.txtCreditorBranch = New System.Windows.Forms.TextBox()
        Me.txtAmount = New System.Windows.Forms.TextBox()
        Me.txtCurrency = New System.Windows.Forms.TextBox()
        Me.txtTransactionStatus = New System.Windows.Forms.TextBox()
        Me.txtBatchStatus = New System.Windows.Forms.TextBox()
        Me.txtRejectionCode = New System.Windows.Forms.TextBox()
        Me.txtRejectionText = New System.Windows.Forms.TextBox()
        Me.txtRemittanceRef = New System.Windows.Forms.TextBox()
        Me.txtRemittanceRef20 = New System.Windows.Forms.TextBox()
        Me.txtProofEmail = New System.Windows.Forms.TextBox()
        Me.txtRequestedDate = New System.Windows.Forms.TextBox()
        Me.txtCreatedDate = New System.Windows.Forms.TextBox()
        Me.txtProcessedDate = New System.Windows.Forms.TextBox()
        Me.txtDebtorAccount = New System.Windows.Forms.TextBox()
        Me.txtSupplierName = New System.Windows.Forms.TextBox()
        Me.txtJournalID = New System.Windows.Forms.TextBox()
        Me.chkIsPosted = New System.Windows.Forms.CheckBox()
        Me.dgvStatusHistory = New System.Windows.Forms.DataGridView()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.grpTransaction = New System.Windows.Forms.GroupBox()
        Me.grpCreditor = New System.Windows.Forms.GroupBox()
        Me.grpStatus = New System.Windows.Forms.GroupBox()
        Me.grpDates = New System.Windows.Forms.GroupBox()
        Me.grpHistory = New System.Windows.Forms.GroupBox()
        CType(Me.dgvStatusHistory, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpTransaction.SuspendLayout()
        Me.grpCreditor.SuspendLayout()
        Me.grpStatus.SuspendLayout()
        Me.grpDates.SuspendLayout()
        Me.grpHistory.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpTransaction
        Me.grpTransaction.Controls.Add(New Label() With {.Text = "Transaction ID:", .Location = New Point(10, 25), .AutoSize = True})
        Me.grpTransaction.Controls.Add(Me.txtTransactionID)
        Me.grpTransaction.Controls.Add(New Label() With {.Text = "End-to-End ID:", .Location = New Point(10, 55), .AutoSize = True})
        Me.grpTransaction.Controls.Add(Me.txtEndToEndID)
        Me.grpTransaction.Controls.Add(New Label() With {.Text = "Batch ID:", .Location = New Point(10, 85), .AutoSize = True})
        Me.grpTransaction.Controls.Add(Me.txtBatchID)
        Me.grpTransaction.Controls.Add(New Label() With {.Text = "Message ID:", .Location = New Point(10, 115), .AutoSize = True})
        Me.grpTransaction.Controls.Add(Me.txtMessageID)
        Me.grpTransaction.Controls.Add(New Label() With {.Text = "Instruction ID:", .Location = New Point(10, 145), .AutoSize = True})
        Me.grpTransaction.Controls.Add(Me.txtInstructionID)
        Me.grpTransaction.Location = New Point(12, 12)
        Me.grpTransaction.Name = "grpTransaction"
        Me.grpTransaction.Size = New Size(380, 180)
        Me.grpTransaction.TabIndex = 0
        Me.grpTransaction.TabStop = False
        Me.grpTransaction.Text = "Transaction Information"
        '
        'txtTransactionID
        Me.txtTransactionID.Location = New Point(130, 22)
        Me.txtTransactionID.Name = "txtTransactionID"
        Me.txtTransactionID.ReadOnly = True
        Me.txtTransactionID.Size = New Size(240, 20)
        Me.txtTransactionID.TabIndex = 1
        '
        'txtEndToEndID
        Me.txtEndToEndID.Location = New Point(130, 52)
        Me.txtEndToEndID.Name = "txtEndToEndID"
        Me.txtEndToEndID.ReadOnly = True
        Me.txtEndToEndID.Size = New Size(240, 20)
        Me.txtEndToEndID.TabIndex = 3
        '
        'txtBatchID
        Me.txtBatchID.Location = New Point(130, 82)
        Me.txtBatchID.Name = "txtBatchID"
        Me.txtBatchID.ReadOnly = True
        Me.txtBatchID.Size = New Size(240, 20)
        Me.txtBatchID.TabIndex = 5
        '
        'txtMessageID
        Me.txtMessageID.Location = New Point(130, 112)
        Me.txtMessageID.Name = "txtMessageID"
        Me.txtMessageID.ReadOnly = True
        Me.txtMessageID.Size = New Size(240, 20)
        Me.txtMessageID.TabIndex = 7
        '
        'txtInstructionID
        Me.txtInstructionID.Location = New Point(130, 142)
        Me.txtInstructionID.Name = "txtInstructionID"
        Me.txtInstructionID.ReadOnly = True
        Me.txtInstructionID.Size = New Size(240, 20)
        Me.txtInstructionID.TabIndex = 9
        '
        'grpCreditor
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Supplier Name:", .Location = New Point(10, 25), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtSupplierName)
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Creditor Name:", .Location = New Point(10, 55), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtCreditorName)
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Account Number:", .Location = New Point(10, 85), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtCreditorAccount)
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Branch Code:", .Location = New Point(10, 115), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtCreditorBranch)
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Amount:", .Location = New Point(10, 145), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtAmount)
        Me.grpCreditor.Controls.Add(New Label() With {.Text = "Currency:", .Location = New Point(200, 145), .AutoSize = True})
        Me.grpCreditor.Controls.Add(Me.txtCurrency)
        Me.grpCreditor.Location = New Point(410, 12)
        Me.grpCreditor.Name = "grpCreditor"
        Me.grpCreditor.Size = New Size(380, 180)
        Me.grpCreditor.TabIndex = 10
        Me.grpCreditor.TabStop = False
        Me.grpCreditor.Text = "Creditor (Supplier) Information"
        '
        'txtSupplierName
        Me.txtSupplierName.Location = New Point(130, 22)
        Me.txtSupplierName.Name = "txtSupplierName"
        Me.txtSupplierName.ReadOnly = True
        Me.txtSupplierName.Size = New Size(240, 20)
        Me.txtSupplierName.TabIndex = 1
        '
        'txtCreditorName
        Me.txtCreditorName.Location = New Point(130, 52)
        Me.txtCreditorName.Name = "txtCreditorName"
        Me.txtCreditorName.ReadOnly = True
        Me.txtCreditorName.Size = New Size(240, 20)
        Me.txtCreditorName.TabIndex = 3
        '
        'txtCreditorAccount
        Me.txtCreditorAccount.Location = New Point(130, 82)
        Me.txtCreditorAccount.Name = "txtCreditorAccount"
        Me.txtCreditorAccount.ReadOnly = True
        Me.txtCreditorAccount.Size = New Size(240, 20)
        Me.txtCreditorAccount.TabIndex = 5
        '
        'txtCreditorBranch
        Me.txtCreditorBranch.Location = New Point(130, 112)
        Me.txtCreditorBranch.Name = "txtCreditorBranch"
        Me.txtCreditorBranch.ReadOnly = True
        Me.txtCreditorBranch.Size = New Size(240, 20)
        Me.txtCreditorBranch.TabIndex = 7
        '
        'txtAmount
        Me.txtAmount.Location = New Point(130, 142)
        Me.txtAmount.Name = "txtAmount"
        Me.txtAmount.ReadOnly = True
        Me.txtAmount.Size = New Size(60, 20)
        Me.txtAmount.TabIndex = 9
        '
        'txtCurrency
        Me.txtCurrency.Location = New Point(260, 142)
        Me.txtCurrency.Name = "txtCurrency"
        Me.txtCurrency.ReadOnly = True
        Me.txtCurrency.Size = New Size(50, 20)
        Me.txtCurrency.TabIndex = 11
        '
        'grpStatus
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Transaction Status:", .Location = New Point(10, 25), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtTransactionStatus)
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Batch Status:", .Location = New Point(10, 55), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtBatchStatus)
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Rejection Code:", .Location = New Point(10, 85), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtRejectionCode)
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Rejection Text:", .Location = New Point(10, 115), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtRejectionText)
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Remittance Ref:", .Location = New Point(10, 145), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtRemittanceRef)
        Me.grpStatus.Controls.Add(New Label() With {.Text = "Ref (20 chars):", .Location = New Point(10, 175), .AutoSize = True})
        Me.grpStatus.Controls.Add(Me.txtRemittanceRef20)
        Me.grpStatus.Location = New Point(12, 200)
        Me.grpStatus.Name = "grpStatus"
        Me.grpStatus.Size = New Size(380, 210)
        Me.grpStatus.TabIndex = 20
        Me.grpStatus.TabStop = False
        Me.grpStatus.Text = "Status & References"
        '
        'txtTransactionStatus
        Me.txtTransactionStatus.Location = New Point(130, 22)
        Me.txtTransactionStatus.Name = "txtTransactionStatus"
        Me.txtTransactionStatus.ReadOnly = True
        Me.txtTransactionStatus.Size = New Size(240, 20)
        Me.txtTransactionStatus.TabIndex = 1
        '
        'txtBatchStatus
        Me.txtBatchStatus.Location = New Point(130, 52)
        Me.txtBatchStatus.Name = "txtBatchStatus"
        Me.txtBatchStatus.ReadOnly = True
        Me.txtBatchStatus.Size = New Size(240, 20)
        Me.txtBatchStatus.TabIndex = 3
        '
        'txtRejectionCode
        Me.txtRejectionCode.Location = New Point(130, 82)
        Me.txtRejectionCode.Name = "txtRejectionCode"
        Me.txtRejectionCode.ReadOnly = True
        Me.txtRejectionCode.Size = New Size(240, 20)
        Me.txtRejectionCode.TabIndex = 5
        '
        'txtRejectionText
        Me.txtRejectionText.Location = New Point(130, 112)
        Me.txtRejectionText.Multiline = True
        Me.txtRejectionText.Name = "txtRejectionText"
        Me.txtRejectionText.ReadOnly = True
        Me.txtRejectionText.Size = New Size(240, 50)
        Me.txtRejectionText.TabIndex = 7
        '
        'txtRemittanceRef
        Me.txtRemittanceRef.Location = New Point(130, 142)
        Me.txtRemittanceRef.Name = "txtRemittanceRef"
        Me.txtRemittanceRef.ReadOnly = True
        Me.txtRemittanceRef.Size = New Size(240, 20)
        Me.txtRemittanceRef.TabIndex = 9
        '
        'txtRemittanceRef20
        Me.txtRemittanceRef20.Location = New Point(130, 172)
        Me.txtRemittanceRef20.Name = "txtRemittanceRef20"
        Me.txtRemittanceRef20.ReadOnly = True
        Me.txtRemittanceRef20.Size = New Size(240, 20)
        Me.txtRemittanceRef20.TabIndex = 11
        '
        'grpDates
        Me.grpDates.Controls.Add(New Label() With {.Text = "Debtor Account:", .Location = New Point(10, 25), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtDebtorAccount)
        Me.grpDates.Controls.Add(New Label() With {.Text = "Proof Email:", .Location = New Point(10, 55), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtProofEmail)
        Me.grpDates.Controls.Add(New Label() With {.Text = "Requested Date:", .Location = New Point(10, 85), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtRequestedDate)
        Me.grpDates.Controls.Add(New Label() With {.Text = "Created Date:", .Location = New Point(10, 115), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtCreatedDate)
        Me.grpDates.Controls.Add(New Label() With {.Text = "Processed Date:", .Location = New Point(10, 145), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtProcessedDate)
        Me.grpDates.Controls.Add(Me.chkIsPosted)
        Me.grpDates.Controls.Add(New Label() With {.Text = "Journal ID:", .Location = New Point(10, 205), .AutoSize = True})
        Me.grpDates.Controls.Add(Me.txtJournalID)
        Me.grpDates.Location = New Point(410, 200)
        Me.grpDates.Name = "grpDates"
        Me.grpDates.Size = New Size(380, 210)
        Me.grpDates.TabIndex = 30
        Me.grpDates.TabStop = False
        Me.grpDates.Text = "Dates & Posting"
        '
        'txtDebtorAccount
        Me.txtDebtorAccount.Location = New Point(130, 22)
        Me.txtDebtorAccount.Name = "txtDebtorAccount"
        Me.txtDebtorAccount.ReadOnly = True
        Me.txtDebtorAccount.Size = New Size(240, 20)
        Me.txtDebtorAccount.TabIndex = 1
        '
        'txtProofEmail
        Me.txtProofEmail.Location = New Point(130, 52)
        Me.txtProofEmail.Name = "txtProofEmail"
        Me.txtProofEmail.ReadOnly = True
        Me.txtProofEmail.Size = New Size(240, 20)
        Me.txtProofEmail.TabIndex = 3
        '
        'txtRequestedDate
        Me.txtRequestedDate.Location = New Point(130, 82)
        Me.txtRequestedDate.Name = "txtRequestedDate"
        Me.txtRequestedDate.ReadOnly = True
        Me.txtRequestedDate.Size = New Size(240, 20)
        Me.txtRequestedDate.TabIndex = 5
        '
        'txtCreatedDate
        Me.txtCreatedDate.Location = New Point(130, 112)
        Me.txtCreatedDate.Name = "txtCreatedDate"
        Me.txtCreatedDate.ReadOnly = True
        Me.txtCreatedDate.Size = New Size(240, 20)
        Me.txtCreatedDate.TabIndex = 7
        '
        'txtProcessedDate
        Me.txtProcessedDate.Location = New Point(130, 142)
        Me.txtProcessedDate.Name = "txtProcessedDate"
        Me.txtProcessedDate.ReadOnly = True
        Me.txtProcessedDate.Size = New Size(240, 20)
        Me.txtProcessedDate.TabIndex = 9
        '
        'chkIsPosted
        Me.chkIsPosted.AutoSize = True
        Me.chkIsPosted.Enabled = False
        Me.chkIsPosted.Location = New Point(10, 175)
        Me.chkIsPosted.Name = "chkIsPosted"
        Me.chkIsPosted.Size = New Size(120, 17)
        Me.chkIsPosted.TabIndex = 10
        Me.chkIsPosted.Text = "Posted to Journals"
        Me.chkIsPosted.UseVisualStyleBackColor = True
        '
        'txtJournalID
        Me.txtJournalID.Location = New Point(130, 172)
        Me.txtJournalID.Name = "txtJournalID"
        Me.txtJournalID.ReadOnly = True
        Me.txtJournalID.Size = New Size(240, 20)
        Me.txtJournalID.TabIndex = 12
        '
        'grpHistory
        Me.grpHistory.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpHistory.Controls.Add(Me.dgvStatusHistory)
        Me.grpHistory.Location = New Point(12, 420)
        Me.grpHistory.Name = "grpHistory"
        Me.grpHistory.Size = New Size(778, 180)
        Me.grpHistory.TabIndex = 40
        Me.grpHistory.TabStop = False
        Me.grpHistory.Text = "Status History"
        '
        'dgvStatusHistory
        Me.dgvStatusHistory.AllowUserToAddRows = False
        Me.dgvStatusHistory.AllowUserToDeleteRows = False
        Me.dgvStatusHistory.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvStatusHistory.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvStatusHistory.Location = New Point(10, 20)
        Me.dgvStatusHistory.Name = "dgvStatusHistory"
        Me.dgvStatusHistory.ReadOnly = True
        Me.dgvStatusHistory.Size = New Size(760, 150)
        Me.dgvStatusHistory.TabIndex = 0
        '
        'btnClose
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.Location = New Point(710, 610)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New Size(80, 30)
        Me.btnClose.TabIndex = 50
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = True
        '
        'FNBTransactionDetailsForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(802, 652)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.grpHistory)
        Me.Controls.Add(Me.grpDates)
        Me.Controls.Add(Me.grpStatus)
        Me.Controls.Add(Me.grpCreditor)
        Me.Controls.Add(Me.grpTransaction)
        Me.Name = "FNBTransactionDetailsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "FNB Payment Transaction Details"
        CType(Me.dgvStatusHistory, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpTransaction.ResumeLayout(False)
        Me.grpTransaction.PerformLayout()
        Me.grpCreditor.ResumeLayout(False)
        Me.grpCreditor.PerformLayout()
        Me.grpStatus.ResumeLayout(False)
        Me.grpStatus.PerformLayout()
        Me.grpDates.ResumeLayout(False)
        Me.grpDates.PerformLayout()
        Me.grpHistory.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
End Class

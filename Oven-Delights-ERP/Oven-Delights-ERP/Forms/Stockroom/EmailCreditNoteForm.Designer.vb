<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class EmailCreditNoteForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
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
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.txtToEmail = New System.Windows.Forms.TextBox()
        Me.txtCCEmail = New System.Windows.Forms.TextBox()
        Me.txtSubject = New System.Windows.Forms.TextBox()
        Me.txtMessage = New System.Windows.Forms.TextBox()
        Me.lblToEmail = New System.Windows.Forms.Label()
        Me.lblCCEmail = New System.Windows.Forms.Label()
        Me.lblSubject = New System.Windows.Forms.Label()
        Me.lblMessage = New System.Windows.Forms.Label()
        Me.chkAttachPDF = New System.Windows.Forms.CheckBox()
        Me.btnSend = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblCreditNoteNumber = New System.Windows.Forms.Label()
        Me.txtCreditNoteNumber = New System.Windows.Forms.TextBox()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.txtSupplier = New System.Windows.Forms.TextBox()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlHeader.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtToEmail
        '
        Me.txtToEmail.Location = New System.Drawing.Point(100, 20)
        Me.txtToEmail.Name = "txtToEmail"
        Me.txtToEmail.Size = New System.Drawing.Size(300, 20)
        Me.txtToEmail.TabIndex = 0
        '
        'txtCCEmail
        '
        Me.txtCCEmail.Location = New System.Drawing.Point(100, 50)
        Me.txtCCEmail.Name = "txtCCEmail"
        Me.txtCCEmail.Size = New System.Drawing.Size(300, 20)
        Me.txtCCEmail.TabIndex = 1
        '
        'txtSubject
        '
        Me.txtSubject.Location = New System.Drawing.Point(100, 80)
        Me.txtSubject.Name = "txtSubject"
        Me.txtSubject.Size = New System.Drawing.Size(400, 20)
        Me.txtSubject.TabIndex = 2
        '
        'txtMessage
        '
        Me.txtMessage.Location = New System.Drawing.Point(100, 110)
        Me.txtMessage.Multiline = True
        Me.txtMessage.Name = "txtMessage"
        Me.txtMessage.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtMessage.Size = New System.Drawing.Size(400, 150)
        Me.txtMessage.TabIndex = 3
        '
        'lblToEmail
        '
        Me.lblToEmail.AutoSize = True
        Me.lblToEmail.Location = New System.Drawing.Point(20, 23)
        Me.lblToEmail.Name = "lblToEmail"
        Me.lblToEmail.Size = New System.Drawing.Size(23, 13)
        Me.lblToEmail.TabIndex = 4
        Me.lblToEmail.Text = "To:"
        '
        'lblCCEmail
        '
        Me.lblCCEmail.AutoSize = True
        Me.lblCCEmail.Location = New System.Drawing.Point(20, 53)
        Me.lblCCEmail.Name = "lblCCEmail"
        Me.lblCCEmail.Size = New System.Drawing.Size(24, 13)
        Me.lblCCEmail.TabIndex = 5
        Me.lblCCEmail.Text = "CC:"
        '
        'lblSubject
        '
        Me.lblSubject.AutoSize = True
        Me.lblSubject.Location = New System.Drawing.Point(20, 83)
        Me.lblSubject.Name = "lblSubject"
        Me.lblSubject.Size = New System.Drawing.Size(46, 13)
        Me.lblSubject.TabIndex = 6
        Me.lblSubject.Text = "Subject:"
        '
        'lblMessage
        '
        Me.lblMessage.AutoSize = True
        Me.lblMessage.Location = New System.Drawing.Point(20, 113)
        Me.lblMessage.Name = "lblMessage"
        Me.lblMessage.Size = New System.Drawing.Size(53, 13)
        Me.lblMessage.TabIndex = 7
        Me.lblMessage.Text = "Message:"
        '
        'chkAttachPDF
        '
        Me.chkAttachPDF.AutoSize = True
        Me.chkAttachPDF.Checked = True
        Me.chkAttachPDF.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkAttachPDF.Location = New System.Drawing.Point(100, 270)
        Me.chkAttachPDF.Name = "chkAttachPDF"
        Me.chkAttachPDF.Size = New System.Drawing.Size(82, 17)
        Me.chkAttachPDF.TabIndex = 8
        Me.chkAttachPDF.Text = "Attach PDF"
        Me.chkAttachPDF.UseVisualStyleBackColor = True
        '
        'btnSend
        '
        Me.btnSend.Location = New System.Drawing.Point(344, 10)
        Me.btnSend.Name = "btnSend"
        Me.btnSend.Size = New System.Drawing.Size(75, 23)
        Me.btnSend.TabIndex = 9
        Me.btnSend.Text = "Send"
        Me.btnSend.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(425, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 10
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblCreditNoteNumber
        '
        Me.lblCreditNoteNumber.AutoSize = True
        Me.lblCreditNoteNumber.Location = New System.Drawing.Point(20, 23)
        Me.lblCreditNoteNumber.Name = "lblCreditNoteNumber"
        Me.lblCreditNoteNumber.Size = New System.Drawing.Size(105, 13)
        Me.lblCreditNoteNumber.TabIndex = 11
        Me.lblCreditNoteNumber.Text = "Credit Note Number:"
        '
        'txtCreditNoteNumber
        '
        Me.txtCreditNoteNumber.Location = New System.Drawing.Point(140, 20)
        Me.txtCreditNoteNumber.Name = "txtCreditNoteNumber"
        Me.txtCreditNoteNumber.ReadOnly = True
        Me.txtCreditNoteNumber.Size = New System.Drawing.Size(150, 20)
        Me.txtCreditNoteNumber.TabIndex = 12
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(320, 23)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 13
        Me.lblSupplier.Text = "Supplier:"
        '
        'txtSupplier
        '
        Me.txtSupplier.Location = New System.Drawing.Point(380, 20)
        Me.txtSupplier.Name = "txtSupplier"
        Me.txtSupplier.ReadOnly = True
        Me.txtSupplier.Size = New System.Drawing.Size(200, 20)
        Me.txtSupplier.TabIndex = 14
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblCreditNoteNumber)
        Me.pnlHeader.Controls.Add(Me.txtSupplier)
        Me.pnlHeader.Controls.Add(Me.txtCreditNoteNumber)
        Me.pnlHeader.Controls.Add(Me.lblSupplier)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(600, 60)
        Me.pnlHeader.TabIndex = 15
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.lblToEmail)
        Me.pnlMain.Controls.Add(Me.txtToEmail)
        Me.pnlMain.Controls.Add(Me.lblCCEmail)
        Me.pnlMain.Controls.Add(Me.txtCCEmail)
        Me.pnlMain.Controls.Add(Me.lblSubject)
        Me.pnlMain.Controls.Add(Me.txtSubject)
        Me.pnlMain.Controls.Add(Me.lblMessage)
        Me.pnlMain.Controls.Add(Me.txtMessage)
        Me.pnlMain.Controls.Add(Me.chkAttachPDF)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 60)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(600, 300)
        Me.pnlMain.TabIndex = 16
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnSend)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 360)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(600, 43)
        Me.pnlButtons.TabIndex = 17
        '
        'EmailCreditNoteForm
        '
        Me.AcceptButton = Me.btnSend
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(600, 403)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlHeader)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "EmailCreditNoteForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Email Credit Note"
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.pnlMain.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents txtToEmail As TextBox
    Friend WithEvents txtCCEmail As TextBox
    Friend WithEvents txtSubject As TextBox
    Friend WithEvents txtMessage As TextBox
    Friend WithEvents lblToEmail As Label
    Friend WithEvents lblCCEmail As Label
    Friend WithEvents lblSubject As Label
    Friend WithEvents lblMessage As Label
    Friend WithEvents chkAttachPDF As CheckBox
    Friend WithEvents btnSend As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblCreditNoteNumber As Label
    Friend WithEvents txtCreditNoteNumber As TextBox
    Friend WithEvents lblSupplier As Label
    Friend WithEvents txtSupplier As TextBox
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlButtons As Panel

End Class

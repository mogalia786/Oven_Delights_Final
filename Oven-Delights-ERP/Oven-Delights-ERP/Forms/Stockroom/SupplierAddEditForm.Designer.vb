<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SupplierAddEditForm
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
        Me.components = New System.ComponentModel.Container()
        Me.SuspendLayout()
        '
        'SupplierAddEditForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 750)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "SupplierAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Supplier Details"
        Me.ResumeLayout(False)
    End Sub

    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents txtCompanyName As TextBox
    Friend WithEvents txtContactPerson As TextBox
    Friend WithEvents txtEmail As TextBox
    Friend WithEvents txtPhone As TextBox
    Friend WithEvents txtMobile As TextBox
    Friend WithEvents txtCity As TextBox
    Friend WithEvents txtProvince As TextBox
    Friend WithEvents txtPostalCode As TextBox
    Friend WithEvents txtCountry As TextBox
    Friend WithEvents txtVATNumber As TextBox
    Friend WithEvents txtPaymentTermsDays As TextBox
    Friend WithEvents txtCreditLimit As TextBox
    Friend WithEvents txtAddress As TextBox
    Friend WithEvents txtBankName As TextBox
    Friend WithEvents txtBranchCode As TextBox
    Friend WithEvents txtAccountNumber As TextBox
    Friend WithEvents txtPaymentTerms As TextBox
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents txtSupplierCode As TextBox
    Friend WithEvents cboAccountType As ComboBox
    Friend WithEvents txtProofOfPaymentEmail As TextBox
    Friend WithEvents chkIsActive As CheckBox

End Class

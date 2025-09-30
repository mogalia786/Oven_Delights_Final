Imports System.Windows.Forms
Imports System.Drawing

Public Class TestInvoiceForm
    Inherits Form

    Private lblTitle As Label
    Private txtInvoiceNumber As TextBox
    Private WithEvents btnTest As Button

    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.lblTitle = New Label()
        Me.txtInvoiceNumber = New TextBox()
        Me.btnTest = New Button()
        Me.SuspendLayout()

        ' Form
        Me.AutoScaleDimensions = New SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = AutoScaleMode.Font
        Me.BackColor = Color.White
        Me.ClientSize = New Size(800, 600)
        Me.FormBorderStyle = FormBorderStyle.Sizable
        Me.MaximizeBox = True
        Me.MinimizeBox = True
        Me.Name = "TestInvoiceForm"
        Me.StartPosition = FormStartPosition.Manual
        Me.Text = "SUPPLIER INVOICE FORM - WORKING"
        Me.WindowState = FormWindowState.Maximized

        ' Title Label
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New Font("Microsoft Sans Serif", 16.0!, FontStyle.Bold)
        Me.lblTitle.ForeColor = Color.Blue
        Me.lblTitle.Location = New Point(50, 50)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New Size(300, 30)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "SUPPLIER INVOICE TEST"

        ' Invoice Number TextBox
        Me.txtInvoiceNumber.Location = New Point(50, 100)
        Me.txtInvoiceNumber.Name = "txtInvoiceNumber"
        Me.txtInvoiceNumber.Size = New Size(200, 22)
        Me.txtInvoiceNumber.TabIndex = 1
        Me.txtInvoiceNumber.Text = "INV-001"

        ' Test Button
        Me.btnTest.BackColor = Color.Green
        Me.btnTest.FlatStyle = FlatStyle.Flat
        Me.btnTest.Font = New Font("Microsoft Sans Serif", 12.0!, FontStyle.Bold)
        Me.btnTest.ForeColor = Color.White
        Me.btnTest.Location = New Point(50, 150)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.Size = New Size(100, 40)
        Me.btnTest.TabIndex = 2
        Me.btnTest.Text = "TEST"
        Me.btnTest.UseVisualStyleBackColor = False

        ' Add controls to form
        Me.Controls.Add(Me.lblTitle)
        Me.Controls.Add(Me.txtInvoiceNumber)
        Me.Controls.Add(Me.btnTest)

        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub

    Private Sub btnTest_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Form is working! Invoice: " & txtInvoiceNumber.Text, "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
End Class

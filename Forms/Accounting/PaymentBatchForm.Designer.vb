Imports System.Windows.Forms

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class PaymentBatchForm
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

    Friend WithEvents dgv As DataGridView
    Friend WithEvents cboBank As ComboBox
    Friend WithEvents cboFormat As ComboBox
    Friend WithEvents btnLoad As Button
    Friend WithEvents btnValidate As Button
    Friend WithEvents btnExport As Button
    Friend WithEvents btnPost As Button
    Friend WithEvents lblBank As Label
    Friend WithEvents lblFormat As Label

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.dgv = New System.Windows.Forms.DataGridView()
        Me.cboBank = New System.Windows.Forms.ComboBox()
        Me.cboFormat = New System.Windows.Forms.ComboBox()
        Me.btnLoad = New System.Windows.Forms.Button()
        Me.btnValidate = New System.Windows.Forms.Button()
        Me.btnExport = New System.Windows.Forms.Button()
        Me.btnPost = New System.Windows.Forms.Button()
        Me.lblBank = New System.Windows.Forms.Label()
        Me.lblFormat = New System.Windows.Forms.Label()
        CType(Me.dgv, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblBank
        Me.lblBank.AutoSize = True
        Me.lblBank.Location = New System.Drawing.Point(12, 13)
        Me.lblBank.Name = "lblBank"
        Me.lblBank.Size = New System.Drawing.Size(35, 13)
        Me.lblBank.TabIndex = 0
        Me.lblBank.Text = "Bank"
        '
        'cboBank
        Me.cboBank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBank.FormattingEnabled = True
        Me.cboBank.Items.AddRange(New Object() {"FNB", "Standard Bank", "ABSA", "Nedbank"})
        Me.cboBank.Location = New System.Drawing.Point(60, 10)
        Me.cboBank.Name = "cboBank"
        Me.cboBank.Size = New System.Drawing.Size(140, 21)
        Me.cboBank.TabIndex = 1
        '
        'lblFormat
        Me.lblFormat.AutoSize = True
        Me.lblFormat.Location = New System.Drawing.Point(220, 13)
        Me.lblFormat.Name = "lblFormat"
        Me.lblFormat.Size = New System.Drawing.Size(39, 13)
        Me.lblFormat.TabIndex = 2
        Me.lblFormat.Text = "Format"
        '
        'cboFormat
        Me.cboFormat.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFormat.FormattingEnabled = True
        Me.cboFormat.Items.AddRange(New Object() {"PAIN.001", "CSV"})
        Me.cboFormat.Location = New System.Drawing.Point(265, 10)
        Me.cboFormat.Name = "cboFormat"
        Me.cboFormat.Size = New System.Drawing.Size(121, 21)
        Me.cboFormat.TabIndex = 3
        '
        'btnLoad
        Me.btnLoad.Location = New System.Drawing.Point(410, 9)
        Me.btnLoad.Name = "btnLoad"
        Me.btnLoad.Size = New System.Drawing.Size(60, 23)
        Me.btnLoad.TabIndex = 4
        Me.btnLoad.Text = "Load"
        Me.btnLoad.UseVisualStyleBackColor = True
        '
        'btnValidate
        Me.btnValidate.Location = New System.Drawing.Point(476, 9)
        Me.btnValidate.Name = "btnValidate"
        Me.btnValidate.Size = New System.Drawing.Size(65, 23)
        Me.btnValidate.TabIndex = 5
        Me.btnValidate.Text = "Validate"
        Me.btnValidate.UseVisualStyleBackColor = True
        '
        'btnExport
        Me.btnExport.Location = New System.Drawing.Point(547, 9)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(60, 23)
        Me.btnExport.TabIndex = 6
        Me.btnExport.Text = "Export"
        Me.btnExport.UseVisualStyleBackColor = True
        '
        'btnPost
        Me.btnPost.Location = New System.Drawing.Point(613, 9)
        Me.btnPost.Name = "btnPost"
        Me.btnPost.Size = New System.Drawing.Size(60, 23)
        Me.btnPost.TabIndex = 7
        Me.btnPost.Text = "Post"
        Me.btnPost.UseVisualStyleBackColor = True
        '
        'dgv
        Me.dgv.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgv.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgv.Location = New System.Drawing.Point(12, 42)
        Me.dgv.Name = "dgv"
        Me.dgv.Size = New System.Drawing.Size(776, 396)
        Me.dgv.TabIndex = 8
        '
        'PaymentBatchForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.dgv)
        Me.Controls.Add(Me.btnPost)
        Me.Controls.Add(Me.btnExport)
        Me.Controls.Add(Me.btnValidate)
        Me.Controls.Add(Me.btnLoad)
        Me.Controls.Add(Me.cboFormat)
        Me.Controls.Add(Me.lblFormat)
        Me.Controls.Add(Me.cboBank)
        Me.Controls.Add(Me.lblBank)
        Me.Name = "PaymentBatchForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Payment Batch"
        CType(Me.dgv, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
End Class

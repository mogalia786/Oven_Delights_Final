<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class SQLBatchSplitter
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
        Me.lblInstructions = New System.Windows.Forms.Label()
        Me.txtInput = New System.Windows.Forms.TextBox()
        Me.txtOutput = New System.Windows.Forms.TextBox()
        Me.btnLoadFile = New System.Windows.Forms.Button()
        Me.btnSplit = New System.Windows.Forms.Button()
        Me.btnCopyOutput = New System.Windows.Forms.Button()
        Me.btnSaveOutput = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.lblStatus = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtBatchSize = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'lblInstructions
        '
        Me.lblInstructions.AutoSize = True
        Me.lblInstructions.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.lblInstructions.Location = New System.Drawing.Point(12, 9)
        Me.lblInstructions.Name = "lblInstructions"
        Me.lblInstructions.Size = New System.Drawing.Size(450, 15)
        Me.lblInstructions.TabIndex = 0
        Me.lblInstructions.Text = "Paste your large INSERT statement below. It will be automatically split into batches."
        '
        'txtInput
        '
        Me.txtInput.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtInput.Font = New System.Drawing.Font("Consolas", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.txtInput.Location = New System.Drawing.Point(12, 70)
        Me.txtInput.Multiline = True
        Me.txtInput.Name = "txtInput"
        Me.txtInput.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtInput.Size = New System.Drawing.Size(960, 250)
        Me.txtInput.TabIndex = 1
        Me.txtInput.WordWrap = False
        '
        'txtOutput
        '
        Me.txtOutput.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtOutput.Font = New System.Drawing.Font("Consolas", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.txtOutput.Location = New System.Drawing.Point(12, 406)
        Me.txtOutput.Multiline = True
        Me.txtOutput.Name = "txtOutput"
        Me.txtOutput.ReadOnly = True
        Me.txtOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtOutput.Size = New System.Drawing.Size(960, 250)
        Me.txtOutput.TabIndex = 2
        Me.txtOutput.WordWrap = False
        '
        'btnLoadFile
        '
        Me.btnLoadFile.Location = New System.Drawing.Point(12, 35)
        Me.btnLoadFile.Name = "btnLoadFile"
        Me.btnLoadFile.Size = New System.Drawing.Size(120, 30)
        Me.btnLoadFile.TabIndex = 3
        Me.btnLoadFile.Text = "Load from File"
        Me.btnLoadFile.UseVisualStyleBackColor = True
        '
        'btnSplit
        '
        Me.btnSplit.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSplit.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnSplit.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSplit.Font = New System.Drawing.Font("Segoe UI", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.btnSplit.ForeColor = System.Drawing.Color.White
        Me.btnSplit.Location = New System.Drawing.Point(832, 326)
        Me.btnSplit.Name = "btnSplit"
        Me.btnSplit.Size = New System.Drawing.Size(140, 40)
        Me.btnSplit.TabIndex = 4
        Me.btnSplit.Text = "Split into Batches"
        Me.btnSplit.UseVisualStyleBackColor = False
        '
        'btnCopyOutput
        '
        Me.btnCopyOutput.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnCopyOutput.Location = New System.Drawing.Point(12, 662)
        Me.btnCopyOutput.Name = "btnCopyOutput"
        Me.btnCopyOutput.Size = New System.Drawing.Size(120, 30)
        Me.btnCopyOutput.TabIndex = 5
        Me.btnCopyOutput.Text = "Copy to Clipboard"
        Me.btnCopyOutput.UseVisualStyleBackColor = True
        '
        'btnSaveOutput
        '
        Me.btnSaveOutput.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnSaveOutput.Location = New System.Drawing.Point(138, 662)
        Me.btnSaveOutput.Name = "btnSaveOutput"
        Me.btnSaveOutput.Size = New System.Drawing.Size(120, 30)
        Me.btnSaveOutput.TabIndex = 6
        Me.btnSaveOutput.Text = "Save to File"
        Me.btnSaveOutput.UseVisualStyleBackColor = True
        '
        'btnClear
        '
        Me.btnClear.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClear.Location = New System.Drawing.Point(852, 662)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(120, 30)
        Me.btnClear.TabIndex = 7
        Me.btnClear.Text = "Clear All"
        Me.btnClear.UseVisualStyleBackColor = True
        '
        'lblStatus
        '
        Me.lblStatus.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point)
        Me.lblStatus.ForeColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.lblStatus.Location = New System.Drawing.Point(264, 669)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(39, 15)
        Me.lblStatus.TabIndex = 8
        Me.lblStatus.Text = "Ready"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.Label1.Location = New System.Drawing.Point(12, 50)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(191, 17)
        Me.Label1.TabIndex = 9
        Me.Label1.Text = "INPUT (Large INSERT Statement)"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.Label2.Location = New System.Drawing.Point(12, 386)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(176, 17)
        Me.Label2.TabIndex = 10
        Me.Label2.Text = "OUTPUT (Batched Statements)"
        '
        'txtBatchSize
        '
        Me.txtBatchSize.Location = New System.Drawing.Point(12, 352)
        Me.txtBatchSize.Name = "txtBatchSize"
        Me.txtBatchSize.Size = New System.Drawing.Size(100, 23)
        Me.txtBatchSize.TabIndex = 11
        Me.txtBatchSize.Text = "1000"
        Me.txtBatchSize.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 334)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(103, 15)
        Me.Label3.TabIndex = 12
        Me.Label3.Text = "Rows per Batch:"
        '
        'SQLBatchSplitter
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(984, 704)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.txtBatchSize)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.btnClear)
        Me.Controls.Add(Me.btnSaveOutput)
        Me.Controls.Add(Me.btnCopyOutput)
        Me.Controls.Add(Me.btnSplit)
        Me.Controls.Add(Me.btnLoadFile)
        Me.Controls.Add(Me.txtOutput)
        Me.Controls.Add(Me.txtInput)
        Me.Controls.Add(Me.lblInstructions)
        Me.Name = "SQLBatchSplitter"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "SQL Batch Splitter"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblInstructions As Label
    Friend WithEvents txtInput As TextBox
    Friend WithEvents txtOutput As TextBox
    Friend WithEvents btnLoadFile As Button
    Friend WithEvents btnSplit As Button
    Friend WithEvents btnCopyOutput As Button
    Friend WithEvents btnSaveOutput As Button
    Friend WithEvents btnClear As Button
    Friend WithEvents lblStatus As Label
    Friend WithEvents Label1 As Label
    Friend WithEvents Label2 As Label
    Friend WithEvents txtBatchSize As TextBox
    Friend WithEvents Label3 As Label
End Class

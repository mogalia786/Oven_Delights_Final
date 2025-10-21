Imports System.Drawing
Imports System.Windows.Forms

Public Class DepositAmountForm
    Inherits Form
    Private _totalAmount As Decimal
    Private _depositAmount As Decimal
    
    Public Property DepositAmount As Decimal
        Get
            Return _depositAmount
        End Get
        Set(value As Decimal)
            _depositAmount = value
        End Set
    End Property
    
    Public Sub New(totalAmount As Decimal)
        _totalAmount = totalAmount
        InitializeComponent()
        SetupUI()
    End Sub

    Private Sub InitializeComponent()
        ' Form properties
        Me.Text = "Deposit Amount"
        Me.Size = New Size(400, 300)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.White
        
        ' Create controls and add to form
        Dim lblTotal As New Label()
        lblTotal.Text = $"Total Amount: {_totalAmount:C}"
        lblTotal.Location = New Point(20, 20)
        lblTotal.Size = New Size(200, 23)
        
        Dim lblDeposit As New Label()
        lblDeposit.Text = "Deposit Amount:"
        lblDeposit.Location = New Point(20, 60)
        lblDeposit.Size = New Size(100, 23)
        
        Dim txtDeposit As New TextBox()
        txtDeposit.Location = New Point(130, 58)
        txtDeposit.Size = New Size(100, 23)
        txtDeposit.Name = "txtDeposit"
        
        Dim btnOK As New Button()
        btnOK.Text = "OK"
        btnOK.Location = New Point(150, 120)
        btnOK.Size = New Size(75, 23)
        btnOK.DialogResult = DialogResult.OK
        
        Dim btnCancel As New Button()
        btnCancel.Text = "Cancel"
        btnCancel.Location = New Point(240, 120)
        btnCancel.Size = New Size(75, 23)
        btnCancel.DialogResult = DialogResult.Cancel
        
        Me.Controls.Add(lblTotal)
        Me.Controls.Add(lblDeposit)
        Me.Controls.Add(txtDeposit)
        Me.Controls.Add(btnOK)
        Me.Controls.Add(btnCancel)
        
        Me.AcceptButton = btnOK
        Me.CancelButton = btnCancel
    End Sub
    
    Private Sub SetupUI()
        Me.Text = "Enter Deposit Amount"
        Me.Size = New Size(400, 300)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.FromArgb(240, 240, 240)
        
        ' Main panel
        Dim mainPanel As New TableLayoutPanel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20),
            .RowCount = 6,
            .ColumnCount = 1
        }
        
        ' Title label
        Dim titleLabel As New Label With {
            .Text = "Custom Order Deposit",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94),
            .TextAlign = ContentAlignment.MiddleCenter,
            .Dock = DockStyle.Fill
        }
        
        ' Total amount label
        Dim totalLabel As New Label With {
            .Text = $"Total Order Amount: {_totalAmount:C2}",
            .Font = New Font("Segoe UI", 12, FontStyle.Regular),
            .ForeColor = Color.FromArgb(52, 73, 94),
            .TextAlign = ContentAlignment.MiddleCenter,
            .Dock = DockStyle.Fill
        }
        
        ' Deposit input label
        Dim depositLabel As New Label With {
            .Text = "Enter Deposit Amount:",
            .Font = New Font("Segoe UI", 11, FontStyle.Regular),
            .ForeColor = Color.FromArgb(52, 73, 94),
            .TextAlign = ContentAlignment.MiddleLeft,
            .Dock = DockStyle.Fill
        }
        
        ' Deposit amount textbox
        Dim depositTextBox As New TextBox With {
            .Name = "depositTextBox",
            .Font = New Font("Segoe UI", 14, FontStyle.Regular),
            .TextAlign = HorizontalAlignment.Right,
            .Dock = DockStyle.Fill,
            .Height = 40
        }
        
        ' Balance label
        Dim balanceLabel As New Label With {
            .Name = "balanceLabel",
            .Text = "Balance Owing: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(231, 76, 60),
            .TextAlign = ContentAlignment.MiddleCenter,
            .Dock = DockStyle.Fill
        }
        
        ' Button panel
        Dim buttonPanel As New FlowLayoutPanel With {
            .FlowDirection = FlowDirection.LeftToRight,
            .Dock = DockStyle.Fill,
            .Padding = New Padding(0, 10, 0, 0)
        }
        
        ' Quick amount buttons
        Dim quickPanel As New FlowLayoutPanel With {
            .FlowDirection = FlowDirection.LeftToRight,
            .Dock = DockStyle.Fill,
            .Height = 50
        }
        
        ' Add quick amount buttons (10%, 25%, 50%)
        AddQuickButton(quickPanel, "10%", _totalAmount * 0.1D, depositTextBox, balanceLabel)
        AddQuickButton(quickPanel, "25%", _totalAmount * 0.25D, depositTextBox, balanceLabel)
        AddQuickButton(quickPanel, "50%", _totalAmount * 0.5D, depositTextBox, balanceLabel)
        
        ' OK and Cancel buttons
        Dim okButton As New Button With {
            .Text = "Accept Deposit",
            .Size = New Size(120, 40),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .FlatStyle = FlatStyle.Flat,
            .DialogResult = DialogResult.OK
        }
        okButton.FlatAppearance.BorderSize = 0
        
        Dim cancelButton As New Button With {
            .Text = "Cancel",
            .Size = New Size(100, 40),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .FlatStyle = FlatStyle.Flat,
            .DialogResult = DialogResult.Cancel
        }
        cancelButton.FlatAppearance.BorderSize = 0
        
        buttonPanel.Controls.Add(okButton)
        buttonPanel.Controls.Add(cancelButton)
        
        ' Event handlers
        AddHandler depositTextBox.TextChanged, Sub() UpdateBalance(depositTextBox, balanceLabel)
        AddHandler okButton.Click, Sub() ValidateAndAccept(depositTextBox)
        
        ' Add controls to main panel
        mainPanel.Controls.Add(titleLabel, 0, 0)
        mainPanel.Controls.Add(totalLabel, 0, 1)
        mainPanel.Controls.Add(depositLabel, 0, 2)
        mainPanel.Controls.Add(depositTextBox, 0, 3)
        mainPanel.Controls.Add(quickPanel, 0, 4)
        mainPanel.Controls.Add(balanceLabel, 0, 5)
        mainPanel.Controls.Add(buttonPanel, 0, 6)
        
        ' Set row styles
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        mainPanel.RowStyles.Add(New RowStyle(SizeType.Percent, 100))
        
        Me.Controls.Add(mainPanel)
        
        ' Set default deposit to 25%
        depositTextBox.Text = (_totalAmount * 0.25D).ToString("F2")
        UpdateBalance(depositTextBox, balanceLabel)
        depositTextBox.SelectAll()
        depositTextBox.Focus()
    End Sub
    
    Private Sub AddQuickButton(parent As FlowLayoutPanel, text As String, amount As Decimal, depositTextBox As TextBox, balanceLabel As Label)
        Dim btn As New Button With {
            .Text = $"{text} ({amount:C0})",
            .Size = New Size(100, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .FlatStyle = FlatStyle.Flat,
            .Margin = New Padding(5, 0, 5, 0)
        }
        btn.FlatAppearance.BorderSize = 0
        
        AddHandler btn.Click, Sub()
                                  depositTextBox.Text = amount.ToString("F2")
                                  UpdateBalance(depositTextBox, balanceLabel)
                              End Sub
        
        parent.Controls.Add(btn)
    End Sub
    
    Private Sub UpdateBalance(depositTextBox As TextBox, balanceLabel As Label)
        Dim depositValue As Decimal
        If Decimal.TryParse(depositTextBox.Text, depositValue) Then
            Dim balance = _totalAmount - depositValue
            balanceLabel.Text = $"Balance Owing: {balance:C2}"
            
            If depositValue > _totalAmount Then
                balanceLabel.ForeColor = Color.FromArgb(231, 76, 60)
                balanceLabel.Text = "Deposit cannot exceed total amount!"
            ElseIf depositValue <= 0 Then
                balanceLabel.ForeColor = Color.FromArgb(231, 76, 60)
                balanceLabel.Text = "Deposit must be greater than zero!"
            Else
                balanceLabel.ForeColor = Color.FromArgb(46, 204, 113)
            End If
        Else
            balanceLabel.Text = "Invalid deposit amount"
            balanceLabel.ForeColor = Color.FromArgb(231, 76, 60)
        End If
    End Sub
    
    Private Sub ValidateAndAccept(depositTextBox As TextBox)
        Dim depositValue As Decimal
        If Decimal.TryParse(depositTextBox.Text, depositValue) Then
            If depositValue > 0 AndAlso depositValue <= _totalAmount Then
                _depositAmount = depositValue
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Else
                MessageBox.Show("Please enter a valid deposit amount between R0.01 and the total amount.", "Invalid Deposit", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        Else
            MessageBox.Show("Please enter a valid numeric deposit amount.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End If
    End Sub
End Class

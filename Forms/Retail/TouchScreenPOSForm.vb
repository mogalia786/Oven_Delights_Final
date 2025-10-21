Imports Microsoft.Data.SqlClient
Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports System.Configuration

Public Class TouchScreenPOSForm
    Inherits Form
    Private _connectionString As String
    Private _currentTransaction As New List(Of POSLineItem)
    Private _currentTotal As Decimal = 0
    Private _selectedCategory As String = ""
    Private _selectedSubcategory As String = ""
    Private _isOrderMode As Boolean = False
    Private _currentCustomer As Customer
    Private _totalLabel As Label
    Private _cartGrid As DataGridView
    Private _modeLabel As Label
    Private btnClear As Button
    Private lstCart As ListBox
    Private _currentUser As User
    Private _currentCart As New List(Of CartItem)
    Private pnlProducts As Panel
    Private pnlCart As Panel
    Private lblTotal As Label
    Private btnCheckout As Button

    Public Sub New(currentUser As User)
        InitializeComponent()
        _currentUser = currentUser
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        LoadProducts()
        SetupTouchInterface()
    End Sub

    Private Sub InitializeComponent()
        ' Basic form setup
        Me.Text = "Touch Screen POS"
        Me.Size = New Size(1024, 768)
        Me.WindowState = FormWindowState.Maximized
        Me.FormBorderStyle = FormBorderStyle.None
        Me.BackColor = Color.White

        ' Create main panels
        pnlProducts = New Panel() With {
            .Location = New Point(10, 10),
            .Size = New Size(600, 600),
            .BackColor = Color.LightGray,
            .BorderStyle = BorderStyle.FixedSingle
        }

        pnlCart = New Panel() With {
            .Location = New Point(620, 10),
            .Size = New Size(380, 600),
            .BackColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle
        }

        ' Cart controls
        lstCart = New ListBox() With {
            .Location = New Point(10, 10),
            .Size = New Size(360, 400),
            .Font = New Font("Arial", 12)
        }

        lblTotal = New Label() With {
            .Location = New Point(10, 420),
            .Size = New Size(360, 40),
            .Text = "Total: R0.00",
            .Font = New Font("Arial", 16, FontStyle.Bold),
            .TextAlign = ContentAlignment.MiddleCenter,
            .BackColor = Color.LightBlue
        }

        btnCheckout = New Button() With {
            .Location = New Point(10, 470),
            .Size = New Size(170, 60),
            .Text = "CHECKOUT",
            .Font = New Font("Arial", 14, FontStyle.Bold),
            .BackColor = Color.Green,
            .ForeColor = Color.White
        }

        btnClear = New Button() With {
            .Location = New Point(190, 470),
            .Size = New Size(170, 60),
            .Text = "CLEAR",
            .Font = New Font("Arial", 14, FontStyle.Bold),
            .BackColor = Color.Red,
            .ForeColor = Color.White
        }

        ' Add event handlers
        AddHandler btnCheckout.Click, AddressOf btnCheckout_Click
        AddHandler btnClear.Click, AddressOf btnClear_Click

        ' Add controls to panels
        pnlCart.Controls.AddRange({lstCart, lblTotal, btnCheckout, btnClear})
        Me.Controls.AddRange({pnlProducts, pnlCart})
    End Sub

    Private Sub LoadProducts()
        ' Load products from database
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT ProductID, ProductName, Price FROM Products WHERE IsActive = 1"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        Dim x As Integer = 10
                        Dim y As Integer = 10
                        While reader.Read()
                            Dim btn As New Button() With {
                                .Size = New Size(120, 80),
                                .Location = New Point(x, y),
                                .Text = reader("ProductName").ToString() & vbCrLf & "R" & reader("Price").ToString(),
                                .Font = New Font("Arial", 10, FontStyle.Bold),
                                .BackColor = Color.LightBlue,
                                .Tag = New With {.ID = reader("ProductID"), .Name = reader("ProductName"), .Price = Convert.ToDecimal(reader("Price"))}
                            }
                            AddHandler btn.Click, AddressOf ProductButton_Click
                            pnlProducts.Controls.Add(btn)

                            x += 130
                            If x > 450 Then
                                x = 10
                                y += 90
                            End If
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading products: " & ex.Message)
        End Try
    End Sub

    Private Sub ProductButton_Click(sender As Object, e As EventArgs)
        Dim btn As Button = DirectCast(sender, Button)
        Dim product = btn.Tag

        ' Add to cart
        Dim item As New CartItem With {
            .ProductID = product.ID,
            .ProductName = product.Name,
            .Price = product.Price,
            .Quantity = 1
        }

        _currentCart.Add(item)
        UpdateCartDisplay()
    End Sub

    Private Sub UpdateCartDisplay()
        lstCart.Items.Clear()
        _currentTotal = 0

        For Each item In _currentCart
            lstCart.Items.Add($"{item.ProductName} x{item.Quantity} - R{item.Price * item.Quantity:F2}")
            _currentTotal += item.Price * item.Quantity
        Next

        lblTotal.Text = $"Total: R{_currentTotal:F2}"
    End Sub

    Private Sub btnCheckout_Click(sender As Object, e As EventArgs)
        If _currentCart.Count = 0 Then
            MessageBox.Show("Cart is empty!", "Checkout", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        MessageBox.Show($"Checkout functionality to be implemented.{vbCrLf}Total: R{_currentTotal:F2}", "Checkout", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs)
        _currentCart.Clear()
        UpdateCartDisplay()
    End Sub

    Private Sub SetupTouchInterface()
        ' Touch interface setup
    End Sub

    Public Class CartItem
        Public Property ProductID As Integer
        Public Property ProductName As String
        Public Property Price As Decimal
        Public Property Quantity As Integer
    End Class

    Private Sub ClearTransaction()
        _currentTransaction.Clear()
        UpdateCartDisplay()
        UpdateTotalDisplay()
    End Sub

    Private Sub UpdateTotalDisplay()
        _totalLabel.Text = _currentTotal.ToString("C2")
    End Sub
End Class

' Supporting classes
Public Class POSLineItem
    Public Property ProductID As Integer
    Public Property SKU As String
    Public Property ProductName As String
    Public Property Quantity As Decimal
    Public Property UnitPrice As Decimal
    Public Property LineTotal As Decimal
End Class

Public Class POSDepositAmountForm
    Inherits Form

    Public Property DepositAmount As Decimal

    Public Sub New(totalAmount As Decimal)
        InitializeComponent()
        Me.Text = "Enter Deposit Amount"
        Me.Size = New Size(300, 150)
        Me.StartPosition = FormStartPosition.CenterParent

        Dim lblTotal As New Label With {
            .Text = $"Total Amount: {totalAmount:C2}",
            .Location = New Point(20, 20),
            .Size = New Size(200, 20)
        }

        Dim lblDeposit As New Label With {
            .Text = "Deposit Amount:",
            .Location = New Point(20, 50),
            .Size = New Size(100, 20)
        }

        Dim txtDeposit As New TextBox With {
            .Location = New Point(130, 48),
            .Size = New Size(100, 20),
            .Text = (totalAmount * 0.5D).ToString("F2")
        }

        Dim btnOK As New Button With {
            .Text = "OK",
            .Location = New Point(50, 80),
            .Size = New Size(75, 23),
            .DialogResult = DialogResult.OK
        }

        Dim btnCancel As New Button With {
            .Text = "Cancel",
            .Location = New Point(150, 80),
            .Size = New Size(75, 23),
            .DialogResult = DialogResult.Cancel
        }

        AddHandler btnOK.Click, Sub()
                                    If Decimal.TryParse(txtDeposit.Text, DepositAmount) AndAlso DepositAmount > 0 AndAlso DepositAmount <= totalAmount Then
                                        Me.DialogResult = DialogResult.OK
                                        Me.Close()
                                    Else
                                        MessageBox.Show("Please enter a valid deposit amount.", "Invalid Amount", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                    End If
                                End Sub

        Me.Controls.AddRange({lblTotal, lblDeposit, txtDeposit, btnOK, btnCancel})
        Me.AcceptButton = btnOK
        Me.CancelButton = btnCancel
    End Sub

    Private Sub InitializeComponent()
        ' Required for designer support
    End Sub
End Class

Public Class Customer
    Public Property CustomerID As Integer
    Public Property Name As String
    Public Property Phone As String
    Public Property Email As String
End Class

Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for creating Internal Delivery Notes from approved POs
    ''' Branch B creates delivery note and dispatches to Branch A
    ''' </summary>
    Public Class CreateDeliveryNoteForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private ReadOnly _internalPOID As Integer
        Private _currentBranchId As Integer
        Private _currentUserId As Integer

        ' PO Data
        Private _poNumber As String
        Private _requestingBranchId As Integer
        Private _requestingBranchName As String
        Private _requestingBranchAddress As String
        Private _productId As Integer
        Private _productName As String
        Private _requestedQty As Decimal
        Private _unitCost As Decimal

        ' UI Controls
        Private lblPONumber As Label
        Private lblRequestingBranch As Label
        Private lblProduct As Label
        Private lblRequestedQty As Label
        Private txtDeliveryQty As TextBox
        Private txtUnitCost As TextBox
        Private txtTotalValue As Label
        Private txtNotes As TextBox
        Private btnSave As Button
        Private btnCancel As Button

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New(internalPOID As Integer)
            _internalPOID = internalPOID
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)
            _currentUserId = If(AppSession.CurrentUser?.UserID, 1)

            Me.Text = "Create Internal Delivery Note"
            Me.Width = 700
            Me.Height = 600
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            LoadPOData()
            InitializeUI()
            CalculateTotal()
        End Sub

        Private Sub LoadPOData()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim sql = "SELECT po.PONumber, po.RequestingBranchID, rb.BranchName AS RequestingBranch, 
                                     rb.Address AS RequestingAddress, po.ProductID, p.Name AS ProductName, po.Quantity
                              FROM InternalPurchaseOrders po
                              INNER JOIN Branches rb ON po.RequestingBranchID = rb.BranchID
                              INNER JOIN Demo_Retail_Product p ON po.ProductID = p.ProductID
                              WHERE po.InternalPOID = @POID"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@POID", _internalPOID)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                _poNumber = reader("PONumber").ToString()
                                _requestingBranchId = Convert.ToInt32(reader("RequestingBranchID"))
                                _requestingBranchName = reader("RequestingBranch").ToString()
                                _requestingBranchAddress = If(reader("RequestingAddress") Is DBNull.Value, "", reader("RequestingAddress").ToString())
                                _productId = Convert.ToInt32(reader("ProductID"))
                                _productName = reader("ProductName").ToString()
                                _requestedQty = Convert.ToDecimal(reader("Quantity"))
                            Else
                                Throw New Exception("PO not found")
                            End If
                        End Using
                    End Using

                    ' Get cost price
                    Dim sqlCost = "SELECT TOP 1 CostPrice FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID ORDER BY EffectiveFrom DESC"
                    Using cmd As New SqlCommand(sqlCost, con)
                        cmd.Parameters.AddWithValue("@ProductID", _productId)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                        Dim result = cmd.ExecuteScalar()
                        _unitCost = If(result IsNot Nothing AndAlso Not IsDBNull(result), Convert.ToDecimal(result), 0)
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading PO data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.Close()
            End Try
        End Sub

        Private Sub InitializeUI()
            ' Header
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "📦 Create Delivery Note",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 25)
            }

            pnlHeader.Controls.Add(lblTitle)

            ' Content Panel
            Dim pnlContent As New Panel With {
                .Location = New Point(20, 100),
                .Size = New Size(640, 380),
                .BackColor = ColorLight,
                .BorderStyle = BorderStyle.FixedSingle
            }

            Dim y As Integer = 20

            ' PO Number
            Dim lblPOLabel As New Label With {
                .Text = "PO Number:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblPONumber = New Label With {
                .Text = _poNumber,
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorPrimary
            }

            y += 35

            ' Requesting Branch
            Dim lblBranchLabel As New Label With {
                .Text = "Deliver To:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblRequestingBranch = New Label With {
                .Text = $"{_requestingBranchName}{vbCrLf}{_requestingBranchAddress}",
                .Location = New Point(200, y),
                .Size = New Size(400, 50),
                .Font = New Font("Segoe UI", 10)
            }

            y += 60

            ' Product
            Dim lblProductLabel As New Label With {
                .Text = "Product:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblProduct = New Label With {
                .Text = _productName,
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10)
            }

            y += 35

            ' Requested Quantity
            Dim lblRequestedQtyLabel As New Label With {
                .Text = "Requested Qty:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblRequestedQty = New Label With {
                .Text = _requestedQty.ToString("N2"),
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10)
            }

            y += 35

            ' Delivery Quantity
            Dim lblDeliveryQtyLabel As New Label With {
                .Text = "Delivery Qty:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtDeliveryQty = New TextBox With {
                .Location = New Point(200, y - 3),
                .Width = 150,
                .Font = New Font("Segoe UI", 10),
                .TextAlign = HorizontalAlignment.Right,
                .Text = _requestedQty.ToString("N2")
            }
            AddHandler txtDeliveryQty.TextChanged, AddressOf OnQuantityChanged

            y += 35

            ' Unit Cost
            Dim lblUnitCostLabel As New Label With {
                .Text = "Unit Cost:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtUnitCost = New TextBox With {
                .Location = New Point(200, y - 3),
                .Width = 150,
                .Font = New Font("Segoe UI", 10),
                .TextAlign = HorizontalAlignment.Right,
                .Text = _unitCost.ToString("N2")
            }
            AddHandler txtUnitCost.TextChanged, AddressOf OnQuantityChanged

            y += 35

            ' Total Value
            Dim lblTotalLabel As New Label With {
                .Text = "Total Value:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtTotalValue = New Label With {
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorSuccess
            }

            y += 40

            ' Notes
            Dim lblNotesLabel As New Label With {
                .Text = "Notes:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtNotes = New TextBox With {
                .Location = New Point(20, y + 25),
                .Size = New Size(600, 60),
                .Multiline = True,
                .Font = New Font("Segoe UI", 10)
            }

            pnlContent.Controls.AddRange({lblPOLabel, lblPONumber, lblBranchLabel, lblRequestingBranch,
                                         lblProductLabel, lblProduct, lblRequestedQtyLabel, lblRequestedQty,
                                         lblDeliveryQtyLabel, txtDeliveryQty, lblUnitCostLabel, txtUnitCost,
                                         lblTotalLabel, txtTotalValue, lblNotesLabel, txtNotes})

            ' Footer
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 70,
                .BackColor = ColorLight
            }

            btnCancel = New Button With {
                .Text = "Cancel",
                .Location = New Point(380, 15),
                .Size = New Size(140, 40),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, Sub() Me.Close()

            btnSave = New Button With {
                .Text = "🚚 Create & Dispatch",
                .Location = New Point(530, 15),
                .Size = New Size(150, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0
            AddHandler btnSave.Click, AddressOf BtnSave_Click

            pnlFooter.Controls.AddRange({btnCancel, btnSave})

            Me.Controls.AddRange({pnlHeader, pnlContent, pnlFooter})
        End Sub

        Private Sub OnQuantityChanged(sender As Object, e As EventArgs)
            CalculateTotal()
        End Sub

        Private Sub CalculateTotal()
            Dim qty As Decimal = 0
            Dim cost As Decimal = 0
            Decimal.TryParse(txtDeliveryQty.Text, qty)
            Decimal.TryParse(txtUnitCost.Text, cost)
            Dim total As Decimal = qty * cost
            txtTotalValue.Text = $"R {total:N2}"
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            Try
                ' Validate
                Dim deliveryQty As Decimal
                If Not Decimal.TryParse(txtDeliveryQty.Text, deliveryQty) OrElse deliveryQty <= 0 Then
                    MessageBox.Show("Please enter a valid delivery quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtDeliveryQty.Focus()
                    Return
                End If

                Dim unitCost As Decimal
                If Not Decimal.TryParse(txtUnitCost.Text, unitCost) OrElse unitCost <= 0 Then
                    MessageBox.Show("Please enter a valid unit cost.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtUnitCost.Focus()
                    Return
                End If

                If MessageBox.Show("Create delivery note and dispatch?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
                    Return
                End If

                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Using tx = con.BeginTransaction()
                        Try
                            ' Get branch info
                            Dim fromBranchName As String = ""
                            Dim fromBranchAddress As String = ""
                            Dim branchCode As String = ""

                            Using cmd As New SqlCommand("SELECT BranchName, Address, BranchCode FROM Branches WHERE BranchID = @BranchID", con, tx)
                                cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                                Using reader = cmd.ExecuteReader()
                                    If reader.Read() Then
                                        fromBranchName = reader("BranchName").ToString()
                                        fromBranchAddress = If(reader("Address") Is DBNull.Value, "", reader("Address").ToString())
                                        branchCode = reader("BranchCode").ToString()
                                    End If
                                End Using
                            End Using

                            ' Generate Delivery Note Number
                            Dim deliveryNoteNumber As String = GenerateDeliveryNoteNumber(con, tx, branchCode)

                            ' Calculate total
                            Dim totalValue As Decimal = deliveryQty * unitCost

                            ' Insert Delivery Note
                            Dim sql = "INSERT INTO InternalDeliveryNotes (DeliveryNoteNumber, InternalPOID, FromBranchID, FromBranchName, FromBranchAddress, " &
                                     "ToBranchID, ToBranchName, ToBranchAddress, ProductID, Quantity, UnitCost, TotalValue, DispatchDate, Status, Notes, CreatedBy, CreatedDate) " &
                                     "VALUES (@DelNumber, @POID, @FromBranch, @FromBranchName, @FromBranchAddress, @ToBranch, @ToBranchName, @ToBranchAddress, " &
                                     "@ProductID, @Qty, @UnitCost, @Total, GETDATE(), 'In Transit', @Notes, @UserID, GETDATE())"

                            Using cmd As New SqlCommand(sql, con, tx)
                                cmd.Parameters.AddWithValue("@DelNumber", deliveryNoteNumber)
                                cmd.Parameters.AddWithValue("@POID", _internalPOID)
                                cmd.Parameters.AddWithValue("@FromBranch", _currentBranchId)
                                cmd.Parameters.AddWithValue("@FromBranchName", fromBranchName)
                                cmd.Parameters.AddWithValue("@FromBranchAddress", fromBranchAddress)
                                cmd.Parameters.AddWithValue("@ToBranch", _requestingBranchId)
                                cmd.Parameters.AddWithValue("@ToBranchName", _requestingBranchName)
                                cmd.Parameters.AddWithValue("@ToBranchAddress", _requestingBranchAddress)
                                cmd.Parameters.AddWithValue("@ProductID", _productId)
                                cmd.Parameters.AddWithValue("@Qty", deliveryQty)
                                cmd.Parameters.AddWithValue("@UnitCost", unitCost)
                                cmd.Parameters.AddWithValue("@Total", totalValue)
                                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(txtNotes.Text), DBNull.Value, CObj(txtNotes.Text)))
                                cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                                cmd.ExecuteNonQuery()
                            End Using

                            ' Update PO Status to Fulfilled
                            Using cmd As New SqlCommand("UPDATE InternalPurchaseOrders SET Status = 'Fulfilled' WHERE InternalPOID = @POID", con, tx)
                                cmd.Parameters.AddWithValue("@POID", _internalPOID)
                                cmd.ExecuteNonQuery()
                            End Using

                            ' Deduct stock from supplying branch
                            Dim sqlStock = "INSERT INTO StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceNumber, Notes, CreatedBy) " &
                                          "VALUES (@MaterialID, 'IBT Dispatch', GETDATE(), 0, @Qty, 0, @UnitCost, @TotalValue, 'Retail', @RefNumber, @Notes, @UserID)"
                            Using cmdStock As New SqlCommand(sqlStock, con, tx)
                                cmdStock.Parameters.AddWithValue("@MaterialID", _productId)
                                cmdStock.Parameters.AddWithValue("@Qty", deliveryQty)
                                cmdStock.Parameters.AddWithValue("@UnitCost", unitCost)
                                cmdStock.Parameters.AddWithValue("@TotalValue", totalValue)
                                cmdStock.Parameters.AddWithValue("@RefNumber", deliveryNoteNumber)
                                cmdStock.Parameters.AddWithValue("@Notes", $"IBT Dispatch to {_requestingBranchName}")
                                cmdStock.Parameters.AddWithValue("@UserID", _currentUserId)
                                cmdStock.ExecuteNonQuery()
                            End Using

                            tx.Commit()
                            MessageBox.Show($"Delivery Note {deliveryNoteNumber} created and dispatched successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Me.DialogResult = DialogResult.OK
                            Me.Close()

                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using

            Catch ex As Exception
                MessageBox.Show($"Error creating delivery note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GenerateDeliveryNoteNumber(con As SqlConnection, tx As SqlTransaction, branchCode As String) As String
            Dim nextNumber As Integer = 1
            Dim pattern As String = $"{branchCode}-i-DEL-IBT-%"

            Using cmd As New SqlCommand("SELECT MAX(CAST(RIGHT(DeliveryNoteNumber, 5) AS INT)) FROM InternalDeliveryNotes WHERE DeliveryNoteNumber LIKE @Pattern", con, tx)
                cmd.Parameters.AddWithValue("@Pattern", pattern)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    nextNumber = Convert.ToInt32(result) + 1
                End If
            End Using

            Return $"{branchCode}-i-DEL-IBT-{nextNumber.ToString("00000")}"
        End Function
    End Class
End Namespace

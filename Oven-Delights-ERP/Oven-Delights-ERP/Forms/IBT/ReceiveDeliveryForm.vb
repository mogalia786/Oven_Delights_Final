Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for receiving Internal Delivery Notes
    ''' Branch A receives delivery from Branch B and updates stock + accounting
    ''' </summary>
    Public Class ReceiveDeliveryForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private ReadOnly _deliveryNoteId As Integer
        Private _currentBranchId As Integer
        Private _currentUserId As Integer

        ' Delivery Data
        Private _deliveryNoteNumber As String
        Private _poNumber As String
        Private _fromBranchId As Integer
        Private _fromBranchName As String
        Private _productId As Integer
        Private _productName As String
        Private _quantity As Decimal
        Private _unitCost As Decimal
        Private _totalValue As Decimal
        Private _dispatchDate As DateTime

        ' UI Controls
        Private lblDeliveryNote As Label
        Private lblPONumber As Label
        Private lblFromBranch As Label
        Private lblProduct As Label
        Private lblQuantity As Label
        Private lblUnitCost As Label
        Private lblTotalValue As Label
        Private lblDispatchDate As Label
        Private txtNotes As TextBox
        Private btnReceive As Button
        Private btnCancel As Button

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New(deliveryNoteId As Integer)
            _deliveryNoteId = deliveryNoteId
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)
            _currentUserId = If(AppSession.CurrentUser?.UserID, 1)

            Me.Text = "Receive Delivery"
            Me.Width = 700
            Me.Height = 650
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            LoadDeliveryData()
            InitializeUI()
        End Sub

        Private Sub LoadDeliveryData()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim sql = "SELECT dn.DeliveryNoteNumber, po.PONumber, dn.FromBranchID, fb.BranchName AS FromBranch, 
                                     dn.ProductID, p.Name AS ProductName, dn.Quantity, dn.UnitCost, dn.TotalValue, dn.DispatchDate
                              FROM InternalDeliveryNotes dn
                              INNER JOIN Branches fb ON dn.FromBranchID = fb.BranchID
                              INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
                              INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
                              WHERE dn.DeliveryNoteID = @DeliveryNoteID"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@DeliveryNoteID", _deliveryNoteId)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                _deliveryNoteNumber = reader("DeliveryNoteNumber").ToString()
                                _poNumber = reader("PONumber").ToString()
                                _fromBranchId = Convert.ToInt32(reader("FromBranchID"))
                                _fromBranchName = reader("FromBranch").ToString()
                                _productId = Convert.ToInt32(reader("ProductID"))
                                _productName = reader("ProductName").ToString()
                                _quantity = Convert.ToDecimal(reader("Quantity"))
                                _unitCost = Convert.ToDecimal(reader("UnitCost"))
                                _totalValue = Convert.ToDecimal(reader("TotalValue"))
                                _dispatchDate = Convert.ToDateTime(reader("DispatchDate"))
                            Else
                                Throw New Exception("Delivery note not found")
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading delivery data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
                .Text = "📥 Receive Delivery",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 25)
            }

            pnlHeader.Controls.Add(lblTitle)

            ' Content Panel
            Dim pnlContent As New Panel With {
                .Location = New Point(20, 100),
                .Size = New Size(640, 430),
                .BackColor = ColorLight,
                .BorderStyle = BorderStyle.FixedSingle
            }

            Dim y As Integer = 20

            ' Delivery Note Number
            Dim lblDelNoteLabel As New Label With {
                .Text = "Delivery Note:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblDeliveryNote = New Label With {
                .Text = _deliveryNoteNumber,
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorPrimary
            }

            y += 35

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
                .Font = New Font("Segoe UI", 10)
            }

            y += 35

            ' From Branch
            Dim lblFromLabel As New Label With {
                .Text = "From Branch:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblFromBranch = New Label With {
                .Text = _fromBranchName,
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10)
            }

            y += 35

            ' Dispatch Date
            Dim lblDispatchLabel As New Label With {
                .Text = "Dispatch Date:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblDispatchDate = New Label With {
                .Text = _dispatchDate.ToString("dd/MM/yyyy HH:mm"),
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10)
            }

            y += 40

            ' Separator
            Dim separator As New Label With {
                .Location = New Point(20, y),
                .Size = New Size(600, 2),
                .BackColor = ColorDark
            }

            y += 15

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
                .Size = New Size(420, 40),
                .Font = New Font("Segoe UI", 10)
            }

            y += 45

            ' Quantity
            Dim lblQtyLabel As New Label With {
                .Text = "Quantity:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblQuantity = New Label With {
                .Text = _quantity.ToString("N2"),
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorSuccess
            }

            y += 35

            ' Unit Cost
            Dim lblCostLabel As New Label With {
                .Text = "Unit Cost:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            lblUnitCost = New Label With {
                .Text = $"R {_unitCost:N2}",
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10)
            }

            y += 35

            ' Total Value
            Dim lblTotalLabel As New Label With {
                .Text = "Total Value:",
                .Location = New Point(20, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold)
            }

            lblTotalValue = New Label With {
                .Text = $"R {_totalValue:N2}",
                .Location = New Point(200, y),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 13, FontStyle.Bold),
                .ForeColor = ColorSuccess
            }

            y += 45

            ' Notes
            Dim lblNotesLabel As New Label With {
                .Text = "Receiving Notes:",
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

            pnlContent.Controls.AddRange({lblDelNoteLabel, lblDeliveryNote, lblPOLabel, lblPONumber,
                                         lblFromLabel, lblFromBranch, lblDispatchLabel, lblDispatchDate,
                                         separator, lblProductLabel, lblProduct, lblQtyLabel, lblQuantity,
                                         lblCostLabel, lblUnitCost, lblTotalLabel, lblTotalValue,
                                         lblNotesLabel, txtNotes})

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

            btnReceive = New Button With {
                .Text = "✅ Confirm Receipt",
                .Location = New Point(530, 15),
                .Size = New Size(150, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnReceive.FlatAppearance.BorderSize = 0
            AddHandler btnReceive.Click, AddressOf BtnReceive_Click

            pnlFooter.Controls.AddRange({btnCancel, btnReceive})

            Me.Controls.AddRange({pnlHeader, pnlContent, pnlFooter})
        End Sub

        Private Sub BtnReceive_Click(sender As Object, e As EventArgs)
            Try
                If MessageBox.Show($"Confirm receipt of delivery {_deliveryNoteNumber}?{vbCrLf}{vbCrLf}This will:{vbCrLf}• Add stock to your branch{vbCrLf}• Create inter-branch debtor entry{vbCrLf}• Mark delivery as received", "Confirm Receipt", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
                    Return
                End If

                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Using tx = con.BeginTransaction()
                        Try
                            ' Update delivery note status
                            Dim sqlUpdate = "UPDATE InternalDeliveryNotes SET Status = 'Delivered', ReceiveDate = GETDATE(), ReceivedBy = @UserID WHERE DeliveryNoteID = @DeliveryNoteID"
                            Using cmd As New SqlCommand(sqlUpdate, con, tx)
                                cmd.Parameters.AddWithValue("@DeliveryNoteID", _deliveryNoteId)
                                cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                                cmd.ExecuteNonQuery()
                            End Using

                            ' Add stock to receiving branch
                            Dim sqlStock = "INSERT INTO StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceNumber, Notes, CreatedBy) " &
                                          "VALUES (@MaterialID, 'IBT Receipt', GETDATE(), @Qty, 0, 0, @UnitCost, @TotalValue, 'Retail', @RefNumber, @Notes, @UserID)"
                            Using cmdStock As New SqlCommand(sqlStock, con, tx)
                                cmdStock.Parameters.AddWithValue("@MaterialID", _productId)
                                cmdStock.Parameters.AddWithValue("@Qty", _quantity)
                                cmdStock.Parameters.AddWithValue("@UnitCost", _unitCost)
                                cmdStock.Parameters.AddWithValue("@TotalValue", _totalValue)
                                cmdStock.Parameters.AddWithValue("@RefNumber", _deliveryNoteNumber)
                                cmdStock.Parameters.AddWithValue("@Notes", $"IBT Receipt from {_fromBranchName}")
                                cmdStock.Parameters.AddWithValue("@UserID", _currentUserId)
                                cmdStock.ExecuteNonQuery()
                            End Using

                            ' Create inter-branch ledger entry (Debtor/Creditor)
                            Dim sqlLedger = "INSERT INTO InterBranchLedger (DebtorBranchID, CreditorBranchID, DeliveryNoteID, Amount, TransactionDate, Status, Notes, CreatedBy, CreatedDate) " &
                                           "VALUES (@DebtorBranch, @CreditorBranch, @DeliveryNoteID, @Amount, GETDATE(), 'Outstanding', @Notes, @UserID, GETDATE())"

                            Using cmd As New SqlCommand(sqlLedger, con, tx)
                                cmd.Parameters.AddWithValue("@DebtorBranch", _currentBranchId) ' Receiving branch owes money
                                cmd.Parameters.AddWithValue("@CreditorBranch", _fromBranchId) ' Supplying branch is owed money
                                cmd.Parameters.AddWithValue("@DeliveryNoteID", _deliveryNoteId)
                                cmd.Parameters.AddWithValue("@Amount", _totalValue)
                                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(txtNotes.Text), DBNull.Value, CObj(txtNotes.Text)))
                                cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                                cmd.ExecuteNonQuery()
                            End Using

                            tx.Commit()
                            MessageBox.Show($"Delivery {_deliveryNoteNumber} received successfully!{vbCrLf}{vbCrLf}Stock updated and inter-branch ledger entry created.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Me.DialogResult = DialogResult.OK
                            Me.Close()

                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using

            Catch ex As Exception
                MessageBox.Show($"Error receiving delivery: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace

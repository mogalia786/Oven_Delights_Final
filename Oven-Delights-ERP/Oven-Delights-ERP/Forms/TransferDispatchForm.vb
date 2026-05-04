Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms

    Public Class TransferDispatchForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private ReadOnly _transferId As Integer

        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34)
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0)

        Private lblTransferNumber As Label
        Private lblFromBranch As Label
        Private lblToBranch As Label
        Private lblProduct As Label
        Private lblQuantity As Label
        Private lblUnitCost As Label
        Private lblTotalValue As Label
        Private txtNotes As TextBox
        Private btnDispatch As Button
        Private btnCancel As Button

        Public Sub New(transferId As Integer)
            _transferId = transferId
            Me.Text = "Dispatch Transfer - Oven Delights"
            Me.Width = 600
            Me.Height = 650
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            InitializeUI()
            LoadTransferDetails()
        End Sub

        Private Sub InitializeUI()
            ' Header
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }
            
            Dim lblHeader As New Label() With {
                .Text = "✅ 📤 Dispatch Transfer",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 25
            }
            
            pnlHeader.Controls.Add(lblHeader)

            ' Content Panel
            Dim pnlContent As New Panel() With {
                .Left = 30,
                .Top = 100,
                .Width = 520,
                .Height = 450,
                .BackColor = Color.White
            }

            Dim y As Integer = 0
            Dim labelFont As New Font("Segoe UI", 10, FontStyle.Bold)
            Dim valueFont As New Font("Segoe UI", 10)

            ' Transfer Number
            Dim lbl1 As New Label() With {.Text = "Transfer Number:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblTransferNumber = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl1, lblTransferNumber})
            y += 35

            ' From Branch
            Dim lbl2 As New Label() With {.Text = "From Branch:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblFromBranch = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl2, lblFromBranch})
            y += 35

            ' To Branch
            Dim lbl3 As New Label() With {.Text = "To Branch:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblToBranch = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl3, lblToBranch})
            y += 35

            ' Product
            Dim lbl4 As New Label() With {.Text = "Product:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblProduct = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl4, lblProduct})
            y += 35

            ' Quantity
            Dim lbl5 As New Label() With {.Text = "Quantity:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblQuantity = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl5, lblQuantity})
            y += 35

            ' Unit Cost
            Dim lbl6 As New Label() With {.Text = "Unit Cost:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblUnitCost = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl6, lblUnitCost})
            y += 35

            ' Total Value
            Dim lbl7 As New Label() With {.Text = "Total Value:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            lblTotalValue = New Label() With {.Left = 160, .Top = y, .Width = 350, .Font = valueFont}
            pnlContent.Controls.AddRange({lbl7, lblTotalValue})
            y += 50

            ' Notes
            Dim lbl8 As New Label() With {.Text = "Dispatch Notes:", .Left = 0, .Top = y, .Width = 150, .Font = labelFont}
            txtNotes = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 520,
                .Height = 100,
                .Multiline = True,
                .Font = valueFont,
                .ScrollBars = ScrollBars.Vertical
            }
            pnlContent.Controls.AddRange({lbl8, txtNotes})

            ' Button Panel
            Dim pnlButtons As New Panel() With {
                .Left = 30,
                .Top = 560,
                .Width = 520,
                .Height = 50
            }

            btnDispatch = New Button() With {
                .Text = "Dispatch Transfer",
                .Left = 0,
                .Top = 0,
                .Width = 200,
                .Height = 40,
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnDispatch.FlatAppearance.BorderSize = 0
            AddHandler btnDispatch.Click, AddressOf BtnDispatch_Click

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Left = 320,
                .Top = 0,
                .Width = 200,
                .Height = 40,
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, Sub(s, ev) Me.DialogResult = DialogResult.Cancel

            pnlButtons.Controls.AddRange({btnDispatch, btnCancel})

            Me.Controls.Add(pnlButtons)
            Me.Controls.Add(pnlContent)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadTransferDetails()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT 
                        t.TransferNumber,
                        fb.BranchName AS FromBranch,
                        tb.BranchName AS ToBranch,
                        p.Name AS ProductName,
                        t.Quantity,
                        t.UnitCost,
                        t.TotalValue
                    FROM InterBranchTransfers t
                    INNER JOIN Branches fb ON t.FromBranchID = fb.BranchID
                    INNER JOIN Branches tb ON t.ToBranchID = tb.BranchID
                    INNER JOIN demo_Retail_product p ON t.ProductID = p.ProductID
                    WHERE t.TransferID = @TransferID"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@TransferID", _transferId)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                lblTransferNumber.Text = reader("TransferNumber").ToString()
                                lblFromBranch.Text = reader("FromBranch").ToString()
                                lblToBranch.Text = reader("ToBranch").ToString()
                                lblProduct.Text = reader("ProductName").ToString()
                                lblQuantity.Text = Convert.ToDecimal(reader("Quantity")).ToString("N2")
                                lblUnitCost.Text = Convert.ToDecimal(reader("UnitCost")).ToString("C2")
                                lblTotalValue.Text = Convert.ToDecimal(reader("TotalValue")).ToString("C2")
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading transfer details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnDispatch_Click(sender As Object, e As EventArgs)
            Dim result As DialogResult = MessageBox.Show(
                "Dispatch this transfer?" & vbCrLf & vbCrLf &
                "This will:" & vbCrLf &
                "• Set status to 'In Transit'" & vbCrLf &
                "• Reduce inventory at sender branch" & vbCrLf &
                "• Create inter-branch debtor entry",
                "Confirm Dispatch",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)

            If result = DialogResult.Yes Then
                Try
                    Using con As New SqlConnection(_connectionString)
                        con.Open()
                        Using tx = con.BeginTransaction()
                            Try
                                ' Update transfer status
                                Dim sqlUpdate As String = "UPDATE InterBranchTransfers 
                                    SET Status = 'In Transit', 
                                        DispatchedBy = @UserId, 
                                        DispatchedDate = GETDATE(),
                                        Notes = ISNULL(Notes, '') + CHAR(13) + CHAR(10) + 'Dispatched: ' + @Notes
                                    WHERE TransferID = @TransferID"

                                Using cmd As New SqlCommand(sqlUpdate, con, tx)
                                    cmd.Parameters.AddWithValue("@TransferID", _transferId)
                                    cmd.Parameters.AddWithValue("@UserId", AppSession.CurrentUserID)
                                    cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(txtNotes.Text), "No notes", txtNotes.Text))
                                    cmd.ExecuteNonQuery()
                                End Using

                                ' TODO: Reduce inventory at sender branch
                                ' TODO: Post accounting entries (DR Inter-Branch Debtors, CR Inventory)

                                tx.Commit()
                                MessageBox.Show("Transfer dispatched successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                Me.DialogResult = DialogResult.OK
                            Catch
                                tx.Rollback()
                                Throw
                            End Try
                        End Using
                    End Using
                Catch ex As Exception
                    MessageBox.Show($"Error dispatching transfer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub

    End Class

End Namespace

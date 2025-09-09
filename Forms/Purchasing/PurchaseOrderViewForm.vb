Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Namespace Purchasing
    Public Class PurchaseOrderViewForm
        Inherits Form

        Private ReadOnly _poId As Integer
        Private ReadOnly lblTitle As New Label()
        Private ReadOnly grid As New DataGridView()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly lblSupplier As New Label()
        Private ReadOnly lblStatus As New Label()
        Private ReadOnly lblCreated As New Label()

        Public Sub New(poId As Integer)
            _poId = poId
            Me.Text = $"Purchase Order #{poId}"
            Me.Size = New Size(720, 420)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog

            lblTitle.Text = Me.Text
            lblTitle.Font = New Font("Segoe UI", 12.0F, FontStyle.Bold)
            lblTitle.Location = New Point(12, 10)
            lblTitle.AutoSize = True

            lblSupplier.Location = New Point(16, 44)
            lblSupplier.AutoSize = True
            lblStatus.Location = New Point(16, 66)
            lblStatus.AutoSize = True
            lblCreated.Location = New Point(16, 88)
            lblCreated.AutoSize = True

            grid.Location = New Point(12, 120)
            grid.Size = New Size(Me.ClientSize.Width - 24, Me.ClientSize.Height - 170)
            grid.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            grid.ReadOnly = True
            grid.AllowUserToAddRows = False
            grid.AllowUserToDeleteRows = False
            grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Field", .HeaderText = "Field", .FillWeight = 35})
            grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Value", .HeaderText = "Value", .FillWeight = 65})

            btnClose.Text = "Close"
            btnClose.Location = New Point(Me.ClientSize.Width - 100, Me.ClientSize.Height - 40)
            btnClose.Anchor = AnchorStyles.Right Or AnchorStyles.Bottom
            AddHandler btnClose.Click, Sub() Me.Close()

            Controls.Add(lblTitle)
            Controls.Add(lblSupplier)
            Controls.Add(lblStatus)
            Controls.Add(lblCreated)
            Controls.Add(grid)
            Controls.Add(btnClose)

            LoadPo()
        End Sub

        Private Sub LoadPo()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT PurchaseOrderID, BranchID, SupplierID, SupplierName, Status, CreatedAtUtc, CreatedBy, Notes FROM dbo.PurchaseOrders WHERE PurchaseOrderID=@id;", cn)
                        cmd.Parameters.AddWithValue("@id", _poId)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                Dim rows = New List(Of (String, String)) From {
                                    ("PurchaseOrderID", Convert.ToString(r("PurchaseOrderID"))),
                                    ("BranchID", If(r("BranchID") Is DBNull.Value, "", Convert.ToString(r("BranchID")))),
                                    ("SupplierID", If(r("SupplierID") Is DBNull.Value, "", Convert.ToString(r("SupplierID")))),
                                    ("SupplierName", If(r("SupplierName") Is DBNull.Value, "", Convert.ToString(r("SupplierName")))),
                                    ("Status", If(r("Status") Is DBNull.Value, "", Convert.ToString(r("Status")))),
                                    ("CreatedAtUtc", If(r("CreatedAtUtc") Is DBNull.Value, "", Convert.ToString(r("CreatedAtUtc")))),
                                    ("CreatedBy", If(r("CreatedBy") Is DBNull.Value, "", Convert.ToString(r("CreatedBy")))),
                                    ("Notes", If(r("Notes") Is DBNull.Value, "", Convert.ToString(r("Notes"))))
                                }
                                lblSupplier.Text = "Supplier: " & rows(3).Item2
                                lblStatus.Text = "Status: " & rows(4).Item2
                                lblCreated.Text = "Created (UTC): " & rows(5).Item2
                                grid.Rows.Clear()
                                For Each t In rows
                                    grid.Rows.Add(t.Item1, t.Item2)
                                Next
                            Else
                                MessageBox.Show(Me, "PO not found.", "PO", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                Me.Close()
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "PO", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace

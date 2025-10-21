Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms
Imports Oven_Delights_ERP.Services

Namespace Retail
    Public Class DailyOrderBookForm
        Inherits Form

        Private ReadOnly dgv As New DataGridView()
        Private ReadOnly dtp As New DateTimePicker()
        Private ReadOnly cbAllDays As New CheckBox()
        Private ReadOnly btnRefresh As New Button()
        Private ReadOnly btnClose As New Button()

        Public Sub New()
            Me.Text = "Daily Order Book"
            Me.Name = "DailyOrderBookForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Size = New Size(1100, 650)

            dtp.Format = DateTimePickerFormat.Short
            dtp.Value = TimeProvider.Today()
            dtp.Location = New Point(20, 15)

            cbAllDays.Text = "All Days"
            cbAllDays.AutoSize = True
            cbAllDays.Location = New Point(140, 16)
            AddHandler cbAllDays.CheckedChanged, Sub() LoadData()

            btnRefresh.Text = "Refresh"
            btnRefresh.Location = New Point(230, 12)
            AddHandler btnRefresh.Click, Sub() LoadData()

            btnClose.Text = "Close"
            btnClose.Location = New Point(980, 12)
            AddHandler btnClose.Click, Sub() Me.Close()

            dgv.Location = New Point(20, 50)
            dgv.Size = New Size(1040, 540)
            dgv.AllowUserToAddRows = False
            dgv.AllowUserToDeleteRows = False
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgv.ReadOnly = True

            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "BookDate", .HeaderText = "Date", .FillWeight = 10})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "BranchID", .HeaderText = "Branch", .FillWeight = 8})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 16})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product Name", .FillWeight = 26})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OrderQty", .HeaderText = "Qty", .FillWeight = 8})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Type", .HeaderText = "Type", .FillWeight = 8})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "RequestedAtUtc", .HeaderText = "Requested (UTC)", .FillWeight = 12})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "RequestedByName", .HeaderText = "Requested By", .FillWeight = 12})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturerName", .HeaderText = "Manufacturer", .FillWeight = 12})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "PurchaseOrderID", .HeaderText = "PO #", .FillWeight = 10})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SupplierName", .HeaderText = "Supplier", .FillWeight = 14})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "PurchaseOrderCreatedAtUtc", .HeaderText = "PO Created (UTC)", .FillWeight = 14})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "StockroomFulfilledAtUtc", .HeaderText = "Stockroom Fulfilled (UTC)", .FillWeight = 14})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturingCompletedAtUtc", .HeaderText = "MFG Completed (UTC)", .FillWeight = 14})

            Controls.AddRange(New Control() {dtp, cbAllDays, btnRefresh, btnClose, dgv})

            LoadData()
        End Sub

        Private Sub LoadData()
            dgv.Rows.Clear()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                    If cbAllDays.Checked Then
                        Using cmd As New SqlCommand("SELECT BookDate, BranchID, ProductID, SKU, ProductName, OrderQty, OrderNumber, InternalOrderID, RequestedAtUtc, RequestedBy, RequestedByName, ManufacturerUserID, ManufacturerName, StockroomFulfilledAtUtc, ManufacturingCompletedAtUtc FROM dbo.DailyOrderBook WHERE BranchID = @b ORDER BY BookDate DESC, ProductName", cn)
                            cmd.Parameters.AddWithValue("@b", branchId)
                            Using rdr = cmd.ExecuteReader()
                                Dim lastDate As Date = Date.MinValue
                                While rdr.Read()
                                    Dim currDate As Date = Convert.ToDateTime(rdr("BookDate")).Date
                                    If lastDate <> currDate Then
                                        AddDateHeaderRow(currDate)
                                        lastDate = currDate
                                    End If
                                    dgv.Rows.Add(New Object() {
                                        currDate.ToString("yyyy-MM-dd"),
                                        Convert.ToInt32(rdr("BranchID")),
                                        Convert.ToInt32(rdr("ProductID")),
                                        Convert.ToString(If(rdr("SKU") Is DBNull.Value, Nothing, rdr("SKU"))),
                                        Convert.ToString(If(rdr("ProductName") Is DBNull.Value, Nothing, rdr("ProductName"))),
                                        Convert.ToDecimal(If(rdr("OrderQty") Is DBNull.Value, 0D, rdr("OrderQty"))),
                                        Convert.ToString(If(rdr("OrderNumber") Is DBNull.Value, Nothing, rdr("OrderNumber"))),
                                        Convert.ToString(If(rdr("InternalOrderID") Is DBNull.Value, Nothing, rdr("InternalOrderID"))),
                                        Convert.ToString(If(rdr("RequestedAtUtc") Is DBNull.Value, Nothing, rdr("RequestedAtUtc"))),
                                        Convert.ToString(If(rdr("RequestedByName") Is DBNull.Value, Nothing, rdr("RequestedByName"))),
                                        Convert.ToString(If(rdr("ManufacturerName") Is DBNull.Value, Nothing, rdr("ManufacturerName"))),
                                        Convert.ToString(If(rdr("StockroomFulfilledAtUtc") Is DBNull.Value, Nothing, rdr("StockroomFulfilledAtUtc"))),
                                        Convert.ToString(If(rdr("ManufacturingCompletedAtUtc") Is DBNull.Value, Nothing, rdr("ManufacturingCompletedAtUtc")))
                                    })
                                End While
                            End Using
                        End Using
                    Else
                        Using cmd As New SqlCommand("SELECT BookDate, BranchID, ProductID, SKU, ProductName, OrderQty, OrderNumber, InternalOrderID, RequestedAtUtc, RequestedBy, RequestedByName, ManufacturerUserID, ManufacturerName, StockroomFulfilledAtUtc, ManufacturingCompletedAtUtc FROM dbo.DailyOrderBook WHERE BookDate = @d AND BranchID = @b ORDER BY ProductName", cn)
                            cmd.Parameters.AddWithValue("@d", dtp.Value.Date)
                            cmd.Parameters.AddWithValue("@b", branchId)
                            Using rdr = cmd.ExecuteReader()
                                While rdr.Read()
                                    dgv.Rows.Add(New Object() {
                                        Convert.ToDateTime(rdr("BookDate")).ToString("yyyy-MM-dd"),
                                        Convert.ToInt32(rdr("BranchID")),
                                        Convert.ToInt32(rdr("ProductID")),
                                        Convert.ToString(If(rdr("SKU") Is DBNull.Value, Nothing, rdr("SKU"))),
                                        Convert.ToString(If(rdr("ProductName") Is DBNull.Value, Nothing, rdr("ProductName"))),
                                        Convert.ToDecimal(If(rdr("OrderQty") Is DBNull.Value, 0D, rdr("OrderQty"))),
                                        Convert.ToString(If(rdr("OrderNumber") Is DBNull.Value, Nothing, rdr("OrderNumber"))),
                                        Convert.ToString(If(rdr("InternalOrderID") Is DBNull.Value, Nothing, rdr("InternalOrderID"))),
                                        Convert.ToString(If(rdr("RequestedAtUtc") Is DBNull.Value, Nothing, rdr("RequestedAtUtc"))),
                                        Convert.ToString(If(rdr("RequestedByName") Is DBNull.Value, Nothing, rdr("RequestedByName"))),
                                        Convert.ToString(If(rdr("ManufacturerName") Is DBNull.Value, Nothing, rdr("ManufacturerName"))),
                                        Convert.ToString(If(rdr("StockroomFulfilledAtUtc") Is DBNull.Value, Nothing, rdr("StockroomFulfilledAtUtc"))),
                                        Convert.ToString(If(rdr("ManufacturingCompletedAtUtc") Is DBNull.Value, Nothing, rdr("ManufacturingCompletedAtUtc")))
                                    })
                                End While
                            End Using
                        End Using
                    End If
                End Using
            Catch ex As Exception
                Try
                    MessageBox.Show(Me, ex.Message, "Daily Order Book", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Catch
                End Try
            End Try
        End Sub

        Private Sub AddDateHeaderRow(d As Date)
            Dim idx = dgv.Rows.Add(New Object() {"— " & d.ToString("yyyy-MM-dd") & " —", Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing})
            Dim r = dgv.Rows(idx)
            r.DefaultCellStyle.BackColor = Color.LightSteelBlue
            r.DefaultCellStyle.ForeColor = Color.MidnightBlue
            r.DefaultCellStyle.Font = New Font(dgv.Font, FontStyle.Bold)
            r.ReadOnly = True
        End Sub

    End Class
End Namespace

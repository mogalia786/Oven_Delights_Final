Imports System
Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Retail
    Public Class ReordersListForm
        Inherits Form

        Private ReadOnly grid As New DataGridView()
        Private ReadOnly btnOpenStockroom As New Button()
        Private ReadOnly btnClose As New Button()
        Private ordersTable As DataTable

        Public Sub New()
            Me.Text = "Retail - Reorders Due"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Size = New Size(900, 560)
            Me.BackColor = Color.White

            grid.Dock = DockStyle.Top
            grid.Height = 440
            grid.ReadOnly = True
            grid.AllowUserToAddRows = False
            grid.AllowUserToDeleteRows = False
            grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            grid.MultiSelect = False

            btnOpenStockroom.Text = "Open in Stockroom Fulfill"
            btnOpenStockroom.Width = 220
            btnOpenStockroom.Height = 36
            btnOpenStockroom.Left = 12
            btnOpenStockroom.Top = 448
            AddHandler btnOpenStockroom.Click, AddressOf OnOpenStockroom
            ' Separation of duties: Retail must not open Stockroom UIs
            btnOpenStockroom.Visible = False
            btnOpenStockroom.Enabled = False

            btnClose.Text = "Close"
            btnClose.Width = 100
            btnClose.Height = 36
            btnClose.Left = btnOpenStockroom.Left + btnOpenStockroom.Width + 12
            btnClose.Top = 448
            AddHandler btnClose.Click, Sub() Me.Close()

            Controls.Add(grid)
            Controls.Add(btnOpenStockroom)
            Controls.Add(btnClose)

            AddHandler Me.Shown, Sub() LoadReorders()
        End Sub

        Private Sub LoadReorders()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    ' Pull open/issued internal orders created from Retail dialog (Notes begins with Products: ...)
                    Dim dtHeaders As New DataTable()
                    Using cmd As New SqlCommand("SELECT IOH.InternalOrderID, IOH.InternalOrderNo, IOH.RequestedDate, IOH.Status, IOH.RequestedBy, IOH.Notes FROM dbo.InternalOrderHeader IOH WHERE IOH.Status IN ('Open','Issued') AND IOH.Notes LIKE 'Products:%' AND IOH.BranchID=@b ORDER BY IOH.RequestedDate DESC;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dtHeaders)
                        End Using
                    End Using

                    ' Build a flat table of products per IO using Notes encoding, and resolve product names
                    ordersTable = New DataTable()
                    ordersTable.Columns.Add("InternalOrderID", GetType(Integer))
                    ordersTable.Columns.Add("InternalOrderNo", GetType(String))
                    ordersTable.Columns.Add("RequestedDate", GetType(Date))
                    ordersTable.Columns.Add("Status", GetType(String))
                    ordersTable.Columns.Add("Manufacturer", GetType(String))
                    ordersTable.Columns.Add("ProductID", GetType(Integer))
                    ordersTable.Columns.Add("ProductName", GetType(String))
                    ordersTable.Columns.Add("Quantity", GetType(Decimal))

                    For Each hdr As DataRow In dtHeaders.Rows
                        Dim ioId As Integer = Convert.ToInt32(hdr("InternalOrderID"))
                        Dim ioNo As String = Convert.ToString(hdr("InternalOrderNo"))
                        Dim reqDate As Date = Convert.ToDateTime(hdr("RequestedDate"))
                        Dim status As String = Convert.ToString(hdr("Status"))
                        Dim requestedBy As Integer = If(IsDBNull(hdr("RequestedBy")), 0, Convert.ToInt32(hdr("RequestedBy")))
                        Dim notes As String = If(IsDBNull(hdr("Notes")), String.Empty, Convert.ToString(hdr("Notes")))

                        Dim manufacturerName As String = ResolveUserName(cn, requestedBy)

                        Dim products = ParseProducts(notes)
                        For Each p In products
                            Dim prodName As String = ResolveProductName(cn, p.Key)
                            Dim row = ordersTable.NewRow()
                            row("InternalOrderID") = ioId
                            row("InternalOrderNo") = ioNo
                            row("RequestedDate") = reqDate
                            row("Status") = status
                            row("Manufacturer") = manufacturerName
                            row("ProductID") = p.Key
                            row("ProductName") = prodName
                            row("Quantity") = p.Value
                            ordersTable.Rows.Add(row)
                        Next
                    Next

                    grid.DataSource = ordersTable
                    If grid.Columns.Contains("ProductID") Then grid.Columns("ProductID").Visible = False
                    grid.AutoResizeColumns()
                End Using
            Catch ex As Exception
                MessageBox.Show("Failed to load reorders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function ParseProducts(notes As String) As Dictionary(Of Integer, Decimal)
            Dim map As New Dictionary(Of Integer, Decimal)()
            If String.IsNullOrWhiteSpace(notes) Then Return map
            Dim marker As String = "Products:"
            Dim idx As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return map
            Dim listPart As String = notes.Substring(idx + marker.Length).Trim()
            Dim parts = listPart.Split(New Char() {"|"c}, StringSplitOptions.RemoveEmptyEntries)
            For Each part In parts
                Dim kv = part.Split("="c)
                If kv.Length = 2 Then
                    Dim id As Integer
                    Dim qty As Decimal
                    If Integer.TryParse(kv(0).Trim(), id) AndAlso Decimal.TryParse(kv(1).Trim(), qty) Then
                        map(id) = qty
                    End If
                End If
            Next
            Return map
        End Function

        Private Function ResolveProductName(cn As SqlConnection, productId As Integer) As String
            If productId <= 0 Then Return ""
            Using cmd As New SqlCommand("SELECT TOP 1 ProductName FROM dbo.Products WHERE ProductID=@id", cn)
                cmd.Parameters.AddWithValue("@id", productId)
                Dim o = cmd.ExecuteScalar()
                If o Is Nothing OrElse o Is DBNull.Value Then Return "#" & productId.ToString()
                Return Convert.ToString(o)
            End Using
        End Function

        Private Function ResolveUserName(cn As SqlConnection, userId As Integer) As String
            If userId <= 0 Then Return ""
            Using cmd As New SqlCommand("SELECT TOP 1 (FirstName + ' ' + LastName) FROM dbo.Users WHERE UserID=@id", cn)
                cmd.Parameters.AddWithValue("@id", userId)
                Dim o = cmd.ExecuteScalar()
                If o Is Nothing OrElse o Is DBNull.Value Then Return "User #" & userId.ToString()
                Return Convert.ToString(o)
            End Using
        End Function

        Private Sub OnOpenStockroom(sender As Object, e As EventArgs)
            ' Navigate to Stockroom fulfill editor with auto shortage-PO prompt ON
            Try
                Dim frm As New Stockroom.InternalOrdersForm(True)
                frm.Show(Me)
            Catch ex As Exception
                MessageBox.Show("Open Stockroom failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

    End Class
End Namespace

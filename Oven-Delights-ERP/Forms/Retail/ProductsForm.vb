' Retail Products screen (frontend label), backed by inventory logic
Imports System
Imports System.Drawing
Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Globalization

Public Class ProductsForm
    Inherits Form

    Private dgv As New DataGridView()
    Private txtSearch As New TextBox()
    Private lblTitle As New Label()
    Private btnClose As New Button()
    Private chkTodayOnly As New CheckBox()

    Public Sub New()
        Me.Text = "Products"
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.Size = New Size(1100, 700)
        Me.MinimumSize = New Size(900, 600)

        lblTitle.Text = "Retail - Products (Internal)"
        lblTitle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
        lblTitle.AutoSize = True
        lblTitle.Location = New Point(20, 15)

        txtSearch.PlaceholderText = "Search by SKU, barcode or name..."
        txtSearch.Location = New Point(22, 60)
        txtSearch.Width = 320
        AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged

        chkTodayOnly.Text = "Today only"
        chkTodayOnly.Checked = True
        chkTodayOnly.AutoSize = True
        chkTodayOnly.Location = New Point(360, 62)
        AddHandler chkTodayOnly.CheckedChanged, Sub(sender, e) LoadData()

        btnClose.Text = "Close"
        btnClose.Location = New Point(1000, 18)
        AddHandler btnClose.Click, Sub(sender, e) Me.Close()

        dgv.Location = New Point(20, 100)
        dgv.Size = New Size(1040, 540)
        dgv.ReadOnly = True
        dgv.AllowUserToAddRows = False
        dgv.AllowUserToDeleteRows = False
        dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgv.RowHeadersVisible = False
        dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgv.EnableHeadersVisualStyles = False
        dgv.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(30, 30, 30)
        dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgv.DefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Regular)

        ' Hidden ProductID for actions
        Dim colPid As New DataGridViewTextBoxColumn()
        colPid.Name = "ProductID"
        colPid.HeaderText = "ProductID"
        colPid.Visible = False
        dgv.Columns.Add(colPid)

        dgv.Columns.Add("SKU", "SKU")
        dgv.Columns.Add("ProductName", "Product")
        dgv.Columns.Add("OnHand", "On Hand")
        dgv.Columns.Add("LastProducer", "Last Producer")
        Dim manuCol As New DataGridViewTextBoxColumn()
        manuCol.HeaderText = "Manufactured Time"
        manuCol.Name = "ManufacturedTime"
        dgv.Columns.Add(manuCol)
        Dim statusCol As New DataGridViewTextBoxColumn()
        statusCol.HeaderText = "Status"
        statusCol.Name = "Status"
        dgv.Columns.Add(statusCol)

        Dim btnCol As New DataGridViewButtonColumn()
        btnCol.HeaderText = "Reorder"
        btnCol.Name = "ReorderBtn"
        btnCol.Text = "Reorder"
        btnCol.UseColumnTextForButtonValue = True
        dgv.Columns.Add(btnCol)

        AddHandler dgv.CellFormatting, AddressOf OnCellFormatting
        AddHandler dgv.CellContentClick, AddressOf OnCellContentClick

        Me.Controls.Add(lblTitle)
        Me.Controls.Add(txtSearch)
        Me.Controls.Add(chkTodayOnly)
        Me.Controls.Add(btnClose)
        Me.Controls.Add(dgv)

        ' Load live data
        LoadData()
    End Sub

    Private Sub OnSearchChanged(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Sub LoadData()
        dgv.Rows.Clear()
        Try
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()

                Dim todayOnly As Boolean = chkTodayOnly.Checked
                Dim sql As String = ""
                sql &= "DECLARE @BranchID INT = @pBranchID;" & vbCrLf
                sql &= "DECLARE @RetailLoc INT = dbo.fn_GetLocationId(@BranchID, N'RETAIL');" & vbCrLf
                sql &= "IF @RetailLoc IS NULL SET @RetailLoc = dbo.fn_GetLocationId(NULL, N'RETAIL');" & vbCrLf
                sql &= "IF @RetailLoc IS NULL SET @RetailLoc = 0;" & vbCrLf
                If todayOnly Then
                    ' Consider only movements to Retail that happened today
                    sql &= "WITH LastMove AS (" & vbCrLf
                    sql &= "  SELECT pm.ProductID, MAX(pm.ProductMovementID) AS LastMovementID" & vbCrLf
                    sql &= "  FROM dbo.ProductMovements pm" & vbCrLf
                    sql &= "  WHERE pm.ToLocationID = @RetailLoc" & vbCrLf
                    sql &= "    AND pm.BranchID = @BranchID" & vbCrLf
                    sql &= "    AND pm.MovementDate >= CAST(GETDATE() AS DATE)" & vbCrLf
                    sql &= "    AND pm.MovementDate < DATEADD(day,1,CAST(GETDATE() AS DATE))" & vbCrLf
                    sql &= "  GROUP BY pm.ProductID" & vbCrLf
                    sql &= ")" & vbCrLf
                Else
                    sql &= "WITH LastMove AS (" & vbCrLf
                    sql &= "  SELECT pm.ProductID, MAX(pm.ProductMovementID) AS LastMovementID" & vbCrLf
                    sql &= "  FROM dbo.ProductMovements pm" & vbCrLf
                    sql &= "  WHERE pm.ToLocationID = @RetailLoc" & vbCrLf
                    sql &= "    AND pm.BranchID = @BranchID" & vbCrLf
                    sql &= "  GROUP BY pm.ProductID" & vbCrLf
                    sql &= ")" & vbCrLf
                End If
                sql &= "SELECT TOP 500" & vbCrLf
                sql &= "    p.ProductID," & vbCrLf
                sql &= "    p.ProductCode AS SKU," & vbCrLf
                sql &= "    p.ProductName," & vbCrLf
                sql &= "    ISNULL(pi.QuantityOnHand, 0) AS OnHand," & vbCrLf
                sql &= "    ISNULL(u.FirstName + ' ' + u.LastName, '') AS LastProducer," & vbCrLf
                sql &= "    pm.MovementDate AS ManufacturedTime" & vbCrLf
                sql &= "FROM dbo.Products p" & vbCrLf
                sql &= "LEFT JOIN dbo.ProductInventory pi" & vbCrLf
                sql &= "  ON pi.ProductID = p.ProductID" & vbCrLf
                sql &= " AND pi.LocationID = @RetailLoc" & vbCrLf
                sql &= " AND pi.BranchID = @BranchID" & vbCrLf
                sql &= "LEFT JOIN LastMove lm ON lm.ProductID = p.ProductID" & vbCrLf
                sql &= "LEFT JOIN dbo.ProductMovements pm ON pm.ProductMovementID = lm.LastMovementID" & vbCrLf
                sql &= "LEFT JOIN dbo.Users u ON u.UserID = pm.CreatedBy" & vbCrLf
                sql &= "WHERE (" & vbCrLf
                sql &= "       @pSearch = ''" & vbCrLf
                sql &= "    OR p.ProductCode LIKE '%' + @pSearch + '%'" & vbCrLf
                sql &= "    OR p.ProductName LIKE '%' + @pSearch + '%')" & vbCrLf
                If todayOnly Then
                    sql &= vbCrLf & "  AND pm.ProductMovementID IS NOT NULL" & vbCrLf
                End If
                sql &= "ORDER BY p.ProductName;"

                Using cmd As New SqlCommand(sql, cn)
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    If branchId <= 0 Then
                        Throw New ApplicationException("Branch is required for Retail view.")
                    End If
                    Dim pBranch As New SqlParameter("@pBranchID", SqlDbType.Int)
                    pBranch.Value = branchId
                    cmd.Parameters.Add(pBranch)
                    cmd.Parameters.AddWithValue("@pSearch", If(txtSearch.Text, String.Empty))

                    Dim added As Integer = 0
                    Using rdr = cmd.ExecuteReader()
                        While rdr.Read()
                            Dim pid As Integer = Convert.ToInt32(rdr("ProductID"))
                            Dim sku As String = Convert.ToString(rdr("SKU"))
                            Dim name As String = Convert.ToString(rdr("ProductName"))
                            Dim onHand As Decimal = If(IsDBNull(rdr("OnHand")), 0D, Convert.ToDecimal(rdr("OnHand")))
                            Dim lastProd As String = Convert.ToString(rdr("LastProducer"))
                            Dim manuTime As String = If(rdr.IsDBNull(rdr.GetOrdinal("ManufacturedTime")), "", Convert.ToDateTime(rdr("ManufacturedTime")).ToLocalTime().ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture))
                            dgv.Rows.Add(New Object() {pid, sku, name, onHand, lastProd, manuTime, StatusText(onHand)})
                            added += 1
                        End While
                    End Using
                    ' No popups for empty state per strict-branch rule
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function StatusText(onHand As Decimal) As String
        If onHand < 10D Then Return "Red"
        If onHand < 15D Then Return "Yellow"
        Return "Green"
    End Function

    Private Sub OnCellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs)
        If dgv.Columns(e.ColumnIndex).Name = "Status" AndAlso e.Value IsNot Nothing Then
            Dim val = e.Value.ToString()
            Dim color As Color = Color.LightGreen
            If val = "Yellow" Then color = Color.Khaki
            If val = "Red" Then color = Color.LightCoral
            dgv.Rows(e.RowIndex).DefaultCellStyle.BackColor = color
        End If
    End Sub

    Private Sub OnCellContentClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        If dgv.Columns(e.ColumnIndex).Name <> "ReorderBtn" Then Return

        Dim status As String = TryCast(dgv.Rows(e.RowIndex).Cells("Status").Value, String)
        Dim pidObj = dgv.Rows(e.RowIndex).Cells("ProductID").Value
        Dim sku As String = Convert.ToString(dgv.Rows(e.RowIndex).Cells("SKU").Value)
        Dim name As String = Convert.ToString(dgv.Rows(e.RowIndex).Cells("ProductName").Value)
        If pidObj Is Nothing Then
            MessageBox.Show("Cannot reorder: missing ProductID.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Dim pid As Integer = Convert.ToInt32(pidObj)

        ' Only show immediate reorder prompt for Red items (shortage)
        If status IsNot Nothing AndAlso status <> "Red" Then
            If MessageBox.Show("This item is not Red. Reorder anyway?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.No Then
                Return
            End If
        End If

        Dim qtyStr As String = InputBox($"Enter quantity to reorder for {sku} - {name}:", "Reorder", "10")
        Dim qty As Decimal
        If Not Decimal.TryParse((If(qtyStr, "")).Trim(), qty) OrElse qty <= 0D Then
            MessageBox.Show("Invalid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        ' Select manufacturer (RequestedBy should be the actual producer, not the current user)
        Dim selUserId As Integer = 0
        Using dlg As New ManufacturerSelectDialog()
            If dlg.ShowDialog(Me) <> DialogResult.OK Then
                Return
            End If
            selUserId = dlg.SelectedUserId
        End Using

        Try
            Dim svc As New ManufacturingService()
            Dim items As New List(Of Tuple(Of Integer, Decimal))()
            items.Add(New Tuple(Of Integer, Decimal)(pid, qty))
            Dim branchId As Integer = AppSession.CurrentBranchID
            svc.CreateBundleFromBOM(items, branchId, selUserId)
            MessageBox.Show("Reorder request generated and routed to Stockroom/MFG for the selected manufacturer.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Failed to create reorder: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class

Imports System.Windows.Forms
Imports System.Data
Imports System.Collections.Generic
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing

Public Class MOActionsForm
    Inherits Form

    Private svc As New ManufacturingService()

    Private txtMOID As TextBox
    Private txtRawMaterialID As TextBox
    Private txtQuantity As TextBox
    Private txtUoM As TextBox
    Private txtProductID As TextBox
    Private txtInternalOrderID As TextBox
    Private txtBundleItems As TextBox ' multiline: ProductID:Qty per line
    
    ' Quick single-product bundle controls (no typing IDs)
    Private cboQuickProduct As ComboBox
    Private txtQuickQty As TextBox
    Private btnCreateQuick As Button

    Private btnIssue As Button
    Private btnReceive As Button
    Private btnTransfer As Button
    Private btnIssueFromBOM As Button
    Private btnCreateBundle As Button
    Private btnFulfillBundle As Button

    Public Sub New()
        Me.Text = "Request Materials (Bundles)"
        Me.Width = 560
        Me.Height = 420
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUi()
    End Sub

    Private Sub OnCreateBundle(sender As Object, e As EventArgs)
        Try
            Dim items As New List(Of Tuple(Of Integer, Decimal))()
            For Each line In (If(txtBundleItems.Text, String.Empty)).Split({vbCrLf}, StringSplitOptions.RemoveEmptyEntries)
                Dim parts = line.Split({":"c}, StringSplitOptions.RemoveEmptyEntries)
                If parts.Length = 2 Then
                    Dim pid As Integer
                    Dim qty As Decimal
                    If Integer.TryParse(parts(0).Trim(), pid) AndAlso Decimal.TryParse(parts(1).Trim(), qty) AndAlso pid > 0 AndAlso qty > 0D Then
                        items.Add(Tuple.Create(pid, qty))
                    End If
                End If
            Next
            If items.Count = 0 Then
                MessageBox.Show("Enter at least one line in the format ProductID:Qty", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim ds = svc.CreateBundleFromBOM(items, AppSession.CurrentBranchID, AppSession.CurrentUserID, "STOCKROOM", "MFG")
            Dim ioInfo As String = ""
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim row = ds.Tables(0).Rows(0)
                ioInfo = $"IO #{row("InternalOrderNo")}, ID={row("InternalOrderID")}"
            End If
            Dim lines As Integer = If(ds IsNot Nothing AndAlso ds.Tables.Count > 1, ds.Tables(1).Rows.Count, 0)
            MessageBox.Show($"Bundle created. {ioInfo}. Lines: {lines}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Create bundle failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnFulfillBundle(sender As Object, e As EventArgs)
        Try
            Dim ioId = SafeInt(txtInternalOrderID.Text)
            If ioId <= 0 Then
                MessageBox.Show("Please provide a valid InternalOrderID.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim dt = svc.FulfillBundleToMFG(ioId, AppSession.CurrentBranchID, AppSession.CurrentUserID)
            Dim lines As Integer = If(dt IsNot Nothing, dt.Rows.Count, 0)
            MessageBox.Show($"Bundle fulfilled to MFG. Lines issued: {lines}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Fulfill bundle failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InitializeUi()
        Dim lblMO As New Label() With {.Text = "MOID:", .Left = 20, .Top = 20, .AutoSize = True}
        txtMOID = New TextBox() With {.Left = 120, .Top = 16, .Width = 120}

        Dim lblRM As New Label() With {.Text = "RawMaterialID:", .Left = 20, .Top = 52, .AutoSize = True}
        txtRawMaterialID = New TextBox() With {.Left = 120, .Top = 48, .Width = 120}

        Dim lblQty As New Label() With {.Text = "Quantity:", .Left = 20, .Top = 84, .AutoSize = True}
        txtQuantity = New TextBox() With {.Left = 120, .Top = 80, .Width = 120, .Text = "1.00"}

        Dim lblU As New Label() With {.Text = "UoM:", .Left = 260, .Top = 84, .AutoSize = True}
        txtUoM = New TextBox() With {.Left = 300, .Top = 80, .Width = 80, .Text = "kg"}

        Dim lblProd As New Label() With {.Text = "ProductID:", .Left = 20, .Top = 116, .AutoSize = True}
        txtProductID = New TextBox() With {.Left = 120, .Top = 112, .Width = 120}

        btnIssue = New Button() With {.Text = "Issue Material", .Left = 20, .Top = 160, .Width = 150}
        btnReceive = New Button() With {.Text = "Receive Output", .Left = 190, .Top = 160, .Width = 150}
        btnTransfer = New Button() With {.Text = "Transfer to Retail", .Left = 360, .Top = 160, .Width = 150}
        btnIssueFromBOM = New Button() With {.Text = "Issue from BOM", .Left = 20, .Top = 200, .Width = 150}

        Dim lblIO As New Label() With {.Text = "InternalOrderID:", .Left = 190, .Top = 204, .AutoSize = True}
        txtInternalOrderID = New TextBox() With {.Left = 290, .Top = 200, .Width = 100}
        btnFulfillBundle = New Button() With {.Text = "Fulfill Bundle", .Left = 400, .Top = 200, .Width = 110}

        ' Quick Bundle section (select product with active BOM + quantity)
        Dim lblQuick As New Label() With {.Text = "Request Materials (Quick Bundle):", .Left = 20, .Top = 236, .AutoSize = True}
        Dim lblQuickProd As New Label() With {.Text = "Product:", .Left = 20, .Top = 260, .AutoSize = True}
        cboQuickProduct = New ComboBox() With {.Left = 80, .Top = 256, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}
        Dim lblQuickQty As New Label() With {.Text = "Qty:", .Left = 310, .Top = 260, .AutoSize = True}
        txtQuickQty = New TextBox() With {.Left = 340, .Top = 256, .Width = 60, .Text = "1.00"}
        btnCreateQuick = New Button() With {.Text = "Create Bundle for Product", .Left = 410, .Top = 255, .Width = 120}

        ' Move advanced multi-line area lower to avoid clutter
        Dim lblBundle As New Label() With {.Text = "Advanced: Bundle Items (ProductID:Qty per line)", .Left = 20, .Top = 296, .AutoSize = True}
        txtBundleItems = New TextBox() With {.Left = 20, .Top = 316, .Width = 350, .Height = 80, .Multiline = True, .ScrollBars = ScrollBars.Vertical}
        btnCreateBundle = New Button() With {.Text = "Create Material Bundle", .Left = 380, .Top = 316, .Width = 150}

        AddHandler btnIssue.Click, AddressOf OnIssue
        AddHandler btnReceive.Click, AddressOf OnReceive
        AddHandler btnTransfer.Click, AddressOf OnTransfer
        AddHandler btnIssueFromBOM.Click, AddressOf OnIssueFromBOM
        AddHandler btnCreateBundle.Click, AddressOf OnCreateBundle
        AddHandler btnFulfillBundle.Click, AddressOf OnFulfillBundle
        AddHandler btnCreateQuick.Click, AddressOf OnCreateQuickBundle

        Me.Controls.AddRange(New Control() {lblMO, txtMOID, lblRM, txtRawMaterialID, lblQty, txtQuantity, lblU, txtUoM, lblProd, txtProductID,
                                             btnIssue, btnReceive, btnTransfer, btnIssueFromBOM, lblIO, txtInternalOrderID, btnFulfillBundle,
                                             lblQuick, lblQuickProd, cboQuickProduct, lblQuickQty, txtQuickQty, btnCreateQuick,
                                             lblBundle, txtBundleItems, btnCreateBundle})

        ' Populate quick product dropdown
        Try
            LoadActiveBOMProducts()
        Catch ex As Exception
            ' Non-fatal: user can still use advanced area
        End Try
    End Sub

    Private Sub LoadActiveBOMProducts()
        Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using cn As New SqlConnection(cs)
            cn.Open()
            Dim sql As String = "SELECT DISTINCT P.ProductID, P.ProductName FROM dbo.Products P WHERE EXISTS (SELECT 1 FROM dbo.BOMHeader H WHERE H.ProductID = P.ProductID AND H.IsActive = 1 AND H.EffectiveFrom <= CAST(GETDATE() AS DATE) AND (H.EffectiveTo IS NULL OR H.EffectiveTo >= CAST(GETDATE() AS DATE))) ORDER BY P.ProductName"
            Using cmd As New SqlCommand(sql, cn)
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    cboQuickProduct.DataSource = dt
                    cboQuickProduct.DisplayMember = "ProductName"
                    cboQuickProduct.ValueMember = "ProductID"
                End Using
            End Using
        End Using
    End Sub

    Private Sub OnCreateQuickBundle(sender As Object, e As EventArgs)
        Try
            If cboQuickProduct Is Nothing OrElse cboQuickProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Select a product with an active BOM.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim pid As Integer = Convert.ToInt32(cboQuickProduct.SelectedValue)
            Dim qty As Decimal = SafeDec(txtQuickQty.Text)
            If qty <= 0D Then
                MessageBox.Show("Enter a positive quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim items As New List(Of Tuple(Of Integer, Decimal))()
            items.Add(Tuple.Create(pid, qty))
            Dim ds = svc.CreateBundleFromBOM(items, AppSession.CurrentBranchID, AppSession.CurrentUserID, "STOCKROOM", "MFG")
            Dim ioInfo As String = ""
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim row = ds.Tables(0).Rows(0)
                ioInfo = $"IO #{row("InternalOrderNo")}, ID={row("InternalOrderID")}"
            End If
            Dim lines As Integer = If(ds IsNot Nothing AndAlso ds.Tables.Count > 1, ds.Tables(1).Rows.Count, 0)
            MessageBox.Show($"Bundle created for product. {ioInfo}. Lines: {lines}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Create bundle failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnIssue(sender As Object, e As EventArgs)
        Try
            Dim moId = SafeInt(txtMOID.Text)
            Dim rmId = SafeInt(txtRawMaterialID.Text)
            Dim qty = SafeDec(txtQuantity.Text)
            Dim u = txtUoM.Text
            If moId <= 0 OrElse rmId <= 0 OrElse qty <= 0D Then
                MessageBox.Show("Please provide MOID, RawMaterialID and positive Quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim outId = svc.IssueMaterial(moId, "RawMaterial", rmId, Nothing, qty, u, "STOCKROOM", "MFG", AppSession.CurrentBranchID, AppSession.CurrentUserID)
            MessageBox.Show($"Issued. OutMovementID={outId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Issue failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnReceive(sender As Object, e As EventArgs)
        Try
            Dim moId = SafeInt(txtMOID.Text)
            Dim qty = SafeDec(txtQuantity.Text)
            Dim u = txtUoM.Text
            If moId <= 0 OrElse qty <= 0D Then
                MessageBox.Show("Please provide MOID and positive Quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim lineId = svc.ReceiveOutput(moId, qty, u, "MFG", AppSession.CurrentBranchID, AppSession.CurrentUserID)
            MessageBox.Show($"Output received. MOOutputLineID={lineId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Receive failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnTransfer(sender As Object, e As EventArgs)
        Try
            Dim prodId = SafeInt(txtProductID.Text)
            Dim qty = SafeDec(txtQuantity.Text)
            If prodId <= 0 OrElse qty <= 0D Then
                MessageBox.Show("Please provide ProductID and positive Quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            svc.TransferToRetail(prodId, qty, AppSession.CurrentBranchID, AppSession.CurrentUserID, "MFG", "RETAIL")
            MessageBox.Show("Transfer completed.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Transfer failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnIssueFromBOM(sender As Object, e As EventArgs)
        Try
            Dim moId = SafeInt(txtMOID.Text)
            Dim qty = SafeDec(txtQuantity.Text)
            If moId <= 0 OrElse qty <= 0D Then
                MessageBox.Show("Please provide MOID and positive Quantity (output to produce).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim dt = svc.IssueFromBOM(moId, qty, AppSession.CurrentBranchID, AppSession.CurrentUserID, "STOCKROOM", "MFG")
            Dim issuedLines As Integer = If(dt IsNot Nothing, dt.Rows.Count, 0)
            MessageBox.Show($"BOM issued for MO {moId}. Lines: {issuedLines}.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Issue from BOM failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function SafeInt(s As String) As Integer
        Dim v As Integer = 0
        Integer.TryParse((If(s, "")).Trim(), v)
        Return v
    End Function

    Private Function SafeDec(s As String) As Decimal
        Dim v As Decimal = 0D
        Decimal.TryParse((If(s, "")).Trim(), v)
        Return v
    End Function

End Class

End Namespace

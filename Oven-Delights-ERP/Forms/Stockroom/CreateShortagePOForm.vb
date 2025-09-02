Imports System.Data
Imports System.Linq
Imports System.Windows.Forms

Namespace Stockroom

Public Class CreateShortagePOForm
    Inherits Form

    Private ReadOnly _branchId As Integer
    Private ReadOnly _internalOrderId As Integer
    Private ReadOnly _shortages As DataTable ' Columns: MaterialID(int), MaterialName(nvarchar), ShortQty(decimal)

    Private ReadOnly svc As New StockroomService()

    Private lblSupplier As Label
    Private cboSupplier As ComboBox
    Private dgvPreview As DataGridView
    Private btnCreate As Button
    Private btnCancel As Button

    Public Sub New(branchId As Integer, internalOrderId As Integer, shortages As DataTable)
        _branchId = branchId
        _internalOrderId = internalOrderId
        _shortages = shortages

        Me.Text = "Create Draft PO for Shortages"
        Me.Width = 820
        Me.Height = 520
        Me.StartPosition = FormStartPosition.CenterParent

        InitializeUi()
        LoadData()
    End Sub

    Private Sub InitializeUi()
        lblSupplier = New Label() With {.Left = 12, .Top = 14, .AutoSize = True, .Text = "Supplier:"}
        cboSupplier = New ComboBox() With {.Left = 80, .Top = 10, .Width = 380, .DropDownStyle = ComboBoxStyle.DropDownList}

        dgvPreview = New DataGridView() With {
            .Left = 12, .Top = 44, .Width = 780, .Height = 380,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False
        }

        btnCreate = New Button() With {.Left = 560, .Top = 440, .Width = 110, .Text = "Create PO"}
        btnCancel = New Button() With {.Left = 680, .Top = 440, .Width = 110, .Text = "Cancel"}

        AddHandler btnCreate.Click, AddressOf OnCreate
        AddHandler btnCancel.Click, Sub(sender, e) Me.Close()

        Me.Controls.AddRange(New Control() {lblSupplier, cboSupplier, dgvPreview, btnCreate, btnCancel})
    End Sub

    Private Sub LoadData()
        Try
            ' Suppliers list
            Dim sup = svc.GetAllSuppliers()
            cboSupplier.DataSource = sup
            cboSupplier.DisplayMember = "Name"
            cboSupplier.ValueMember = "ID"

            ' Shortages preview
            dgvPreview.DataSource = _shortages
            If dgvPreview.Columns.Contains("MaterialID") Then dgvPreview.Columns("MaterialID").HeaderText = "MaterialID"
            If dgvPreview.Columns.Contains("MaterialName") Then dgvPreview.Columns("MaterialName").HeaderText = "Material"
            If dgvPreview.Columns.Contains("ShortQty") Then dgvPreview.Columns("ShortQty").HeaderText = "Short Qty"

            ' Default supplier resolution
            Dim ids As IEnumerable(Of Integer) = _shortages.AsEnumerable().Select(Function(r) Convert.ToInt32(r("MaterialID"))).Distinct()
            Dim defaultSup As Integer = svc.ResolveDefaultSupplierForMaterials(ids)
            If defaultSup > 0 Then
                cboSupplier.SelectedValue = defaultSup
            End If
        Catch ex As Exception
            MessageBox.Show("Failed to load suppliers or shortages: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCreate(sender As Object, e As EventArgs)
        Dim supplierId As Integer = 0
        If cboSupplier.SelectedValue IsNot Nothing Then
            Integer.TryParse(cboSupplier.SelectedValue.ToString(), supplierId)
        End If
        If supplierId <= 0 Then
            MessageBox.Show("Please select a supplier.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If _shortages Is Nothing OrElse _shortages.Rows.Count = 0 Then
            MessageBox.Show("No shortage lines to create a PO.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            ' Prepare lines for CreatePurchaseOrder: MaterialID, OrderedQuantity, UnitCost
            Dim dtLines As New DataTable()
            dtLines.Columns.Add("MaterialID", GetType(Integer))
            dtLines.Columns.Add("OrderedQuantity", GetType(Decimal))
            dtLines.Columns.Add("UnitCost", GetType(Decimal))

            For Each r As DataRow In _shortages.Rows
                Dim mid As Integer = Convert.ToInt32(r("MaterialID"))
                Dim q As Decimal = Convert.ToDecimal(r("ShortQty"))
                If q <= 0 OrElse mid <= 0 Then Continue For
                dtLines.Rows.Add(mid, q, 0D) ' UnitCost = 0; pricing to be adjusted later
            Next

            If dtLines.Rows.Count = 0 Then
                MessageBox.Show("No valid shortage lines found.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim ref As String = $"IO#{_internalOrderId} Shortages"
            Dim notes As String = "Auto-created from Stockroom shortages. Prices to be confirmed."

            Dim poId As Integer = svc.CreatePurchaseOrder(
                _branchId,
                supplierId,
                DateTime.Now,
                Nothing,
                ref,
                notes,
                AppSession.CurrentUserID,
                dtLines
            )

            If poId > 0 Then
                Dim h = svc.GetPurchaseOrderHeader(poId)
                Dim poNo As String = If(h IsNot Nothing AndAlso h.Rows.Count > 0 AndAlso Not IsDBNull(h.Rows(0)("PONumber")), Convert.ToString(h.Rows(0)("PONumber")), poId.ToString())
                MessageBox.Show($"Draft PO created: {poNo}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Else
                MessageBox.Show("PO creation returned no ID.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        Catch ex As Exception
            MessageBox.Show("Failed to create PO: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class

End Namespace

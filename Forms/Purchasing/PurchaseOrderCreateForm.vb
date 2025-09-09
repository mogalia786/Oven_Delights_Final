Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Namespace Purchasing
    Public Class PurchaseOrderCreateForm
        Inherits Form

        Private ReadOnly cboSupplier As New ComboBox()
        Private ReadOnly txtSupplier As New TextBox()
        Private ReadOnly btnOk As New Button()
        Private ReadOnly btnCancel As New Button()
        Private ReadOnly lblSupplier As New Label()

        Public Property CreatedPurchaseOrderID As Integer
        Public Property SupplierID As Integer?
        Public Property SupplierName As String

        Public Sub New()
            Me.Text = "Create Purchase Order"
            Me.Size = New Size(480, 180)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            lblSupplier.Text = "Supplier:"
            lblSupplier.Location = New Point(16, 22)
            lblSupplier.AutoSize = True

            ' Supplier selector (preferred)
            cboSupplier.DropDownStyle = ComboBoxStyle.DropDownList
            cboSupplier.Location = New Point(130, 18)
            cboSupplier.Width = 320
            AddHandler cboSupplier.SelectedIndexChanged, AddressOf OnSupplierChanged

            ' Optional free-text (advanced/override); hidden by default to avoid mismatches
            txtSupplier.Location = New Point(130, 48)
            txtSupplier.Width = 320
            txtSupplier.Visible = False

            btnOk.Text = "Create"
            btnOk.Location = New Point(270, 70)
            btnOk.Width = 80
            AddHandler btnOk.Click, AddressOf OnCreate

            btnCancel.Text = "Cancel"
            btnCancel.Location = New Point(370, 70)
            btnCancel.Width = 80
            AddHandler btnCancel.Click, Sub() Me.DialogResult = DialogResult.Cancel

            Controls.Add(lblSupplier)
            Controls.Add(cboSupplier)
            Controls.Add(txtSupplier)
            Controls.Add(btnOk)
            Controls.Add(btnCancel)

            LoadSuppliers()
        End Sub

        Private Sub LoadSuppliers()
            Try
                Dim svc As New StockroomService()
                Dim dt = svc.GetSuppliersLookup()
                cboSupplier.DisplayMember = "CompanyName"
                cboSupplier.ValueMember = "SupplierID"
                cboSupplier.DataSource = dt
                cboSupplier.SelectedIndex = -1
            Catch
                ' fall back to free-text
                cboSupplier.Enabled = False
                txtSupplier.Visible = True
            End Try
        End Sub

        Private Sub OnSupplierChanged(sender As Object, e As EventArgs)
            If cboSupplier.SelectedIndex >= 0 Then
                Dim drv = TryCast(cboSupplier.SelectedItem, DataRowView)
                If drv IsNot Nothing Then
                    SupplierID = Convert.ToInt32(drv("SupplierID"))
                    SupplierName = Convert.ToString(drv("CompanyName"))
                Else
                    Dim valObj As Object = cboSupplier.SelectedValue
                    If valObj IsNot Nothing AndAlso valObj IsNot DBNull.Value Then
                        SupplierID = Convert.ToInt32(valObj)
                    Else
                        SupplierID = Nothing
                    End If
                    SupplierName = cboSupplier.Text
                End If
            Else
                SupplierID = Nothing
                SupplierName = Nothing
            End If
        End Sub

        Private Sub OnCreate(sender As Object, e As EventArgs)
            Dim sup As String = SupplierName
            If cboSupplier.Enabled Then
                If cboSupplier.SelectedIndex < 0 Then
                    MessageBox.Show(Me, "Select a supplier.", "PO", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If
            Else
                ' Fallback: free-text
                sup = txtSupplier.Text?.Trim()
                If String.IsNullOrEmpty(sup) Then
                    MessageBox.Show(Me, "Enter Supplier Name.", "PO", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If
            End If
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("dbo.sp_PurchaseOrders_Create", cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentBranchID)
                        cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
                        cmd.Parameters.AddWithValue("@SupplierID", If(SupplierID.HasValue, CType(SupplierID.Value, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@SupplierName", sup)
                        cmd.Parameters.AddWithValue("@Notes", DBNull.Value)
                        Dim pOut = cmd.Parameters.Add("@PurchaseOrderID", SqlDbType.Int)
                        pOut.Direction = ParameterDirection.Output
                        cmd.ExecuteNonQuery()
                        CreatedPurchaseOrderID = If(pOut.Value Is Nothing OrElse pOut.Value Is DBNull.Value, 0, Convert.ToInt32(pOut.Value))
                        SupplierName = sup
                    End Using
                End Using
                If CreatedPurchaseOrderID <= 0 Then
                    MessageBox.Show(Me, "Failed to create PO.", "PO", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
                Me.DialogResult = DialogResult.OK
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "PO", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Public Shared Function CreatePO(owner As IWin32Window) As (Ok As Boolean, PurchaseOrderID As Integer, SupplierID As Integer?, SupplierName As String)
            Using f As New PurchaseOrderCreateForm()
                If f.ShowDialog(owner) = DialogResult.OK Then
                    Return (True, f.CreatedPurchaseOrderID, f.SupplierID, f.SupplierName)
                End If
            End Using
            Return (False, 0, Nothing, Nothing)
        End Function
    End Class
End Namespace

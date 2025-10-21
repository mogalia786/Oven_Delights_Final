' MainDashboard.vb
' Logic for the main dashboard form
Public Class MainDashboard
    Inherits Form
    
    Private Sub MainDashboard_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        ' Initialize dashboard
        UpdateNewOrdersBadge()
    End Sub
    
    Private Sub mnuNewOrders_Click(sender As Object, e As EventArgs) Handles mnuNewOrders.Click
        Try
            Dim frm As New ManufacturerOrdersForm("New")
            frm.ShowDialog()
            UpdateNewOrdersBadge()
        Catch ex As Exception
            MessageBox.Show("Error opening orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub mnuReadyOrders_Click(sender As Object, e As EventArgs) Handles mnuReadyOrders.Click
        Try
            Dim frm As New ManufacturerOrdersForm("Ready")
            frm.ShowDialog()
            UpdateNewOrdersBadge()
        Catch ex As Exception
            MessageBox.Show("Error opening orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub mnuAllOrders_Click(sender As Object, e As EventArgs) Handles mnuAllOrders.Click
        Try
            Dim frm As New ManufacturerOrdersForm("All")
            frm.ShowDialog()
            UpdateNewOrdersBadge()
        Catch ex As Exception
            MessageBox.Show("Error opening orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub UpdateNewOrdersBadge()
        Try
            Dim connString As String = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            If String.IsNullOrEmpty(connString) Then Return
            
            Using conn As New System.Data.SqlClient.SqlConnection(connString)
                conn.Open()
                Dim cmd As New System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM POS_CustomOrders WHERE OrderStatus = 'New'", conn)
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                
                If count > 0 Then
                    mnuNewOrders.Text = $"New Orders ({count})"
                    mnuNewOrders.BackColor = Color.Orange
                    mnuNewOrders.ForeColor = Color.White
                Else
                    mnuNewOrders.Text = "New Orders"
                    mnuNewOrders.BackColor = Color.Transparent
                    mnuNewOrders.ForeColor = Color.Black
                End If
            End Using
        Catch ex As Exception
            ' Silent fail
        End Try
    End Sub
End Class

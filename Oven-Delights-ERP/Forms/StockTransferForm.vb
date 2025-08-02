Imports System.Windows.Forms

Public Class StockTransferForm
    Inherits Form

    Private currentUser As User

    Public Sub New(user As User)
        InitializeComponent()
        currentUser = user
        LoadSampleData()
    End Sub

    Private Sub LoadSampleData()
        Try
            ' Sample stock transfer data
            Dim transfers As New List(Of Object) From {
                New With {.ID = 1, .TransferNumber = "ST-2024-001", .FromLocation = "Main Warehouse", .ToLocation = "Retail Store", .TransferDate = DateTime.Now.AddDays(-2), .Status = "Completed"},
                New With {.ID = 2, .TransferNumber = "ST-2024-002", .FromLocation = "Production Floor", .ToLocation = "Main Warehouse", .TransferDate = DateTime.Now.AddDays(-1), .Status = "Pending"}
            }
            
            If dgvTransfers IsNot Nothing Then
                dgvTransfers.DataSource = transfers
            End If

        Catch ex As Exception
            MessageBox.Show($"Error loading transfer data: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockTransferForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Stock Transfers - Oven Delights ERP"
        Me.WindowState = FormWindowState.Maximized
    End Sub
End Class

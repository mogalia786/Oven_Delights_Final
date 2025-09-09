Imports System.Windows.Forms

Public Class StockAdjustmentForm
    Inherits Form

    Private currentUser As User

    ' Parameterless constructor for design-time support
    Public Sub New()
        InitializeComponent()
        ' Do not load data here to keep designer safe
    End Sub

    Public Sub New(user As User)
        InitializeComponent()
        currentUser = user
        LoadSampleData()
    End Sub

    Private Sub LoadSampleData()
        Try
            ' Sample stock adjustment data
            Dim adjustments As New List(Of Object) From {
                New With {.ID = 1, .AdjustmentNumber = "SA-2024-001", .MaterialName = "All Purpose Flour", .AdjustmentType = "Increase", .Quantity = 50, .Reason = "Stock Count Correction", .AdjustmentDate = DateTime.Now.AddDays(-1)},
                New With {.ID = 2, .AdjustmentNumber = "SA-2024-002", .MaterialName = "Granulated Sugar", .AdjustmentType = "Decrease", .Quantity = -25, .Reason = "Damaged Goods", .AdjustmentDate = DateTime.Now}
            }
            
            If dgvAdjustments IsNot Nothing Then
                dgvAdjustments.DataSource = adjustments
            End If

        Catch ex As Exception
            MessageBox.Show($"Error loading adjustment data: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockAdjustmentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Stock Adjustments - Oven Delights ERP"
        Me.WindowState = FormWindowState.Maximized
    End Sub
End Class

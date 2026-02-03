Imports System.Data.SqlClient
Imports System.Configuration

Public Class TestGridHeaders
    Inherits Form
    
    Private dgv As DataGridView
    
    Public Sub New()
        Me.Text = "Grid Header Test"
        Me.Size = New Size(800, 600)
        Me.StartPosition = FormStartPosition.CenterScreen
        
        dgv = New DataGridView()
        dgv.Dock = DockStyle.Fill
        dgv.AutoGenerateColumns = False
        dgv.ColumnHeadersVisible = True
        dgv.ColumnHeadersHeight = 50
        dgv.EnableHeadersVisualStyles = False
        dgv.ColumnHeadersDefaultCellStyle.BackColor = Color.Orange
        dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.Black
        dgv.ColumnHeadersDefaultCellStyle.Font = New Font("Arial", 12, FontStyle.Bold)
        
        dgv.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Col1", .HeaderText = "HEADER 1", .Width = 150})
        dgv.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Col2", .HeaderText = "HEADER 2", .Width = 150})
        dgv.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Col3", .HeaderText = "HEADER 3", .Width = 150})
        
        ' Add test data
        dgv.Rows.Add("Data 1", "Data 2", "Data 3")
        dgv.Rows.Add("Test A", "Test B", "Test C")
        
        Me.Controls.Add(dgv)
    End Sub
End Class

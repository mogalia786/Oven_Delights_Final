Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class ProductForm
        Inherits Form
        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        Private dgv As DataGridView
        Private btnRefresh As Button

        Public Sub New()
            Me.Text = "Manufacturing - Products"
            Me.Name = "ProductForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.FromArgb(245, 247, 250)
            Me.Width = 1200
            Me.Height = 800

            Dim header As New Label() With {
                .Text = "Products (Finished / Semi-Finished)",
                .Dock = DockStyle.Top,
                .Height = 44,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.White,
                .BackColor = Color.FromArgb(0, 99, 99),
                .Padding = New Padding(12, 8, 12, 8)
            }

            Dim toolbar As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 48,
                .BackColor = Color.White
            }
            btnRefresh = New Button() With {
                .Text = "Refresh",
                .Width = 100,
                .Height = 30,
                .Left = 12,
                .Top = 9
            }
            AddHandler btnRefresh.Click, AddressOf OnRefreshClicked
            toolbar.Controls.Add(btnRefresh)

            dgv = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .AutoGenerateColumns = False,
                .BackgroundColor = Color.White
            }
            dgv.ColumnHeadersDefaultCellStyle.BackColor = Color.Gainsboro
            dgv.EnableHeadersVisualStyles = False

            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "ID", .DataPropertyName = "ProductID", .Name = "ProductID", .Width = 70})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Code", .DataPropertyName = "Code", .Name = "Code", .Width = 160})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Product Name", .DataPropertyName = "ProductName", .Name = "ProductName", .Width = 360})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "UoM", .DataPropertyName = "UoM", .Name = "UoM", .Width = 100})
            dgv.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Active", .DataPropertyName = "IsActive", .Name = "IsActive", .Width = 70})

            Controls.Add(dgv)
            Controls.Add(toolbar)
            Controls.Add(header)

            AddHandler Me.Load, AddressOf OnFormLoad
            AddHandler Me.Activated, AddressOf OnActivatedRefresh
        End Sub

        Private Sub OnFormLoad(sender As Object, e As EventArgs)
            Try
                LoadProducts()
            Catch ex As Exception
                MessageBox.Show("Failed to load products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnRefreshClicked(sender As Object, e As EventArgs)
            Try
                LoadProducts()
            Catch ex As Exception
                MessageBox.Show("Refresh failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnActivatedRefresh(sender As Object, e As EventArgs)
            Try
                LoadProducts()
            Catch
            End Try
        End Sub

        Private Sub LoadProducts()
            Dim dt As New DataTable()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                Dim hasSku As Boolean = ColumnExists(cn, Nothing, "Products", "SKU")
                Dim hasDefaultUoMID As Boolean = ColumnExists(cn, Nothing, "Products", "DefaultUoMID")
                
                If hasSku AndAlso hasDefaultUoMID Then
                    Using cmd As New SqlCommand("SELECT p.ProductID, p.SKU AS Code, p.ProductName, u.UoMCode AS UoM, p.IsActive FROM dbo.Products p LEFT JOIN dbo.UoM u ON u.UoMID = p.DefaultUoMID ORDER BY p.ProductName", cn)
                        dt.Load(cmd.ExecuteReader())
                    End Using
                ElseIf hasSku Then
                    Using cmd As New SqlCommand("SELECT p.ProductID, p.SKU AS Code, p.ProductName, p.UnitOfMeasure AS UoM, p.IsActive FROM dbo.Products p ORDER BY p.ProductName", cn)
                        dt.Load(cmd.ExecuteReader())
                    End Using
                Else
                    Using cmd As New SqlCommand("SELECT p.ProductID, p.ProductCode AS Code, p.ProductName, p.UnitOfMeasure AS UoM, p.IsActive FROM dbo.Products p ORDER BY p.ProductName", cn)
                        dt.Load(cmd.ExecuteReader())
                    End Using
                End If
            End Using
            dgv.DataSource = dt
        End Sub

        Private Function ColumnExists(cn As SqlConnection, tx As SqlTransaction, tableName As String, columnName As String) As Boolean
            Using cmd As New SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME=@t AND COLUMN_NAME=@c) THEN 1 ELSE 0 END", cn, tx)
                cmd.Parameters.AddWithValue("@t", tableName)
                cmd.Parameters.AddWithValue("@c", columnName)
                Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
            End Using
        End Function
    End Class
End Namespace

Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class CreditNoteViewerForm
    Inherits Form
    
    Private dgvCreditNotes As DataGridView
    Private btnPrint As Button
    Private btnEmail As Button
    Private btnRefresh As Button
    Private cboStatus As ComboBox
    Private currentBranchId As Integer
    
    Public Sub New()
        InitializeComponent()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Credit Notes Viewer"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        
        currentBranchId = AppSession.CurrentBranchID
        
        ' Header panel
        Dim headerPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#2C3E50"),
            .Padding = New Padding(15)
        }
        
        Dim lblTitle As New Label With {
            .Text = "Credit Notes",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(15, 15)
        }
        
        Dim lblStatus As New Label With {
            .Text = "Status:",
            .ForeColor = Color.White,
            .Location = New Point(15, 50),
            .AutoSize = True
        }
        
        cboStatus = New ComboBox With {
            .Location = New Point(70, 47),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cboStatus.Items.AddRange({"All", "Pending", "Approved", "Applied"})
        cboStatus.SelectedIndex = 0
        AddHandler cboStatus.SelectedIndexChanged, AddressOf LoadCreditNotes
        
        btnRefresh = New Button With {
            .Text = "Refresh",
            .Location = New Point(230, 45),
            .Width = 100,
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnRefresh.Click, AddressOf LoadCreditNotes
        
        headerPanel.Controls.AddRange({lblTitle, lblStatus, cboStatus, btnRefresh})
        
        ' Button panel
        Dim buttonPanel As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Padding = New Padding(15)
        }
        
        btnPrint = New Button With {
            .Text = "Print Selected",
            .Location = New Point(15, 15),
            .Width = 150,
            .Height = 35,
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Enabled = False
        }
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        
        btnEmail = New Button With {
            .Text = "Email Selected",
            .Location = New Point(175, 15),
            .Width = 150,
            .Height = 35,
            .BackColor = ColorTranslator.FromHtml("#E67E22"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Enabled = False
        }
        AddHandler btnEmail.Click, AddressOf btnEmail_Click
        
        buttonPanel.Controls.AddRange({btnPrint, btnEmail})
        
        ' DataGridView
        dgvCreditNotes = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = ColorTranslator.FromHtml("#F8F9FA")}
        }
        AddHandler dgvCreditNotes.SelectionChanged, AddressOf dgvCreditNotes_SelectionChanged
        
        Me.Controls.Add(dgvCreditNotes)
        Me.Controls.Add(headerPanel)
        Me.Controls.Add(buttonPanel)
        
        LoadCreditNotes(Nothing, Nothing)
    End Sub
    
    Private Sub LoadCreditNotes(sender As Object, e As EventArgs)
        Try
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                Dim sql = "SELECT cn.CreditNoteID, cn.CreditNoteNumber, cn.CreditDate, cn.Status, cn.CreditType, " &
                         "cn.TotalAmount, cn.CreditReason, s.CompanyName AS SupplierName, " &
                         "grv.GRNNumber AS GRVNumber, b.BranchName " &
                         "FROM CreditNotes cn " &
                         "LEFT JOIN Suppliers s ON cn.SupplierID = s.SupplierID " &
                         "LEFT JOIN GoodsReceivedNotes grv ON cn.GRVID = grv.GRNID " &
                         "LEFT JOIN Branches b ON cn.BranchID = b.BranchID " &
                         "WHERE cn.BranchID = @BranchID "
                
                If cboStatus.SelectedItem.ToString() <> "All" Then
                    sql &= "AND cn.Status = @Status "
                End If
                
                sql &= "ORDER BY cn.CreditDate DESC"
                
                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@BranchID", currentBranchId)
                    If cboStatus.SelectedItem.ToString() <> "All" Then
                        ad.SelectCommand.Parameters.AddWithValue("@Status", cboStatus.SelectedItem.ToString())
                    End If
                    
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    dgvCreditNotes.DataSource = dt
                    FormatGrid()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading credit notes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatGrid()
        If dgvCreditNotes.Columns.Count = 0 Then Return
        
        If dgvCreditNotes.Columns.Contains("CreditNoteID") Then dgvCreditNotes.Columns("CreditNoteID").Visible = False
        If dgvCreditNotes.Columns.Contains("CreditNoteNumber") Then dgvCreditNotes.Columns("CreditNoteNumber").HeaderText = "Credit Note #"
        If dgvCreditNotes.Columns.Contains("CreditDate") Then
            dgvCreditNotes.Columns("CreditDate").HeaderText = "Date"
            dgvCreditNotes.Columns("CreditDate").DefaultCellStyle.Format = "dd MMM yyyy"
        End If
        If dgvCreditNotes.Columns.Contains("Status") Then dgvCreditNotes.Columns("Status").HeaderText = "Status"
        If dgvCreditNotes.Columns.Contains("CreditType") Then dgvCreditNotes.Columns("CreditType").HeaderText = "Type"
        If dgvCreditNotes.Columns.Contains("TotalAmount") Then
            dgvCreditNotes.Columns("TotalAmount").HeaderText = "Amount"
            dgvCreditNotes.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
        End If
        If dgvCreditNotes.Columns.Contains("CreditReason") Then dgvCreditNotes.Columns("CreditReason").HeaderText = "Reason"
        If dgvCreditNotes.Columns.Contains("SupplierName") Then dgvCreditNotes.Columns("SupplierName").HeaderText = "Supplier"
        If dgvCreditNotes.Columns.Contains("GRVNumber") Then dgvCreditNotes.Columns("GRVNumber").HeaderText = "GRV #"
        If dgvCreditNotes.Columns.Contains("BranchName") Then dgvCreditNotes.Columns("BranchName").HeaderText = "Branch"
    End Sub
    
    Private Sub dgvCreditNotes_SelectionChanged(sender As Object, e As EventArgs)
        Dim hasSelection As Boolean = dgvCreditNotes.CurrentRow IsNot Nothing
        btnPrint.Enabled = hasSelection
        btnEmail.Enabled = hasSelection
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        If dgvCreditNotes.CurrentRow Is Nothing Then Return
        
        Try
            Dim creditNoteId As Integer = Convert.ToInt32(dgvCreditNotes.CurrentRow.Cells("CreditNoteID").Value)
            Dim creditNoteNumber As String = dgvCreditNotes.CurrentRow.Cells("CreditNoteNumber").Value.ToString()
            Dim totalAmount As Decimal = Convert.ToDecimal(dgvCreditNotes.CurrentRow.Cells("TotalAmount").Value)
            Dim supplierName As String = If(dgvCreditNotes.CurrentRow.Cells("SupplierName").Value, "").ToString()
            
            ' Generate simple print preview
            Dim printText As String = $"CREDIT NOTE{Environment.NewLine}" &
                                     $"Number: {creditNoteNumber}{Environment.NewLine}" &
                                     $"Supplier: {supplierName}{Environment.NewLine}" &
                                     $"Amount: {totalAmount:C2}{Environment.NewLine}"
            
            Dim printDialog As New PrintDialog()
            Dim printDoc As New System.Drawing.Printing.PrintDocument()
            AddHandler printDoc.PrintPage, Sub(s, ev)
                ev.Graphics.DrawString(printText, New Font("Courier New", 12), Brushes.Black, 50, 50)
            End Sub
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
                MessageBox.Show("Credit note printed!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing credit note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnEmail_Click(sender As Object, e As EventArgs)
        If dgvCreditNotes.CurrentRow Is Nothing Then Return
        
        Try
            Dim creditNoteNumber As String = dgvCreditNotes.CurrentRow.Cells("CreditNoteNumber").Value.ToString()
            Dim totalAmount As Decimal = Convert.ToDecimal(dgvCreditNotes.CurrentRow.Cells("TotalAmount").Value)
            Dim supplierName As String = If(dgvCreditNotes.CurrentRow.Cells("SupplierName").Value, "").ToString()
            
            Dim subject As String = $"Credit Note - {creditNoteNumber}"
            Dim body As String = Uri.EscapeDataString($"Credit Note: {creditNoteNumber}{Environment.NewLine}Supplier: {supplierName}{Environment.NewLine}Amount: {totalAmount:C2}")
            Dim mailto As String = $"mailto:?subject={subject}&body={body}"
            
            System.Diagnostics.Process.Start(New System.Diagnostics.ProcessStartInfo(mailto) With {.UseShellExecute = True})
            MessageBox.Show("Email client opened!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error emailing credit note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class

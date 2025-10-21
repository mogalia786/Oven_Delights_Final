Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class CreditNoteListForm
    Inherits Form
    Private ReadOnly stockroomService As New StockroomService()
    Private ReadOnly grvId As Integer
    Private currentBranchId As Integer
    
    ' Controls are declared in Designer file
    Private WithEvents btnPrintSelected As New Button()
    Private WithEvents btnEmailSelected As New Button()
    Private WithEvents btnClose As New Button()
    Private lblGRVInfo As New Label()

    Public Sub New(grvId As Integer)
        Me.grvId = grvId
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        InitializeComponent()
        LoadData()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadData()
        Try
            ' Load GRV info
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                Dim grvSql As String = "SELECT GRNNumber AS GRVNumber, s.CompanyName AS SupplierName FROM GoodsReceivedNotes grv LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID WHERE grv.GRNID = @id"
                Using cmd As New SqlCommand(grvSql, con)
                    cmd.Parameters.AddWithValue("@id", grvId)
                    con.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            lblGRVInfo.Text = $"Credit Notes for GRV: {reader("GRVNumber")} - {reader("SupplierName")}"
                        End If
                    End Using
                End Using
                
                ' Load credit notes
                Dim cnSql As String = "
                    SELECT cn.CreditNoteID, cn.CreditNoteNumber, cn.CreditDate, cn.Status, cn.CreditType,
                           cn.TotalAmount, cn.CreditReason, u.FirstName + ' ' + u.LastName AS CreatedBy
                    FROM CreditNotes cn
                    LEFT JOIN Users u ON cn.CreatedBy = u.UserID
                    WHERE cn.GRVID = @grvId
                    ORDER BY cn.CreditDate DESC"
                
                Dim sql As String = cnSql
                Using da As New SqlDataAdapter(sql, con)
                    da.SelectCommand.Parameters.AddWithValue("@grvId", grvId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    dgvCreditNotes.DataSource = dt
                    FormatGrid()
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error loading credit notes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        ' Hide system columns
        If dgvCreditNotes.Columns.Contains("CreditNoteID") Then dgvCreditNotes.Columns("CreditNoteID").Visible = False
        
        ' Format display columns
        If dgvCreditNotes.Columns.Contains("CreditNoteNumber") Then dgvCreditNotes.Columns("CreditNoteNumber").HeaderText = "Credit Note #"
        If dgvCreditNotes.Columns.Contains("CreditDate") Then 
            dgvCreditNotes.Columns("CreditDate").HeaderText = "Date"
            dgvCreditNotes.Columns("CreditDate").DefaultCellStyle.Format = "dd/MM/yyyy"
        End If
        If dgvCreditNotes.Columns.Contains("CreditType") Then dgvCreditNotes.Columns("CreditType").HeaderText = "Type"
        If dgvCreditNotes.Columns.Contains("TotalAmount") Then 
            dgvCreditNotes.Columns("TotalAmount").HeaderText = "Amount"
            dgvCreditNotes.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
        End If
        If dgvCreditNotes.Columns.Contains("CreditReason") Then dgvCreditNotes.Columns("CreditReason").HeaderText = "Reason"
        If dgvCreditNotes.Columns.Contains("CreatedBy") Then dgvCreditNotes.Columns("CreatedBy").HeaderText = "Created By"
    End Sub

    Private Sub dgvCreditNotes_SelectionChanged(sender As Object, e As EventArgs) Handles dgvCreditNotes.SelectionChanged
        Dim hasSelection As Boolean = dgvCreditNotes.CurrentRow IsNot Nothing
        btnPrintSelected.Enabled = hasSelection
        btnEmailSelected.Enabled = hasSelection
    End Sub

    Private Sub btnPrintSelected_Click(sender As Object, e As EventArgs) Handles btnPrintSelected.Click
        If dgvCreditNotes.CurrentRow Is Nothing Then Return
        
        Dim creditNoteId As Integer = Convert.ToInt32(dgvCreditNotes.CurrentRow.Cells("CreditNoteID").Value)
        
        ' Get credit note data from database and create structure
        Try
            Dim creditNoteService As New CreditNoteService()
            Dim printData As CreditNotePrintData = creditNoteService.GetCreditNoteForPrint(creditNoteId)
            
            Dim creditNote As New CreditNoteData()
            creditNote.CreditNoteNumber = printData.CreditNoteNumber
            creditNote.SupplierName = printData.SupplierName
            creditNote.SupplierAddress = printData.SupplierAddress
            creditNote.SupplierEmail = printData.SupplierEmail
            creditNote.IssueDate = printData.CreditDate
            creditNote.MaterialCode = If(printData.Lines.Count > 0, printData.Lines(0).ItemCode, "")
            creditNote.MaterialName = If(printData.Lines.Count > 0, printData.Lines(0).ItemName, "")
            creditNote.ReturnQuantity = If(printData.Lines.Count > 0, printData.Lines(0).CreditQuantity, 0)
            creditNote.UnitCost = If(printData.Lines.Count > 0, printData.Lines(0).UnitCost, 0)
            creditNote.TotalAmount = printData.TotalAmount
            creditNote.Reason = printData.CreditReason
            creditNote.Comments = printData.CreditReason
            creditNote.PONumber = printData.PONumber
            creditNote.DeliveryNote = printData.DeliveryNote
            
            Using printForm As New CreditNotePrintForm(creditNote)
                printForm.ShowDialog()
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading credit note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnEmailSelected_Click(sender As Object, e As EventArgs) Handles btnEmailSelected.Click
        If dgvCreditNotes.CurrentRow Is Nothing Then Return
        
        Dim creditNoteId As Integer = Convert.ToInt32(dgvCreditNotes.CurrentRow.Cells("CreditNoteID").Value)
        
        Try
            Dim creditNoteService As New CreditNoteService()
            Dim printData As CreditNotePrintData = creditNoteService.GetCreditNoteForPrint(creditNoteId)
            
            Dim creditNote As New CreditNoteData()
            creditNote.CreditNoteNumber = printData.CreditNoteNumber
            creditNote.SupplierName = printData.SupplierName
            creditNote.SupplierAddress = printData.SupplierAddress
            creditNote.SupplierEmail = printData.SupplierEmail
            creditNote.IssueDate = printData.CreditDate
            creditNote.MaterialCode = If(printData.Lines.Count > 0, printData.Lines(0).ItemCode, "")
            creditNote.MaterialName = If(printData.Lines.Count > 0, printData.Lines(0).ItemName, "")
            creditNote.ReturnQuantity = If(printData.Lines.Count > 0, printData.Lines(0).CreditQuantity, 0)
            creditNote.UnitCost = If(printData.Lines.Count > 0, printData.Lines(0).UnitCost, 0)
            creditNote.TotalAmount = printData.TotalAmount
            creditNote.Reason = printData.CreditReason
            creditNote.Comments = printData.CreditReason
            creditNote.PONumber = printData.PONumber
            creditNote.DeliveryNote = printData.DeliveryNote
            
            Using emailForm As New EmailCreditNoteForm(creditNote, "")
                emailForm.ShowDialog()
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error preparing email: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvCreditNotes_DoubleClick(sender As Object, e As EventArgs) Handles dgvCreditNotes.DoubleClick
        btnPrintSelected_Click(sender, e)
    End Sub
End Class

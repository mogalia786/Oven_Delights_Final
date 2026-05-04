Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class CakeCuttingListForm
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private dtpReadyDate As DateTimePicker
    Private cmbBranch As ComboBox
    Private dgvCuttingList As DataGridView
    Private dgvSheetSummary As DataGridView
    Private btnGenerate As Button
    Private btnShowSheetSummary As Button
    Private btnPrint As Button
    Private btnExport As Button
    Private btnClose As Button
    Private lblTitle As Label
    Private lblSummary As Label
    Private pnlTop As Panel
    Private pnlFilters As Panel
    Private currentView As String = "cutting" ' "cutting" or "sheet"
    
    Public Sub New(branchID As Integer)
        MyBase.New()
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadBranches()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Cake Cutting List - Manufacturing"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Top Panel
        pnlTop = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#2C3E50")
        }
        
        lblTitle = New Label With {
            .Text = "🎂 CAKE CUTTING LIST",
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = False,
            .Size = New Size(800, 50),
            .Location = New Point(20, 15),
            .TextAlign = ContentAlignment.MiddleLeft
        }
        pnlTop.Controls.Add(lblTitle)
        
        ' Filters Panel
        pnlFilters = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Padding = New Padding(20, 15, 20, 15)
        }
        
        Dim lblDate As New Label With {
            .Text = "Ready Date:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 25),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblDate)
        
        dtpReadyDate = New DateTimePicker With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(120, 22),
            .Size = New Size(200, 25),
            .Format = DateTimePickerFormat.Short
        }
        pnlFilters.Controls.Add(dtpReadyDate)
        
        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(350, 25),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblBranch)
        
        cmbBranch = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(420, 22),
            .Size = New Size(250, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        pnlFilters.Controls.Add(cmbBranch)
        
        btnGenerate = New Button With {
            .Text = "� SHEET SUMMARY",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(700, 18),
            .Size = New Size(150, 35),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf btnGenerate_Click
        pnlFilters.Controls.Add(btnGenerate)
        
        btnShowSheetSummary = New Button With {
            .Text = "� CUTTING LIST",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(870, 18),
            .Size = New Size(170, 35),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnShowSheetSummary.FlatAppearance.BorderSize = 0
        AddHandler btnShowSheetSummary.Click, AddressOf btnShowSheetSummary_Click
        pnlFilters.Controls.Add(btnShowSheetSummary)
        
        ' Summary Label
        lblSummary = New Label With {
            .Text = "Select date and click Generate to view cutting list",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#7F8C8D"),
            .Location = New Point(20, 10),
            .AutoSize = True,
            .Dock = DockStyle.Top,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        ' DataGridView
        dgvCuttingList = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10),
            .ColumnHeadersHeight = 40
        }
        
        dgvCuttingList.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#34495E")
        dgvCuttingList.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvCuttingList.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvCuttingList.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        dgvCuttingList.EnableHeadersVisualStyles = False
        dgvCuttingList.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvCuttingList.RowTemplate.Height = 35
        
        ' Add click event for completion dialog
        AddHandler dgvCuttingList.CellClick, AddressOf dgvCuttingList_CellClick
        
        ' Sheet Summary DataGridView (hidden by default)
        dgvSheetSummary = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 11),
            .ColumnHeadersHeight = 40,
            .Visible = False
        }
        
        dgvSheetSummary.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#8E44AD")
        dgvSheetSummary.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvSheetSummary.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        dgvSheetSummary.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        dgvSheetSummary.EnableHeadersVisualStyles = False
        dgvSheetSummary.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvSheetSummary.RowTemplate.Height = 40
        
        ' Bottom Panel with buttons
        Dim pnlBottom As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        btnPrint = New Button With {
            .Text = "🖨️ PRINT",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        pnlBottom.Controls.Add(btnPrint)
        
        btnExport = New Button With {
            .Text = "📤 EXPORT",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(190, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf btnExport_Click
        pnlBottom.Controls.Add(btnExport)
        
        btnClose = New Button With {
            .Text = "❌ CLOSE",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(1020, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf btnClose_Click
        pnlBottom.Controls.Add(btnClose)
        
        ' Add controls to form
        Me.Controls.Add(dgvCuttingList)
        Me.Controls.Add(dgvSheetSummary)
        Me.Controls.Add(lblSummary)
        Me.Controls.Add(pnlFilters)
        Me.Controls.Add(pnlTop)
        Me.Controls.Add(pnlBottom)
    End Sub
    
    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                cmbBranch.Items.Clear()
                cmbBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbBranch.Items.Add(New With {
                                .BranchID = CInt(reader("BranchID")),
                                .BranchName = reader("BranchName").ToString()
                            })
                        End While
                    End Using
                End Using
                
                ' Set default selection
                If _currentBranchID = 0 AndAlso cmbBranch.Items.Count > 0 Then
                    cmbBranch.SelectedIndex = 0 ' All Branches
                Else
                    ' Find and select current branch
                    For i As Integer = 0 To cmbBranch.Items.Count - 1
                        Dim item = cmbBranch.Items(i)
                        Dim branchId As Integer = CInt(item.GetType().GetProperty("BranchID").GetValue(item, Nothing))
                        If branchId = _currentBranchID Then
                            cmbBranch.SelectedIndex = i
                            Exit For
                        End If
                    Next
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim selectedBranchID As Integer? = Nothing
            If cmbBranch.SelectedItem IsNot Nothing Then
                Dim branchId As Integer = CInt(cmbBranch.SelectedItem.GetType().GetProperty("BranchID").GetValue(cmbBranch.SelectedItem, Nothing))
                If branchId > 0 Then selectedBranchID = branchId
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_GetCakeCuttingList", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReadyDate", dtpReadyDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID, DBNull.Value))
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvCuttingList.DataSource = dt
                        
                        FormatGrid()
                        
                        ' Switch views
                        dgvSheetSummary.Visible = False
                        dgvCuttingList.Visible = True
                        currentView = "cutting"
                        
                        ' Update summary
                        Dim totalCakes As Integer = 0
                        For Each row As DataRow In dt.Rows
                            totalCakes += CInt(row("Total"))
                        Next
                        
                        lblSummary.Text = $"Cutting List for {dtpReadyDate.Value:dd MMM yyyy} - Total Cakes: {totalCakes} - Unique Combinations: {dt.Rows.Count}"
                        lblTitle.Text = "🎂 CAKE CUTTING LIST"
                        pnlTop.BackColor = ColorTranslator.FromHtml("#2C3E50")
                        
                        ' Update button states
                        btnGenerate.BackColor = ColorTranslator.FromHtml("#27AE60")
                        btnShowSheetSummary.BackColor = ColorTranslator.FromHtml("#95A5A6")
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error generating cutting list: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatGrid()
        ' Hide internal columns
        If dgvCuttingList.Columns.Contains("BranchID") Then
            dgvCuttingList.Columns("BranchID").Visible = False
        End If
        
        ' Set column headers and widths
        If dgvCuttingList.Columns.Contains("CollectionPoint") Then
            dgvCuttingList.Columns("CollectionPoint").HeaderText = "Coll Point"
            dgvCuttingList.Columns("CollectionPoint").Width = 120
            dgvCuttingList.Columns("CollectionPoint").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        End If
        
        If dgvCuttingList.Columns.Contains("ReadyTime") Then
            dgvCuttingList.Columns("ReadyTime").HeaderText = "Time"
            dgvCuttingList.Columns("ReadyTime").Width = 80
            dgvCuttingList.Columns("ReadyTime").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvCuttingList.Columns("ReadyTime").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        End If
        
        If dgvCuttingList.Columns.Contains("Size") Then
            dgvCuttingList.Columns("Size").HeaderText = "Size"
            dgvCuttingList.Columns("Size").Width = 60
            dgvCuttingList.Columns("Size").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        End If
        
        If dgvCuttingList.Columns.Contains("Layer") Then
            dgvCuttingList.Columns("Layer").HeaderText = "Layer"
            dgvCuttingList.Columns("Layer").Width = 80
            dgvCuttingList.Columns("Layer").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        End If
        
        If dgvCuttingList.Columns.Contains("Shape") Then
            dgvCuttingList.Columns("Shape").HeaderText = "Shape"
            dgvCuttingList.Columns("Shape").Width = 80
            dgvCuttingList.Columns("Shape").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        End If
        
        If dgvCuttingList.Columns.Contains("CakeCream") Then
            dgvCuttingList.Columns("CakeCream").HeaderText = "Cake Cream"
            dgvCuttingList.Columns("CakeCream").Width = 120
        End If
        
        If dgvCuttingList.Columns.Contains("SpecialRequest") Then
            dgvCuttingList.Columns("SpecialRequest").HeaderText = "Special Request"
            dgvCuttingList.Columns("SpecialRequest").Width = 180
        End If
        
        If dgvCuttingList.Columns.Contains("Total") Then
            dgvCuttingList.Columns("Total").HeaderText = "Total"
            dgvCuttingList.Columns("Total").Width = 60
            dgvCuttingList.Columns("Total").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvCuttingList.Columns("Total").DefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
            dgvCuttingList.Columns("Total").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#E8F8F5")
        End If
        
        If dgvCuttingList.Columns.Contains("QtyCompleted") Then
            dgvCuttingList.Columns("QtyCompleted").HeaderText = "Done"
            dgvCuttingList.Columns("QtyCompleted").Width = 60
            dgvCuttingList.Columns("QtyCompleted").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvCuttingList.Columns("QtyCompleted").DefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
            dgvCuttingList.Columns("QtyCompleted").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#D5F4E6")
            dgvCuttingList.Columns("QtyCompleted").DefaultCellStyle.ForeColor = ColorTranslator.FromHtml("#27AE60")
        End If
        
        If dgvCuttingList.Columns.Contains("Remaining") Then
            dgvCuttingList.Columns("Remaining").HeaderText = "TODO"
            dgvCuttingList.Columns("Remaining").Width = 60
            dgvCuttingList.Columns("Remaining").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvCuttingList.Columns("Remaining").DefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
            dgvCuttingList.Columns("Remaining").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FADBD8")
            dgvCuttingList.Columns("Remaining").DefaultCellStyle.ForeColor = ColorTranslator.FromHtml("#E74C3C")
        End If
        
        ' Color code by branch
        For Each row As DataGridViewRow In dgvCuttingList.Rows
            If Not row.IsNewRow Then
                Dim branchName As String = row.Cells("CollectionPoint").Value?.ToString()
                If Not String.IsNullOrEmpty(branchName) Then
                    ' Alternate colors by branch for better readability
                    If branchName.ToUpper().Contains("CHATSWORTH") Then
                        row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#E8F8F5")
                    ElseIf branchName.ToUpper().Contains("UMHLANGA") Then
                        row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FEF9E7")
                    End If
                End If
            End If
        Next
    End Sub
    
    Private Sub btnShowSheetSummary_Click(sender As Object, e As EventArgs)
        Try
            Dim selectedBranchID As Integer? = Nothing
            If cmbBranch.SelectedItem IsNot Nothing Then
                Dim branchId As Integer = CInt(cmbBranch.SelectedItem.GetType().GetProperty("BranchID").GetValue(cmbBranch.SelectedItem, Nothing))
                If branchId > 0 Then selectedBranchID = branchId
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_GetCakeSheetCuttingSummary", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReadyDate", dtpReadyDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID, DBNull.Value))
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvSheetSummary.DataSource = dt
                        
                        FormatSheetSummaryGrid()
                        
                        ' Switch views
                        dgvCuttingList.Visible = False
                        dgvSheetSummary.Visible = True
                        currentView = "sheet"
                        
                        ' Update summary
                        Dim totalCakes As Integer = 0
                        For Each row As DataRow In dt.Rows
                            totalCakes += CInt(row("Total"))
                        Next
                        
                        lblSummary.Text = $"Sheet Cutting Summary for {dtpReadyDate.Value:dd MMM yyyy} - Total Cakes: {totalCakes} - Unique Combinations: {dt.Rows.Count}"
                        lblTitle.Text = "📋 SHEET CUTTING SUMMARY"
                        pnlTop.BackColor = ColorTranslator.FromHtml("#8E44AD")
                        
                        ' Update button states
                        btnGenerate.BackColor = ColorTranslator.FromHtml("#95A5A6")
                        btnShowSheetSummary.BackColor = ColorTranslator.FromHtml("#8E44AD")
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error generating sheet summary: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatSheetSummaryGrid()
        ' Set column headers and widths for sheet summary
        If dgvSheetSummary.Columns.Contains("Size") Then
            dgvSheetSummary.Columns("Size").HeaderText = "Size"
            dgvSheetSummary.Columns("Size").Width = 100
            dgvSheetSummary.Columns("Size").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("Size").DefaultCellStyle.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        End If
        
        If dgvSheetSummary.Columns.Contains("Layer") Then
            dgvSheetSummary.Columns("Layer").HeaderText = "Layer"
            dgvSheetSummary.Columns("Layer").Width = 120
            dgvSheetSummary.Columns("Layer").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("Layer").DefaultCellStyle.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        End If
        
        If dgvSheetSummary.Columns.Contains("Shape") Then
            dgvSheetSummary.Columns("Shape").HeaderText = "Shape"
            dgvSheetSummary.Columns("Shape").Width = 120
            dgvSheetSummary.Columns("Shape").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("Shape").DefaultCellStyle.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        End If
        
        If dgvSheetSummary.Columns.Contains("CakeCream") Then
            dgvSheetSummary.Columns("CakeCream").HeaderText = "Cake Cream"
            dgvSheetSummary.Columns("CakeCream").Width = 150
            dgvSheetSummary.Columns("CakeCream").DefaultCellStyle.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        End If
        
        If dgvSheetSummary.Columns.Contains("Total") Then
            dgvSheetSummary.Columns("Total").HeaderText = "Total"
            dgvSheetSummary.Columns("Total").Width = 90
            dgvSheetSummary.Columns("Total").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("Total").DefaultCellStyle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            dgvSheetSummary.Columns("Total").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#E8F8F5")
        End If
        
        If dgvSheetSummary.Columns.Contains("QtyCompleted") Then
            dgvSheetSummary.Columns("QtyCompleted").HeaderText = "Done"
            dgvSheetSummary.Columns("QtyCompleted").Width = 90
            dgvSheetSummary.Columns("QtyCompleted").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("QtyCompleted").DefaultCellStyle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            dgvSheetSummary.Columns("QtyCompleted").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#D5F4E6")
            dgvSheetSummary.Columns("QtyCompleted").DefaultCellStyle.ForeColor = ColorTranslator.FromHtml("#27AE60")
        End If
        
        If dgvSheetSummary.Columns.Contains("Remaining") Then
            dgvSheetSummary.Columns("Remaining").HeaderText = "TODO"
            dgvSheetSummary.Columns("Remaining").Width = 90
            dgvSheetSummary.Columns("Remaining").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            dgvSheetSummary.Columns("Remaining").DefaultCellStyle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            dgvSheetSummary.Columns("Remaining").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FADBD8")
            dgvSheetSummary.Columns("Remaining").DefaultCellStyle.ForeColor = ColorTranslator.FromHtml("#E74C3C")
        End If
    End Sub
    
    Private printBitmap As Bitmap = Nothing
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            ' Determine which grid to print based on visibility
            Dim gridToPrint As DataGridView = If(dgvCuttingList.Visible, dgvCuttingList, dgvSheetSummary)
            Dim title As String = If(dgvCuttingList.Visible, "CAKE CUTTING LIST", "SHEET CUTTING SUMMARY")
            
            ' Check if grid has data
            If gridToPrint.Rows.Count = 0 OrElse (gridToPrint.Rows.Count = 1 AndAlso gridToPrint.Rows(0).IsNewRow) Then
                MessageBox.Show("No data to print. Please generate the cutting list or sheet summary first.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            ' Get selected branch name
            Dim branchName As String = "All Branches"
            If cmbBranch.SelectedItem IsNot Nothing Then
                branchName = cmbBranch.SelectedItem.GetType().GetProperty("BranchName").GetValue(cmbBranch.SelectedItem, Nothing).ToString()
            End If
            
            ' Capture grid as bitmap
            Dim width As Integer = gridToPrint.Width
            Dim height As Integer = gridToPrint.Height
            printBitmap = New Bitmap(width, height)
            gridToPrint.DrawToBitmap(printBitmap, New Rectangle(0, 0, width, height))
            
            ' Create print document
            Dim printDoc As New Printing.PrintDocument()
            printDoc.DefaultPageSettings.Landscape = True
            
            AddHandler printDoc.PrintPage, Sub(sender2 As Object, e2 As Printing.PrintPageEventArgs)
                Dim g As Graphics = e2.Graphics
                Dim titleFont As New Font("Arial", 14, FontStyle.Bold)
                Dim dateFont As New Font("Arial", 9)
                Dim branchFont As New Font("Arial", 10, FontStyle.Bold)
                
                Dim leftMargin As Single = e2.MarginBounds.Left
                Dim topMargin As Single = e2.MarginBounds.Top
                Dim pageWidth As Single = e2.MarginBounds.Width
                Dim yPos As Single = topMargin
                
                ' Print title
                g.DrawString(title, titleFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                
                ' Print branch name
                g.DrawString($"Branch: {branchName}", branchFont, Brushes.Black, leftMargin, yPos)
                yPos += 22
                
                ' Print date and time
                Dim printDateTime As DateTime = DateTime.Now
                g.DrawString($"Ready Date: {dtpReadyDate.Value:dddd, dd MMM yyyy}", dateFont, Brushes.Black, leftMargin, yPos)
                yPos += 20
                g.DrawString($"Printed: {printDateTime:dddd, dd MMM yyyy} at {printDateTime:HH:mm:ss}", dateFont, Brushes.Gray, leftMargin, yPos)
                yPos += 30
                
                ' Scale to fit full page width
                Dim availableHeight As Single = e2.MarginBounds.Height - (yPos - topMargin) - 30
                Dim scaleWidth As Single = pageWidth / printBitmap.Width
                
                ' Use full width, calculate height proportionally
                Dim printWidth As Integer = CInt(pageWidth)
                Dim printHeight As Integer = CInt(printBitmap.Height * scaleWidth)
                
                ' Draw the grid bitmap
                g.DrawImage(printBitmap, leftMargin, yPos, printWidth, printHeight)
                
                ' No more pages
                e2.HasMorePages = False
            End Sub
            
            ' Show print preview
            Dim printPreview As New PrintPreviewDialog()
            printPreview.Document = printDoc
            printPreview.ShowDialog()
            
            ' Clean up bitmap
            If printBitmap IsNot Nothing Then
                printBitmap.Dispose()
                printBitmap = Nothing
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Export functionality to be implemented", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
    
    Private Sub dgvCuttingList_CellClick(sender As Object, e As DataGridViewCellEventArgs)
        ' Ignore header clicks
        If e.RowIndex < 0 Then Return
        
        Try
            Dim row As DataGridViewRow = dgvCuttingList.Rows(e.RowIndex)
            
            ' Get cake details from row
            Dim size As String = row.Cells("Size").Value?.ToString()
            Dim layer As String = row.Cells("Layer").Value?.ToString()
            Dim shape As String = row.Cells("Shape").Value?.ToString()
            Dim cakeCream As String = row.Cells("CakeCream").Value?.ToString()
            Dim specialRequest As String = row.Cells("SpecialRequest").Value?.ToString()
            Dim total As Integer = CInt(row.Cells("Total").Value)
            Dim qtyCompleted As Integer = CInt(row.Cells("QtyCompleted").Value)
            Dim remaining As Integer = CInt(row.Cells("Remaining").Value)
            
            ' Show completion dialog
            Using dialog As New Form()
                dialog.Text = "Update Completion Quantity"
                dialog.Size = New Size(500, 350)
                dialog.StartPosition = FormStartPosition.CenterParent
                dialog.FormBorderStyle = FormBorderStyle.FixedDialog
                dialog.MaximizeBox = False
                dialog.MinimizeBox = False
                
                ' Info panel
                Dim pnlInfo As New Panel With {
                    .Dock = DockStyle.Top,
                    .Height = 180,
                    .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
                    .Padding = New Padding(15)
                }
                
                Dim lblInfo As New Label With {
                    .Text = $"Size: {size}   |   Layer: {layer}   |   Shape: {shape}" & vbCrLf &
                            $"Cream: {cakeCream}" & vbCrLf &
                            If(String.IsNullOrEmpty(specialRequest), "", $"Special: {specialRequest}" & vbCrLf) &
                            vbCrLf &
                            $"Total Required: {total}" & vbCrLf &
                            $"Already Completed: {qtyCompleted}" & vbCrLf &
                            $"Remaining: {remaining}",
                    .Font = New Font("Segoe UI", 11),
                    .Dock = DockStyle.Fill,
                    .AutoSize = False
                }
                pnlInfo.Controls.Add(lblInfo)
                
                ' Input panel
                Dim pnlInput As New Panel With {
                    .Dock = DockStyle.Top,
                    .Height = 80,
                    .Padding = New Padding(15, 10, 15, 10)
                }
                
                Dim lblQty As New Label With {
                    .Text = "Quantity Completed Now:",
                    .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                    .Location = New Point(15, 15),
                    .AutoSize = True
                }
                
                Dim numQty As New NumericUpDown With {
                    .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                    .Location = New Point(15, 45),
                    .Size = New Size(150, 30),
                    .Minimum = 0,
                    .Maximum = remaining,
                    .Value = Math.Min(1, remaining)
                }
                
                pnlInput.Controls.AddRange({lblQty, numQty})
                
                ' Button panel
                Dim pnlButtons As New Panel With {
                    .Dock = DockStyle.Bottom,
                    .Height = 60,
                    .BackColor = ColorTranslator.FromHtml("#ECF0F1")
                }
                
                Dim btnSave As New Button With {
                    .Text = "✓ SAVE",
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .Size = New Size(120, 35),
                    .Location = New Point(150, 12),
                    .BackColor = ColorTranslator.FromHtml("#27AE60"),
                    .ForeColor = Color.White,
                    .FlatStyle = FlatStyle.Flat,
                    .DialogResult = DialogResult.OK
                }
                btnSave.FlatAppearance.BorderSize = 0
                
                Dim btnCancel As New Button With {
                    .Text = "✗ CANCEL",
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .Size = New Size(120, 35),
                    .Location = New Point(280, 12),
                    .BackColor = ColorTranslator.FromHtml("#95A5A6"),
                    .ForeColor = Color.White,
                    .FlatStyle = FlatStyle.Flat,
                    .DialogResult = DialogResult.Cancel
                }
                btnCancel.FlatAppearance.BorderSize = 0
                
                pnlButtons.Controls.AddRange({btnSave, btnCancel})
                
                dialog.Controls.AddRange({pnlInput, pnlInfo, pnlButtons})
                dialog.AcceptButton = btnSave
                dialog.CancelButton = btnCancel
                
                If dialog.ShowDialog() = DialogResult.OK Then
                    Dim completedQty As Integer = CInt(numQty.Value)
                    
                    If completedQty > 0 Then
                        ' Update database
                        UpdateCompletionQuantity(size, layer, shape, cakeCream, specialRequest, completedQty)
                        
                        ' Refresh current view
                        If currentView = "cutting" Then
                            btnGenerate.PerformClick()
                        Else
                            btnShowSheetSummary.PerformClick()
                        End If
                        
                        MessageBox.Show($"Successfully updated: {completedQty} cake(s) marked as completed", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End If
                End If
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error opening completion dialog: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub UpdateCompletionQuantity(size As String, layer As String, shape As String, cakeCream As String, specialRequest As String, completedQty As Integer)
        Try
            Dim selectedBranchID As Integer? = Nothing
            If cmbBranch.SelectedItem IsNot Nothing Then
                Dim branchId As Integer = CInt(cmbBranch.SelectedItem.GetType().GetProperty("BranchID").GetValue(cmbBranch.SelectedItem, Nothing))
                If branchId > 0 Then selectedBranchID = branchId
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_UpdateCakeCompletionQty", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReadyDate", dtpReadyDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID, DBNull.Value))
                    cmd.Parameters.AddWithValue("@Size", size)
                    cmd.Parameters.AddWithValue("@Layer", layer)
                    cmd.Parameters.AddWithValue("@Shape", shape)
                    cmd.Parameters.AddWithValue("@CakeCream", cakeCream)
                    cmd.Parameters.AddWithValue("@SpecialRequest", If(String.IsNullOrEmpty(specialRequest), "", specialRequest))
                    cmd.Parameters.AddWithValue("@CompletedQty", completedQty)
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to update completion quantity: {ex.Message}")
        End Try
    End Sub
End Class

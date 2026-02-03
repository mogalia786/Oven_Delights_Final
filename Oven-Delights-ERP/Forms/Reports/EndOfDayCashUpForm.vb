Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing.Printing
Imports System.Linq

Public Class EndOfDayCashUpForm
    Inherits Form
    
    Private _connectionString As String
    Private _currentBranchID As Integer
    Private _selectedDate As Date
    Private _selectedTillID As Integer
    Private _reportData As DataTable
    Private WithEvents _printDocument As New PrintDocument()
    Private _printPreviewDialog As PrintPreviewDialog
    Private _currentPrintRow As Integer = 0
    Private _printYPos As Integer = 0
    Private _tillPanels As New List(Of Panel)
    Private _isFinalized As Boolean = False
    Private _tillDenominationControls As New Dictionary(Of String, Dictionary(Of String, TextBox))
    
    ' Color scheme
    Private _primaryColor As Color = Color.FromArgb(183, 58, 46)
    Private _accentColor As Color = Color.FromArgb(242, 215, 212)
    Private _successColor As Color = Color.FromArgb(46, 125, 50)
    Private _warningColor As Color = Color.FromArgb(255, 152, 0)
    Private _errorColor As Color = Color.FromArgb(211, 47, 47)
    
    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
        _selectedDate = DateTime.Today
        
        Me.Text = "End of Day Cash-Up Report"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.WhiteSmoke
        
        SetupUI()
        LoadBranches()
        LoadTills()
    End Sub
    
    Private Sub SetupUI()
        ' Main panel
        Dim pnlMain As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20),
            .BackColor = Color.WhiteSmoke
        }
        
        ' Header panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = _primaryColor,
            .Padding = New Padding(20)
        }
        
        Dim lblTitle As New Label With {
            .Text = "END OF DAY CASH-UP REPORT",
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 20)
        }
        
        Dim lblSubtitle As New Label With {
            .Text = "Reconcile till cash with system sales",
            .Font = New Font("Segoe UI", 12),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 65)
        }
        
        pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})
        
        ' Filter panel
        Dim pnlFilters As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 140,
            .BackColor = Color.White,
            .Padding = New Padding(20)
        }
        
        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        
        Dim cboBranch As New ComboBox With {
            .Name = "cboBranch",
            .Location = New Point(20, 45),
            .Width = 250,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }
        
        Dim lblDate As New Label With {
            .Text = "Date:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(290, 20),
            .AutoSize = True
        }
        
        Dim dtpDate As New DateTimePicker With {
            .Name = "dtpDate",
            .Location = New Point(290, 45),
            .Width = 200,
            .Format = DateTimePickerFormat.Short,
            .Font = New Font("Segoe UI", 10),
            .Value = DateTime.Today
        }
        
        Dim lblTill As New Label With {
            .Text = "Till:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(510, 20),
            .AutoSize = True
        }
        
        Dim cboTill As New ComboBox With {
            .Name = "cboTill",
            .Location = New Point(510, 45),
            .Width = 200,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }
        
        AddHandler cboBranch.SelectedIndexChanged, AddressOf OnBranchChanged
        
        Dim btnGenerate As New Button With {
            .Text = "Generate Report",
            .Location = New Point(730, 40),
            .Size = New Size(150, 35),
            .BackColor = _primaryColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand,
            .Name = "btnGenerate"
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf GenerateReport
        
        Dim btnPrint As New Button With {
            .Text = "Print Report",
            .Location = New Point(900, 40),
            .Size = New Size(150, 35),
            .BackColor = _successColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand,
            .Name = "btnPrint",
            .Enabled = False
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf PrintReport
        
        Dim btnFinalize As New Button With {
            .Text = "Finalize Day",
            .Location = New Point(1070, 40),
            .Size = New Size(150, 35),
            .BackColor = _errorColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand,
            .Name = "btnFinalize",
            .Enabled = False
        }
        btnFinalize.FlatAppearance.BorderSize = 0
        AddHandler btnFinalize.Click, AddressOf FinalizeDay
        
        Dim chkViewFinalized As New CheckBox With {
            .Text = "View Finalized Reports Only",
            .Name = "chkViewFinalized",
            .Location = New Point(1240, 48),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = _primaryColor
        }
        AddHandler chkViewFinalized.CheckedChanged, AddressOf OnViewFinalizedChanged
        
        Dim btnSave As New Button With {
            .Text = "Save Progress",
            .Location = New Point(20, 85),
            .Size = New Size(150, 30),
            .BackColor = _successColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Cursor = Cursors.Hand,
            .Name = "btnSave",
            .Enabled = False
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf SaveProgress
        
        Dim lblSaveStatus As New Label With {
            .Name = "lblSaveStatus",
            .Location = New Point(190, 92),
            .Width = 300,
            .Font = New Font("Segoe UI", 9, FontStyle.Italic),
            .ForeColor = Color.Gray,
            .Text = ""
        }
        
        pnlFilters.Controls.AddRange({lblBranch, cboBranch, lblDate, dtpDate, lblTill, cboTill, btnGenerate, btnPrint, btnFinalize, chkViewFinalized, btnSave, lblSaveStatus})
        
        ' Report panel with scroll
        Dim pnlReport As New Panel With {
            .Name = "pnlReport",
            .Dock = DockStyle.Fill,
            .BackColor = Color.WhiteSmoke,
            .AutoScroll = True,
            .Padding = New Padding(20)
        }
        
        pnlMain.Controls.AddRange({pnlReport, pnlFilters, pnlHeader})
        Me.Controls.Add(pnlMain)
        
        Me.Size = New Size(1400, 900)
        Me.StartPosition = FormStartPosition.CenterScreen
    End Sub
    
    Private Sub LoadBranches()
        Try
            Dim cboBranch = TryCast(Me.Controls.Find("cboBranch", True).FirstOrDefault(), ComboBox)
            If cboBranch Is Nothing Then Return
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                    cboBranch.DataSource = dt
                    
                    If _currentBranchID > 0 Then
                        cboBranch.SelectedValue = _currentBranchID
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadTills()
        Try
            Dim cboBranch = TryCast(Me.Controls.Find("cboBranch", True).FirstOrDefault(), ComboBox)
            Dim cboTill = TryCast(Me.Controls.Find("cboTill", True).FirstOrDefault(), ComboBox)
            If cboBranch Is Nothing OrElse cboTill Is Nothing Then Return
            
            Dim branchID As Integer = If(cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), 0)
            If branchID = 0 Then Return
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                ' Use actual column names: TillPointID, TillNumber
                Dim sql = "SELECT TillPointID, TillNumber, COALESCE(TillNumber, 'Till ' + CAST(TillPointID AS NVARCHAR(10))) AS TillName FROM TillPoints WHERE BranchID = @BranchID AND IsActive = 1 ORDER BY TillNumber"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        
                        ' Add "All Tills" option
                        Dim allRow = dt.NewRow()
                        allRow("TillPointID") = 0
                        allRow("TillNumber") = "ALL"
                        allRow("TillName") = "All Tills"
                        dt.Rows.InsertAt(allRow, 0)
                        
                        cboTill.DisplayMember = "TillName"
                        cboTill.ValueMember = "TillPointID"
                        cboTill.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading tills: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OnBranchChanged(sender As Object, e As EventArgs)
        LoadTills()
    End Sub
    
    Private Sub OnViewFinalizedChanged(sender As Object, e As EventArgs)
        ' When checkbox changes, clear the report to force regeneration
        Dim pnlReport = TryCast(Me.Controls.Find("pnlReport", True).FirstOrDefault(), Panel)
        If pnlReport IsNot Nothing Then
            pnlReport.Controls.Clear()
            _tillPanels.Clear()
            _tillDenominationControls.Clear()
        End If
    End Sub
    
    Private Sub GenerateReport(sender As Object, e As EventArgs)
        Try
            Dim cboBranch = TryCast(Me.Controls.Find("cboBranch", True).FirstOrDefault(), ComboBox)
            Dim dtpDate = TryCast(Me.Controls.Find("dtpDate", True).FirstOrDefault(), DateTimePicker)
            Dim cboTill = TryCast(Me.Controls.Find("cboTill", True).FirstOrDefault(), ComboBox)
            Dim btnPrint = TryCast(Me.Controls.Find("btnPrint", True).FirstOrDefault(), Button)
            
            If cboBranch Is Nothing OrElse dtpDate Is Nothing OrElse cboTill Is Nothing Then Return
            
            Dim branchID As Integer = Convert.ToInt32(cboBranch.SelectedValue)
            _selectedDate = dtpDate.Value.Date
            _selectedTillID = Convert.ToInt32(cboTill.SelectedValue)
            
            ' Get report data
            _reportData = GetCashUpData(branchID, _selectedDate, _selectedTillID)
            
            ' Display report
            DisplayReport()
            
            ' Load saved cash-up data if exists
            LoadSavedCashUpData(branchID, _selectedDate)
            
            ' Enable print, save, and finalize buttons
            If btnPrint IsNot Nothing Then
                btnPrint.Enabled = True
            End If
            
            Dim btnFinalize = TryCast(Me.Controls.Find("btnFinalize", True).FirstOrDefault(), Button)
            If btnFinalize IsNot Nothing Then
                btnFinalize.Enabled = True
            End If
            
            Dim btnSave = TryCast(Me.Controls.Find("btnSave", True).FirstOrDefault(), Button)
            If btnSave IsNot Nothing Then
                btnSave.Enabled = True
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function GetCashUpData(branchID As Integer, reportDate As Date, tillID As Integer) As DataTable
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_GetEndOfDayCashUp", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BranchID", branchID)
                cmd.Parameters.AddWithValue("@ReportDate", reportDate)
                cmd.Parameters.AddWithValue("@TillID", If(tillID = 0, DBNull.Value, CType(tillID, Object)))
                
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function
    
    Private Sub DisplayReport()
        Dim pnlReport = TryCast(Me.Controls.Find("pnlReport", True).FirstOrDefault(), Panel)
        If pnlReport Is Nothing OrElse _reportData Is Nothing Then Return
        
        pnlReport.Controls.Clear()
        
        Dim yPos As Integer = 10
        
        ' Clear previous panels
        _tillPanels.Clear()
        
        ' Group by Till
        Dim tills = _reportData.AsEnumerable().Select(Function(r) r.Field(Of String)("TillName")).Distinct()
        
        For Each tillName In tills
            Dim tillData = _reportData.AsEnumerable().Where(Function(r) r.Field(Of String)("TillName") = tillName).ToList()
            If tillData.Count = 0 Then Continue For
            
            Dim tillRow = tillData(0)
            
            ' Create till report card
            Dim pnlTillCard As Panel = CreateTillReportCard(tillRow, yPos)
            pnlReport.Controls.Add(pnlTillCard)
            _tillPanels.Add(pnlTillCard)
            
            yPos += pnlTillCard.Height + 20
        Next
    End Sub
    
    Private Function CreateTillReportCard(tillRow As DataRow, yPos As Integer) As Panel
        Dim pnlCard As New Panel With {
            .Location = New Point(0, yPos),
            .Width = 1200,
            .Height = 1200,
            .BackColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle
        }
        
        Dim currentY As Integer = 20
        
        ' Till header
        Dim lblTillHeader As New Label With {
            .Text = $"TILL: {tillRow("TillName")} ({tillRow("TillNumber")})",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = _primaryColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblTillHeader)
        currentY += 40
        
        ' Date and Cashier
        Dim lblInfo As New Label With {
            .Text = $"Date: {_selectedDate:dd MMM yyyy} | Cashier: {tillRow("CashierName")}",
            .Font = New Font("Segoe UI", 11),
            .ForeColor = Color.DimGray,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblInfo)
        currentY += 40
        
        ' Separator
        Dim separator1 As New Panel With {
            .Location = New Point(20, currentY),
            .Size = New Size(1160, 2),
            .BackColor = _accentColor
        }
        pnlCard.Controls.Add(separator1)
        currentY += 20
        
        ' SALES SUMMARY SECTION
        Dim lblSalesHeader As New Label With {
            .Text = "SALES SUMMARY",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _primaryColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblSalesHeader)
        currentY += 35
        
        ' Sales breakdown
        Dim salesData As New List(Of Tuple(Of String, Decimal)) From {
            Tuple.Create("Total Sales (Excl VAT)", Convert.ToDecimal(tillRow("TotalSalesExclVAT"))),
            Tuple.Create("VAT Amount", Convert.ToDecimal(tillRow("VATAmount"))),
            Tuple.Create("Total Sales (Incl VAT)", Convert.ToDecimal(tillRow("TotalSalesInclVAT"))),
            Tuple.Create("Number of Transactions", Convert.ToDecimal(tillRow("TransactionCount")))
        }
        
        For Each item In salesData
            currentY = AddReportLine(pnlCard, item.Item1, item.Item2, currentY, False)
        Next
        
        currentY += 10
        Dim separator2 As New Panel With {
            .Location = New Point(20, currentY),
            .Size = New Size(1160, 2),
            .BackColor = _accentColor
        }
        pnlCard.Controls.Add(separator2)
        currentY += 20
        
        ' PAYMENT BREAKDOWN SECTION
        Dim lblPaymentHeader As New Label With {
            .Text = "PAYMENT BREAKDOWN",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _primaryColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblPaymentHeader)
        currentY += 35
        
        Dim paymentData As New List(Of Tuple(Of String, Decimal)) From {
            Tuple.Create("Cash Payments", Convert.ToDecimal(tillRow("CashPayments"))),
            Tuple.Create("Card Payments", Convert.ToDecimal(tillRow("CardPayments"))),
            Tuple.Create("EFT Payments", Convert.ToDecimal(tillRow("EFTPayments"))),
            Tuple.Create("Account Payments", Convert.ToDecimal(tillRow("AccountPayments")))
        }
        
        For Each item In paymentData
            currentY = AddReportLine(pnlCard, item.Item1, item.Item2, currentY, False)
        Next
        
        ' RETURNS SECTION
        If tillRow.Table.Columns.Contains("ReturnCount") AndAlso Convert.ToInt32(tillRow("ReturnCount")) > 0 Then
            currentY += 10
            Dim separatorReturns As New Panel With {
                .Location = New Point(20, currentY),
                .Size = New Size(1160, 2),
                .BackColor = _accentColor
            }
            pnlCard.Controls.Add(separatorReturns)
            currentY += 20
            
            Dim lblReturnsHeader As New Label With {
                .Text = "RETURNS/REFUNDS",
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.FromArgb(231, 76, 60),
                .Location = New Point(20, currentY),
                .AutoSize = True
            }
            pnlCard.Controls.Add(lblReturnsHeader)
            currentY += 35
            
            Dim returnsData As New List(Of Tuple(Of String, Decimal)) From {
                Tuple.Create("Number of Returns", Convert.ToDecimal(tillRow("ReturnCount"))),
                Tuple.Create("Total Returns", Convert.ToDecimal(tillRow("TotalReturns"))),
                Tuple.Create("Cash Returns", Convert.ToDecimal(tillRow("CashReturns"))),
                Tuple.Create("Card Returns", Convert.ToDecimal(tillRow("CardReturns")))
            }
            
            For Each item In returnsData
                currentY = AddReportLine(pnlCard, item.Item1, item.Item2, currentY, False, Color.FromArgb(231, 76, 60))
            Next
        End If
        
        currentY += 10
        Dim separator3 As New Panel With {
            .Location = New Point(20, currentY),
            .Size = New Size(1160, 2),
            .BackColor = _accentColor
        }
        pnlCard.Controls.Add(separator3)
        currentY += 20
        
        ' ORDER DEPOSITS SECTION (if any)
        If tillRow.Table.Columns.Contains("OrderDepositCount") AndAlso Convert.ToInt32(tillRow("OrderDepositCount")) > 0 Then
            Dim lblOrdersHeader As New Label With {
                .Text = "ORDER DEPOSITS",
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 152, 219),
                .Location = New Point(20, currentY),
                .AutoSize = True
            }
            pnlCard.Controls.Add(lblOrdersHeader)
            currentY += 35
            
            Dim orderData As New List(Of Tuple(Of String, Decimal)) From {
                Tuple.Create("Order Transactions", Convert.ToDecimal(tillRow("OrderDepositCount"))),
                Tuple.Create("Deposits Received", Convert.ToDecimal(tillRow("OrderDeposits")))
            }
            
            For Each item In orderData
                currentY = AddReportLine(pnlCard, item.Item1, item.Item2, currentY, False, Color.FromArgb(52, 152, 219))
            Next
            
            currentY += 10
            Dim separatorOrders As New Panel With {
                .Location = New Point(20, currentY),
                .Size = New Size(1160, 2),
                .BackColor = _accentColor
            }
            pnlCard.Controls.Add(separatorOrders)
            currentY += 20
        End If
        
        ' CASH FLOAT SECTION
        Dim lblFloatHeader As New Label With {
            .Text = "CASH FLOAT",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = Color.FromArgb(155, 89, 182),
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblFloatHeader)
        currentY += 35
        
        Dim openingFloat As Decimal = Convert.ToDecimal(tillRow("OpeningFloat"))
        currentY = AddReportLine(pnlCard, "Opening Float", openingFloat, currentY, False, Color.FromArgb(155, 89, 182))
        
        currentY += 10
        Dim separatorFloat As New Panel With {
            .Location = New Point(20, currentY),
            .Size = New Size(1160, 2),
            .BackColor = _accentColor
        }
        pnlCard.Controls.Add(separatorFloat)
        currentY += 20
        
        ' EXPECTED CASH SECTION
        Dim lblExpectedHeader As New Label With {
            .Text = "TOTAL CASH IN TILL",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _successColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblExpectedHeader)
        currentY += 35
        
        Dim expectedCash As Decimal = Convert.ToDecimal(tillRow("ExpectedCash"))
        currentY = AddReportLine(pnlCard, "Expected Cash (Float + Sales + Orders)", expectedCash, currentY, True, _successColor)
        
        currentY += 20
        
        ' ACTUAL CASH SECTION (To be filled in)
        Dim lblActualHeader As New Label With {
            .Text = "ACTUAL CASH COUNTED",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _warningColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblActualHeader)
        currentY += 35
        
        ' Cash denomination breakdown
        Dim denominations As New List(Of Tuple(Of String, Decimal)) From {
            Tuple.Create("R200", 200D),
            Tuple.Create("R100", 100D),
            Tuple.Create("R50", 50D),
            Tuple.Create("R20", 20D),
            Tuple.Create("R10", 10D),
            Tuple.Create("R5", 5D),
            Tuple.Create("R2", 2D),
            Tuple.Create("R1", 1D),
            Tuple.Create("50c", 0.5D),
            Tuple.Create("20c", 0.2D),
            Tuple.Create("10c", 0.1D),
            Tuple.Create("5c", 0.05D)
        }
        
        For Each denom In denominations
            Dim denomName = denom.Item1
            Dim denomValue = denom.Item2
            
            Dim lblDenom As New Label With {
                .Text = $"{denomName} x",
                .Font = New Font("Segoe UI", 11),
                .Location = New Point(40, currentY),
                .Width = 100
            }
            
            Dim txtQty As New TextBox With {
                .Name = $"txt{denomName.Replace("c", "c")}",
                .Location = New Point(150, currentY - 2),
                .Width = 80,
                .Font = New Font("Segoe UI", 11),
                .Text = "0",
                .Tag = denomValue
            }
            AddHandler txtQty.TextChanged, AddressOf OnDenominationChanged
            AddHandler txtQty.KeyPress, AddressOf OnNumericKeyPress
            
            ' Store reference to textbox for this till
            Dim tillNumber As String = tillRow("TillNumber").ToString()
            If Not _tillDenominationControls.ContainsKey(tillNumber) Then
                _tillDenominationControls(tillNumber) = New Dictionary(Of String, TextBox)
            End If
            _tillDenominationControls(tillNumber)(txtQty.Name) = txtQty
            
            Dim lblEquals As New Label With {
                .Text = "=",
                .Font = New Font("Segoe UI", 11),
                .Location = New Point(240, currentY),
                .Width = 20
            }
            
            Dim lblAmount As New Label With {
                .Name = $"lbl{denomName.Replace("c", "c")}Amount",
                .Text = "R 0.00",
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Location = New Point(270, currentY),
                .Width = 100
            }
            
            pnlCard.Controls.AddRange({lblDenom, txtQty, lblEquals, lblAmount})
            currentY += 30
        Next
        
        currentY += 10
        Dim separator4 As New Panel With {
            .Location = New Point(20, currentY),
            .Size = New Size(1160, 3),
            .BackColor = Color.Black
        }
        pnlCard.Controls.Add(separator4)
        currentY += 20
        
        ' TOTAL ACTUAL CASH
        Dim lblTotalActual As New Label With {
            .Text = "TOTAL ACTUAL CASH:",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .Location = New Point(40, currentY),
            .AutoSize = True
        }
        
        Dim lblTotalActualAmount As New Label With {
            .Name = "lblTotalActualAmount",
            .Text = "R 0.00",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = _warningColor,
            .Location = New Point(900, currentY),
            .Width = 200,
            .TextAlign = ContentAlignment.MiddleRight
        }
        
        pnlCard.Controls.AddRange({lblTotalActual, lblTotalActualAmount})
        currentY += 50
        
        ' VARIANCE SECTION
        Dim lblVarianceHeader As New Label With {
            .Text = "VARIANCE (Over/Short)",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = _errorColor,
            .Location = New Point(40, currentY),
            .AutoSize = True
        }
        
        Dim lblVarianceAmount As New Label With {
            .Name = "lblVarianceAmount",
            .Text = "R 0.00",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = _errorColor,
            .Location = New Point(900, currentY),
            .Width = 200,
            .TextAlign = ContentAlignment.MiddleRight
        }
        
        pnlCard.Controls.AddRange({lblVarianceHeader, lblVarianceAmount})
        currentY += 60
        
        ' SIGNATURE SECTION
        Dim lblSignatures As New Label With {
            .Text = "SIGNATURES",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = _primaryColor,
            .Location = New Point(20, currentY),
            .AutoSize = True
        }
        pnlCard.Controls.Add(lblSignatures)
        currentY += 40
        
        ' Cashier signature
        Dim lblCashierSig As New Label With {
            .Text = "Cashier: _______________________",
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(40, currentY),
            .AutoSize = True
        }
        
        Dim lblManagerSig As New Label With {
            .Text = "Manager: _______________________",
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(600, currentY),
            .AutoSize = True
        }
        
        pnlCard.Controls.AddRange({lblCashierSig, lblManagerSig})
        
        Return pnlCard
    End Function
    
    Private Function AddReportLine(parent As Panel, label As String, amount As Decimal, yPos As Integer, isBold As Boolean, Optional color As Color = Nothing) As Integer
        Dim lblText As New Label With {
            .Text = label,
            .Font = New Font("Segoe UI", 12, If(isBold, FontStyle.Bold, FontStyle.Regular)),
            .Location = New Point(40, yPos),
            .Width = 800,
            .ForeColor = If(color = Nothing, Color.Black, color)
        }
        
        Dim lblAmount As New Label With {
            .Text = If(label.Contains("Number"), amount.ToString("N0"), $"R {amount:N2}"),
            .Font = New Font("Segoe UI", 12, If(isBold, FontStyle.Bold, FontStyle.Regular)),
            .Location = New Point(900, yPos),
            .Width = 200,
            .TextAlign = ContentAlignment.MiddleRight,
            .ForeColor = If(color = Nothing, Color.Black, color)
        }
        
        parent.Controls.AddRange({lblText, lblAmount})
        
        Return yPos + 30
    End Function
    
    Private Sub OnNumericKeyPress(sender As Object, e As KeyPressEventArgs)
        ' Only allow numbers and control keys (backspace, delete, etc.)
        If Not Char.IsControl(e.KeyChar) AndAlso Not Char.IsDigit(e.KeyChar) Then
            e.Handled = True
        End If
    End Sub
    
    Private Sub OnDenominationChanged(sender As Object, e As EventArgs)
        Try
            Dim txt = TryCast(sender, TextBox)
            If txt Is Nothing Then Return
            
            ' Don't allow changes if finalized
            If _isFinalized Then
                Return
            End If
            
            Dim denomValue As Decimal = Convert.ToDecimal(txt.Tag)
            Dim qty As Integer = 0
            Integer.TryParse(txt.Text, qty)
            
            Dim lineTotal As Decimal = qty * denomValue
            
            ' Update the line amount label
            Dim denomName = txt.Name.Replace("txt", "")
            Dim lblAmount = TryCast(txt.Parent.Controls($"lbl{denomName}Amount"), Label)
            If lblAmount IsNot Nothing Then
                lblAmount.Text = $"R {lineTotal:N2}"
            End If
            
            ' Calculate total actual cash from all denomination textboxes
            Dim totalActual As Decimal = 0
            For Each ctrl In txt.Parent.Controls
                Dim txtDenom = TryCast(ctrl, TextBox)
                If txtDenom IsNot Nothing AndAlso txtDenom.Name.StartsWith("txt") AndAlso txtDenom.Tag IsNot Nothing Then
                    Dim val As Decimal = Convert.ToDecimal(txtDenom.Tag)
                    Dim q As Integer = 0
                    Integer.TryParse(txtDenom.Text, q)
                    totalActual += q * val
                End If
            Next
            
            ' Update total actual amount
            Dim lblTotalActual = TryCast(txt.Parent.Controls("lblTotalActualAmount"), Label)
            If lblTotalActual IsNot Nothing Then
                lblTotalActual.Text = $"R {totalActual:N2}"
            End If
            
            ' Get expected cash from the report data for this till
            Dim expectedCash As Decimal = 0
            If _reportData IsNot Nothing AndAlso _reportData.Rows.Count > 0 Then
                ' Find the matching till row
                For Each row As DataRow In _reportData.Rows
                    expectedCash = Convert.ToDecimal(row("ExpectedCash"))
                    Exit For ' Use first till for now - you can enhance this to match specific till
                Next
            End If
            
            ' Calculate and update variance
            Dim variance As Decimal = totalActual - expectedCash
            Dim lblVarianceAmount = TryCast(txt.Parent.Controls("lblVarianceAmount"), Label)
            If lblVarianceAmount IsNot Nothing Then
                lblVarianceAmount.Text = $"R {variance:N2}"
                lblVarianceAmount.ForeColor = If(variance >= 0, _successColor, _errorColor)
            End If
            
            ' Auto-save when denomination changes
            SaveCashUpDataAsync()
        Catch ex As Exception
            ' Silently handle calculation errors
        End Try
    End Sub
    
    Private Sub SaveProgress(sender As Object, e As EventArgs)
        Try
            SaveCashUpDataAsync(showMessage:=True)
        Catch ex As Exception
            MessageBox.Show($"Error saving cash-up data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub SaveCashUpDataAsync(Optional showMessage As Boolean = False)
        ' Save denomination counts to database
        Try
            If _isFinalized Then Return
            
            Dim cboBranch = TryCast(Me.Controls.Find("cboBranch", True).FirstOrDefault(), ComboBox)
            Dim dtpDate = TryCast(Me.Controls.Find("dtpDate", True).FirstOrDefault(), DateTimePicker)
            
            If cboBranch Is Nothing OrElse dtpDate Is Nothing OrElse _reportData Is Nothing Then Return
            
            Dim branchID As Integer = CInt(cboBranch.SelectedValue)
            Dim reportDate As Date = dtpDate.Value.Date
            
            For Each tillRow As DataRow In _reportData.Rows
                Dim tillNumber As String = tillRow("TillNumber").ToString()
                Dim cashierName As String = tillRow("CashierName").ToString()
                Dim expectedCash As Decimal = Convert.ToDecimal(tillRow("ExpectedCash"))
                
                ' Get denomination counts for this till
                If Not _tillDenominationControls.ContainsKey(tillNumber) Then Continue For
                
                Dim controls = _tillDenominationControls(tillNumber)
                
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_SaveCashUpData", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@BranchID", branchID)
                        cmd.Parameters.AddWithValue("@TillNumber", tillNumber)
                        cmd.Parameters.AddWithValue("@CashUpDate", reportDate)
                        cmd.Parameters.AddWithValue("@CashierName", cashierName)
                        cmd.Parameters.AddWithValue("@Count_R200", GetTextBoxValue(controls, "txtR200"))
                        cmd.Parameters.AddWithValue("@Count_R100", GetTextBoxValue(controls, "txtR100"))
                        cmd.Parameters.AddWithValue("@Count_R50", GetTextBoxValue(controls, "txtR50"))
                        cmd.Parameters.AddWithValue("@Count_R20", GetTextBoxValue(controls, "txtR20"))
                        cmd.Parameters.AddWithValue("@Count_R10", GetTextBoxValue(controls, "txtR10"))
                        cmd.Parameters.AddWithValue("@Count_R5", GetTextBoxValue(controls, "txtR5"))
                        cmd.Parameters.AddWithValue("@Count_R2", GetTextBoxValue(controls, "txtR2"))
                        cmd.Parameters.AddWithValue("@Count_R1", GetTextBoxValue(controls, "txtR1"))
                        cmd.Parameters.AddWithValue("@Count_50c", GetTextBoxValue(controls, "txt50c"))
                        cmd.Parameters.AddWithValue("@Count_20c", GetTextBoxValue(controls, "txt20c"))
                        cmd.Parameters.AddWithValue("@Count_10c", GetTextBoxValue(controls, "txt10c"))
                        cmd.Parameters.AddWithValue("@Count_5c", GetTextBoxValue(controls, "txt5c"))
                        cmd.Parameters.AddWithValue("@ExpectedCash", expectedCash)
                        cmd.Parameters.AddWithValue("@UserName", AppSession.CurrentUserName)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Next
            
            ' Update save status label
            Dim lblSaveStatus = TryCast(Me.Controls.Find("lblSaveStatus", True).FirstOrDefault(), Label)
            If lblSaveStatus IsNot Nothing Then
                lblSaveStatus.Text = $"Last saved: {DateTime.Now:HH:mm:ss}"
                lblSaveStatus.ForeColor = _successColor
            End If
            
            If showMessage Then
                MessageBox.Show("Cash-up data saved successfully.", "Saved", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            ' Update save status with error
            Dim lblSaveStatus = TryCast(Me.Controls.Find("lblSaveStatus", True).FirstOrDefault(), Label)
            If lblSaveStatus IsNot Nothing Then
                lblSaveStatus.Text = "Save failed"
                lblSaveStatus.ForeColor = _errorColor
            End If
            
            If showMessage Then
                Throw
            End If
        End Try
    End Sub
    
    Private Function GetTextBoxValue(controls As Dictionary(Of String, TextBox), key As String) As Integer
        If controls.ContainsKey(key) AndAlso controls(key) IsNot Nothing Then
            Dim value As Integer
            If Integer.TryParse(controls(key).Text, value) Then
                Return value
            End If
        End If
        Return 0
    End Function
    
    Private Sub LoadSavedCashUpData(branchID As Integer, reportDate As Date)
        Try
            ' Check if viewing finalized reports only
            Dim chkViewFinalized = TryCast(Me.Controls.Find("chkViewFinalized", True).FirstOrDefault(), CheckBox)
            Dim viewFinalizedOnly As Boolean = chkViewFinalized IsNot Nothing AndAlso chkViewFinalized.Checked
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_LoadCashUpData", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    cmd.Parameters.AddWithValue("@CashUpDate", reportDate)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim tillNumber As String = reader.GetString(reader.GetOrdinal("TillNumber"))
                            Dim isFinalized As Boolean = reader.GetBoolean(reader.GetOrdinal("IsFinalized"))
                            
                            ' Skip if viewing finalized only and this record is not finalized
                            If viewFinalizedOnly AndAlso Not isFinalized Then
                                Continue While
                            End If
                            
                            ' Set finalized flag if any till is finalized
                            If isFinalized Then
                                _isFinalized = True
                            End If
                            
                            ' Load denomination counts
                            If _tillDenominationControls.ContainsKey(tillNumber) Then
                                Dim controls = _tillDenominationControls(tillNumber)
                                SetTextBoxValue(controls, "txtR200", reader.GetInt32(reader.GetOrdinal("Count_R200")))
                                SetTextBoxValue(controls, "txtR100", reader.GetInt32(reader.GetOrdinal("Count_R100")))
                                SetTextBoxValue(controls, "txtR50", reader.GetInt32(reader.GetOrdinal("Count_R50")))
                                SetTextBoxValue(controls, "txtR20", reader.GetInt32(reader.GetOrdinal("Count_R20")))
                                SetTextBoxValue(controls, "txtR10", reader.GetInt32(reader.GetOrdinal("Count_R10")))
                                SetTextBoxValue(controls, "txtR5", reader.GetInt32(reader.GetOrdinal("Count_R5")))
                                SetTextBoxValue(controls, "txtR2", reader.GetInt32(reader.GetOrdinal("Count_R2")))
                                SetTextBoxValue(controls, "txtR1", reader.GetInt32(reader.GetOrdinal("Count_R1")))
                                SetTextBoxValue(controls, "txt50c", reader.GetInt32(reader.GetOrdinal("Count_50c")))
                                SetTextBoxValue(controls, "txt20c", reader.GetInt32(reader.GetOrdinal("Count_20c")))
                                SetTextBoxValue(controls, "txt10c", reader.GetInt32(reader.GetOrdinal("Count_10c")))
                                SetTextBoxValue(controls, "txt5c", reader.GetInt32(reader.GetOrdinal("Count_5c")))
                            End If
                        End While
                    End Using
                End Using
            End Using
            
            ' If finalized, disable all inputs
            If _isFinalized Then
                DisableReportInputs()
                Dim btnFinalize = TryCast(Me.Controls.Find("btnFinalize", True).FirstOrDefault(), Button)
                If btnFinalize IsNot Nothing Then
                    btnFinalize.Enabled = False
                    btnFinalize.Text = "Day Finalized"
                End If
            End If
        Catch ex As Exception
            ' Silently handle load errors - no saved data exists
        End Try
    End Sub
    
    Private Sub SetTextBoxValue(controls As Dictionary(Of String, TextBox), key As String, value As Integer)
        If controls.ContainsKey(key) AndAlso controls(key) IsNot Nothing Then
            controls(key).Text = value.ToString()
        End If
    End Sub
    
    Private Sub FinalizeDay(sender As Object, e As EventArgs)
        Try
            Dim cboBranch = TryCast(Me.Controls.Find("cboBranch", True).FirstOrDefault(), ComboBox)
            Dim dtpDate = TryCast(Me.Controls.Find("dtpDate", True).FirstOrDefault(), DateTimePicker)
            
            If cboBranch Is Nothing OrElse dtpDate Is Nothing Then Return
            
            Dim branchID As Integer = CInt(cboBranch.SelectedValue)
            Dim reportDate As Date = dtpDate.Value.Date
            
            ' Confirm finalization
            Dim result = MessageBox.Show(
                "Are you sure you want to finalize the End of Day?" & vbCrLf & vbCrLf &
                "This will:" & vbCrLf &
                "- Lock all tills for the day" & vbCrLf &
                "- Make this report read-only" & vbCrLf &
                "- Require supervisor approval to reopen tills" & vbCrLf & vbCrLf &
                "This action cannot be undone without supervisor access.",
                "Finalize End of Day",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Warning)
            
            If result <> DialogResult.Yes Then Return
            
            ' Set EndOfDay flag for all tills
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_FinalizeEndOfDay", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    cmd.Parameters.AddWithValue("@ReportDate", reportDate)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show(
                "End of Day has been finalized." & vbCrLf & vbCrLf &
                "All tills are now locked. A supervisor must reset the End of Day flag to allow operations.",
                "Success",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information)
            
            ' Set finalized flag and disable all input fields
            _isFinalized = True
            DisableReportInputs()
            
            Dim btnFinalize = TryCast(Me.Controls.Find("btnFinalize", True).FirstOrDefault(), Button)
            If btnFinalize IsNot Nothing Then
                btnFinalize.Enabled = False
                btnFinalize.Text = "Day Finalized"
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error finalizing day: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub DisableReportInputs()
        ' Disable all textboxes in till panels (denomination inputs)
        For Each pnl In _tillPanels
            DisableControlsRecursive(pnl)
        Next
    End Sub
    
    Private Sub DisableControlsRecursive(parent As Control)
        ' Recursively disable all textboxes in the control tree
        For Each ctrl In parent.Controls
            If TypeOf ctrl Is TextBox Then
                DirectCast(ctrl, TextBox).ReadOnly = True
                DirectCast(ctrl, TextBox).BackColor = Color.LightGray
                DirectCast(ctrl, TextBox).Enabled = False
            ElseIf ctrl.HasChildren Then
                DisableControlsRecursive(ctrl)
            End If
        Next
    End Sub
    
    Private Sub PrintReport(sender As Object, e As EventArgs)
        Try
            ' Reset pagination
            _currentPrintRow = 0
            _printYPos = 0
            
            ' Set portrait orientation (A4 size)
            _printDocument.DefaultPageSettings.Landscape = False
            _printDocument.DefaultPageSettings.PaperSize = New Printing.PaperSize("A4", 827, 1169)
            
            _printPreviewDialog = New PrintPreviewDialog()
            _printPreviewDialog.Document = _printDocument
            _printPreviewDialog.Width = 1200
            _printPreviewDialog.Height = 900
            _printPreviewDialog.WindowState = FormWindowState.Maximized
            _printPreviewDialog.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error printing report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub _printDocument_PrintPage(sender As Object, e As PrintPageEventArgs) Handles _printDocument.PrintPage
        If _reportData Is Nothing OrElse _reportData.Rows.Count = 0 Then Return
        
        Dim g = e.Graphics
        Dim yPos As Integer = If(_printYPos = 0, 50, _printYPos)
        Dim leftMargin As Integer = 50
        Dim pageWidth As Integer = e.PageBounds.Width
        Dim rightMargin As Integer = pageWidth - 50
        Dim pageHeight As Integer = e.PageBounds.Height - 100
        
        ' Fonts
        Dim titleFont As New Font("Segoe UI", 18, FontStyle.Bold)
        Dim headerFont As New Font("Segoe UI", 14, FontStyle.Bold)
        Dim normalFont As New Font("Segoe UI", 11)
        Dim boldFont As New Font("Segoe UI", 11, FontStyle.Bold)
        
        ' Print title on first page only
        If _currentPrintRow = 0 Then
            g.DrawString("END OF DAY CASH-UP REPORT", titleFont, Brushes.Black, leftMargin, yPos)
            yPos += 40
        End If
        
        ' Print each till starting from current row
        For i As Integer = _currentPrintRow To _reportData.Rows.Count - 1
            Dim row = _reportData.Rows(i)
            ' Till header
            g.DrawString($"TILL: {row("TillName")} ({row("TillNumber")})", headerFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            g.DrawString($"Date: {_selectedDate:dd MMM yyyy} | Cashier: {row("CashierName")}", normalFont, Brushes.Gray, leftMargin, yPos)
            yPos += 40
            
            ' Sales summary
            g.DrawString("SALES SUMMARY", headerFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            g.DrawString($"Total Sales (Excl VAT): R {Convert.ToDecimal(row("TotalSalesExclVAT")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"VAT Amount: R {Convert.ToDecimal(row("VATAmount")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"Total Sales (Incl VAT): R {Convert.ToDecimal(row("TotalSalesInclVAT")):N2}", boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"Transactions: {row("TransactionCount")}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 40
            
            ' Payment breakdown
            g.DrawString("PAYMENT BREAKDOWN", headerFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            g.DrawString($"Cash: R {Convert.ToDecimal(row("CashPayments")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"Card: R {Convert.ToDecimal(row("CardPayments")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"EFT: R {Convert.ToDecimal(row("EFTPayments")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 25
            g.DrawString($"Account: R {Convert.ToDecimal(row("AccountPayments")):N2}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 40
            
            ' Expected cash
            g.DrawString("EXPECTED CASH IN TILL", headerFont, Brushes.DarkGreen, leftMargin, yPos)
            yPos += 30
            g.DrawString($"Expected Cash: R {Convert.ToDecimal(row("ExpectedCash")):N2}", boldFont, Brushes.DarkGreen, leftMargin, yPos)
            yPos += 40
            
            ' Actual cash section (blank for manual entry)
            g.DrawString("ACTUAL CASH COUNTED", headerFont, Brushes.DarkOrange, leftMargin, yPos)
            yPos += 30
            g.DrawString("(To be filled in manually)", normalFont, Brushes.Gray, leftMargin, yPos)
            yPos += 40
            
            ' Denomination breakdown section - read from screen
            g.DrawString("DENOMINATION BREAKDOWN", headerFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            
            Dim tillPanel As Panel = Nothing
            If i < _tillPanels.Count Then tillPanel = _tillPanels(i)
            
            Dim denominations As New List(Of Tuple(Of String, Decimal)) From {
                Tuple.Create("R200", 200D), Tuple.Create("R100", 100D), Tuple.Create("R50", 50D),
                Tuple.Create("R20", 20D), Tuple.Create("R10", 10D), Tuple.Create("R5", 5D),
                Tuple.Create("R2", 2D), Tuple.Create("R1", 1D), Tuple.Create("50c", 0.5D),
                Tuple.Create("20c", 0.2D), Tuple.Create("10c", 0.1D), Tuple.Create("5c", 0.05D)
            }
            
            For Each denom In denominations
                Dim qty As String = "0"
                Dim amount As String = "R 0.00"
                
                If tillPanel IsNot Nothing Then
                    Dim txtQty = TryCast(tillPanel.Controls($"txt{denom.Item1}"), TextBox)
                    Dim lblAmt = TryCast(tillPanel.Controls($"lbl{denom.Item1}Amount"), Label)
                    If txtQty IsNot Nothing Then qty = txtQty.Text
                    If lblAmt IsNot Nothing Then amount = lblAmt.Text
                End If
                
                g.DrawString($"{denom.Item1} x {qty} = {amount}", normalFont, Brushes.Black, leftMargin + 20, yPos)
                yPos += 25
            Next
            
            yPos += 20
            Dim totalActual As String = "R 0.00"
            Dim variance As String = "R 0.00"
            
            If tillPanel IsNot Nothing Then
                Dim lblTotal = TryCast(tillPanel.Controls("lblTotalActualAmount"), Label)
                Dim lblVar = TryCast(tillPanel.Controls("lblVarianceAmount"), Label)
                If lblTotal IsNot Nothing Then totalActual = lblTotal.Text
                If lblVar IsNot Nothing Then variance = lblVar.Text
            End If
            
            g.DrawString($"TOTAL ACTUAL CASH: {totalActual}", boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            g.DrawString($"VARIANCE (Over/Short): {variance}", boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 40
            
            ' Signature lines
            g.DrawString("Cashier Signature: _____________________", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 30
            g.DrawString("Manager Signature: _____________________", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 50
            
            g.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 30
            
            ' Check if we need another page
            If yPos > pageHeight Then
                _currentPrintRow = i + 1
                _printYPos = 50
                e.HasMorePages = True
                Return
            End If
            
            _currentPrintRow = i + 1
        Next
        
        e.HasMorePages = False
    End Sub
End Class

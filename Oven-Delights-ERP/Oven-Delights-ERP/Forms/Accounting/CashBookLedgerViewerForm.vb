Imports System.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class CashBookLedgerViewerForm
        Inherits Form

    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchId As Integer = 1 ' Should get from session

    ' Controls
    Private WithEvents dtpFromDate As DateTimePicker
    Private WithEvents dtpToDate As DateTimePicker
    Private WithEvents cboCashBookType As ComboBox
    Private WithEvents cboTransactionType As ComboBox
    Private WithEvents btnFilter As Button
    Private WithEvents btnExport As Button
    Private WithEvents btnPrint As Button
    Private WithEvents dgvLedger As DataGridView
    Private lblOpeningBalance As Label
    Private lblTotalReceipts As Label
    Private lblTotalPayments As Label
    Private lblClosingBalance As Label
    Private pnlHeader As Panel
    Private pnlFilters As Panel
    Private pnlSummary As Panel

    Public Sub New()
        InitializeComponent()
        InitializeCustomComponents()
        Me.Text = "Cash Book Ledger Viewer"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.WindowState = FormWindowState.Maximized
    End Sub

    Private Sub InitializeCustomComponents()
        ' Header Panel
        pnlHeader = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 60,
            .BackColor = Color.FromArgb(52, 73, 94),
            .Padding = New Padding(10)
        }

        Dim lblTitle As New Label With {
            .Text = "Cash Book Ledger Viewer",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(10, 15)
        }
        pnlHeader.Controls.Add(lblTitle)

        ' Filters Panel
        pnlFilters = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(236, 240, 241),
            .Padding = New Padding(10)
        }

        ' From Date
        Dim lblFromDate As New Label With {
            .Text = "From Date:",
            .Location = New Point(10, 15),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblFromDate)

        dtpFromDate = New DateTimePicker With {
            .Location = New Point(10, 35),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now.AddMonths(-1)
        }
        pnlFilters.Controls.Add(dtpFromDate)

        ' To Date
        Dim lblToDate As New Label With {
            .Text = "To Date:",
            .Location = New Point(170, 15),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblToDate)

        dtpToDate = New DateTimePicker With {
            .Location = New Point(170, 35),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now
        }
        pnlFilters.Controls.Add(dtpToDate)

        ' Cash Book Type
        Dim lblCashBookType As New Label With {
            .Text = "Cash Book:",
            .Location = New Point(330, 15),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblCashBookType)

        cboCashBookType = New ComboBox With {
            .Location = New Point(330, 35),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cboCashBookType.Items.AddRange(New String() {"All", "Main Cash Book", "Petty Cash"})
        cboCashBookType.SelectedIndex = 0
        pnlFilters.Controls.Add(cboCashBookType)

        ' Transaction Type
        Dim lblTransactionType As New Label With {
            .Text = "Transaction Type:",
            .Location = New Point(490, 15),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblTransactionType)

        cboTransactionType = New ComboBox With {
            .Location = New Point(490, 35),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cboTransactionType.Items.AddRange(New String() {"All", "Receipt", "Payment", "Opening Balance", "Closing Balance"})
        cboTransactionType.SelectedIndex = 0
        pnlFilters.Controls.Add(cboTransactionType)

        ' Filter Button
        btnFilter = New Button With {
            .Text = "Apply Filter",
            .Location = New Point(650, 35),
            .Width = 100,
            .Height = 25,
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        pnlFilters.Controls.Add(btnFilter)

        ' Export Button
        btnExport = New Button With {
            .Text = "Export Excel",
            .Location = New Point(760, 35),
            .Width = 100,
            .Height = 25,
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        pnlFilters.Controls.Add(btnExport)

        ' Print Button
        btnPrint = New Button With {
            .Text = "Print",
            .Location = New Point(870, 35),
            .Width = 100,
            .Height = 25,
            .BackColor = Color.FromArgb(142, 68, 173),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        pnlFilters.Controls.Add(btnPrint)

        ' Summary Panel
        pnlSummary = New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 80,
            .BackColor = Color.FromArgb(236, 240, 241),
            .Padding = New Padding(10)
        }

        lblOpeningBalance = New Label With {
            .Text = "Opening Balance: R 0.00",
            .Location = New Point(10, 10),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlSummary.Controls.Add(lblOpeningBalance)

        lblTotalReceipts = New Label With {
            .Text = "Total Receipts: R 0.00",
            .Location = New Point(10, 35),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(39, 174, 96)
        }
        pnlSummary.Controls.Add(lblTotalReceipts)

        lblTotalPayments = New Label With {
            .Text = "Total Payments: R 0.00",
            .Location = New Point(250, 35),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(231, 76, 60)
        }
        pnlSummary.Controls.Add(lblTotalPayments)

        lblClosingBalance = New Label With {
            .Text = "Closing Balance: R 0.00",
            .Location = New Point(490, 10),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        pnlSummary.Controls.Add(lblClosingBalance)

        ' DataGridView
        dgvLedger = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = Color.FromArgb(245, 245, 245)}
        }

        ' Add controls to form
        Me.Controls.Add(dgvLedger)
        Me.Controls.Add(pnlSummary)
        Me.Controls.Add(pnlFilters)
        Me.Controls.Add(pnlHeader)
    End Sub

    Private Sub CashBookLedgerViewerForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SetupGrid()
        LoadLedgerData()
    End Sub

    Private Sub SetupGrid()
        dgvLedger.Columns.Clear()

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "TransactionDate",
            .HeaderText = "Date",
            .DataPropertyName = "TransactionDate",
            .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "dd/MM/yyyy"}
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "TransactionNumber",
            .HeaderText = "Transaction #",
            .DataPropertyName = "TransactionNumber"
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "CashBookType",
            .HeaderText = "Cash Book",
            .DataPropertyName = "CashBookType"
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "TransactionType",
            .HeaderText = "Type",
            .DataPropertyName = "TransactionType"
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "Description",
            .HeaderText = "Description",
            .DataPropertyName = "Description",
            .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "ReceivedFrom",
            .HeaderText = "Received From / Paid To",
            .DataPropertyName = "ReceivedFrom"
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "ReceiptAmount",
            .HeaderText = "Receipt",
            .DataPropertyName = "ReceiptAmount",
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Format = "N2",
                .Alignment = DataGridViewContentAlignment.MiddleRight,
                .ForeColor = Color.FromArgb(39, 174, 96)
            }
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "PaymentAmount",
            .HeaderText = "Payment",
            .DataPropertyName = "PaymentAmount",
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Format = "N2",
                .Alignment = DataGridViewContentAlignment.MiddleRight,
                .ForeColor = Color.FromArgb(231, 76, 60)
            }
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "Balance",
            .HeaderText = "Balance",
            .DataPropertyName = "Balance",
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Format = "N2",
                .Alignment = DataGridViewContentAlignment.MiddleRight,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "RecordedBy",
            .HeaderText = "Recorded By",
            .DataPropertyName = "RecordedBy"
        })

        dgvLedger.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "GLAccount",
            .HeaderText = "GL Account",
            .DataPropertyName = "GLAccount"
        })
    End Sub

    Private Sub LoadLedgerData()
        Try
            Dim dt As New DataTable()

            Using conn As New SqlConnection(connectionString)
                conn.Open()

                Dim query As String = "
                    SELECT 
                        t.TransactionDate,
                        ISNULL(t.ReferenceNumber, 'N/A') AS TransactionNumber,
                        cb.CashBookName AS CashBookType,
                        t.TransactionType,
                        ISNULL(t.Description, '') AS Description,
                        CASE 
                            WHEN t.TransactionType = 'Receipt' THEN ISNULL(t.Payee, '(Not Specified)')
                            WHEN t.TransactionType = 'Payment' THEN ISNULL(u.Username, 'System')
                            ELSE ''
                        END AS ReceivedFrom,
                        CASE 
                            WHEN t.TransactionType = 'Payment' THEN ISNULL(t.Payee, '(Not Specified)')
                            WHEN t.TransactionType = 'Receipt' THEN ISNULL(u.Username, 'System')
                            ELSE ''
                        END AS PaidTo,
                        CASE WHEN t.TransactionType = 'Receipt' THEN t.Amount ELSE 0 END AS ReceiptAmount,
                        CASE WHEN t.TransactionType = 'Payment' THEN t.Amount ELSE 0 END AS PaymentAmount,
                        ISNULL(u.Username, 'System') AS RecordedBy,
                        CASE 
                            WHEN gl.AccountID IS NOT NULL THEN gl.AccountNumber + ' - ' + gl.AccountName
                            WHEN coa.AccountID IS NOT NULL THEN coa.AccountCode + ' - ' + coa.AccountName
                            WHEN ec.CategoryID IS NOT NULL THEN 'Category: ' + ec.CategoryName
                            WHEN t.PaymentMethod IS NOT NULL THEN 'Method: ' + t.PaymentMethod
                            ELSE '(Not Linked)'
                        END AS GLAccount
                    FROM CashBookTransactions t
                    INNER JOIN CashBooks cb ON t.CashBookID = cb.CashBookID
                    LEFT JOIN Users u ON t.CreatedBy = u.UserID
                    LEFT JOIN GLAccounts gl ON t.GLAccountID = gl.AccountID
                    LEFT JOIN ChartOfAccounts coa ON t.GLAccountID = coa.AccountID
                    LEFT JOIN ExpenseCategories ec ON t.CategoryID = ec.CategoryID
                    WHERE cb.BranchID = @BranchID
                      AND t.TransactionDate BETWEEN @FromDate AND @ToDate
                      AND t.IsVoid = 0
                      AND (@CashBookType = 'All' 
                           OR (@CashBookType = 'Main Cash Book' AND cb.CashBookType = 'Main') 
                           OR (@CashBookType = 'Petty Cash' AND cb.CashBookType = 'Petty'))
                      AND (@TransactionType = 'All' OR t.TransactionType = @TransactionType)
                    ORDER BY t.TransactionDate, t.TransactionID
                "

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                    cmd.Parameters.AddWithValue("@FromDate", dtpFromDate.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                    cmd.Parameters.AddWithValue("@CashBookType", cboCashBookType.SelectedItem.ToString())
                    cmd.Parameters.AddWithValue("@TransactionType", cboTransactionType.SelectedItem.ToString())

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            ' Calculate running balance
            Dim balance As Decimal = 0
            dt.Columns.Add("Balance", GetType(Decimal))

            For Each row As DataRow In dt.Rows
                Dim receipt As Decimal = If(IsDBNull(row("ReceiptAmount")), 0D, Convert.ToDecimal(row("ReceiptAmount")))
                Dim payment As Decimal = If(IsDBNull(row("PaymentAmount")), 0D, Convert.ToDecimal(row("PaymentAmount")))
                balance += receipt - payment
                row("Balance") = balance
            Next

            dgvLedger.DataSource = dt

            ' Update summary
            CalculateSummary(dt)

        Catch ex As Exception
            MessageBox.Show($"Error loading ledger data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CalculateSummary(dt As DataTable)
        Try
            Dim totalReceipts As Decimal = 0
            Dim totalPayments As Decimal = 0

            For Each row As DataRow In dt.Rows
                totalReceipts += If(IsDBNull(row("ReceiptAmount")), 0D, Convert.ToDecimal(row("ReceiptAmount")))
                totalPayments += If(IsDBNull(row("PaymentAmount")), 0D, Convert.ToDecimal(row("PaymentAmount")))
            Next

            Dim closingBalance As Decimal = totalReceipts - totalPayments

            lblTotalReceipts.Text = $"Total Receipts: R {totalReceipts:N2}"
            lblTotalPayments.Text = $"Total Payments: R {totalPayments:N2}"
            lblClosingBalance.Text = $"Closing Balance: R {closingBalance:N2}"

            ' Color code the closing balance
            If closingBalance < 0 Then
                lblClosingBalance.ForeColor = Color.FromArgb(231, 76, 60) ' Red
            Else
                lblClosingBalance.ForeColor = Color.FromArgb(39, 174, 96) ' Green
            End If

        Catch ex As Exception
            MessageBox.Show($"Error calculating summary: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnFilter_Click(sender As Object, e As EventArgs) Handles btnFilter.Click
        LoadLedgerData()
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            ' Export to Excel functionality
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "Excel Files|*.xlsx",
                .FileName = $"CashBookLedger_{DateTime.Now:yyyyMMdd}.xlsx"
            }

            If saveDialog.ShowDialog() = DialogResult.OK Then
                ' TODO: Implement Excel export
                MessageBox.Show("Excel export functionality to be implemented", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        Try
            ' Print functionality
            MessageBox.Show("Print functionality to be implemented", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    End Class
End Namespace

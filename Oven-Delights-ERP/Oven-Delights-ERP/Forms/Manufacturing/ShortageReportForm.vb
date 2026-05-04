Imports System.Data
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Windows.Forms

Namespace Manufacturing

    Public Class ShortageReportForm
        Inherits Form

        Private ReadOnly _productName As String
        Private ReadOnly _productionQty As Decimal
        Private ReadOnly _shortages As DataTable
        Private ReadOnly _requestedBy As String
        Private ReadOnly _branchName As String

        Private txtReport As RichTextBox
        Private btnPrint As Button
        Private btnClose As Button
        Private printDoc As PrintDocument

        Public Sub New(productName As String, productionQty As Decimal, shortages As DataTable, requestedBy As String, branchName As String)
            _productName = productName
            _productionQty = productionQty
            _shortages = shortages
            _requestedBy = requestedBy
            _branchName = branchName

            InitializeComponent()
            GenerateReport()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Material Shortage Report"
            Me.Size = New Size(900, 700)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Font = New Font("Segoe UI", 9.0F)

            ' Rich text box for report
            txtReport = New RichTextBox() With {
                .Left = 20,
                .Top = 20,
                .Width = 840,
                .Height = 580,
                .ReadOnly = True,
                .Font = New Font("Courier New", 10.0F),
                .BackColor = Color.White
            }

            ' Buttons
            btnPrint = New Button() With {
                .Text = "🖨️ Print",
                .Left = 680,
                .Top = 620,
                .Width = 90,
                .Height = 35,
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            }
            btnPrint.FlatAppearance.BorderSize = 0

            btnClose = New Button() With {
                .Text = "Close",
                .Left = 780,
                .Top = 620,
                .Width = 80,
                .Height = 35,
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10.0F)
            }
            btnClose.FlatAppearance.BorderSize = 0

            AddHandler btnPrint.Click, AddressOf OnPrint
            AddHandler btnClose.Click, Sub() Me.Close()

            Me.Controls.AddRange(New Control() {txtReport, btnPrint, btnClose})
        End Sub

        Private Sub GenerateReport()
            Dim sb As New System.Text.StringBuilder()

            ' Header
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine("                      MATERIAL SHORTAGE REPORT")
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine()
            sb.AppendLine($"Branch:           {_branchName}")
            sb.AppendLine($"Date:             {DateTime.Now:yyyy-MM-dd HH:mm}")
            sb.AppendLine($"Requested By:     {_requestedBy}")
            sb.AppendLine()
            sb.AppendLine("───────────────────────────────────────────────────────────────────────────")
            sb.AppendLine("PRODUCTION REQUEST")
            sb.AppendLine("───────────────────────────────────────────────────────────────────────────")
            sb.AppendLine($"Product:          {_productName}")
            sb.AppendLine($"Quantity Needed:  {_productionQty:N2} units")
            sb.AppendLine()
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine("                    MATERIALS IN SHORT SUPPLY")
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine()

            ' Column headers
            sb.AppendLine(String.Format("{0,-50} {1,12} {2,12} {3,12}",
                                       "Material", "Required", "Available", "Shortage"))
            sb.AppendLine("───────────────────────────────────────────────────────────────────────────")

            ' Shortage details
            Dim totalShortages As Integer = 0
            For Each row As DataRow In _shortages.Rows
                Dim materialName As String = row("MaterialName").ToString()
                Dim required As Decimal = Convert.ToDecimal(row("Required"))
                Dim available As Decimal = Convert.ToDecimal(row("Available"))
                Dim shortage As Decimal = required - available
                Dim uom As String = row("UoM").ToString()

                sb.AppendLine(String.Format("{0,-50} {1,9:N2} {2} {3,9:N2} {4} {5,9:N2} {6}",
                                           materialName,
                                           required, uom,
                                           available, uom,
                                           shortage, uom))
                totalShortages += 1
            Next

            sb.AppendLine("───────────────────────────────────────────────────────────────────────────")
            sb.AppendLine($"Total Items Short: {totalShortages}")
            sb.AppendLine()
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine("                         ACTION REQUIRED")
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine()
            sb.AppendLine("⚠️  STOCKROOM: Please create Purchase Orders for the above materials.")
            sb.AppendLine()
            sb.AppendLine("    1. Review shortage quantities")
            sb.AppendLine("    2. Create Purchase Order(s) for short materials")
            sb.AppendLine("    3. Process GRV when materials arrive")
            sb.AppendLine("    4. Notify manufacturer when materials are available")
            sb.AppendLine()
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")
            sb.AppendLine()
            sb.AppendLine("Stockroom Signature: _________________________  Date: _______________")
            sb.AppendLine()
            sb.AppendLine("Manager Approval:    _________________________  Date: _______________")
            sb.AppendLine()
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════════")

            txtReport.Text = sb.ToString()
        End Sub

        Private Sub OnPrint(sender As Object, e As EventArgs)
            Try
                printDoc = New PrintDocument()
                AddHandler printDoc.PrintPage, AddressOf PrintPage
                
                Dim printDialog As New PrintDialog() With {
                    .Document = printDoc
                }

                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                End If
            Catch ex As Exception
                MessageBox.Show("Print error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintPage(sender As Object, e As PrintPageEventArgs)
            Dim font As New Font("Courier New", 9.0F)
            Dim brush As New SolidBrush(Color.Black)
            Dim leftMargin As Single = e.MarginBounds.Left
            Dim topMargin As Single = e.MarginBounds.Top
            Dim yPos As Single = topMargin

            ' Print each line
            Dim lines() As String = txtReport.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
            For Each line As String In lines
                e.Graphics.DrawString(line, font, brush, leftMargin, yPos)
                yPos += font.GetHeight(e.Graphics)
            Next

            e.HasMorePages = False
        End Sub

    End Class

End Namespace

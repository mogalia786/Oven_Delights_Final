Imports System.Data.SqlClient
Imports System.Drawing.Printing
Imports System.Configuration

Public Class BarcodeLabelPrintForm
    Private _connectionString As String
    Private _branchID As Integer
    Private _currentUser As String

    Public Sub New()
        InitializeComponent()
        
        Try
            ' Get connection string from App.config
            Dim connStr = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")
            If connStr IsNot Nothing Then
                _connectionString = connStr.ConnectionString
            Else
                Throw New Exception("Connection string 'OvenDelightsERPConnectionString' not found in configuration file.")
            End If

            ' Safe initialization - use defaults if AppSession not available
            If AppSession.CurrentUser IsNot Nothing Then
                _branchID = AppSession.CurrentUser.BranchID
                _currentUser = AppSession.CurrentUser.Username
            Else
                _branchID = 0 ' Default to head office
                _currentUser = "System"
            End If
        Catch ex As Exception
            MessageBox.Show($"Error initializing form: {ex.Message}", "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            _branchID = 0
            _currentUser = "System"
            _connectionString = ""
        End Try
    End Sub

    Private Sub BarcodeLabelPrintForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Set default values
            nudQuantity.Value = 1
            nudStartPosition.Value = 1
            txtFreeText.Text = ""
            
            ' Set default label dimensions (standard 50mm x 30mm label)
            nudLabelWidth.Value = 50
            nudLabelHeight.Value = 30
            
            ' Load available printers
            LoadPrinters()
            
            ' Load products
            LoadProducts()
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}", "Load Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadPrinters()
        Try
            cboPrinter.Items.Clear()
            
            ' Add all installed printers
            For Each printer As String In PrinterSettings.InstalledPrinters
                cboPrinter.Items.Add(printer)
            Next
            
            ' Select default printer if available
            Dim defaultPrinter As New PrinterSettings()
            If cboPrinter.Items.Contains(defaultPrinter.PrinterName) Then
                cboPrinter.SelectedItem = defaultPrinter.PrinterName
            ElseIf cboPrinter.Items.Count > 0 Then
                cboPrinter.SelectedIndex = 0
            End If
        Catch ex As Exception
            MessageBox.Show($"Error loading printers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub LoadProducts()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT DISTINCT 
                        p.ProductID,
                        p.Name,
                        p.SKU,
                        ISNULL(p.ExternalBarcode, p.SKU) AS Barcode,
                        ISNULL(pr.SellingPrice, 0) AS Price
                    FROM Demo_Retail_Product p
                    LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID 
                        AND (pr.BranchID = @BranchID OR pr.BranchID = 0)
                    WHERE p.IsActive = 1
                        AND (p.ProductType = 'External' OR p.ProductType = 'Internal')
                        AND p.Category NOT IN ('ingredients', 'sub recipe', 'packaging', 'consumables', 'equipment', 'miscellaneous')
                    ORDER BY p.Name"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", _branchID)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        cboProduct.DisplayMember = "Name"
                        cboProduct.ValueMember = "ProductID"
                        cboProduct.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboProduct_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboProduct.SelectedIndexChanged
        If cboProduct.SelectedIndex >= 0 Then
            Dim row As DataRowView = CType(cboProduct.SelectedItem, DataRowView)
            
            lblProductName.Text = row("Name").ToString()
            lblBarcode.Text = row("Barcode").ToString()
            lblPrice.Text = $"R {CDec(row("Price")):N2}"
            
            ' Generate preview
            GeneratePreview()
        End If
    End Sub

    Private Sub txtFreeText_TextChanged(sender As Object, e As EventArgs) Handles txtFreeText.TextChanged
        GeneratePreview()
    End Sub

    Private Sub GeneratePreview()
        If cboProduct.SelectedIndex < 0 Then Return
        
        Try
            Dim row As DataRowView = CType(cboProduct.SelectedItem, DataRowView)
            Dim productName As String = row("Name").ToString()
            Dim barcode As String = row("Barcode").ToString()
            Dim price As Decimal = CDec(row("Price"))
            Dim freeText As String = txtFreeText.Text.Trim()
            
            ' Create label preview
            Dim labelWidth As Integer = CInt(nudLabelWidth.Value * 3.78)  ' mm to pixels at 96 DPI
            Dim labelHeight As Integer = CInt(nudLabelHeight.Value * 3.78)
            
            Dim preview As New Bitmap(labelWidth, labelHeight)
            Using g As Graphics = Graphics.FromImage(preview)
                g.Clear(Color.White)
                g.TextRenderingHint = Drawing.Text.TextRenderingHint.AntiAlias
                
                Dim yPos As Single = 5
                
                ' Company name
                Dim companyFont As New Font("Arial", 10, FontStyle.Bold)
                Dim companySize = g.MeasureString("Oven Delights", companyFont)
                g.DrawString("Oven Delights", companyFont, Brushes.Black, (labelWidth - companySize.Width) / 2, yPos)
                yPos += companySize.Height + 2
                
                ' Barcode number
                Dim barcodeNumFont As New Font("Arial", 8, FontStyle.Regular)
                Dim barcodeNumSize = g.MeasureString(barcode, barcodeNumFont)
                g.DrawString(barcode, barcodeNumFont, Brushes.Black, (labelWidth - barcodeNumSize.Width) / 2, yPos)
                yPos += barcodeNumSize.Height + 2
                
                ' Barcode image (scaled to fit label)
                Dim barcodeWidth As Integer = CInt(labelWidth * 0.9)
                Dim barcodeHeight As Integer = 40
                Dim barcodeImage = GenerateBarcode(barcode, barcodeWidth, barcodeHeight)
                g.DrawImage(barcodeImage, CSng((labelWidth - barcodeWidth) / 2), CSng(yPos))
                yPos += barcodeHeight + 5
                
                ' Product name (word wrap if needed)
                Dim productFont As New Font("Arial", 9, FontStyle.Regular)
                Dim productRect As New RectangleF(5, yPos, labelWidth - 10, 30)
                Dim format As New StringFormat()
                format.Alignment = StringAlignment.Center
                format.LineAlignment = StringAlignment.Near
                g.DrawString(productName, productFont, Brushes.Black, productRect, format)
                yPos += 32
                
                ' Price and freetext on bottom right
                Dim priceFont As New Font("Arial", 10, FontStyle.Bold)
                Dim priceText As String = $"R {price:N2}"
                
                If Not String.IsNullOrEmpty(freeText) Then
                    ' Draw price and freetext on bottom right
                    Dim combinedText As String = $"{priceText}        {freeText}"
                    Dim combinedSize = g.MeasureString(combinedText, priceFont)
                    g.DrawString(combinedText, priceFont, Brushes.Black, labelWidth - combinedSize.Width - 5, yPos)
                Else
                    ' Draw price on bottom right
                    Dim priceSize = g.MeasureString(priceText, priceFont)
                    g.DrawString(priceText, priceFont, Brushes.Black, labelWidth - priceSize.Width - 5, yPos)
                End If
            End Using
            
            ' Display preview
            If picPreview.Image IsNot Nothing Then
                picPreview.Image.Dispose()
            End If
            picPreview.Image = preview
            picPreview.SizeMode = PictureBoxSizeMode.Zoom
            
        Catch ex As Exception
            MessageBox.Show($"Error generating preview: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GenerateBarcode(text As String, width As Integer, height As Integer) As Bitmap
        Try
            ' Manual Code 39 barcode generation - following research rules:
            ' - Regular weight (not bold)
            ' - Proper bar width for 203 DPI thermal printers
            ' - Adequate quiet zones (margins)
            Dim bmp As New Bitmap(width, height)
            Using g As Graphics = Graphics.FromImage(bmp)
                g.Clear(Color.White)
                g.SmoothingMode = Drawing2D.SmoothingMode.None
                g.InterpolationMode = Drawing2D.InterpolationMode.NearestNeighbor
                
                ' Code 39 encoding
                Dim code39 As New Dictionary(Of Char, String) From {
                    {"0"c, "101001101101"}, {"1"c, "110100101011"}, {"2"c, "101100101011"},
                    {"3"c, "110110010101"}, {"4"c, "101001101011"}, {"5"c, "110100110101"},
                    {"6"c, "101100110101"}, {"7"c, "101001011011"}, {"8"c, "110100101101"},
                    {"9"c, "101100101101"}, {"A"c, "110101001011"}, {"B"c, "101101001011"},
                    {"C"c, "110110100101"}, {"D"c, "101011001011"}, {"E"c, "110101100101"},
                    {"F"c, "101101100101"}, {"G"c, "101010011011"}, {"H"c, "110101001101"},
                    {"I"c, "101101001101"}, {"J"c, "101011001101"}, {"K"c, "110101010011"},
                    {"L"c, "101101010011"}, {"M"c, "110110101001"}, {"N"c, "101011010011"},
                    {"O"c, "110101101001"}, {"P"c, "101101101001"}, {"Q"c, "101010110011"},
                    {"R"c, "110101011001"}, {"S"c, "101101011001"}, {"T"c, "101011011001"},
                    {"U"c, "110010101011"}, {"V"c, "100110101011"}, {"W"c, "110011010101"},
                    {"X"c, "100101101011"}, {"Y"c, "110010110101"}, {"Z"c, "100110110101"},
                    {"-"c, "100101011011"}, {"."c, "110010101101"}, {" "c, "100110101101"},
                    {"*"c, "100101101101"}
                }
                
                ' Build barcode pattern with start/stop
                Dim pattern As String = code39("*"c)
                For Each c As Char In text.ToUpper()
                    If code39.ContainsKey(c) Then
                        pattern &= "0" & code39(c) ' 0 = narrow space between chars
                    End If
                Next
                pattern &= "0" & code39("*"c)
                
                ' Draw bars - following research-based sizing
                ' 10% margins on each side for quiet zones (20% total)
                ' Bar height 60% of total height
                Dim barWidth As Single = CSng(width * 0.8) / pattern.Length
                Dim x As Single = width * 0.1 ' 10% left margin (quiet zone)
                Dim barHeight As Single = height * 0.6 ' 60% height for bars
                
                For Each bit As Char In pattern
                    If bit = "1"c Then
                        g.FillRectangle(Brushes.Black, x, 5, barWidth, barHeight)
                    End If
                    x += barWidth
                Next
                
                ' Human-readable text removed to prevent touching barcode bars
                ' Barcode number is already displayed above the barcode on the label
            End Using
            
            Return bmp
        Catch ex As Exception
            ' Fallback: return text
            Dim bmp As New Bitmap(width, height)
            Using g As Graphics = Graphics.FromImage(bmp)
                g.Clear(Color.White)
                Dim errorFont As New Font("Arial", 8, FontStyle.Regular)
                g.DrawString(text, errorFont, Brushes.Black, 5, height / 2)
            End Using
            Return bmp
        End Try
    End Function

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        If cboProduct.SelectedIndex < 0 Then
            MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Dim printDoc As New PrintDocument()
            
            ' Set printer if selected
            If cboPrinter.SelectedIndex >= 0 Then
                printDoc.PrinterSettings.PrinterName = cboPrinter.SelectedItem.ToString()
            End If
            
            AddHandler printDoc.PrintPage, AddressOf PrintLabels
            
            ' Show print dialog with selected printer
            Dim printDialog As New PrintDialog()
            printDialog.Document = printDoc
            printDialog.AllowSomePages = False
            printDialog.AllowSelection = False
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
                MessageBox.Show($"Printed {nudQuantity.Value} label(s) successfully to {printDoc.PrinterSettings.PrinterName}.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error printing labels: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private labelsPrinted As Integer = 0
    Private totalLabelsToPrint As Integer = 0
    Private startPosition As Integer = 0

    Private Sub PrintLabels(sender As Object, e As PrintPageEventArgs)
        Try
            If labelsPrinted = 0 Then
                totalLabelsToPrint = CInt(nudQuantity.Value)
                startPosition = CInt(nudStartPosition.Value) - 1
                labelsPrinted = 0
            End If
            
            Dim row As DataRowView = CType(cboProduct.SelectedItem, DataRowView)
            Dim productName As String = row("Name").ToString()
            Dim barcode As String = row("Barcode").ToString()
            Dim price As Decimal = CDec(row("Price"))
            Dim freeText As String = txtFreeText.Text.Trim()
            
            ' Label dimensions in mm converted to 1/100th inch (for printing)
            Dim labelWidthMM As Single = CSng(nudLabelWidth.Value)
            Dim labelHeightMM As Single = CSng(nudLabelHeight.Value)
            Dim labelWidth As Single = labelWidthMM / 25.4 * 100  ' Convert mm to 1/100th inch
            Dim labelHeight As Single = labelHeightMM / 25.4 * 100
            
            ' Get configurable spacing between labels from form controls
            Dim horizontalGapMM As Single = CSng(nudHorizontalGap.Value)
            Dim verticalGapMM As Single = CSng(nudVerticalGap.Value)
            Dim horizontalSpacing As Single = horizontalGapMM / 25.4 * 100  ' Convert mm to 1/100th inch
            Dim verticalSpacing As Single = verticalGapMM / 25.4 * 100      ' Convert mm to 1/100th inch
            
            ' Total space needed per label including spacing
            Dim totalLabelWidth As Single = labelWidth + horizontalSpacing
            Dim totalLabelHeight As Single = labelHeight + verticalSpacing
            
            ' Calculate labels per row and column (assuming A4 page)
            Dim labelsPerRow As Integer = CInt(Math.Floor(e.PageBounds.Width / totalLabelWidth))
            Dim labelsPerColumn As Integer = CInt(Math.Floor(e.PageBounds.Height / totalLabelHeight))
            Dim labelsPerPage As Integer = labelsPerRow * labelsPerColumn
            
            ' Calculate starting position
            Dim currentPosition As Integer = startPosition + labelsPrinted
            Dim labelsOnThisPage As Integer = Math.Min(totalLabelsToPrint - labelsPrinted, labelsPerPage - (currentPosition Mod labelsPerPage))
            
            For i As Integer = 0 To labelsOnThisPage - 1
                Dim positionOnPage As Integer = (currentPosition + i) Mod labelsPerPage
                Dim rowIndex As Integer = positionOnPage \ labelsPerRow
                Dim col As Integer = positionOnPage Mod labelsPerRow
                
                ' Position with spacing
                Dim x As Single = col * totalLabelWidth
                Dim y As Single = rowIndex * totalLabelHeight
                
                DrawLabel(e.Graphics, x, y, labelWidth, labelHeight, productName, barcode, price, freeText)
            Next
            
            labelsPrinted += labelsOnThisPage
            e.HasMorePages = (labelsPrinted < totalLabelsToPrint)
            
            If Not e.HasMorePages Then
                labelsPrinted = 0
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error during printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            e.HasMorePages = False
        End Try
    End Sub

    Private Sub DrawLabel(g As Graphics, x As Single, y As Single, width As Single, height As Single, productName As String, barcode As String, price As Decimal, freeText As String)
        ' Draw label border (for debugging - remove in production)
        'g.DrawRectangle(Pens.LightGray, x, y, width, height)
        
        Dim yPos As Single = y + 5
        
        ' Company name
        Dim companyFont As New Font("Arial", 10, FontStyle.Bold)
        Dim companySize = g.MeasureString("Oven Delights", companyFont)
        g.DrawString("Oven Delights", companyFont, Brushes.Black, x + (width - companySize.Width) / 2, yPos)
        yPos += companySize.Height + 2
        
        ' Barcode number
        Dim barcodeNumFont As New Font("Arial", 8, FontStyle.Regular)
        Dim barcodeNumSize = g.MeasureString(barcode, barcodeNumFont)
        g.DrawString(barcode, barcodeNumFont, Brushes.Black, x + (width - barcodeNumSize.Width) / 2, yPos)
        yPos += barcodeNumSize.Height + 2
        
        ' Barcode image
        Dim barcodeWidth As Integer = CInt(width * 0.9)
        Dim barcodeHeight As Integer = 40
        Dim barcodeImage = GenerateBarcode(barcode, barcodeWidth, barcodeHeight)
        g.DrawImage(barcodeImage, x + (width - barcodeWidth) / 2, yPos)
        yPos += barcodeHeight + 5
        
        ' Product name
        Dim productFont As New Font("Arial", 9, FontStyle.Regular)
        Dim productRect As New RectangleF(x + 5, yPos, width - 10, 30)
        Dim format As New StringFormat()
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Near
        g.DrawString(productName, productFont, Brushes.Black, productRect, format)
        yPos += 32
        
        ' Price and freetext on bottom right
        Dim priceFont As New Font("Arial", 10, FontStyle.Bold)
        Dim priceText As String = $"R {price:N2}"
        
        If Not String.IsNullOrEmpty(freeText) Then
            ' Draw price and freetext on bottom right
            Dim combinedText As String = $"{priceText}        {freeText}"
            Dim combinedSize = g.MeasureString(combinedText, priceFont)
            g.DrawString(combinedText, priceFont, Brushes.Black, x + width - combinedSize.Width - 5, yPos)
        Else
            ' Draw price on bottom right
            Dim priceSize = g.MeasureString(priceText, priceFont)
            g.DrawString(priceText, priceFont, Brushes.Black, x + width - priceSize.Width - 5, yPos)
        End If
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class

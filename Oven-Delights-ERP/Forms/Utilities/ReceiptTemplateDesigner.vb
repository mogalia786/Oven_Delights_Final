Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing.Printing

Public Class ReceiptTemplateDesigner
    Inherits Form
    
    Private _connectionString As String
    Private _currentBranchID As Integer
    Private _fields As New Dictionary(Of String, FieldConfig)
    Private _previewPanel As Panel
    Private Const PAPER_WIDTH_MM As Integer = 220
    Private Const PAPER_WIDTH_PX As Integer = 830 ' 220mm at 96 DPI
    
    Private Class FieldConfig
        Public Property Name As String
        Public Property XPos As Integer
        Public Property YPos As Integer
        Public Property FontSize As Integer = 8
        Public Property IsBold As Boolean = False
        Public Property IsEnabled As Boolean = True
        Public Property SampleText As String
        Public Property Label As Label
        Public Property BtnUp As Button
        Public Property BtnDown As Button
        Public Property BtnLeft As Button
        Public Property BtnRight As Button
    End Class
    
    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = 1 ' Default
        Me.Text = "Receipt Template Designer"
        Me.Size = New Size(1400, 900)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.WhiteSmoke
        InitializeFields()
        SetupUI()
        LoadConfiguration()
    End Sub
    
    Private Sub InitializeFields()
        ' Define all receipt fields with sample data
        AddField("CompanyName", 10, 10, "Oven Delights", 12, True)
        AddField("CompanyTagline", 10, 30, "YOUR TRUSTED FAMILY BAKERY", 8, False)
        AddField("CoRegNo", 10, 50, "Co Reg No: 1987/83783", 7, False)
        AddField("VATNumber", 10, 65, "VAT Number:", 7, False)
        AddField("ShopNo", 10, 80, "Shop No.1", 7, False)
        AddField("Address", 10, 95, "Oven Delights - Ayesha Centre", 7, False)
        AddField("City", 10, 110, "Chatsworth", 7, False)
        AddField("Phone", 10, 125, "Tel: 0314078042  Fax: 0314078673", 7, False)
        AddField("Email", 10, 140, "Email: info@ovendelights.co.za", 7, False)
        AddField("AccountRef", 10, 160, "PLEASE USE ACCOUNT NO AS REFERENCE", 7, True)
        
        AddField("AccountNo", 10, 185, "ACCOUNT NO: AWHA007", 8, False)
        AddField("CustomerName", 10, 200, "NAME: MINNIE", 8, False)
        AddField("Telephone", 10, 215, "TELEPHONE:", 8, False)
        AddField("CellNumber", 10, 230, "CELL NUMBER: 0765144058", 8, False)
        AddField("SpecialRequest", 10, 250, "Special Request:", 8, True)
        
        AddField("CakeColour", 450, 50, "Cake Colour: PEACH/WHITE", 8, False)
        AddField("CakePicture", 450, 65, "Cake Picture:", 8, False)
        AddField("CollectionDate", 450, 80, "Collection Date: 2025/11/03", 8, False)
        AddField("CollectionDay", 450, 95, "Collection Day: Saturday", 8, False)
        AddField("CollectionTime", 450, 110, "Collection Time: 12:00", 8, False)
        
        AddField("OrderHeader", 10, 290, "Collection Point    Order Number         Date           Order Taken By", 8, True)
        AddField("OrderDetails", 10, 305, "Ayesha Centre      PB2MOND15270    2025/11/03      Crystal", 8, False)
        
        AddField("ItemHeader", 10, 330, "Item Description              Qty Required    Unit Price (R)    Total Price (R)", 8, True)
        AddField("ItemLine1", 10, 345, "BD Freshcream 20 DL          1.00            640.00            640.00", 8, False)
        
        AddField("Message", 10, 380, "HAPPY BIRTHDAY MAKHOSI", 10, True)
        
        AddField("Terms", 10, 650, "All same day orders and cancellations will attract a R30.00 service charge", 7, False)
        AddField("Terms2", 10, 665, "All changes to size, cream and date - R20.00 service charge", 7, False)
        
        AddField("InvoiceTotal", 450, 650, "Invoice Total        640.00", 9, True)
        AddField("DepositPaid", 450, 670, "Deposit paid         350.00", 9, False)
        AddField("BalanceOwing", 450, 690, "Balance Owing        290.00", 9, True)
    End Sub
    
    Private Sub AddField(name As String, x As Integer, y As Integer, sample As String, fontSize As Integer, isBold As Boolean)
        _fields(name) = New FieldConfig With {
            .Name = name,
            .XPos = x,
            .YPos = y,
            .SampleText = sample,
            .FontSize = fontSize,
            .IsBold = isBold,
            .IsEnabled = True
        }
    End Sub
    
    Private Sub SetupUI()
        Dim pnlMain As New Panel With {
            .Dock = DockStyle.Fill,
            .BackColor = Color.White
        }
        
        ' Left panel - Controls
        Dim pnlControls As New Panel With {
            .Dock = DockStyle.Left,
            .Width = 400,
            .BackColor = Color.WhiteSmoke,
            .AutoScroll = True,
            .Padding = New Padding(10)
        }
        
        Dim yPos As Integer = 10
        
        ' Printer config
        Dim lblPrinter As New Label With {
            .Text = "Printer Configuration",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(10, yPos),
            .AutoSize = True
        }
        pnlControls.Controls.Add(lblPrinter)
        yPos += 30
        
        Dim lblPrinterName As New Label With {
            .Text = "Printer Name:",
            .Location = New Point(10, yPos),
            .AutoSize = True
        }
        Dim txtPrinterName As New TextBox With {
            .Name = "txtPrinterName",
            .Location = New Point(120, yPos),
            .Width = 250
        }
        pnlControls.Controls.AddRange({lblPrinterName, txtPrinterName})
        yPos += 30
        
        Dim lblPrinterIP As New Label With {
            .Text = "Printer IP:",
            .Location = New Point(10, yPos),
            .AutoSize = True
        }
        Dim txtPrinterIP As New TextBox With {
            .Name = "txtPrinterIP",
            .Location = New Point(120, yPos),
            .Width = 250
        }
        pnlControls.Controls.AddRange({lblPrinterIP, txtPrinterIP})
        yPos += 40
        
        Dim btnSavePrinter As New Button With {
            .Text = "Save Printer Config",
            .Location = New Point(10, yPos),
            .Width = 150,
            .BackColor = Color.DodgerBlue,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnSavePrinter.Click, AddressOf SavePrinterConfig
        pnlControls.Controls.Add(btnSavePrinter)
        yPos += 50
        
        ' Field adjustments
        Dim lblFields As New Label With {
            .Text = "Field Positioning",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(10, yPos),
            .AutoSize = True
        }
        pnlControls.Controls.Add(lblFields)
        yPos += 30
        
        For Each kvp In _fields
            Dim field = kvp.Value
            Dim pnlField As New Panel With {
                .Location = New Point(10, yPos),
                .Size = New Size(370, 60),
                .BorderStyle = BorderStyle.FixedSingle
            }
            
            Dim lbl As New Label With {
                .Text = field.Name,
                .Location = New Point(5, 5),
                .Width = 200,
                .Font = New Font("Segoe UI", 8, FontStyle.Bold)
            }
            
            Dim btnUp As New Button With {
                .Text = "↑",
                .Size = New Size(30, 25),
                .Location = New Point(220, 5),
                .Tag = field.Name
            }
            AddHandler btnUp.Click, Sub() MoveField(field.Name, 0, -1)
            
            Dim btnDown As New Button With {
                .Text = "↓",
                .Size = New Size(30, 25),
                .Location = New Point(220, 30),
                .Tag = field.Name
            }
            AddHandler btnDown.Click, Sub() MoveField(field.Name, 0, 1)
            
            Dim btnLeft As New Button With {
                .Text = "←",
                .Size = New Size(30, 25),
                .Location = New Point(255, 17),
                .Tag = field.Name
            }
            AddHandler btnLeft.Click, Sub() MoveField(field.Name, -1, 0)
            
            Dim btnRight As New Button With {
                .Text = "→",
                .Size = New Size(30, 25),
                .Location = New Point(290, 17),
                .Tag = field.Name
            }
            AddHandler btnRight.Click, Sub() MoveField(field.Name, 1, 0)
            
            Dim chkEnabled As New CheckBox With {
                .Text = "Show",
                .Location = New Point(5, 30),
                .Checked = field.IsEnabled,
                .Tag = field.Name
            }
            AddHandler chkEnabled.CheckedChanged, Sub(s, e) ToggleField(field.Name, chkEnabled.Checked)
            
            pnlField.Controls.AddRange({lbl, btnUp, btnDown, btnLeft, btnRight, chkEnabled})
            pnlControls.Controls.Add(pnlField)
            yPos += 65
        Next
        
        Dim btnSave As New Button With {
            .Text = "Save Template",
            .Location = New Point(10, yPos),
            .Width = 150,
            .Height = 40,
            .BackColor = Color.Green,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnSave.Click, AddressOf SaveTemplate
        pnlControls.Controls.Add(btnSave)
        
        ' Right panel - Preview
        _previewPanel = New Panel With {
            .Dock = DockStyle.Fill,
            .BackColor = Color.White,
            .AutoScroll = True,
            .Padding = New Padding(20)
        }
        
        Dim pnlPaper As New Panel With {
            .Name = "pnlPaper",
            .Size = New Size(PAPER_WIDTH_PX, 1100),
            .BackColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle,
            .Location = New Point(20, 20)
        }
        _previewPanel.Controls.Add(pnlPaper)
        
        pnlMain.Controls.AddRange({_previewPanel, pnlControls})
        Me.Controls.Add(pnlMain)
        
        RenderPreview()
    End Sub
    
    Private Sub MoveField(fieldName As String, deltaX As Integer, deltaY As Integer)
        If _fields.ContainsKey(fieldName) Then
            _fields(fieldName).XPos += deltaX
            _fields(fieldName).YPos += deltaY
            RenderPreview()
        End If
    End Sub
    
    Private Sub ToggleField(fieldName As String, enabled As Boolean)
        If _fields.ContainsKey(fieldName) Then
            _fields(fieldName).IsEnabled = enabled
            RenderPreview()
        End If
    End Sub
    
    Private Sub RenderPreview()
        Dim pnlPaper = TryCast(Me.Controls.Find("pnlPaper", True).FirstOrDefault(), Panel)
        If pnlPaper Is Nothing Then Return
        
        pnlPaper.Controls.Clear()
        
        For Each kvp In _fields
            Dim field = kvp.Value
            If Not field.IsEnabled Then Continue For
            
            Dim lbl As New Label With {
                .Text = field.SampleText,
                .Location = New Point(field.XPos, field.YPos),
                .AutoSize = True,
                .Font = New Font("Courier New", field.FontSize, If(field.IsBold, FontStyle.Bold, FontStyle.Regular)),
                .BackColor = Color.Transparent
            }
            pnlPaper.Controls.Add(lbl)
        Next
    End Sub
    
    Private Sub SaveTemplate(sender As Object, e As EventArgs)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Delete existing config
                Using cmd As New SqlCommand("DELETE FROM ReceiptTemplateConfig WHERE BranchID = @BranchID", conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    cmd.ExecuteNonQuery()
                End Using
                
                ' Insert new config
                For Each kvp In _fields
                    Dim field = kvp.Value
                    Dim sql = "INSERT INTO ReceiptTemplateConfig (BranchID, FieldName, XPosition, YPosition, FontSize, IsBold, IsEnabled) VALUES (@BranchID, @FieldName, @XPos, @YPos, @FontSize, @IsBold, @IsEnabled)"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                        cmd.Parameters.AddWithValue("@FieldName", field.Name)
                        cmd.Parameters.AddWithValue("@XPos", field.XPos)
                        cmd.Parameters.AddWithValue("@YPos", field.YPos)
                        cmd.Parameters.AddWithValue("@FontSize", field.FontSize)
                        cmd.Parameters.AddWithValue("@IsBold", field.IsBold)
                        cmd.Parameters.AddWithValue("@IsEnabled", field.IsEnabled)
                        cmd.ExecuteNonQuery()
                    End Using
                Next
            End Using
            
            MessageBox.Show("Template saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error saving template: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub SavePrinterConfig(sender As Object, e As EventArgs)
        Try
            Dim txtPrinterName = TryCast(Me.Controls.Find("txtPrinterName", True).FirstOrDefault(), TextBox)
            Dim txtPrinterIP = TryCast(Me.Controls.Find("txtPrinterIP", True).FirstOrDefault(), TextBox)
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql = "IF EXISTS (SELECT 1 FROM PrinterConfig WHERE BranchID = @BranchID) " &
                         "UPDATE PrinterConfig SET PrinterName = @PrinterName, PrinterIPAddress = @PrinterIP WHERE BranchID = @BranchID " &
                         "ELSE INSERT INTO PrinterConfig (BranchID, PrinterName, PrinterIPAddress) VALUES (@BranchID, @PrinterName, @PrinterIP)"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    cmd.Parameters.AddWithValue("@PrinterName", If(String.IsNullOrEmpty(txtPrinterName?.Text), DBNull.Value, txtPrinterName.Text))
                    cmd.Parameters.AddWithValue("@PrinterIP", If(String.IsNullOrEmpty(txtPrinterIP?.Text), DBNull.Value, txtPrinterIP.Text))
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show("Printer configuration saved!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error saving printer config: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadConfiguration()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Load template config
                Using cmd As New SqlCommand("SELECT * FROM ReceiptTemplateConfig WHERE BranchID = @BranchID", conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim fieldName = reader("FieldName").ToString()
                            If _fields.ContainsKey(fieldName) Then
                                _fields(fieldName).XPos = Convert.ToInt32(reader("XPosition"))
                                _fields(fieldName).YPos = Convert.ToInt32(reader("YPosition"))
                                _fields(fieldName).FontSize = Convert.ToInt32(reader("FontSize"))
                                _fields(fieldName).IsBold = Convert.ToBoolean(reader("IsBold"))
                                _fields(fieldName).IsEnabled = Convert.ToBoolean(reader("IsEnabled"))
                            End If
                        End While
                    End Using
                End Using
                
                ' Load printer config
                Using cmd As New SqlCommand("SELECT * FROM PrinterConfig WHERE BranchID = @BranchID", conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim txtPrinterName = TryCast(Me.Controls.Find("txtPrinterName", True).FirstOrDefault(), TextBox)
                            Dim txtPrinterIP = TryCast(Me.Controls.Find("txtPrinterIP", True).FirstOrDefault(), TextBox)
                            If txtPrinterName IsNot Nothing Then txtPrinterName.Text = If(IsDBNull(reader("PrinterName")), "", reader("PrinterName").ToString())
                            If txtPrinterIP IsNot Nothing Then txtPrinterIP.Text = If(IsDBNull(reader("PrinterIPAddress")), "", reader("PrinterIPAddress").ToString())
                        End If
                    End Using
                End Using
            End Using
            
            RenderPreview()
        Catch ex As Exception
            ' No config yet, use defaults
        End Try
    End Sub
End Class

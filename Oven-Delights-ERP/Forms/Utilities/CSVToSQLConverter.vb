Imports System.Windows.Forms
Imports System.IO
Imports System.Text

Public Class CSVToSQLConverter
    Inherits Form

    Private txtOutput As TextBox

    Public Sub New()
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "CSV to SQL Converter"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        Dim btnConvert As New Button()
        btnConvert.Text = "Convert CSV Files to SQL"
        btnConvert.Location = New Point(20, 20)
        btnConvert.Size = New Size(200, 40)
        AddHandler btnConvert.Click, AddressOf ConvertCSVToSQL

        txtOutput = New TextBox()
        txtOutput.Multiline = True
        txtOutput.ScrollBars = ScrollBars.Both
        txtOutput.Location = New Point(20, 70)
        txtOutput.Size = New Size(940, 580)
        txtOutput.Font = New Font("Consolas", 9)

        Me.Controls.Add(btnConvert)
        Me.Controls.Add(txtOutput)
    End Sub

    Private Sub ConvertCSVToSQL(sender As Object, e As EventArgs)
        Try
            Dim sb As New StringBuilder()
            
            Dim od200File As String = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Exports\OD200_Ayesha_Centre.csv"
            Dim od400File As String = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Exports\OD400_Umhlanga.csv"
            
            If Not File.Exists(od200File) Then
                MessageBox.Show("OD200 CSV file not found!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            If Not File.Exists(od400File) Then
                MessageBox.Show("OD400 CSV file not found!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            ' Generate INSERT statements for staging table
            sb.AppendLine("-- Insert CSV data into staging table")
            sb.AppendLine("INSERT INTO #StagingImport (Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch)")
            sb.AppendLine("VALUES")
            
            Dim allRows As New List(Of String)()
            
            ' Process OD200
            ProcessCSVFileForStaging(od200File, allRows, "OD200 - Ayesha Centre")
            
            ' Process OD400
            ProcessCSVFileForStaging(od400File, allRows, "OD400 - Umhlanga")
            
            sb.AppendLine(String.Join("," & vbCrLf, allRows))
            sb.AppendLine(";")
            sb.AppendLine("GO")
            sb.AppendLine()
            sb.AppendLine("PRINT 'CSV data loaded into staging table.';")
            sb.AppendLine("GO")
            
            txtOutput.Text = sb.ToString()
            MessageBox.Show("SQL generated! Copy and paste into Fixed_Import_Script.sql at the marked location.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ProcessCSVFileForStaging(filePath As String, allRows As List(Of String), branchName As String)
        Dim lines() As String = File.ReadAllLines(filePath)
        
        For i As Integer = 2 To lines.Length - 1 ' Skip header rows
            Dim parts() As String = ParseCSVLine(lines(i))
            If parts.Length < 11 Then Continue For
            
            Dim code As String = parts(9).Trim() ' Item Code
            If String.IsNullOrEmpty(code) Then Continue For
            
            Dim cost As Decimal = 0
            Decimal.TryParse(parts(0), cost)
            
            Dim price As Decimal = 0
            Decimal.TryParse(parts(10), price)
            
            ' Extract warehouse from branch name (OD200 or OD400)
            Dim warehouse As String = branchName.Split(" "c)(0)
            
            ' Build INSERT row
            Dim row As String = String.Format("({0}, '{1}', {2}, '{3}', '{4}', '{5}', {6}, '{7}', {8}, '{9}', {10}, {11}, '{12}')", _
                cost.ToString("0.0000"), _
                warehouse, _
                "NULL", _
                EscapeSQL(parts(3).Trim()), _
                EscapeSQL(parts(4).Trim()), _
                EscapeSQL(parts(5).Trim()), _
                If(String.IsNullOrEmpty(parts(6).Trim()) OrElse parts(6).Trim() = "0", "NULL", "'" & EscapeSQL(parts(6).Trim()) & "'"), _
                EscapeSQL(parts(7).Trim()), _
                "NULL", _
                EscapeSQL(code), _
                price.ToString("0.00"), _
                "NULL", _
                EscapeSQL(branchName))
            
            allRows.Add(row)
        Next
    End Sub

    Private Function ParseCSVLine(line As String) As String()
        Dim result As New List(Of String)()
        Dim current As New StringBuilder()
        Dim inQuotes As Boolean = False
        
        For i As Integer = 0 To line.Length - 1
            Dim c As Char = line(i)
            
            If c = """"c Then
                inQuotes = Not inQuotes
            ElseIf c = ","c AndAlso Not inQuotes Then
                result.Add(current.ToString())
                current.Clear()
            Else
                current.Append(c)
            End If
        Next
        
        result.Add(current.ToString())
        Return result.ToArray()
    End Function

    Private Function EscapeSQL(value As String) As String
        If String.IsNullOrEmpty(value) Then Return ""
        Return value.Replace("'", "''")
    End Function
End Class

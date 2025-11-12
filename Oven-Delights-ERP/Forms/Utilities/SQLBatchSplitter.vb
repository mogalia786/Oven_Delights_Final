Imports System.IO
Imports System.Text

Public Class SQLBatchSplitter
    Private Sub SQLBatchSplitter_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "SQL Batch Splitter - Split Large INSERT Statements"
        lblInstructions.Text = "Paste your large INSERT statement below. It will be automatically split into batches of 1000 rows."
        txtBatchSize.Text = "1000"
    End Sub

    Private Sub btnLoadFile_Click(sender As Object, e As EventArgs) Handles btnLoadFile.Click
        Try
            Using ofd As New OpenFileDialog()
                ofd.Filter = "SQL Files (*.sql)|*.sql|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
                ofd.Title = "Select SQL File with Large INSERT Statement"

                If ofd.ShowDialog() = DialogResult.OK Then
                    txtInput.Text = File.ReadAllText(ofd.FileName)
                    UpdateStatus("File loaded: " & Path.GetFileName(ofd.FileName))
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading file: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSplit_Click(sender As Object, e As EventArgs) Handles btnSplit.Click
        Try
            If String.IsNullOrWhiteSpace(txtInput.Text) Then
                MessageBox.Show("Please paste or load an INSERT statement first.", "No Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim batchSize As Integer
            If Not Integer.TryParse(txtBatchSize.Text, batchSize) OrElse batchSize < 1 OrElse batchSize > 1000 Then
                MessageBox.Show("Batch size must be between 1 and 1000.", "Invalid Batch Size", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            UpdateStatus("Splitting INSERT statement...")
            Dim result As String = SplitInsertStatement(txtInput.Text, batchSize)
            txtOutput.Text = result
            UpdateStatus("Split complete! Ready to copy or save.")

        Catch ex As Exception
            MessageBox.Show("Error splitting statement: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            UpdateStatus("Error: " & ex.Message)
        End Try
    End Sub

    Private Function SplitInsertStatement(inputSql As String, batchSize As Integer) As String
        Dim sb As New StringBuilder()

        ' Extract the INSERT INTO clause
        Dim insertStart As Integer = inputSql.IndexOf("INSERT INTO", StringComparison.OrdinalIgnoreCase)
        If insertStart = -1 Then
            Throw New Exception("No INSERT INTO statement found.")
        End If

        Dim valuesStart As Integer = inputSql.IndexOf("VALUES", insertStart, StringComparison.OrdinalIgnoreCase)
        If valuesStart = -1 Then
            Throw New Exception("No VALUES clause found.")
        End If

        ' Get the INSERT INTO ... part (including column names)
        Dim insertClause As String = inputSql.Substring(insertStart, valuesStart - insertStart + 6).Trim()

        ' Extract all the value rows
        Dim valuesSection As String = inputSql.Substring(valuesStart + 6).Trim()
        
        ' Remove trailing semicolon and GO if present
        valuesSection = valuesSection.TrimEnd(";"c, " "c, vbCr, vbLf)
        If valuesSection.EndsWith("GO", StringComparison.OrdinalIgnoreCase) Then
            valuesSection = valuesSection.Substring(0, valuesSection.Length - 2).Trim()
        End If

        ' Parse individual rows
        Dim rows As New List(Of String)()
        Dim currentRow As New StringBuilder()
        Dim parenDepth As Integer = 0
        Dim inString As Boolean = False
        Dim stringChar As Char = Nothing

        For i As Integer = 0 To valuesSection.Length - 1
            Dim c As Char = valuesSection(i)

            ' Handle string literals
            If (c = "'"c OrElse c = """"c) AndAlso (i = 0 OrElse valuesSection(i - 1) <> "\"c) Then
                If Not inString Then
                    inString = True
                    stringChar = c
                ElseIf c = stringChar Then
                    inString = False
                End If
            End If

            If Not inString Then
                If c = "("c Then
                    parenDepth += 1
                ElseIf c = ")"c Then
                    parenDepth -= 1
                    currentRow.Append(c)
                    
                    ' End of a row
                    If parenDepth = 0 Then
                        rows.Add(currentRow.ToString().Trim())
                        currentRow.Clear()
                        Continue For
                    End If
                    Continue For
                ElseIf c = ","c AndAlso parenDepth = 0 Then
                    ' Skip commas between rows
                    Continue For
                End If
            End If

            currentRow.Append(c)
        Next

        ' Add any remaining row
        If currentRow.Length > 0 Then
            Dim lastRow As String = currentRow.ToString().Trim()
            If Not String.IsNullOrWhiteSpace(lastRow) Then
                rows.Add(lastRow)
            End If
        End If

        ' Now split into batches
        Dim totalRows As Integer = rows.Count
        Dim batchCount As Integer = Math.Ceiling(totalRows / batchSize)

        sb.AppendLine("-- =====================================================")
        sb.AppendLine("-- AUTO-GENERATED BATCHED INSERT STATEMENTS")
        sb.AppendLine("-- Total Rows: " & totalRows.ToString())
        sb.AppendLine("-- Batch Size: " & batchSize.ToString())
        sb.AppendLine("-- Total Batches: " & batchCount.ToString())
        sb.AppendLine("-- =====================================================")
        sb.AppendLine()

        For batchNum As Integer = 0 To batchCount - 1
            Dim startIdx As Integer = batchNum * batchSize
            Dim endIdx As Integer = Math.Min(startIdx + batchSize, totalRows)
            Dim rowsInBatch As Integer = endIdx - startIdx

            sb.AppendLine("-- BATCH " & (batchNum + 1).ToString() & " (Rows " & (startIdx + 1).ToString() & "-" & endIdx.ToString() & ")")
            sb.AppendLine(insertClause)
            sb.AppendLine("VALUES")

            For i As Integer = startIdx To endIdx - 1
                sb.Append(rows(i))
                If i < endIdx - 1 Then
                    sb.AppendLine(",")
                Else
                    sb.AppendLine(";")
                End If
            Next

            sb.AppendLine("GO")
            sb.AppendLine()
            sb.AppendLine("PRINT 'Batch " & (batchNum + 1).ToString() & " loaded (" & rowsInBatch.ToString() & " rows).';")
            sb.AppendLine("GO")
            sb.AppendLine()
        Next

        Return sb.ToString()
    End Function

    Private Sub btnCopyOutput_Click(sender As Object, e As EventArgs) Handles btnCopyOutput.Click
        Try
            If Not String.IsNullOrWhiteSpace(txtOutput.Text) Then
                Clipboard.SetText(txtOutput.Text)
                UpdateStatus("Output copied to clipboard!")
                MessageBox.Show("Batched SQL copied to clipboard. Paste into your SQL script.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show("Error copying to clipboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSaveOutput_Click(sender As Object, e As EventArgs) Handles btnSaveOutput.Click
        Try
            If String.IsNullOrWhiteSpace(txtOutput.Text) Then
                MessageBox.Show("No output to save.", "No Output", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Using sfd As New SaveFileDialog()
                sfd.Filter = "SQL Files (*.sql)|*.sql|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
                sfd.Title = "Save Batched SQL"
                sfd.FileName = "Batched_Import_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".sql"

                If sfd.ShowDialog() = DialogResult.OK Then
                    File.WriteAllText(sfd.FileName, txtOutput.Text)
                    UpdateStatus("Saved to: " & Path.GetFileName(sfd.FileName))
                    MessageBox.Show("Batched SQL saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error saving file: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        txtInput.Clear()
        txtOutput.Clear()
        UpdateStatus("Ready")
    End Sub

    Private Sub UpdateStatus(message As String)
        lblStatus.Text = message
        lblStatus.Refresh()
    End Sub
End Class

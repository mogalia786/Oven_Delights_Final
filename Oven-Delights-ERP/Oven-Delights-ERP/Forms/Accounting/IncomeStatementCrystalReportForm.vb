Imports System.Windows.Forms
Imports System.IO

Public Class IncomeStatementCrystalReportForm
    Inherits Form

    Public Sub New()
        InitializeComponent()
        Me.Text = "Income Statement (Crystal)"
        TryLoadReportTemplate("Resources/Reports/IncomeStatement.rpt")
    End Sub

    Private Sub TryLoadReportTemplate(relativePath As String)
        Try
            Dim baseDir As String = AppDomain.CurrentDomain.BaseDirectory
            Dim fullPath As String = Path.Combine(baseDir, relativePath)
            If Not File.Exists(fullPath) Then
                ShowInfo($"Crystal template not found: {relativePath}")
                Return
            End If
            ShowInfo($"Loaded Crystal template: {relativePath}")
        Catch ex As Exception
            ShowInfo("Failed to load Crystal template: " & ex.Message)
        End Try
    End Sub

    Private Sub ShowInfo(message As String)
        Dim host = Me.Controls("pnlHost")
        Dim lbl As New Label() With {
            .AutoSize = True,
            .Text = message,
            .Left = 12,
            .Top = 12
        }
        If host IsNot Nothing Then
            host.Controls.Clear()
            host.Controls.Add(lbl)
        Else
            Me.Controls.Add(lbl)
        End If
    End Sub
End Class

Imports System.Windows.Forms
' NOTE: Requires CrystalDecisions references if binding a real .rpt; this is a viewer scaffold.
Imports System.IO

Public Class LowStockCrystalReportForm
    Inherits Form

    Private ReadOnly viewer As Control

    Public Sub New()
        InitializeComponent()
        ' Defer CrystalReportsViewer binding here once the .rpt is available
        ' For now, keep a placeholder panel readable in UI
        viewer = Me.Controls("pnlHost")
        Me.Text = "Low Stock (Crystal)"
    End Sub

    Public Sub LoadFromData(branchId As Integer)
        ' TODO: Bind dataset and report document once .rpt is finalized
        ' Placeholder: set title to reflect branch context
        Me.Text = $"Low Stock (Crystal) - Branch {branchId}"
        TryLoadReportTemplate("Resources/Reports/LowStock.rpt")
    End Sub

    Private Sub TryLoadReportTemplate(relativePath As String)
        Try
            Dim baseDir As String = AppDomain.CurrentDomain.BaseDirectory
            Dim fullPath As String = Path.Combine(baseDir, relativePath)
            If Not File.Exists(fullPath) Then
                ShowInfo($"Crystal template not found: {relativePath}")
                Return
            End If
            ' When Crystal runtime and references are present, load the ReportDocument here.
            ShowInfo($"Loaded Crystal template: {relativePath}")
        Catch ex As Exception
            ShowInfo("Failed to load Crystal template: " & ex.Message)
        End Try
    End Sub

    Private Sub ShowInfo(message As String)
        Dim lbl As New Label() With {
            .AutoSize = True,
            .Text = message,
            .Left = 12,
            .Top = 12
        }
        If viewer IsNot Nothing Then
            viewer.Controls.Clear()
            viewer.Controls.Add(lbl)
        Else
            Me.Controls.Add(lbl)
        End If
    End Sub
End Class

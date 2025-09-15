Imports System.Windows.Forms
Imports System.IO

Public Class PriceHistoryCrystalReportForm
    Inherits Form

    Public Sub New()
        InitializeComponent()
        Me.Text = "Price History (Crystal)"
        TryLoadReportTemplate("Resources/Reports/PriceHistory.rpt")
    End Sub

    Public Sub LoadForProduct(productId As Integer)
        ' TODO: Bind .rpt and set parameter for ProductID when available
        Me.Text = $"Price History (Crystal) - Product {productId}"
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
        Dim found() As Control = Me.Controls.Find("pnlHost", True)
        Dim hostCtrl As Control = Nothing
        If found IsNot Nothing AndAlso found.Length > 0 Then
            hostCtrl = TryCast(found(0), Control)
        End If
        Dim lbl As New Label() With {
            .AutoSize = True,
            .Text = message,
            .Left = 12,
            .Top = 12
        }
        If hostCtrl IsNot Nothing Then
            hostCtrl.Controls.Clear()
            hostCtrl.Controls.Add(lbl)
        Else
            Me.Controls.Add(lbl)
        End If
    End Sub
End Class

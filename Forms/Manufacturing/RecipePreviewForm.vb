Imports System.Data
Imports System.Drawing.Printing
Imports System.Windows.Forms

Namespace Manufacturing

Public Class RecipePreviewForm
    Inherits Form

    Private ReadOnly _productCode As String
    Private ReadOnly _productName As String
    Private ReadOnly _lines As DataTable
    Private ReadOnly _totalText As String

    Private lblHeader As Label
    Private dgv As DataGridView
    Private btnPrint As Button
    Private btnClose As Button
    Private printDoc As PrintDocument
    Private printPreview As PrintPreviewDialog

    Public Sub New(productCode As String, productName As String, lines As DataTable, totalText As String)
        _productCode = productCode
        _productName = productName
        _lines = lines
        _totalText = totalText

        Me.Text = "Recipe Preview"
        Me.Width = 1000
        Me.Height = 700
        Me.StartPosition = FormStartPosition.CenterParent

        InitializeUi()
    End Sub

    Private Sub OnCloseClicked(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

    Private Sub InitializeUi()
        lblHeader = New Label() With {
            .Dock = DockStyle.Top,
            .Height = 48,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .TextAlign = ContentAlignment.MiddleLeft,
            .Padding = New Padding(16, 0, 0, 0),
            .Text = $"Recipe: {_productCode} - {_productName}    |    {_totalText}"
        }

        dgv = New DataGridView() With {
            .Dock = DockStyle.Fill,
            .ReadOnly = True,
            .AutoGenerateColumns = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .AllowUserToOrderColumns = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
        }
        dgv.DataSource = _lines

        Dim pnlBottom As New Panel() With {.Dock = DockStyle.Bottom, .Height = 56}
        btnPrint = New Button() With {.Text = "Export to PDF / Print", .Width = 180, .Height = 32, .Left = 16, .Top = 12}
        btnClose = New Button() With {.Text = "Close", .Width = 100, .Height = 32, .Left = 208, .Top = 12}
        AddHandler btnPrint.Click, AddressOf OnPrintClicked
        AddHandler btnClose.Click, AddressOf OnCloseClicked
        pnlBottom.Controls.AddRange(New Control() {btnPrint, btnClose})

        printDoc = New PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf OnPrintPage
        printPreview = New PrintPreviewDialog() With {.Document = printDoc}

        Me.Controls.Add(dgv)
        Me.Controls.Add(pnlBottom)
        Me.Controls.Add(lblHeader)
    End Sub

    Private Sub OnPrintClicked(sender As Object, e As EventArgs)
        ' Let user choose Microsoft Print to PDF or any printer
        Using dlg As New PrintDialog()
            dlg.Document = printDoc
            If dlg.ShowDialog(Me) = DialogResult.OK Then
                Try
                    printDoc.Print()
                Catch ex As Exception
                    MessageBox.Show("Print failed: " & ex.Message, "Print", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Using
    End Sub

    Private Sub OnPrintPage(sender As Object, e As PrintPageEventArgs)
        Dim g = e.Graphics
        Dim margin = 40
        Dim y = margin
        Dim lineHeight = 22
        Dim fontHeader As New Font("Segoe UI", 11, FontStyle.Bold)
        Dim fontRow As New Font("Segoe UI", 9)

        ' Header
        g.DrawString($"Recipe: {_productCode} - {_productName}", fontHeader, Brushes.Black, margin, y)
        y += lineHeight
        g.DrawString(_totalText, fontHeader, Brushes.Black, margin, y)
        y += lineHeight
        g.DrawLine(Pens.Black, margin, y, e.PageBounds.Width - margin, y)
        y += 8

        ' Column titles
        Dim headers = New String() {"Level", "Kind", "ItemType", "Name", "Qty", "UoM", "UnitCost", "LineCost", "Notes"}
        Dim colWidths = New Integer() {50, 80, 90, 260, 60, 60, 80, 80, 200}
        Dim x = margin
        For i = 0 To headers.Length - 1
            g.DrawString(headers(i), fontRow, Brushes.Black, x, y)
            x += colWidths(i)
        Next
        y += lineHeight
        g.DrawLine(Pens.Black, margin, y, e.PageBounds.Width - margin, y)
        y += 6

        ' Rows
        For Each r As DataRow In _lines.Rows
            x = margin
            Dim values = New Object() {
                r("Level"), r("Kind"), r("ItemType"), r("Name"),
                If(IsDBNull(r("Qty")), "", String.Format("{0:N3}", r("Qty"))),
                If(IsDBNull(r("UoM")), "", r("UoM").ToString()),
                String.Format("{0:N2}", r("UnitCost")),
                String.Format("{0:N2}", r("LineCost")),
                If(IsDBNull(r("Notes")), "", r("Notes").ToString())
            }

            ' new page if necessary
            If y + lineHeight > e.MarginBounds.Bottom Then
                e.HasMorePages = True
                Return
            End If

            For i = 0 To values.Length - 1
                g.DrawString(values(i).ToString(), fontRow, Brushes.Black, x, y)
                x += colWidths(i)
            Next
            y += lineHeight
        Next

        e.HasMorePages = False
    End Sub

End Class

End Namespace

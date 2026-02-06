Imports System.Drawing
Imports System.Drawing.Printing

Partial Public Class PurchaseOrderFormNew
    
    Private Sub Print_Click(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrEmpty(savedPONumber) Then
                MessageBox.Show("Please save the Purchase Order first before printing.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim printDialog As New PrintDialog()
            printDialog.Document = printDocument
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDocument.Print()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Try
            Dim normalFont As New Font("Arial", 9)
            Dim headerFont As New Font("Arial", 10, FontStyle.Bold)
            Dim titleFont As New Font("Arial", 14, FontStyle.Bold)
            Dim smallFont As New Font("Arial", 8)
            
            Dim printY As Integer = 50
            
            ' Title
            e.Graphics.DrawString("PURCHASE ORDER", titleFont, Brushes.Black, 300, printY)
            printY += 40
            
            ' PO Details
            e.Graphics.DrawString($"PO Number: {savedPONumber}", headerFont, Brushes.Black, 50, printY)
            e.Graphics.DrawString($"Date: {dtpOrderDate.Value:dd MMM yyyy}", normalFont, Brushes.Black, 500, printY)
            printY += 25
            
            e.Graphics.DrawString($"Supplier: {txtSupplier.Text}", normalFont, Brushes.Black, 50, printY)
            printY += 25
            
            e.Graphics.DrawString($"Required Date: {dtpRequiredDate.Value:dd MMM yyyy}", normalFont, Brushes.Black, 50, printY)
            printY += 25
            
            If Not String.IsNullOrWhiteSpace(txtReference.Text) Then
                e.Graphics.DrawString($"Reference: {txtReference.Text}", normalFont, Brushes.Black, 50, printY)
                printY += 25
            End If
            
            If Not String.IsNullOrWhiteSpace(txtNotes.Text) Then
                e.Graphics.DrawString($"Notes: {txtNotes.Text}", normalFont, Brushes.Black, 50, printY)
                printY += 25
            End If
            
            printY += 15
            
            ' Line items header
            e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
            printY += 5
            
            e.Graphics.DrawString("Product/Material", headerFont, Brushes.Black, 50, printY)
            e.Graphics.DrawString("Quantity", headerFont, Brushes.Black, 450, printY)
            e.Graphics.DrawString("Unit Price", headerFont, Brushes.Black, 550, printY)
            e.Graphics.DrawString("Total", headerFont, Brushes.Black, 680, printY)
            printY += 25
            
            e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
            printY += 10
            
            ' Line items
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow AndAlso row.Cells("Product").Value IsNot Nothing Then
                    Dim product As String = row.Cells("Product").Value.ToString()
                    
                    ' Truncate long product names
                    If product.Length > 50 Then
                        product = product.Substring(0, 47) & "..."
                    End If
                    
                    Dim qty = If(row.Cells("Qty").Value, 0D)
                    Dim unitPrice = If(row.Cells("UnitPrice").Value, 0D)
                    Dim lineTotal = If(row.Cells("LineTotal").Value, 0D)
                    
                    e.Graphics.DrawString(product, normalFont, Brushes.Black, 50, printY)
                    e.Graphics.DrawString(Convert.ToDecimal(qty).ToString("N4"), normalFont, Brushes.Black, 450, printY)
                    e.Graphics.DrawString(Convert.ToDecimal(unitPrice).ToString("N4"), normalFont, Brushes.Black, 550, printY)
                    e.Graphics.DrawString(Convert.ToDecimal(lineTotal).ToString("N4"), normalFont, Brushes.Black, 680, printY)
                    printY += 20
                End If
            Next
            
            printY += 10
            e.Graphics.DrawLine(Pens.Black, 50, printY, 780, printY)
            printY += 20
            
            ' Totals
            e.Graphics.DrawString("Sub Total (Excl VAT):", normalFont, Brushes.Black, 550, printY)
            e.Graphics.DrawString($"R {txtSubTotal.Text}", normalFont, Brushes.Black, 680, printY)
            printY += 25
            
            e.Graphics.DrawString("VAT (15%):", normalFont, Brushes.Black, 550, printY)
            e.Graphics.DrawString($"R {txtVAT.Text}", normalFont, Brushes.Black, 680, printY)
            printY += 25
            
            ' Draw line before total
            e.Graphics.DrawLine(Pens.Black, 550, printY, 780, printY)
            printY += 10
            
            e.Graphics.DrawString("TOTAL (Incl VAT):", headerFont, Brushes.Black, 550, printY)
            e.Graphics.DrawString($"R {txtTotal.Text}", headerFont, Brushes.Black, 680, printY)
            
            ' Footer
            printY = 1050
            e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, 50, printY)
            
            e.HasMorePages = False
        Catch ex As Exception
            MessageBox.Show($"Error during print: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
End Class

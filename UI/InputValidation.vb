Imports System.Windows.Forms

Namespace UI
    Public Module InputValidation
        ' Attach numeric-only KeyPress handler to a TextBox
        Public Sub AttachNumericOnly(tb As TextBox, Optional allowDecimal As Boolean = True)
            If tb Is Nothing Then Return
            ' Remove both to avoid duplicate subscriptions
            RemoveHandler tb.KeyPress, AddressOf NumericKeyPressDecimal
            RemoveHandler tb.KeyPress, AddressOf NumericKeyPressInteger
            If allowDecimal Then
                AddHandler tb.KeyPress, AddressOf NumericKeyPressDecimal
            Else
                AddHandler tb.KeyPress, AddressOf NumericKeyPressInteger
            End If
        End Sub

        ' Convenience for DataGridView EditingControlShowing: attach to current editing TextBox when column matches
        Public Sub AttachNumericOnlyForGrid(dgv As DataGridView, e As DataGridViewEditingControlShowingEventArgs, allowDecimal As Boolean, ParamArray columnNames() As String)
            If dgv Is Nothing OrElse e Is Nothing OrElse dgv.CurrentCell Is Nothing Then Return
            Dim colName = dgv.CurrentCell.OwningColumn.Name
            For Each name In columnNames
                If String.Equals(name, colName, StringComparison.OrdinalIgnoreCase) Then
                    Dim tb = TryCast(e.Control, TextBox)
                    If tb IsNot Nothing Then
                        AttachNumericOnly(tb, allowDecimal)
                    End If
                    Exit For
                End If
            Next
        End Sub

        ' Integer-only handler
        Private Sub NumericKeyPressInteger(sender As Object, e As KeyPressEventArgs)
            If Char.IsControl(e.KeyChar) Then Return
            If Char.IsDigit(e.KeyChar) Then Return
            e.Handled = True
        End Sub

        ' Decimal-allowed handler (one dot)
        Private Sub NumericKeyPressDecimal(sender As Object, e As KeyPressEventArgs)
            If Char.IsControl(e.KeyChar) Then Return
            If Char.IsDigit(e.KeyChar) Then Return
            If e.KeyChar = "."c Then
                Dim tb = TryCast(sender, TextBox)
                If tb IsNot Nothing AndAlso Not tb.Text.Contains(".") Then Return
            End If
            e.Handled = True
        End Sub
    End Module
End Namespace

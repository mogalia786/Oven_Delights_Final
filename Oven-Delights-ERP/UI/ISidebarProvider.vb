Imports System.Windows.Forms

Namespace UI
    ' Child forms implement this to provide adaptive sidebar content.
    Public Interface ISidebarProvider
        ' Raised when the child form context changes and the sidebar should refresh.
        Event SidebarContextChanged As EventHandler

        ' Return a fresh Panel to be placed in the sidebar's context area.
        Function BuildSidebarPanel() As Panel
    End Interface
End Namespace

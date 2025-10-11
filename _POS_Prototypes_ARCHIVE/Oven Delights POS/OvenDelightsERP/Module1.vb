Imports System.Windows.Forms

Module Module1
    <STAThread>
    Sub Main()
        ' Enable visual styles for modern appearance
        Application.EnableVisualStyles()
        Application.SetCompatibleTextRenderingDefault(False)
        
        ' Start the application with LoginForm
        Application.Run(New LoginForm())
    End Sub
End Module

Imports System.Windows.Forms

Public Class BranchHelper
    ''' <summary>
    ''' Locks branch dropdown to user's branch if not super admin
    ''' </summary>
    ''' <param name="cboBranch">The branch ComboBox control</param>
    ''' <param name="isSuperAdmin">Whether current user is super admin</param>
    ''' <param name="currentBranchId">Current user's branch ID</param>
    Public Shared Sub LockBranchDropdown(cboBranch As ComboBox, isSuperAdmin As Boolean, currentBranchId As Integer)
        If cboBranch Is Nothing Then Return
        
        If isSuperAdmin Then
            ' Super admin can see and select all branches
            cboBranch.Enabled = True
            cboBranch.Visible = True
        Else
            ' Regular user - lock to their branch
            cboBranch.Enabled = False
            cboBranch.Visible = True
            
            ' Set to user's branch if datasource is bound
            If cboBranch.DataSource IsNot Nothing AndAlso cboBranch.ValueMember <> "" Then
                cboBranch.SelectedValue = currentBranchId
            End If
        End If
    End Sub
    
    ''' <summary>
    ''' Gets the effective branch ID (user's branch if not super admin, selected branch if super admin)
    ''' </summary>
    Public Shared Function GetEffectiveBranchId(cboBranch As ComboBox, isSuperAdmin As Boolean, currentBranchId As Integer) As Integer
        If isSuperAdmin AndAlso cboBranch IsNot Nothing AndAlso cboBranch.SelectedValue IsNot Nothing Then
            Return Convert.ToInt32(cboBranch.SelectedValue)
        Else
            Return currentBranchId
        End If
    End Function
End Class

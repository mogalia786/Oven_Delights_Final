Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Manufacturing
    Public Class BakerDashboardForm
        Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private currentBranchID As Integer = 0
        Private bakerCards As New List(Of Panel)
        Private WithEvents refreshTimer As New Timer()

        Private Sub BakerDashboardForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
            Try
                If AppSession.CurrentUser Is Nothing Then
                    MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.Close()
                    Return
                End If
                
                currentBranchID = AppSession.CurrentUser.BranchID
                
                ' Setup auto-refresh timer (every 30 seconds)
                refreshTimer.Interval = 30000
                refreshTimer.Start()
                
                LoadBakerCards()
            Catch ex As Exception
                MessageBox.Show("Error loading dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadBakerCards()
        End Sub
        
        Private Sub refreshTimer_Tick(sender As Object, e As EventArgs) Handles refreshTimer.Tick
            LoadBakerCards()
        End Sub

        Private Sub LoadBakerCards()
            Try
                flpBakers.Controls.Clear()
                bakerCards.Clear()
                
                Using conn As New SqlConnection(connectionString)
                    ' Get all bakers with their today's orders
                    Dim cmd As New SqlCommand("
                        SELECT 
                            u.UserID,
                            u.FirstName + ' ' + u.LastName AS BakerName,
                            u.Email,
                            COUNT(DISTINCT rob.ReOrderBookID) AS TodayOrders,
                            SUM(CASE WHEN rob.Status = 'Posted' THEN 1 ELSE 0 END) AS PendingOrders,
                            SUM(CASE WHEN rob.Status = 'BOM Fulfilled' THEN 1 ELSE 0 END) AS ReadyOrders,
                            SUM(CASE WHEN rob.Status = 'In Production' THEN 1 ELSE 0 END) AS InProgressOrders,
                            SUM(CASE WHEN rob.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
                            ISNULL(SUM(rbl.QuantityOrdered), 0) AS TotalProducts,
                            COUNT(DISTINCT rbl.ProductID) AS TotalQuantity
                        FROM Users u
                        INNER JOIN Roles r ON u.RoleID = r.RoleID
                        LEFT JOIN ReOrderBooks rob ON u.UserID = rob.ManufacturerUserID 
                            AND rob.OrderDate = CAST(GETDATE() AS DATE)
                            AND rob.BranchID = @BranchID
                        LEFT JOIN ReOrderBookLines rbl ON rob.ReOrderBookID = rbl.ReOrderBookID
                        WHERE r.RoleName = 'Manufacturer' 
                            AND u.IsActive = 1 
                            AND u.BranchID = @BranchID
                        GROUP BY u.UserID, u.FirstName, u.LastName, u.Email
                        ORDER BY u.FirstName", conn)
                
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    conn.Open()
                
                    Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                    While reader.Read()
                        Dim card As Panel = CreateBakerCard(
                            CInt(reader("UserID")),
                            reader("BakerName").ToString(),
                            If(IsDBNull(reader("Email")), "", reader("Email").ToString()),
                            If(IsDBNull(reader("TodayOrders")), 0, CInt(reader("TodayOrders"))),
                            If(IsDBNull(reader("PendingOrders")), 0, CInt(reader("PendingOrders"))),
                            If(IsDBNull(reader("ReadyOrders")), 0, CInt(reader("ReadyOrders"))),
                            If(IsDBNull(reader("InProgressOrders")), 0, CInt(reader("InProgressOrders"))),
                            If(IsDBNull(reader("CompletedOrders")), 0, CInt(reader("CompletedOrders"))),
                            If(IsDBNull(reader("TotalProducts")), 0, CInt(reader("TotalProducts"))),
                            If(IsDBNull(reader("TotalQuantity")), 0, CInt(reader("TotalQuantity")))
                        )
                    
                        flpBakers.Controls.Add(card)
                        bakerCards.Add(card)
                    End While
                End Using
            
                If bakerCards.Count = 0 Then
                    Dim lblNoData As New Label With {
                        .Text = "No bakers found",
                        .Font = New Font("Segoe UI", 14, FontStyle.Italic),
                        .ForeColor = Color.Gray,
                        .AutoSize = True,
                        .Padding = New Padding(20)
                    }
                    flpBakers.Controls.Add(lblNoData)
                End If
            
            Catch ex As Exception
                MessageBox.Show("Error loading baker cards: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function CreateBakerCard(bakerID As Integer, bakerName As String, email As String,
                                        todayOrders As Integer, pending As Integer, ready As Integer, inProgress As Integer,
                                        completed As Integer, totalProducts As Integer, totalQty As Integer) As Panel
        
            ' Main card panel
            Dim card As New Panel With {
                .Width = 320,
                .Height = 220,
                .BorderStyle = BorderStyle.FixedSingle,
                .Margin = New Padding(15),
                .Cursor = Cursors.Hand,
                .Tag = bakerID
            }
        
            ' Determine card color based on status
            Dim cardColor As Color
            If ready > 0 Then
                cardColor = Color.FromArgb(144, 238, 144) ' Bright green - ready to start!
            ElseIf pending > 0 Then
                cardColor = Color.FromArgb(255, 243, 205) ' Yellow - waiting for stockroom
            ElseIf inProgress > 0 Then
                cardColor = Color.FromArgb(209, 231, 221) ' Light blue - in progress
            ElseIf completed > 0 Then
                cardColor = Color.FromArgb(212, 237, 218) ' Light green - completed
            Else
                cardColor = Color.FromArgb(248, 249, 250) ' Gray - no orders
            End If
            card.BackColor = cardColor
        
            ' Baker icon/initial
            Dim lblInitial As New Label With {
                .Text = bakerName.Substring(0, 1).ToUpper(),
                .Font = New Font("Segoe UI", 32, FontStyle.Bold),
                .ForeColor = Color.White,
                .BackColor = Color.FromArgb(0, 122, 204),
                .Size = New Size(70, 70),
                .Location = New Point(15, 15),
                .TextAlign = ContentAlignment.MiddleCenter
            }
            card.Controls.Add(lblInitial)
        
            ' Baker name
            Dim lblName As New Label With {
                .Text = bakerName,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .Location = New Point(100, 15),
                .AutoSize = True,
                .ForeColor = Color.FromArgb(33, 37, 41)
            }
            card.Controls.Add(lblName)
        
            ' Email
            If Not String.IsNullOrEmpty(email) Then
                Dim lblEmail As New Label With {
                    .Text = email,
                    .Font = New Font("Segoe UI", 8),
                    .Location = New Point(100, 40),
                    .AutoSize = True,
                    .ForeColor = Color.Gray
                }
                card.Controls.Add(lblEmail)
            End If
        
            ' Today's orders summary
            Dim lblOrders As New Label With {
                .Text = $"📋 Today's Orders: {todayOrders}",
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Location = New Point(15, 100),
                .AutoSize = True,
                .ForeColor = Color.FromArgb(33, 37, 41)
            }
            card.Controls.Add(lblOrders)
        
            ' Status breakdown
            Dim yPos As Integer = 125
            If ready > 0 Then
                Dim lblReady As New Label With {
                    .Text = $"🚀 Ready to Start: {ready}",
                    .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                    .Location = New Point(20, yPos),
                    .AutoSize = True,
                    .ForeColor = Color.FromArgb(0, 128, 0)
                }
                card.Controls.Add(lblReady)
                yPos += 20
            End If
            
            If pending > 0 Then
                Dim lblPending As New Label With {
                    .Text = $"⏳ Waiting Stockroom: {pending}",
                    .Font = New Font("Segoe UI", 9),
                    .Location = New Point(20, yPos),
                    .AutoSize = True,
                    .ForeColor = Color.FromArgb(255, 193, 7)
                }
                card.Controls.Add(lblPending)
                yPos += 20
            End If
        
            If inProgress > 0 Then
                Dim lblInProgress As New Label With {
                    .Text = $"🔄 In Progress: {inProgress}",
                    .Font = New Font("Segoe UI", 9),
                    .Location = New Point(20, yPos),
                    .AutoSize = True,
                    .ForeColor = Color.FromArgb(0, 123, 255)
                }
                card.Controls.Add(lblInProgress)
                yPos += 20
            End If
        
            If completed > 0 Then
                Dim lblCompleted As New Label With {
                    .Text = $"✅ Completed: {completed}",
                    .Font = New Font("Segoe UI", 9),
                    .Location = New Point(20, yPos),
                    .AutoSize = True,
                    .ForeColor = Color.FromArgb(40, 167, 69)
                }
                card.Controls.Add(lblCompleted)
                yPos += 20
            End If
        
            ' Total products and quantity
            If totalProducts > 0 Then
                Dim lblTotal As New Label With {
                    .Text = $"📦 {totalProducts} products | {totalQty:N0} units",
                    .Font = New Font("Segoe UI", 9),
                    .Location = New Point(20, yPos),
                    .AutoSize = True,
                    .ForeColor = Color.Gray
                }
                card.Controls.Add(lblTotal)
            End If
        
            ' Click to view button
            Dim btnView As New Button With {
                .Text = "View Orders →",
                .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                .BackColor = Color.FromArgb(0, 122, 204),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Size = New Size(120, 30),
                .Location = New Point(180, 175),
                .Cursor = Cursors.Hand,
                .Tag = bakerID
            }
            AddHandler btnView.Click, AddressOf BakerCard_Click
            card.Controls.Add(btnView)
        
            ' Add click handler to entire card
            AddHandler card.Click, AddressOf BakerCard_Click
            AddHandler lblInitial.Click, AddressOf BakerCard_Click
            AddHandler lblName.Click, AddressOf BakerCard_Click
        
            ' Hover effect
            AddHandler card.MouseEnter, Sub(s, e)
                                            card.BackColor = Color.FromArgb(
                                                Math.Max(0, cardColor.R - 20),
                                                Math.Max(0, cardColor.G - 20),
                                                Math.Max(0, cardColor.B - 20))
                                        End Sub
            AddHandler card.MouseLeave, Sub(s, e) card.BackColor = cardColor
        
            Return card
        End Function

        Private Sub BakerCard_Click(sender As Object, e As EventArgs)
            Try
                Dim bakerID As Integer = 0
            
                If TypeOf sender Is Button Then
                    bakerID = CInt(DirectCast(sender, Button).Tag)
                ElseIf TypeOf sender Is Panel Then
                    bakerID = CInt(DirectCast(sender, Panel).Tag)
                ElseIf TypeOf sender Is Label Then
                    bakerID = CInt(DirectCast(sender, Label).Parent.Tag)
                End If
            
                If bakerID > 0 Then
                    ' Open Baker Production View
                    Dim productionForm As New BakerProductionViewForm(bakerID)
                    productionForm.ShowDialog()
                
                    ' Refresh cards after closing
                    LoadBakerCards()
                End If
            
            Catch ex As Exception
                MessageBox.Show("Error opening baker orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub
    End Class
End Namespace

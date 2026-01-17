# FIGMENT MiniPOS Cloud Gateway - Complete API Documentation

**Version:** 1.0  
**Date:** January 17, 2026  
**Environment:** Sandbox Testing  
**API Base URL:** https://test.figment.co.za:49410/api/  
**API Key:** Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq  
**Contact:** Marcel Zuur

---

## TABLE OF CONTENTS

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [API Endpoints](#api-endpoints)
4. [Transaction Types](#transaction-types)
5. [Request/Response Schemas](#requestresponse-schemas)
6. [Error Codes](#error-codes)
7. [VB.NET Implementation](#vbnet-implementation)
8. [Testing Guide](#testing-guide)
9. [Production Deployment](#production-deployment)

---

## OVERVIEW

### What is Figment MiniPOS?

Figment MiniPOS Cloud Gateway is a REST API that allows POS systems to process card payments without requiring a physical card terminal. The API communicates with virtual terminals in the cloud.

### Key Features

- ✅ **No Physical Terminal Required** - Cloud-based processing
- ✅ **REST API** - Standard HTTPS/JSON integration
- ✅ **Sandbox Environment** - Full testing capability
- ✅ **Multiple Transaction Types** - Settlement, Refund, CashAdvance
- ✅ **Transaction Management** - Status queries, reprints, cancellations
- ✅ **Secure** - Point-to-Point Encryption (P2PE)
- ✅ **Real-time Processing** - Immediate approval/decline responses

### Integration Benefits

- No hardware purchase required
- Easy API integration
- Sandbox testing before going live
- Support for all major card types (Visa, Mastercard, Amex)
- Contactless and chip card support

---

## AUTHENTICATION

### OAuth2 Token Authentication (PRODUCTION)

**Client ID:** `MP7BQIe0TMxgxzhpGghkNF303zhmYnjA`  
**Client Secret:** `Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma`  
**Token Expiry:** 60 minutes (adjustable)

**Endpoint:** `POST /oauth2/token`

**Request Body:**
```json
{
  "client_id": "MP7BQIe0TMxgxzhpGghkNF303zhmYnjA",
  "client_secret": "Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma"
}
```

**Response:**
```json
{
  "access_token": "227a0d096b445fcbec61a0e3c17ec901ba274a71f52467d1e5ee82f715cf1284",
  "token_type": "Bearer",
  "expires_in": 1800
}
```

**Usage:** Include token in Authorization header for all API calls:
```
Authorization: Bearer {access_token}
```

**Token Management:**
- Request new token only when previous expires (60 minutes)
- Store token securely in memory/session
- Implement automatic token refresh before expiry (recommend 5 minute buffer)

**VB.NET Example:**
```vb
Using client As New HttpClient()
    ' Get OAuth token first
    Dim token = Await GetOAuthToken()
    
    ' Add to Authorization header
    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")
    
    ' Make API call
    Dim response = Await client.PostAsync(url, content)
End Using
```

### API Key Authentication (Alternative)

**API Key:** `Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq`

**Method:** Query Parameter
```
GET https://test.figment.co.za:49410/api/endpoint?apiKey=Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq
```

**Note:** OAuth2 is recommended for production use.

---

## TEST CONFIGURATION

### Test Terminal Details

**Site ID:** `UT02`  
**POS Identifier:** `7`  
**Terminal Location:** Marcel's desk (physical device available for testing)

**Test Transaction Parameters:**
```json
{
  "siteId": "UT02",
  "posIdentifier": 7,
  "requestType": "Settlement",
  "reconIndicator": "1234567",
  "posVersion": "1.0.0",
  "totalAmount": 1000,
  "productItems": [...]
}
```

**Testing Support:**
- Physical terminal available for verification
- Pictures/video of device during test transactions
- Real-time transaction monitoring with Marcel

### Network Architecture

**Sandbox Testing (Current Setup):**
```
Your POS Application (Development PC)
    ↓ HTTPS API Call
Figment Sandbox API (https://test.figment.co.za:49410/api/)
    ↓ Routes transaction to
Marcel's Physical Terminal (posIdentifier: 7)
    ↓ Terminal processes card
Response + Photos sent back
    ↓ JSON Response
Your POS Application receives result
```

**Production Environment (Planned):**
```
POS Terminal (Windows PC)
    ↓ Same LAN Network
Payment Terminal (Ethernet-connected)
    ↓ Internet Connection
Figment Production API
    ↓ Routes to your terminal
Payment Terminal processes card
    ↓ Response
POS Terminal receives result
```

**Key Points:**
- POS and payment terminal on same network (LAN)
- Payment terminal connects via Ethernet
- API calls go over internet to Figment
- Figment routes to appropriate terminal based on `siteId` and `posIdentifier`
- Async processing - POS must wait for terminal response

### Implementation Timeline

**Target Start Date:** January 23, 2026

**Pre-Implementation Checklist:**
- [ ] OAuth2 credentials configured in App.config (encrypted)
- [ ] `FigmentTokenManager` class implemented
- [ ] `FigmentPaymentService` class implemented
- [ ] Database schema for card transactions created
- [ ] Error handling and timeout logic implemented
- [ ] Receipt printing integration (if needed)
- [ ] Network connectivity verified
- [ ] Test transactions with Marcel's terminal successful

---

## API ENDPOINTS

### Base URL
```
https://test.figment.co.za:49410/api/
```

### Endpoint Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/status` | GET | API health check |
| `/oauth2/token` | POST | Generate OAuth token |
| `/transactions/transaction` | POST | Start new transaction |
| `/transactions/resumeTransaction` | POST | Resume timed-out transaction |
| `/transactions/status` | GET | Get transaction status |
| `/transactions/findTransaction` | GET | Find transaction in database |
| `/transactions/reprintReceipt` | POST | Reprint receipt |
| `/transactions/cancel` | DELETE | Cancel pending transaction |

---

## TRANSACTION TYPES

### 1. Settlement (Standard Sale)

**Purpose:** Process a card payment for goods/services

**Request Type:** `Settlement`

**Use Case:** Customer purchases items at POS

### 2. Refund

**Purpose:** Refund a previous transaction

**Request Type:** `Refund`

**Use Case:** Customer returns items

### 3. CashAdvance (CashBack)

**Purpose:** CashBack with no items purchased

**Request Type:** `CashAdvance`

**Use Case:** Customer requests cash only

---

## REQUEST/RESPONSE SCHEMAS

### Start Transaction (POST /transactions/transaction)

#### Request Parameters

| Field | Type | Required | Max Length | Description |
|-------|------|----------|------------|-------------|
| `siteId` | string | ✅ | 15 | Unique site identifier (e.g., "UT02") |
| `requestType` | string | ✅ | - | "Settlement", "Refund", or "CashAdvance" |
| `reconIndicator` | string | ✅ | 7 | Unique request identifier (e.g., "1234567") |
| `posIdentifier` | number | ✅ | 3 | Till number (e.g., 7 for test terminal) |
| `posVersion` | string | ✅ | 40 | POS software version (e.g., "1.8.5.3") |
| `totalAmount` | integer | ✅ | 10 | Total amount in cents (e.g., 1000 = R10.00) |
| `operatorId` | number | ❌ | 7 | Cashier ID (e.g., 107010) |
| `operatorName` | string | ❌ | 20 | Cashier name (e.g., "Marcel") |
| `shiftNo` | number | ❌ | 4 | Shift number |
| `slipNo` | number | ❌ | 4 | Slip number |
| `supervisor` | array | ❌ | - | Supervisor override options ["S"] |
| `cashBackAmount` | integer | ❌ | 8 | CashBack amount in cents (must be < totalAmount) |
| `budgetPeriod` | number | ❌ | 2 | Budget period if applicable |
| `productItems` | array | ✅ | - | Array of product items |

#### Product Item Schema

| Field | Type | Required | Max Length | Description |
|-------|------|----------|------------|-------------|
| `itemId` | number | ✅ | 1 | Item number (e.g., 1) |
| `category` | number | ✅ | 3 | Category code (e.g., 255) |
| `amount` | integer | ✅ | 10 | Item amount in cents |
| `barCode` | string | ❌ | 13 | Product barcode |
| `description` | string | ❌ | 20 | Product description |
| `quantity` | number | ✅ | 7 | Quantity |
| `unitPrice` | integer | ✅ | 10 | Unit price in cents |
| `rebate` | integer | ❌ | 10 | Discount amount in cents |

#### Request Example

```json
{
  "siteId": "UT02",
  "requestType": "Settlement",
  "reconIndicator": "1234567",
  "posIdentifier": 10,
  "posVersion": "1.8.5.3",
  "totalAmount": 1000,
  "operatorId": 107010,
  "operatorName": "Marcel",
  "shiftNo": 1,
  "slipNo": 1,
  "supervisor": ["S"],
  "cashBackAmount": 0,
  "budgetPeriod": 0,
  "productItems": [
    {
      "itemId": 1,
      "category": 255,
      "amount": 1000,
      "barCode": "600123456100",
      "description": "1L CocaCola",
      "quantity": 1,
      "unitPrice": 1000,
      "rebate": 0
    }
  ]
}
```

#### Success Response (200)

```json
{
  "applicationSender": "VBSPOS",
  "requestType": "Settlement",
  "resultCode": "0000",
  "resultSubCode": "001",
  "posIdentifier": 10,
  "reconIndicator": "1234567",
  "totalAmount": 1000,
  "operatorId": 107010,
  "operatorName": "Marcel",
  "supervisor": ["S"],
  "cashBackAmount": 1000,
  "budgetPeriod": 0,
  "printTemplate": "Y",
  "transactions": [
    {
      "date": "2026-01-17T03:52:31.398Z",
      "pan": "528497xxxxxx5593",
      "expiry": "1705",
      "cardType": "006",
      "sequence": "003165",
      "batch": "000076",
      "record": "001",
      "approvalCode": "176593",
      "flags": "60024001",
      "indicators": "221IH ",
      "uti": "99123001-0000-0000-0000-151223165901",
      "track2": ";528497xxxxxx75593=170520100000000000000?",
      "spdhSeqNo": "003165",
      "signature": "N",
      "hotcardSeq": "2000500"
    }
  ],
  "server": {
    "serial": 2644,
    "version": "4.20A"
  },
  "merchant": {
    "number": "600115",
    "terminalId": "600115",
    "name": "Engen Dev",
    "type": "R"
  },
  "printLines": {
    "textLine": [
      {
        "text": "PAN: 457896xxxxxxx391        Visa Card  "
      }
    ],
    "terminalId": false
  }
}
```

#### Declined Response (402)

```json
{
  "error": "Incorrect PIN",
  "resultCode": "1000",
  "resultSubCode": "201",
  "posIdentifier": 10,
  "totalAmount": 1000,
  "server": {
    "serial": "2644",
    "version": "4.20A"
  },
  "merchant": {
    "name": "MiniPOS POSAPI",
    "number": "086553",
    "terminalId": "991230",
    "type": "R"
  },
  "reconIndicator": "1234567",
  "transaction": {
    "pan": "528497xxxxxx5593",
    "cardName": "Credit",
    "cardType": "006",
    "date": "2015-12-23 08:10:00",
    "track2": "528497xxxxxx75593=170520100000000000000",
    "expiry": "1705",
    "sequence": "003165",
    "approvalCode": "176593",
    "uti": "99123001-0000-0000-0000-151223165901",
    "batch": "000076",
    "record": "001",
    "sPDHSeqNo": "003165",
    "flags": "60024001",
    "signature": "N",
    "hotcardSeq": "2000500",
    "indicators": "221IH"
  },
  "printTemplate": "R"
}
```

### Get Transaction Status (GET /transactions/status)

**Purpose:** Query the status of an active transaction (vital for handling communication issues)

**Parameters:**
- `siteId` (required): Unique site identifier
- `posIdentifier` (required): Till number
- `operatorId` (optional): Cashier ID
- `reconIndicator` (required): Request ID

**Example:**
```
GET /transactions/status?siteId=UT02&posIdentifier=10&reconIndicator=1234567&apiKey=Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq
```

**Response Codes:**
- **200**: Transaction successful
- **202**: Transaction in progress (waiting for cashier)
- **402**: Transaction declined
- **404**: Transaction not found

### Resume Transaction (POST /transactions/resumeTransaction)

**Purpose:** Continue a transaction that was timed out by the API but is still being processed

**Parameters:**
- `siteId` (required): Unique site identifier
- `posIdentifier` (required): Till number
- `reconIndicator` (required): Request ID

### Find Transaction (GET /transactions/findTransaction)

**Purpose:** Read transactions from the transaction database

**Parameters:**
- `siteId` (required): Unique site identifier
- `posIdentifier` (required): Till number
- `mode` (required): Filter mode - "TillNo", "OperatorNo", "ReceiptNo", "BatchNo", or "ReconIndicator"
- `value` (required): Value to search for
- `recordNo` (optional): Offset for returned transaction

**Example:**
```
GET /transactions/findTransaction?siteId=UT02&posIdentifier=10&mode=ReconIndicator&value=1104131&apiKey=Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq
```

### Cancel Transaction (DELETE /transactions/cancel)

**Purpose:** Cancel a pending transaction that is still in the queue

**Parameters:**
- `siteId` (required): Unique site identifier
- `posIdentifier` (required): Till number
- `reconIndicator` (required): Request ID of transaction to cancel

**Response (200):**
```json
{
  "resultCode": "0000",
  "posIdentifier": 10,
  "reconIndicator": "1234567"
}
```

### Reprint Receipt (POST /transactions/reprintReceipt)

**Purpose:** Reprint a transaction receipt

**Parameters:**
- `siteId` (required): Unique site identifier
- `posIdentifier` (required): Till number
- `operatorId` (optional): Cashier ID
- `reconIndicator` (required): Request ID

---

## ERROR CODES

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Transaction successful |
| 202 | Transaction in progress (waiting for cashier) |
| 400 | Invalid/Missing field or JSON |
| 401 | API key is missing or invalid |
| 402 | Transaction declined |
| 403 | Not authorised |
| 404 | Transaction not found |
| 500 | Internal System Error |

### Result Codes

| Code | Description |
|------|-------------|
| 0000 | Success |
| 1000 | Declined (e.g., Incorrect PIN) |
| 3015 | Waiting for cashier |
| 3050 | Not found. Please retry |

### Result Sub Codes

| Code | Description |
|------|-------------|
| 001 | Standard success |
| 050 | Not found |
| 201 | Incorrect PIN |

---

## VB.NET IMPLEMENTATION

### Service Class

```vb
Imports System.Net.Http
Imports System.Text
Imports Newtonsoft.Json

' OAuth2 Token Manager
Public Class FigmentTokenManager
    Private ReadOnly apiBaseUrl As String = "https://test.figment.co.za:49410/api/"
    Private ReadOnly clientId As String = "MP7BQIe0TMxgxzhpGghkNF303zhmYnjA"
    Private ReadOnly clientSecret As String = "Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma"
    
    Private currentToken As String
    Private tokenExpiry As DateTime
    
    Public Async Function GetValidToken() As Task(Of String)
        ' Check if token is still valid (with 5 minute buffer)
        If String.IsNullOrEmpty(currentToken) OrElse DateTime.Now >= tokenExpiry.AddMinutes(-5) Then
            Await RefreshToken()
        End If
        
        Return currentToken
    End Function
    
    Private Async Function RefreshToken() As Task
        Try
            Using client As New HttpClient()
                Dim request = New With {
                    .client_id = clientId,
                    .client_secret = clientSecret
                }
                
                Dim json = JsonConvert.SerializeObject(request)
                Dim content = New StringContent(json, Encoding.UTF8, "application/json")
                
                Dim response = Await client.PostAsync($"{apiBaseUrl}oauth2/token", content)
                Dim responseJson = Await response.Content.ReadAsStringAsync()
                
                If response.IsSuccessStatusCode Then
                    Dim tokenResponse = JsonConvert.DeserializeObject(Of TokenResponse)(responseJson)
                    currentToken = tokenResponse.access_token
                    tokenExpiry = DateTime.Now.AddSeconds(tokenResponse.expires_in)
                Else
                    Throw New Exception($"Failed to get token: {responseJson}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Token refresh failed: {ex.Message}")
        End Try
    End Function
End Class

Public Class TokenResponse
    Public Property access_token As String
    Public Property token_type As String
    Public Property expires_in As Integer
End Class

' Payment Service with OAuth2
Public Class FigmentPaymentService
    Private ReadOnly apiBaseUrl As String = "https://test.figment.co.za:49410/api/"
    Private ReadOnly tokenManager As New FigmentTokenManager()
    Private ReadOnly siteId As String = "UT02"
    Private ReadOnly posIdentifier As Integer = 7  ' Test terminal
    Private ReadOnly posVersion As String = "1.0.0"
    
    Public Async Function ProcessPayment(
        amount As Decimal,
        operatorId As Integer,
        operatorName As String,
        slipNo As Integer,
        productItems As List(Of ProductItem)
    ) As Task(Of PaymentResult)
        
        Try
            ' Get valid OAuth token
            Dim token = Await tokenManager.GetValidToken()
            
            ' Generate unique reconIndicator (7 digits)
            Dim reconIndicator As String = DateTime.Now.ToString("HHmmss") & posIdentifier.ToString()
            
            ' Convert amount to cents
            Dim totalAmountCents As Integer = CInt(amount * 100)
            
            ' Build request
            Dim request = New With {
                .siteId = siteId,
                .requestType = "Settlement",
                .reconIndicator = reconIndicator,
                .posIdentifier = posIdentifier,
                .posVersion = posVersion,
                .totalAmount = totalAmountCents,
                .operatorId = operatorId,
                .operatorName = operatorName,
                .shiftNo = 1,
                .slipNo = slipNo,
                .supervisor = New String() {"S"},
                .cashBackAmount = 0,
                .budgetPeriod = 0,
                .productItems = productItems
            }
            
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(120) ' 2 minute timeout
                
                ' Add OAuth token to Authorization header
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")
                
                Dim json = JsonConvert.SerializeObject(request)
                Dim content = New StringContent(json, Encoding.UTF8, "application/json")
                
                Dim url = $"{apiBaseUrl}transactions/transaction"
                Dim response = Await client.PostAsync(url, content)
                Dim responseJson = Await response.Content.ReadAsStringAsync()
                
                If response.IsSuccessStatusCode Then
                    ' Parse success response
                    Dim result = JsonConvert.DeserializeObject(Of FigmentTransactionResponse)(responseJson)
                    
                    Return New PaymentResult With {
                        .Success = True,
                        .ResultCode = result.resultCode,
                        .Amount = amount,
                        .ReconIndicator = reconIndicator,
                        .ApprovalCode = If(result.transactions?.Count > 0, result.transactions(0).approvalCode, ""),
                        .CardType = If(result.transactions?.Count > 0, result.transactions(0).cardType, ""),
                        .MaskedPan = If(result.transactions?.Count > 0, result.transactions(0).pan, ""),
                        .Sequence = If(result.transactions?.Count > 0, result.transactions(0).sequence, ""),
                        .Batch = If(result.transactions?.Count > 0, result.transactions(0).batch, ""),
                        .UTI = If(result.transactions?.Count > 0, result.transactions(0).uti, ""),
                        .TransactionDate = DateTime.Now,
                        .PrintLines = result.printLines
                    }
                Else
                    ' Parse error response
                    Dim errorResult = JsonConvert.DeserializeObject(Of FigmentErrorResponse)(responseJson)
                    
                    Return New PaymentResult With {
                        .Success = False,
                        .ResultCode = errorResult.resultCode,
                        .ErrorMessage = errorResult.error,
                        .ReconIndicator = reconIndicator
                    }
                End If
            End Using
            
        Catch ex As Exception
            Return New PaymentResult With {
                .Success = False,
                .ErrorMessage = $"Communication error: {ex.Message}"
            }
        End Try
    End Function
    
    Public Async Function GetTransactionStatus(
        posIdentifier As Integer,
        reconIndicator As String
    ) As Task(Of PaymentResult)
        
        Try
            Using client As New HttpClient()
                Dim url = $"{apiBaseUrl}transactions/status?siteId={siteId}&posIdentifier={posIdentifier}&reconIndicator={reconIndicator}&apiKey={apiKey}"
                
                Dim response = Await client.GetAsync(url)
                Dim responseJson = Await response.Content.ReadAsStringAsync()
                
                If response.StatusCode = Net.HttpStatusCode.Accepted Then ' 202
                    Return New PaymentResult With {
                        .Success = False,
                        .ErrorMessage = "Transaction in progress",
                        .ResultCode = "3015"
                    }
                ElseIf response.IsSuccessStatusCode Then
                    Dim result = JsonConvert.DeserializeObject(Of FigmentTransactionResponse)(responseJson)
                    
                    Return New PaymentResult With {
                        .Success = True,
                        .ResultCode = result.resultCode,
                        .ReconIndicator = reconIndicator
                    }
                Else
                    Dim errorResult = JsonConvert.DeserializeObject(Of FigmentErrorResponse)(responseJson)
                    
                    Return New PaymentResult With {
                        .Success = False,
                        .ErrorMessage = errorResult.error,
                        .ResultCode = errorResult.resultCode
                    }
                End If
            End Using
            
        Catch ex As Exception
            Return New PaymentResult With {
                .Success = False,
                .ErrorMessage = $"Communication error: {ex.Message}"
            }
        End Try
    End Function
    
    Public Async Function CancelTransaction(
        posIdentifier As Integer,
        reconIndicator As String
    ) As Task(Of Boolean)
        
        Try
            Using client As New HttpClient()
                Dim url = $"{apiBaseUrl}transactions/cancel?siteId={siteId}&posIdentifier={posIdentifier}&reconIndicator={reconIndicator}&apiKey={apiKey}"
                
                Dim response = Await client.DeleteAsync(url)
                
                Return response.IsSuccessStatusCode
            End Using
            
        Catch ex As Exception
            Return False
        End Try
    End Function
End Class

' Data Classes
Public Class ProductItem
    Public Property itemId As Integer
    Public Property category As Integer
    Public Property amount As Integer
    Public Property barCode As String
    Public Property description As String
    Public Property quantity As Integer
    Public Property unitPrice As Integer
    Public Property rebate As Integer
End Class

Public Class PaymentResult
    Public Property Success As Boolean
    Public Property ResultCode As String
    Public Property Amount As Decimal
    Public Property ReconIndicator As String
    Public Property ApprovalCode As String
    Public Property CardType As String
    Public Property MaskedPan As String
    Public Property Sequence As String
    Public Property Batch As String
    Public Property UTI As String
    Public Property TransactionDate As DateTime
    Public Property ErrorMessage As String
    Public Property PrintLines As Object
End Class

Public Class FigmentTransactionResponse
    Public Property applicationSender As String
    Public Property requestType As String
    Public Property resultCode As String
    Public Property resultSubCode As String
    Public Property posIdentifier As Integer
    Public Property reconIndicator As String
    Public Property totalAmount As Integer
    Public Property transactions As List(Of TransactionDetail)
    Public Property printLines As Object
End Class

Public Class TransactionDetail
    Public Property date As DateTime
    Public Property pan As String
    Public Property expiry As String
    Public Property cardType As String
    Public Property sequence As String
    Public Property batch As String
    Public Property approvalCode As String
    Public Property uti As String
End Class

Public Class FigmentErrorResponse
    Public Property [error] As String
    Public Property resultCode As String
    Public Property resultSubCode As String
End Class
```

### Usage Example

```vb
' In your POS form
Private paymentService As New FigmentPaymentService()

Private Async Sub btnPayCard_Click(sender As Object, e As EventArgs) Handles btnPayCard.Click
    Try
        ' Disable UI
        btnPayCard.Enabled = False
        lblStatus.Text = "Processing payment..."
        
        ' Build product items from cart
        Dim productItems As New List(Of ProductItem)
        Dim itemId As Integer = 1
        
        For Each cartItem In cartItems
            productItems.Add(New ProductItem With {
                .itemId = itemId,
                .category = 255,
                .amount = CInt(cartItem.LineTotal * 100),
                .barCode = cartItem.Barcode,
                .description = cartItem.ProductName.Substring(0, Math.Min(20, cartItem.ProductName.Length)),
                .quantity = cartItem.Quantity,
                .unitPrice = CInt(cartItem.UnitPrice * 100),
                .rebate = CInt(cartItem.Discount * 100)
            })
            itemId += 1
        Next
        
        ' Process payment
        Dim result = Await paymentService.ProcessPayment(
            totalAmount,
            tillNumber,
            cashierId,
            cashierName,
            slipNumber,
            productItems
        )
        
        If result.Success Then
            ' Payment approved
            MessageBox.Show($"Payment Approved!{vbCrLf}Approval Code: {result.ApprovalCode}", 
                          "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            ' Save transaction to database
            SaveTransaction(result)
            
            ' Print receipt
            PrintReceipt(result)
            
            ' Clear cart
            ClearCart()
        Else
            ' Payment declined or error
            MessageBox.Show($"Payment Failed{vbCrLf}{result.ErrorMessage}", 
                          "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        
    Catch ex As Exception
        MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    Finally
        ' Re-enable UI
        btnPayCard.Enabled = True
        lblStatus.Text = ""
    End Try
End Sub
```

---

## TESTING GUIDE

### Sandbox Environment

**URL:** https://test.figment.co.za:49410/api/  
**OAuth Client ID:** MP7BQIe0TMxgxzhpGghkNF303zhmYnjA  
**OAuth Client Secret:** Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma  
**API Key (Alternative):** Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq

### Test Scenarios

#### 1. Successful Transaction
- Use valid request format
- Expect HTTP 200 with resultCode "0000"

#### 2. Declined Transaction
- Test with invalid card details (if supported)
- Expect HTTP 402 with error message

#### 3. Timeout Handling
- Simulate network delay
- Use `/transactions/resumeTransaction` to recover

#### 4. Transaction Status Query
- Start a transaction
- Query status using `/transactions/status`

#### 5. Cancel Transaction
- Start a transaction
- Cancel using `/transactions/cancel` before processing

### Test Data

```vb
' Sample test transaction
Dim testRequest = New With {
    .siteId = "UT02",
    .requestType = "Settlement",
    .reconIndicator = "1234567",
    .posIdentifier = 10,
    .posVersion = "1.0.0",
    .totalAmount = 1000, ' R10.00
    .operatorId = 107010,
    .operatorName = "Test User",
    .productItems = New List(Of Object) From {
        New With {
            .itemId = 1,
            .category = 255,
            .amount = 1000,
            .barCode = "600123456100",
            .description = "Test Product",
            .quantity = 1,
            .unitPrice = 1000,
            .rebate = 0
        }
    }
}
```

---

## PRODUCTION DEPLOYMENT

### Pre-Production Checklist

- [ ] Complete sandbox testing
- [ ] Obtain production API credentials from Figment
- [ ] Update API base URL to production endpoint
- [ ] Update API key to production key
- [ ] Configure merchant details (siteId, merchant number)
- [ ] Test with real card terminal (if applicable)
- [ ] Implement proper error logging
- [ ] Set up transaction reconciliation
- [ ] Configure receipt printing
- [ ] Train staff on payment flow

### Production Configuration

```vb
' Production settings (to be provided by Figment)
Private ReadOnly apiBaseUrl As String = "https://prod.figment.co.za/api/" ' TBD
Private ReadOnly apiKey As String = "PRODUCTION_API_KEY" ' TBD
Private ReadOnly siteId As String = "YOUR_SITE_ID" ' TBD
```

### Security Considerations

1. **API Key Protection**
   - Store API key in encrypted configuration
   - Never hardcode in source code
   - Use App.config with encryption

2. **HTTPS Only**
   - All communication over HTTPS
   - Validate SSL certificates

3. **PCI Compliance**
   - Never store full card numbers
   - Use masked PAN from response
   - Log only non-sensitive data

4. **Error Handling**
   - Don't expose API keys in error messages
   - Log errors securely
   - Provide user-friendly messages

### Support

**Contact:** Marcel Zuur  
**Documentation:** https://test.figment.co.za:49410/api/spec/

---

## APPENDIX

### Card Type Codes

| Code | Card Type |
|------|-----------|
| 006 | Visa |
| 007 | Mastercard |
| 008 | American Express |

### Merchant Type Codes

| Code | Type |
|------|------|
| R | Retail |
| F | Fuel |
| H | Hospitality |
| S | Services |
| O | Other |

### Print Template Codes

| Code | Description |
|------|-------------|
| Y | Print full receipt |
| R | Reprint receipt |
| N | No print |

---

**END OF DOCUMENTATION**

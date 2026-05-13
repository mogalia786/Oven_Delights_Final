# FNB Terminal Credentials Configuration

## Overview
This document contains the FNB payment terminal credentials for both TEST (Sandbox) and LIVE (Production) environments.

---

## TEST/SANDBOX CREDENTIALS (CURRENT)

**Status:** ✅ Active  
**Environment:** Test/Sandbox  
**File:** `Services/FNBTerminalTestService.vb`

### API Configuration
```
API Base URL: https://test.figment.co.za:49410/api/
OAuth Endpoint: https://test.figment.co.za:49410/api/oauth2/token
Transaction Endpoint: https://test.figment.co.za:49410/api/transactions/transaction
```

### OAuth Credentials
```
Client ID: MP7BQIe0TMxgxzhpGghkNF303zhmYnjA
Client Secret: Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma
```

### Site Configuration
```
Site ID: UT02
POS Version: 1.8.5.3
```

### Terminal Configuration
```
Terminal 10: Virtual (Auto-Approved) - No physical card required
Terminal 7: Real PED - Requires actual card swipe at physical terminal
```

### Default Transaction Settings
```
Shift No: 1
Cash Back Amount: 0
Budget Period: 0
Supervisor Code (Settlement): S
Supervisor Code (Refund): R
```

---

## LIVE/PRODUCTION CREDENTIALS ✅ ACTIVE

**Status:** ✅ Active - Ready for Production Use  
**Environment:** Production  
**File:** `Overn-Delights-POS/Services/PaypointPaymentService.vb`

### API Configuration
```
API Base URL: https://miniposfnb.co.za:49410/api/
OAuth Endpoint: https://miniposfnb.co.za:49410/api/oauth2/token
Transaction Endpoint: https://miniposfnb.co.za:49410/api/transactions/transaction
```

### OAuth Credentials (AUT Keys)
```
Client ID: qEXGrBTnJQS9ZBX7bzuKnkHQfZ0UUFUX
Client Secret: j082ZT3cPyojxN9CSmdp41p7nXGLQ8zH
```

### Site Configuration
```
Site ID: RT08
POS Version: 1.8.5.3
```

### Merchant Information
```
Retail Merchant Number: 100000002543170
Retail Terminal ID: 201435
Terminal Type: Physical PED (Card Swipe Required)
```

### Default Transaction Settings
```
Shift No: 1
Cash Back Amount: 0
Budget Period: 0
Supervisor Code (Settlement): S
Supervisor Code (Refund): R
```

---

## Implementation Checklist

When LIVE credentials are received:

- [ ] Create new `FNBTerminalService.vb` file (production version)
- [ ] Update API Base URL to production endpoint
- [ ] Replace Client ID with production credentials
- [ ] Replace Client Secret with production credentials
- [ ] Update Site ID to actual production site
- [ ] Configure actual terminal ID(s)
- [ ] Test connection to production API
- [ ] Test OAuth token generation
- [ ] Perform test transaction with small amount
- [ ] Verify transaction approval flow
- [ ] Test refund functionality
- [ ] Update payment dialogs to use production service
- [ ] Document any production-specific requirements
- [ ] Archive test credentials for reference

---

## Security Notes

⚠️ **IMPORTANT:**
- NEVER commit production credentials to version control
- Store production credentials in secure configuration (encrypted app.config or Azure Key Vault)
- Use environment variables or secure configuration management
- Restrict access to production credentials to authorized personnel only
- Regularly rotate credentials as per FNB security policy
- Keep test and production environments completely separate

---

## Contact Information

**FNB Support:**
- Technical Support: [TO BE PROVIDED]
- Account Manager: [TO BE PROVIDED]
- Emergency Contact: [TO BE PROVIDED]

---

## Change Log

| Date | Environment | Change | Updated By |
|------|-------------|--------|------------|
| 2026-05-04 | TEST | Initial documentation created | System |
| 2026-05-05 | LIVE | Production credentials added | System |
| 2026-05-05 | LIVE | Merchant #: 100000002543170, Terminal: 201435 | System |

---

## Related Files

**ERP (Test/Development):**
- `Oven-Delights-ERP/Services/FNBTerminalTestService.vb` - Test implementation
- `Oven-Delights-ERP/Forms/FNBTerminalTestForm.vb` - Test UI

**POS (Production):**
- `Overn-Delights-POS/Services/PaypointPaymentService.vb` - ✅ LIVE credentials configured
- `Overn-Delights-POS/Forms/CustomOrders/RefundTenderDialog.vb` - Payment/refund dialog

---

**Last Updated:** 2026-05-05  
**Document Version:** 2.0 (LIVE Credentials Added)

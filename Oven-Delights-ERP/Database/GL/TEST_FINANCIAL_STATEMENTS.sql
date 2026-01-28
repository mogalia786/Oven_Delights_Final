-- Test script to verify what columns the procedures return
PRINT 'Testing sp_GL_BalanceSheet...'
PRINT ''

-- Execute and show columns
EXEC sp_GL_BalanceSheet

PRINT ''
PRINT '================================'
PRINT 'Testing sp_GL_ProfitAndLoss...'
PRINT ''

EXEC sp_GL_ProfitAndLoss

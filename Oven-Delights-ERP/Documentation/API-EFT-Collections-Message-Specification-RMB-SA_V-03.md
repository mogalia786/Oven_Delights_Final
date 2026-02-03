# API-EFT-Collections-Message-Specification-RMB-SA_V-03

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
 
 
 
  APPLICATION 
PROGRAMMING 
INTERFACE (API)  
EFT 
COLLECTIONS  
MESSAGE 
SPECIFICATION  
 
SOUTH AFRICA  
a division of FirstRand Bank Limited, is an Authorised Financial Services and Credit Provider NCRCP20.  

 
2 
 Contents  
2.1 Document Scope  ................................ ................................ ................................ .... 3 
2.2 Customer Direct Debit Initiation  ................................ ................................ ..............  3 
2.3 Collection Status Report  ................................ ................................ .........................  3 
2.4 Referenced Swagger Docs  ................................ ................................ .....................  3 
2.5 Message Specification Explained  ................................ ................................ ...........  4 
2.6 Customer Direct Debit Initiation V02 – PAIN.008.001.02 Message Specification  .... 5 
2.7 Collection Status Report – PAIN.002.001.03 Message Specification  ..................... 14 
3. Code Definition Tables  ................................ ................................ ........................... 19 
3.1 HTTP Response Status Codes  ................................ ................................ .............. 19 
3.2 Collection Transaction Status Code  ................................ ................................ .......19 
3.3 Account Types  ................................ ................................ ................................ .......20 
3.4 Service Level Codes  ................................ ................................ .............................. 20 
3.5 Sequence Type ................................ ................................ ................................ ......21 
3.6 Entry Class  ................................ ................................ ................................ ............ 21 
3.7 Tracking Codes ................................ ................................ ................................ ......21 
3.8 Permitted Character Set  ................................ ................................ ........................ 22 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
No part of this document may be reproduced, stored in a retrieval system or transmitted in any form by any means 
electronic, mechanical, photocopying, recording or otherwise, without the prior written permission of Rand Merchant 
Bank.   

 
 3 
 2.1 Document Scope  
 
The purpose of this document is to provide all details as well as data fields to create a Customer 
Direct Debit Initiation (Collections) Messages based on Rand Merchant Bank (RMB)  specific 
rules and usage guidelines derived from the base message ISO20022 PAIN.008.001.0 2 and 
PAIN.002.001.03 respectively.  
 
2.2 Customer Direct  Debit Initiation  
 
A Customer Direct Debit Initiation is a message sent by the initiating party to request collections 
of funds.  
 
It is used to request single or bulk collection(s) of funds from one or various debtor's account(s) 
for a creditor.  
 
2.3 Collection Status Report  
 
This service is used to retrieve the current status report of collections transactions.  
 
2.4 Referenced Swagger Docs  
 
The Swagger Docs together with the message specification outlining RMB usage rules should 
be used as a guideline to create a Customer Direct Debit Initiation message.  
 
 
 
*Reference: For more information about this XSD format please visit www.iso20022.org . 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 4 
 2.5 Message Specification Explained  
 
The following table explains the usage in the message format.  
 
Column  Definition  
Field  Refers to a JSON field within the P AIN.008.001.02 
message.  
Name  Refers to the full name of the field.  
Multiplicity  This determines if a field is optional or mandatory, and how 
many times the field can be repeated as per the base ISO 
message.  
 
For example**:  
[0..1] Shows that the field can appear 0 or 1 time. The field 
is optional.  
[0..n] Shows that the field can appear 0 or multiple times. 
The field is optional.  
[1..1] Shows that the field is required and must appear 
once.  
[1..n] Shows that the field is required and must appear at 
least once. The field can appear multiple times.  
In case a lower -level field is required while its higher field is 
optional, the lower level is required only if the higher -level 
field is present.  
 
Where a field is required in the multiplicity column it will 
always be required in the ROC column. However, an 
optional field in the multiplicity column may be overwritten 
by the rule in the ROC column.  
R/O/C  This determines if a field is Required/Optional/Conditional 
for RMB. 
R = Required  
O = Optional  
C = Conditional. Example: Either the creditor or the ultimate 
creditor details can be provided. If both are provided the 
ultimate creditor details will be used.  
XOR = This field or the next field, but not both must be 
populated.  
RMB Rules  This defines the RMB restrictions on a field.  
Where length and other format rules differ between ISO 
default and the RMB length and format rules will be 
stipulated here.  
Additional Information  This provides more information on the usage of the field.  

 
 5 
 2.6 Customer Direct Debit Initiation V02 – PAIN.008.001.02 Message Specification  
 
 
Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
GroupHeader  1..1 R   Set of characteristics shared by all individual 
transactions included in the message.  
messageIdentification 
(MessageID)  1..1 R  Text: 
Maximum 
length = 35  Point -to-point reference, as assigned by the 
instructing party, and sent to the next party in the 
chain to unambiguously identify the message.  
Usage: The instructing party must make sure 
that MessageIdentification is unique for all 
PAIN008 messages submitt ed by the same 
Integration Channel partner for a pre -agreed 
period (currently indefinite).  
Do not use slashes as this results in changes in 
folder allocations on file -based systems.  
Must not be blank or spaces.  
creationDateTime  1..1 R  ISODateTime  Date and time at which the message was 
created.  
Format is: YYYY -MM-DDThh:mm:ss  
initiatingPartyName  1..1 R  Text: 
Maximum 
length = 30  Party that initiates the collection.  
Name by which a party is known, and which is 
usually used to identify that party.  
If the transaction is not initiated by a System 
Operator or Third -Party Payment Provider, the 
creditor name needs to be provided in this field.  
This field is used for informational purposes.  
initiatingPartyBIC  0..1 0 Text: 
Maximum 
length = 11  -BIC address used to Identify the initiating Party.  
 

 
 6 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
totalNumberOfTransactions  1..1 R Integer:  
Maximum 
Length = 6  Number of individual transactions contained in 
the message. It is the number of all the debit 
transactions included in all the Payment 
Information groups combined.  
totalControlSum  0..1 O Number Float  
Total Digits: 
13 
Fraction 
Digits: 2  Total of all individual amounts included in the 
message, irrespective of currencies. Must not 
contain more than 2 decimal places.  
For more than one Payment Information group, 
this would be the sum of all the Control Sums 
contained in each of the Payment Information 
groups.  
paymentInformation  1..n R   Set of characteristics that applies to the credit 
side of the collection transactions included in the 
direct debit transaction initiation, also referred to 
as a batch.  
Repeated for all Payment Information groups in 
a message (i.e. multiple collection batc hes could 
be submitted in the message, each batch 
containing a credit and one or more debits).  
Where entire batches are submitted for 
processing and all the transactions relate to the 
same credit account, these should be part of the 
same payment informatio n group.  
If batching of transactions with different credit 
references is required, then different payment 
information groups can be used.  
If every individual transaction requires a credit 
with a unique reference then the itemisation 
feature can be request ed.  

 
 7 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
paymentInformationIdentification 
(paymentInformationId)  1..1 R Text: 
Maximum = 
30 Unique identification, as assigned by a sending 
party, to identify the payment information group 
within the message.  
When processing the transactions in a 
consolidated manner, this value will be used as 
the bulk reference on the creditor's account and 
will appear on the account statement. This 
reference must not be only spaces. Spaces after 
(at the end of the) text is trimmed.  
It must also be unique across all payment 
information groups contained in the message.  
Please note: All references are converted to  
upper case when processed but will appear in 
title case on RMB Online Banking.  
paymentInformationMethod  1..1 R Code  
Text:  
Maximum = 2  Can only be "DD" (Direct Debit).  
batchBooking  0..1 O Boolean  
True or False   Indicator to state whether the transactions 
should be processed in a consolidated manner.  
• "true": Transactions will be posted to the 
creditor account in a consolidated manner.  A 
single transaction entry will be posted to the 
creditor account, for the full value of all 
transactions. Any transactions that fail will result 
in a reversal entry being po sted on the creditor 
account.  
• "false ": Transactions will be posted to the 
creditor account in an itemised manner. An entry 
will be posted into the creditor account for each 
successful transaction.  

 
 8 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
numberOfTransactions  1..1 R Integer:  
Maximum 
Length = 6  Number of individual transactions contained in 
the Payment Information group. This is the 
number of credit transactions applicable to the 
Payment Information group.  
controlSum  0..1 O Number Float  
Total Digits: 
13 
Fraction 
Digits: 2  Total amount of all individual transactions' 
Instructed Amounts included in this Payment 
Information group, irrespective of currency.  
paymentTypeInformationServiceL
evelCode  1..1 R  Code  
Text:  
Maximum = 4  Specifies a pre -agreed service or level of service 
between the parties, as published in an external 
service level code set, in this case the ISO code 
list where there is no predefined option in the 
external code set.  
 
Please refer to the “ Service level codes ” 
 
Please note: real time processing does not 
apply to collections.  
requestedCollectionDate  1..1 R  ISODate   Date on which the creditor requests that the 
amount of money is to be collected from the 
debtor and credited to their account.  
creditor  1..1 R   Party to which an amount is due.  
name  1..1 R Text: 
Maximum = 
30 Name by which a party is known, and which is 
usually used to identify that party, i.e., the 
Integration Channel client name. Must not be 
only spaces. Spaces after text is trimmed.  
abbreviatedName  1..1 R Text: 
Maximum = 
10 Identification assigned by an institution, i.e., the 
abbreviated name of the Creditor. Must not be 
only spaces.  

 
 9 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
bicOrBEI  0..1 O Text: 
Maximum = 
11 -BIC address of the creditor.  
creditorAccount  1..1 R   Unambiguous identification of the  creditor's 
account to which a credit entry will be posted as 
a result of the collection transaction.  
accountNumber  1..1 R Text: 
Maximum = 
23 Identification assigned by an institution.  
Creditor (client) account number assigned by the 
Bank. Must not be only zeroes or spaces.  
accountType  1..1 R Code  
Text:  
Maximum = 4  Specifies the nature or use of the account. 
Creditor account can only be cheque/cash or 
savings. Therefore, proprietary cannot be used  
ISO account type code published in the ISO 
external code set.  
Refer to " Account Type Codes ” table for 
accepted options.  
creditorAgent  1..1 R   Unambiguous identification of the account of the 
creditor agent at its servicing agent in the 
collection chain.  
branchIdentifier  
(branchId)  1..1 R Text: 
Maximum = 6  Identifies a specific branch of a financial 
institution.  
Branch Code for the Creditor account. Must not 
be only zeroes and must not contain any 
spaces.  
directDebitTransactionInformation  1..n R   Set of fields used to provide information on the 
individual debit transaction(s) included in the 
message. Repeated for all debit transactions 
within a payment information group or batch. 
Debits are batched together where they have the 
same credit details, i.e., same creditor account 
and same reference used for the batch (if 
different credit references required for a batch of 

 
 10 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
collections, then these can be grouped as a 
different batch). Also, itemised processing allows 
an individual reference per debit transaction.  
EndToEndIdentification  
(endToEndId)  1..1 R Text: 
Maximum = 
30 Unique identification assigned by the initiating 
party to unambiguously identify the transaction. 
This identification is passed on throughout the 
entire end -to-end chain. For itemised processing 
this will be the reference reflecting on the 
creditor's (clie nt) statement. Must not be only 
spaces. Spaces after text is trimmed.  
Please note: All references are converted to 
upper case when processed but will appear in 
title case on RMB Online Banking.  
amount  1..1 R  
Amount of money to be collected from the debtor 
by the creditor, before deduction of charges, 
expressed in the currency as ordered by the 
initiating party.  
currency  1..1 R Code: 
Maximum 
length = 3  Amount field must contain JSON attribute "Ccy" 
to indicate Currency Code.  
Currency Code must comply with ISO 4217.  
Use "ZAR" for RSA transactions.  
value  1..1 R Number Float  
Total Digits: 
13 
Fraction 
Digits: 2  The Value field contains one or two or no 
decimal values. Decimal separator is a period. 
Values greater than 2 decimals will result in a 
failure. The set of permutations include:  
.1 = 0.10  
0.1 = 0.10  
12 = 12.00  

 
 11 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
12.0 = 12.00  
12.1  = 12.10  
12.10 = 12.10  
 
Must not be only zeroes.  
debtorAgent  1..1 R   Financial institution servicing an account for the 
debtor.  
branchIdentifier  
(branchId)  1..1 R Text: 
Maximum = 6  Identifies a specific branch of a financial 
institution.  
Branch code for the debtor account. Must not be 
only zeroes or spaces.  
debtor  1..1 R   Party that owes an amount of money to the 
(ultimate) creditor.  
name  1..1 R Text: 
Maximum = 
30 Name by which a party is known, and which is 
usually used to identify that party.  
bicOrBEI  0..1 O Text: 
Maximum = 
11 -BIC address of the debtor.  
debtorAccount  1..1 R   Unambiguous identification of the account of the 
debtor to which a debit entry will be posted as a 
result of the collection (direct debit) transaction.  
accountNumber  1..1 R Text: 
Maximum = 
23 Identification assigned by an institution. Debtor 
account number. Must not be only zeroes or 
spaces.  
accountType  1..1 R  Code  
Text:  
Maximum = 4  
 Specifies the nature, type or use of the account.  
Either Code or Proprietary may be used, but not 
both.  
ISO account type code published in the ISO 
external code set.  

 
 12 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
Refer to " Account Type Codes ” tab for 
accepted options.  
localInstrument  0...1 C  Code  
Text:  
Maximum = 2  This indicates tracking period.  
Refer to “Tracking Codes ” table.  
 
-Only applicable for DebiCheck Collections.  
sequencetype  0...1 C Code  
Text:  
Maximum = 
34 Identifies the direct debit sequence, such as first, 
recurring, final, once -off, or represented.  
Refer to  “Sequence type ” table.  
 
-Only applicable for DebiCheck Collections.  
categoryPurpose  0...1 C Code  
Text:  
Maximum = 3  Specifies the high level  purpose of the 
instruction based on a set of pre -defined 
categories.  
-Refer to “Entry Class ” table.  
 
-Only applicable for DebiCheck Collections.  
mandateID  0...1 C Text: 
Maximum = 
35 Unique identification (Mandate Reference 
Number), as assigned by the Debtor Bank, to 
unambiguously identify the mandate that the 
collection needs to be processed against.  
Structure :  
• 4 AN = Bank Number  
 • 8 N = Mandate Creation Date  
• 10 AN  
 
-Only applicable for DebiCheck Collections.  
remittanceInformationUnstructure
d 1..1 R  Text: 
Maximum = 
30 Information supplied to enable the 
matching/reconciliation of an entry with the items 
that the payment is intended to settle, such as 
commercial invoices in an accounts' receivable 

 
 13 
 Name  Multiplicity  R/O/C  RMB Rules  Additional Information  
system, in an unstructured form.  
This is the reference that will appear on the 
debtor's account statement.  
 
EFT Collections (SDVA & TWOD in RSA) 
reference number consist of:  
• 10AN - Creditor Abbreviated Name (taken 
from Creditor --> ID tag above)  
• 20AN - Transaction Reference (populated 
here)  
 
For RMB, the debtor will see these 30 
characters on their statements consisting of the 
above.  
It must not be only spaces. Spaces after text will 
be trimmed.  
Please note: All references are converted to 
upper case w hen processed but will appear in 
title case on RMB Online Banking and may be 
displayed differently at other banks.  
 
 
 
 
 
 
 
 
 
 
 
 

 
 14 
 2.7 Collection Status Report – PAIN.002.001.03 Message Specification  
 
Name  Multiplicity  R/O/C  RMB  Rules  Additional Information  
InstructionId  1..1 R   Text: 
Maximum 
length = 35  Identifier used within RMB to identify each 
request.  
groupHeader  1..1 R   
Set of characteristics shared by all individual 
transactions included in the message.  
messageIdentification 
(messageId)  1..1 R  Text: 
Maximum 
length = 35  Point to point reference to uniquely identify the 
message.  
Usage: The instructing party must make sure 
that 'MessageIdentification' is unique per 
instructed party.  
creationDateTime  1..1 R  ISODateTime  Date and time at which the message was 
created.  
initiatingPartyName  1..1 R Text: 
Maximum 
length = 35  Field containing information on the party that 
initiates the status message.  
initiatingPartyBIC  1..1 O Text: 
Maximum 
length = 11  BIC address by which a party is known  and 
which is usually used to identify that party.  
totalNumberOfTransactions  1..1 R  Integer:  
Maximum 
Length = 6  Number of individual transactions contained in 
the message. It is the number of all the credit 
transactions included in ALL the 
PaymentInformation groups combined.  
totalControlSum  0..1 O  Number Float  
Total Digits: 13  
Fraction Digits: 
2 Total sum of all individual amounts included in 
the message, irrespective of currencies. Must 
not contain more than 2 decimal places.  
For more than one PaymentInformation group, 
this would be the sum of all the Control Sums 
contained in each of the PaymentInformation 
groups.  

 
 15 
 Name  Multiplicity  R/O/C  RMB  Rules  Additional Information  
originalGroupHeader  1..1 R   
Original group information concerning the group 
of transactions, to which the status report 
message refers to.  
originalMessageIdentification 
(originalMessageId)  1..1 R  Text: 
Maximum 
length = 35  Point to point identification reference to the 
original request message.  
originalCreationDateTime  1..1 R  ISODateTime  Date and time at which the original message 
was created.  
originalInitiatingPartyName  1..1 R Text: 
Maximum 
length = 35  Field containing information on the initiating 
party from original Collection request  
originalInitiatingPartyBIC  0..1 O Text: 
Maximum 
length = 11  BIC address by which a party is known and 
which is usually used to identify that party from 
the original transaction  
OriginalTotalNumberOfTransactio
ns 1..1 O Integer:  
Maximum 
Length = 6  Number of individual transactions contained in 
the original message.  
OriginalTotalControlSum  1..1 O Number Float  
Total Digits: 13  
Fraction Digits: 
2 Total of all individual amounts included in the 
original message, irrespective of currencies.  
groupStatus  1..1 R Code  
Text:  
Maximum = 4  Overall group status of the entire file.  
Please refer to the “ Status codes ” section for 
the full list of allowed Status codes.  
The status will be aggregated if it is a bulk file, 
the status of the individual transaction will then 
be detailed in the transactionStatus  field 
StatusReasonInformation  0..1 C  Set of fields used to provide detailed 
information on the status reason, The reason  
and additionalInformation  is only applicable 
when the failure has occurred on the group 
level and there is a specific error code, 

 
 16 
 Name  Multiplicity  R/O/C  RMB  Rules  Additional Information  
successful transactions will not contain these 
fields and subsequently the 
StatusReasonInformation  field will be Null.  
reason  1..1 C Code  
Text:  
Maximum = 4  Error code as defined in the error code 
document for all Integration Channel related 
errors, this will be different from the status code  
additionalInformation  1..1 C Text: 
Maximum 
length = 35  Description of the error code in the reason field.  
OriginalPaymentInformation  0..n R  Information concerning the original payment 
information, to which the status report message 
refers.  
OriginalPaymentInformationIdentif
ication 
(originalPaymentInformationId)  1..1 R Text: 
Maximum 
length = 35  Unique identification, as assigned by the 
original sending party, to unambiguously 
identify the original payment information group. 
The "Client Reference" will be populated in this 
field to assist the client with correlation of the 
response.  
paymentInformationStatus  1..1 R Code  
Text:  
Maximum = 4  Specifies the status of a transaction, in a coded 
form.  
Please refer to the “ Status codes ” section for 
the full list of allowed Status codes.  
StatusReasonInformation  0..n C  Set of fields used to provide detailed 
information on the status reason, The reason  
and additionalInformation  is only applicable 
when there is a specific error code,  successful 
transactions will not contain these fields and 
subsequently the StatusReasonInformation  
will be Null.  
reason  1..1 C Code  
Text:  
Maximum = 4  Error code as defined in the error code 
document for all Integration Channel related 

 
 17 
 Name  Multiplicity  R/O/C  RMB  Rules  Additional Information  
errors, this will be different from the status 
code.  
additionalInformation  1..1 C Text: 
Maximum 
length = 35  Description of the error code in the reason field.  
transactionInfoAndStatus  0..n C  Set of fields used to provide information on the 
original transactions and status to which the 
status report refers. This field will be repeated 
in the case of a bulk file to share the transaction 
status of each transaction.  
originalEndToEndId  1..1 R Text: 
Maximum 
length = 30  Unique identification, as assigned by the 
original initiating party, to unambiguously 
identify the original transaction.  
transactionStatus  1..1 R Code  
Text:  
Maximum = 4  Specifies the status of a transaction, in a coded 
form.  
Refer to “ Status Codes " section.  
 
statusReasonInformation  0..1 C  Set of fields used to provide detailed 
information on the status reason, The reason  
and additionalInformation  is only applicable 
when there is a specific error code, successful 
transactions will not contain these fields and 
subsequently the StatusReasonInformation  
will be Null.  
reason  1..1 C Code  
Text:  
Maximum = 4  Error code as defined in the error code 
document for all Integration Channel related 
errors, this will be different from the status 
code.  
additionalInformation  1..1 C Text: 
Maximum 
length = 35  Description of the error code in the reason field.  

 
 18 
 Name  Multiplicity  R/O/C  RMB  Rules  Additional Information  
clearingSystemReference  0..1 C Text: 
Maximum 
length = 35  Unique reference, as assigned by a clearing 
system, to unambiguously identify the 
instruction. This represents the Stop Payment 
Id assigned by the Paying Bank when the Stop 
Payment was generated.  
 
-Only applicable for DebiCheck Collections.  
originalTransactionReference  0..1 C Text: 
Maximum 
length = 35  Set of key elements used to identify the original 
transaction that is being referred to.  
 
-Only applicable for DebiCheck Collections.  
interbankSettlementDate  0..1 C ISODate  Date on which the mandate suspension is 
reported, i.e. date on which the post financial 
transaction was settled.  
 
-Only applicable for DebiCheck Collections.  
requestedCollectionDate  0..1  ISODate  Original date on which the creditor requested 
that the amount of money was to be collected 
from the debtor. Please note the transaction 
may have settled in tracking later.  
 
-Only applicable for DebiCheck Collections.  
mandateId  0..1 C Text: 
Maximum 
length = 35  Unique identification, as assigned by the debtor 
bank, to unambiguously identify the mandate.  
 
-Only applicable for DebiCheck Collections.  

 
 19 
 3. Code Definition Tables  
3.1 HTTP Response Status Codes  
The below table details the HTTP response status codes sent from the API . 
 
Code  Name  Description  
200 Accepted  -Request validated successfully and Instruction ID is 
returned . 
-Retrieve report returned successfully using the 
Instruction ID . 
204 No Content  Request has been received and is still being 
validated and processed in the RMB  systems . 
400 Bad request  Request sent has failed technical validation . 
401 Unauthorised Error  Access token has expired, and a new Access token 
is required . 
403 Forbidden Error  The client is not authorised for the specific service . 
404 Not found  Resource being called cannot be found at the given 
endpoint . 
429 Too Many Requests Error  Too many requests have been sent . 
500 Internal Server Error  The server encountered an unexpected condition 
that prevented it from fulfilling the request.  
503 Service Unavailable  API service is unavailable . 
 
3.2 Collection Transaction Status Code  
The below table details the status of the individual transactions and group status codes of the bulk file . 
 
Code  Name  Definition  
ACSC  AcceptedSettlementComplete  Transaction Level: The transaction has been 
successfully processed by Integration 
Channel.  If the credit was to a RMB  
member, the transaction will have been 
settled. If the transaction was to another 
bank, the transaction will have been 
aggregated for clearing at financial day end.  
ACSP  AcceptedSettlementInProgress  Transaction Level: The transaction has been 
successfully warehoused by Integration 
Channel.  
ACWC  AcceptedWithChange  Transaction Level: The transaction has been 
successfully processed by Integration 
Channel but has been changed in some way 
e.g., the execution date has been auto 
bumped by one business day.  
PDNG  Pending  Direct Debit initiation or individual 
transaction included in the Direct Debit 

 
 20 
 Code  Name  Definition  
initiation is pending. Further checks and 
status update will be performed.  
PART  PartiallyAccepted  A number of transactions have been 
accepted, whereas another number of 
transactions have not yet achieved 
'accepted' status or have been rejected.  
RJCT  Rejected  Direct Debit initiation or individual 
transaction included in the Direct Debit 
initiation has been rejected.  
 
3.3 Account Types  
 
The below table details the account type codes as defined in the ISO codes list and the proprietary 
codes created within RMB . 
 
Code  Description  
CACC  Cash Account  
LOAN  Loan Account  
SVGS  Savings Account  
TRAN  Transmission Account  
SBSH  Subscription Share  
 
3.4 Service Level Codes  
 
The below table details the service types for when the collection will clear and settle . 
 
Code  Description  Processing Explanation  
SDVA  Same Day Value  Settlement happens on the same day, given that the 
instruction was sent before cut -off times. Debit is 
immediate (real -time). RMB  credits also reflect 
immediately. Non -RMB  credits will happen during end -
of-day batch processing and reflect by the next 
morning.  
TWOD  Two Day  The instruction must be sent to the bank for processing 
two days prior to the execution date. Settlement is 
processed in the end -of-day batch of the execution 
date.  
 
 
 
 
 
 

 
 21 
 3.5 Sequence Type  
 
Code  Name  Description  
RCUR  Recurring  Direct debit instruction where the debtor's authori sation 
is used for regular direct debit transactions initiated by 
the creditor.  
OOFF  OnceOff  Direct debit instruction where the debtor's authori sation 
is used to initiate one single direct debit transaction.  
 
3.6 Entry Class  
 
Entry Class Code  Entry Class Description  
0021  Insurance Premium  
0022  Pension Fund Contribution  
0023  Medical Aid Fund Contribution  
0026  Unit Trust Purchase  
0028  Charitable or Religious Contribution  
0031  H.P. Repayment  
0032  Account Repayment  
0033  Loan Repayment (Other than mortgage )  
0034  Rental -Lease (Other than property)  
0035  Service Charge (Maintenance of Service Agreements, etc .)  
0036  Service Charge (Variable Amounts)  
0037  Value Added Tax (VAT Collection)  
0041  Rent (Property)  
0042  Bond Repayment  
0044  Bank Use - Debit Transfer  
0046  Bank Use - Cheque Card Debits  
 
3.7 Tracking Codes  
 
Tracking Codes  Tracking Description  
00  No tracking  
01  1 Day Tracking  
02  2 Day Tracking  
03  3 Day Tracking  
04  4 Day Tracking  
05  5 Day Tracking  
06  6 Day Tracking  

 
 22 
 07  7 Day Tracking  
08  8 Day Tracking  
09  9 Day Tracking  
10  10 Day Tracking  
 
3.8 Permitted Character Set 
 
The below table details the character sets that are applicable in the request . 
 
Character  Description  
“A” – “Z” 29 capital characters of the Latin alphabet (Uppercase)  
“a” – “z” 29 capital characters of the Latin alphabet (Lowercase)  
“0” – “9” 10 numeric characters  
“.” Period  
“-” Hyphen  
“*” Asterisk  
“,” Comma  
“(“ Left parenthesis  
“)” Right parenthesis  
“%” Percentage  
“+” Plus 
“$” Dollar  
“;” Semi -colon  
“=” Equal  
“@” At 
“?” Question mark  
“:” Colon  
“ “ Space  
“!” Exclamation mark  
“ Quotes  
“#” Hash  
“&” Ampersand  
‘  Quote  
“/“ Slash  
“<“ Less than  
“>”  Greater than  
“[“   Square bracket (left)  
“\” Back slash  
“]”   Square bracket (right)  
“^” Circumflex  
“_” Underscore  
 
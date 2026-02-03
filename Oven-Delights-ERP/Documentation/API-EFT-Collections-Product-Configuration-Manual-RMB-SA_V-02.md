# API-EFT-Collections-Product-Configuration-Manual-RMB-SA_V-02

 
 
  1 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 APPLICATION 
PROGRAMMING 
INTERFACE (API)  
EFT COLLECTION S 
PRODUCT 
CONFIGURATION  
MANUAL  
 
SOUTH AFRICA  
 
 
 
a division of FirstRand Bank Limited, is an Authorised Financial Services and Credit Provider NCRCP20.  

 
 
  2 
 EFT DOMESTIC COLLECTIONS API  
 
 
 
CHANNEL FEATURES  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ✓ Auto-Bump  
✓ Partial Processing  
✓ Submit and Release/Straight -
through processing  
✓ Itemised and Consolidated 
processing  
✓ Proof of Collections  
✓ Unpaids  WHAT CAN APIs DO?  
This service allows the client to:  
• Connect to the API on their own behalf.  
• Connect to the API through a Third -Party.  
• Provide the bank with a Collection 
instruction to make an EFT Collection to a 
beneficiary.  
• Provide the bank with a Collection 
instruction to make an EFT Collection 
from one of your accounts to another 
account.  
• Send a request to the bank to retrieve the 
status of their instruction.  
API SCOPE  
The API is currently available to certain customer 
groups, countries and covers a specific list of 
product accounts.  
This API is available for business, commercial, 
corporate and investment customers in South Africa  HOW TO GET THE API  
The client will need to be an Online Banking 
Enterprise ™ user or complete the platform 
registration.  
 
There are a few ways in which the client can get 
and connect to the API.  
 
✓ Unassisted : With unassisted, you can 
subscribe for the EFT Collection API on 
Integration Channel, which is found under 
Business Solutions tab on Online Banking 
Enterprise ™. 
 
✓ Assisted : The client can contact their 
Digital Profile Manager, Transactional 
Portfolio Manager,  or Implementation 
Manager for assistance.  DESCRIPTION  
 
This document provides channel guidelines 
specific to processing of Electronic Funds 
Transfer (EFT) Collections on APIs.  
This document details the transports available,  
message formats and channel features available 
for EFT on Integration Channel.  
 
This document further outlines what the API can 
do, what products are supported and how to 
connect to and use the API.  
 

 
 
  3 
 HOW TO CONNECT TO THE API  
 
The client will connect and consume the API in two 
ways:  
 
1. On my own behalf  
 
The client can connect to the API directly from their 
line of business system. This can be achieved 
without a technology intermediary or third -party 
(System Operator or technology partner).   
 
In both unassisted and assisted journeys, the client 
can maintain their connection details to their line of 
business system.  
 
2. Through a Third -Party  
 
The client can delegate the API processing and 
connection responsibility to an intermediary or 
Third -Party (System Operator or technology 
partner).   
 
With this connection type, the client will be required 
to provide the bank with consent to share their 
product account information with the Third -Party as 
well as indicate which accounts the Third -Party can 
retrieve information on.  
 
In both unassisted and assisted journeys, the client 
can maintain or revoke their consent for the Third -
Party to act on their behalf as well as the selection 
of the accounts.  
 HOW TO GET THE API 
 
SECURITY AND ACCESS CONTROL  
 
Our APIs are secured and protected. We require 
positive authentication, authorisation and access 
tokens to gain access to the API.  
 
• Authentication  
 
API client authentication use JWT signed tokens. 
Authentication will be done through the use of a 
client ID and client secret that will serve as 
credentials to positively identify the client. The 
credentials are provided through the subscribe 
process on th e Integration Channel.  
 
• Authorisation  
 
Authorisation is achieved through the OAuth 2.0 
standard using the authorisation code flow. The 
authorisation code flow includes using an Auth 
Code to receive an access token to initiate the 
process to make calls. When connecting through 
a Third -Party, the authorisation ca n be done in 
two ways:  
✓ Auth Code:  The client receives the Auth 
Code when subscribing to the service on 
Integration Channel and share the Auth 
Code securely with the Third -Party to 
connect to the API.  
 
✓ OAuth 2.0:   The Third -Party provides 
their redirect URL when subscribing to the 
service and the client will be redirected to 
the Third -Party’s website when they 
complete the subscription and choosing 
to connect through a Third -Party.  
 

 
 
  4 
 Integration Channel Cut -off times  
 RMB to RMB  RMB  to Non RMB  
Same Day Service Type (SDV)  
Monday to Friday  20:00  16:45  
Saturday  20:00  10:15  
2 Day Service Type 
Monday to Friday  16:45  16:45  
Saturday  10:15  10:15  CUT-OFF TIMES  • Access Token  
 
This is treated as a subset of authorisation.  
 
Access tokens can be obtained through the OAuth 2.0 
token endpoint by either presenting the authorisation code 
or a refresh token. An access token is used each time a 
call is made and has a set life span, once expired the 
refresh token can be used to reque st a new access token. 
In the instance where the refresh token expires, the client 
will need to request for a new access and refresh token by 
initiating the subscribe process again.  
 
 

 
 
  5 
 WHAT FORMAT IS THE 
API IN?  
EFT Collection API uses OpenAPI 
Specification (OAS) standard.  
OpenAPI  Specification (OAS) is an 
industry standard, programming 
language -agnostic specification standard 
for RESTful APIs. OAS allows easy 
access to discover and understand the 
API without having access to the source 
code, documentation or implementation 
logic. OAS is also widely known as the 
Swagger Document.  
APPENDIX  
Below is the referenced information which 
should be read in conjunction with this 
document. The information can also be 
retrieved on Integration Channel, EFT 
Collections catalogue card under the API 
subtab:  
• EFT Collection API Message 
Specification  
• Collections Execution Swagger 
Document  
 API REFERENCE  
 
The EFT Collections API follows the 
ISO20022  message standard in JSON 
Format, using the  Pain.008 for the Request 
and Pain.002 for the response.  
 
The API is enabled through the below 
methods:  
 
✓ POST - CollectionExecution  
  
Create Direct Debit initiation instruction:  
Allows the client to instruct the Bank to 
collect funds from their debtor to credit their 
account.  
 
✓ GET – retrieveCollectionReport  
 
Retrieve Collection execution result:  
Allows the client to retrieve the status reports 
of the Collection instruction using a unique 
identifier – Instruction ID.  
 
✓ POST – retrieveUnpaidsReport  
 
Retrieve unpaids report:  
Allows you to retrieve a report of all 
transactions returned as unpaid.  
 
Our APIs use polling method, which allows 
the client to query the API at regular intervals 
to check for new data.  

 
 
  6 
  PROCESS FLOWS  


 
 
  7 
 : 

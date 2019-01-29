<#
---------------------------------------------
PowerShell script to get expiring AD accounts
  
File		: Get_users_expiring.PS1
Author		: Moubai
Date		: 29-01-2019
Version		: 1.0

 Revision history:
-----------------
1.0 Initial version
---------------------------------------------
#>

# -----------------------
# Import required modules
# -----------------------
Import-Module ActiveDirectory

# ----------------
# Define variables
# ----------------

$To = "myemail@domain.local"
$From = "HR@domain.local"
$Subject = "Users that will expire"
$Body = "This CSV file contains all account that will expire in the next 30 days"
$SMTPServer = "smtp.domain.local"

$SearchBase = "OU=Users, OU=Management, DC=domain, DC=local"
$DateExpiration = (Get-Date).AddDays(30)
$Date = Get-Date -format yyyyMMdd
$ReportName = "c:\temp\Domain_Local_Expiring_Users_$Date.csv"


# ------------------------------------------------------------------
# Get list of users from Active Directory that will expire in 30 days
# ------------------------------------------------------------------

$UserList = get-aduser -filter {Enabled -eq $true -and AccountExpirationDate -lt $DateExpiration} -properties AccountExpirationDate,Givenname,Surname,Name,mail -SearchBase $SearchBase

# -----------------------------------------------
# Send an email using the variables defined above
# -----------------------------------------------

if ($null -eq $UserList){}
Else{
    $UserList | Select-Object @{Label ="Full Name";Expression = {$_.Name}},
    @{Label = "FirstName";Expression = {$_.GivenName}},
    @{Label = "Name";Expression = {$_.Surname}},
    @{Label = "Email";Expression = {$_.Mail}},
    @{Label ="Expiration Date";Expression ={$_.AccountExpirationDate}} |
    Export-Csv $ReportName -NoTypeInformation -Encoding UTF8
    Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SMTPServer $SMTPServer -Attachments $ReportName
}

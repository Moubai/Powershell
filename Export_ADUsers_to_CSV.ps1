
#Export Folder
$path = Split-Path -parent "D:\powershell\ExportADUsers\*.*"

#Create a variable for the date stamp in the log file

$LogDate = get-date -f yyyyMMddhhmm

#Define CSV and log file location variables
#they have to be on the same location as the script

$csvfile = $path + "\ADUsersHUM_$logDate.csv"

#import the ActiveDirectory Module

Import-Module ActiveDirectory

#Sets the OU to do the base search for all user accounts, change as required.

$SearchBase = "OU=Users, OU=Management, DC=mydomain, DC=local"

$AllADUsers = Get-ADUser ` -searchbase $SearchBase ` -Filter * -Properties * | Where-Object {$_.enabled -eq $true} #ensures that updated users are never exported.

$AllADUsers |
Select-Object @{Label = "First Name";Expression = {$_.GivenName}},
@{Label = "Last Name";Expression = {$_.Surname}},
@{Label = "Email";Expression = {$_.Mail}},
@{Label ="NISS";Expression ={$_.extensionAttribute8}} | 

#Export CSV report

Export-Csv -Path $csvfile -Encoding UTF8 -NoTypeInformation

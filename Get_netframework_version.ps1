<#
Author : Moubai
Usage : Getting version of .net framework 4 of Server
Creation Date : 11-04-2019
#>
$Cred = Get-Credential

$ServerList = Get-Content -Path "D:\powershell\ServerList.txt"

foreach($Server in $ServerList){
    $RegKey = Invoke-Command -ComputerName $Server -Credential $Cred -ScriptBlock {Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'}
    $Version = $RegKey.Version
    Write-Host "Serveur $Server, version netframework : $Version"
    Write-Output "$Server,$Version" | Out-File "D:\powershell\NetFramework_IIS.txt" -Append
}

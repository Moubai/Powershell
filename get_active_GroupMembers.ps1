import-module activedirectory
$user = ""
$groupname = Read-Host 'Quel est le nom du groupe ?'
$ListeUsers = Get-ADGroupMember -Identity $groupname | Select SamAccountName | Sort-Object SamAccountName | Write-Output
foreach($User in $ListeUsers){
    $utilisateur = $user.SamAccountName
    Get-ADUser -identity $utilisateur -Properties SamAccountName,Enabled | Where-Object Enabled -eq $true | select SamAccountName,Enabled

}

import-module activedirectory
$groupname = Read-Host 'Quel est le nom du groupe à nettoyer des comptes inactifs ?'
$Members = Get-ADGroupMember -Identity $groupname | Select-Object SamAccountName

foreach($utilisateur in $Members){
	Write-debug $utilisateur.SamAccountName
	$user = Get-ADUser -Identity $utilisateur.SamAccountName -Properties SamAccountName,Enabled
	if($user.Enabled -eq $false){
		$username = $user.SamAccountName
		Remove-ADGroupMember $groupname -member $user.SamAccountName 
		Write-Host "utilisateurs retire: $username" -ForegroundColor Green
	}
}

$contentAccessAccount

$contentAccessAcctPrincipal = New-SPClaimsPrincipal -Identity $contentAccessAccount -IdentityType WindowsSamAccountName
Grant-SPObjectSecurity $profileServiceAppSecurity -Principal $contentAccessAcctPrincipal -Rights "Retrieve People Data for Search Crawlers"



foreach ($contentAccessAcct in $contentAccessAccounts)
{
    # Give 'Retrieve People Data for Search Crawlers' permissions to the Content Access claims principal
    Write-Host -ForegroundColor White "  - $contentAccessAcct..."
    $contentAccessAcctPrincipal = New-SPClaimsPrincipal -Identity $contentAccessAcct -IdentityType WindowsSamAccountName
    Grant-SPObjectSecurity $profileServiceAppSecurity -Principal $contentAccessAcctPrincipal -Rights "Retrieve People Data for Search Crawlers"
}





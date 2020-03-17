
$WAurl = "https://content.sharepoint.dnbAD.nl"
$WA = Get-SPWebApplication -Identity $WAurl

$SPkaraatName = "dnbad.nl\nc9848s"
$SPkaraatClaim = "i:0#.w|" + dnbad.nl\nc9848s"
$SPkaraatDispl = "SharePoint Karaat Service" 
$SPkaraatPerm = "Full Read" 

#AutoSP Set-WebAppUserPolicy $wa $superReaderAcc "Super Reader (Object Cache)" "Full Read"

Set-WebAppUserPolicy $WA $SPkaraatClaim $SPkaraatDispl $SPkaraatPerm



Import-Module SPkaraat-Functions.psm1

Function Set-WebAppUserPolicy ($wa, $userName, $displayName, $perm)
{
    Try
    {
    [Microsoft.SharePoint.Administration.SPPolicyCollection]$policies = $wa.Policies
    [Microsoft.SharePoint.Administration.SPPolicy]$policy = $policies.Add($userName, $displayName)
    [Microsoft.SharePoint.Administration.SPPolicyRole]$policyRole = $wa.PolicyRoles | Where-Object {$_.Name -eq $perm}
    If ($policyRole -ne $null)
        {
        $policy.PolicyRoleBindings.Add($policyRole)
        }
    $wa.Update()
    }
    Catch
    {
        $_
        Write-Warning "An error occurred applying WebAppUserPolicy "$displayName"
        Pause "exit"
    }
}



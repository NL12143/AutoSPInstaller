
Import-Module SPkaraat-Functions.psm1

Function Set-WebAppUserPolicy ($wa, $userName, $displayName, $perm)
#Example Set-WebAppUserPolicy $WA $SPkaraatClaim $SPkaraatDispl $SPkaraatPerm
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

Function Set-WebAppUserPolicy ($wa, $userName, $displayName, $perm)
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

$domain = "dnbAD.nl" #  | "dnbAD.nl" | "dnbA.nl" | "dnb.nl"
$wa = "https://content.sharepoint.$domain" 

#A
$displayName = "SP Karaat Service" 
$userName = "i:0#.w|" "$domain\nc9848s"
$perm = "Full Read" 
Set-WebAppUserPolicy $wa $userName $displName $perm

#B
$spKaraatName = "$domain\nc9848s"
$spKaraatClaim "i:0#.w|" $spKaraatName
$spKaraatDisp = "SP Karaat Service"
$spKaraatPerm = "Full Read" 
Set-WebAppUserPolicy $wa $spKaraatClaim $spKaraatDisp $spKaraatPerm


<######################
[Microsoft.SharePoint.Administration.SPPolicyRoleType], 
Such as: FullControl, FullRead, DenyAll	DenyWrite FullControl FullRead

$Policy.PolicyRoleBindings.Add($FullControl)
PolicyRoleBindings
[Microsoft.SharePoint.Administration.SPPolicyCollection]$policies = $wa.Policies
[Microsoft.SharePoint.Administration.SPPolicy]$policy = $policies.Add($userName, $displayName)
[Microsoft.SharePoint.Administration.SPPolicyRole]$policyRole = $wa.PolicyRoles | Where-Object {$_.Name -eq $perm}

$policyRole = $wa.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 

$policyRole = $wa.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 
$policy.PolicyRoleBindings.Add($policyRole)
$wa.Properties["portalsuperuseraccount"] = $sUser
$wa.Update()

Function Set-WebAppUserPolicy ($wa, $userName, $displayName, $perm)
#$perm = 
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

# Func: ConfigureObjectCache
# Desc: Applies the portal super accounts to the object cache for a web application
Function ConfigureObjectCache([System.Xml.XmlElement]$webApp)
{
    Try
    {
        $url = ($webApp.Url).TrimEnd("/") + ":" + $webApp.Port
        $wa = Get-SPWebApplication -Identity $url
        $superUserAcc = $xmlInput.Configuration.Farm.ObjectCacheAccounts.SuperUser
        $superReaderAcc = $xmlInput.Configuration.Farm.ObjectCacheAccounts.SuperReader
        # If the web app is using Claims auth, change the user accounts to the proper syntax
        If ($wa.UseClaimsAuthentication -eq $true)
        {
            $superUserAcc = 'i:0#.w|' + $superUserAcc
            $superReaderAcc = 'i:0#.w|' + $superReaderAcc
        }
        Write-Host -ForegroundColor White " - Applying object cache accounts to `"$url`"..."

        $wa.Properties["portalsuperuseraccount"] = $superUserAcc
        Set-WebAppUserPolicy $wa $superUserAcc "Super User (Object Cache)" "Full Control"

        $wa.Properties["portalsuperreaderaccount"] = $superReaderAcc
        Set-WebAppUserPolicy $wa $superReaderAcc "Super Reader (Object Cache)" "Full Read"

        $wa.Update()
        Write-Host -ForegroundColor White " - Done applying object cache accounts to `"$url`""
    }
    Catch
    {
        $_
        Write-Warning "An error occurred applying object cache to `"$url`""
        Pause "exit"
    }
}
#>
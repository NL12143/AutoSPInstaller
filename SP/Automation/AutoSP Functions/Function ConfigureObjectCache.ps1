# Func: Set-WebAppUserPolicy
# AMW 1.7.2
# Desc: Set the web application user policy
# Refer to http://technet.microsoft.com/en-us/library/ff758656.aspx
# Updated based on Gary Lapointe example script to include Policy settings 18/10/2010
Function Set-WebAppUserPolicy ($wa, $userName, $displayName, $perm)
{
    [Microsoft.SharePoint.Administration.SPPolicyCollection]$policies = $wa.Policies
    [Microsoft.SharePoint.Administration.SPPolicy]$policy = $policies.Add($userName, $displayName)
    [Microsoft.SharePoint.Administration.SPPolicyRole]$policyRole = $wa.PolicyRoles | Where-Object {$_.Name -eq $perm}
    If ($policyRole -ne $null)
    {
        Write-Host -ForegroundColor White " - Granting $userName $perm to $($wa.Url)..."
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

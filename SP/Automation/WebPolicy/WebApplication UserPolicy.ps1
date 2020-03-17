How to Create Web Application Policy in SharePoint using PowerShell?
This PowerShell script adds new user policy to web application.
https://www.sharepointdiary.com/2013/04/powershell-to-add-web-application-user-policy.html#ixzz6GOYkkySq1

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Variables
$domain = "dnbAD"
$WebAppURL = "http://sharepoint.crescent.com"
$WebAppURL = "http://content.sharepoint.$domain.nl"

$UserID = "$domain\NC9848S"     # $UserID = "Global\EricConnell"
$UserDN = "SP Karaat Service"   # $UserDisplayName = "Global CIO"
$Control =  
#Get the Web Application
$WebApp = Get-spWebApplication $WebAppURL
 
#Convert the UserID to Claims - If your Web App is claims based!!!
if($WebApp.UseClaimsAuthentication)
{ 
 $UserAccount = (New-SPClaimsPrincipal -identity $UserID -identitytype 1).ToEncodedString()
}
If ($wa.UseClaimsAuthentication -eq $true)
{
    $superUserAcc = 'i:0#.w|' + $superUserAcc
    $superReaderAcc = 'i:0#.w|' + $superReaderAcc
}

#Create FULL Access Web Application User Policy
$ZonePolicies = $WebApp.ZonePolicies("Default")
 
#Add sharepoint web application user policy with powershell
$Policy = $ZonePolicies.Add($UserAccount,$UserDN)
$FullControl=$WebApp.PolicyRoles.GetSpecialRole("FullControl")
$Policy.PolicyRoleBindings.Add($FullControl)
$WebApp.Update()
 
Write-Host "Web Application Policy for $($UserDN) has been Granted!"

$Policy.PolicyRoleBindings.Add($FullControl)
PolicyRoleBindings
[Microsoft.SharePoint.Administration.SPPolicyCollection]$policies = $wa.Policies
[Microsoft.SharePoint.Administration.SPPolicy]$policy = $policies.Add($userName, $displayName)
[Microsoft.SharePoint.Administration.SPPolicyRole]$policyRole = $wa.PolicyRoles | Where-Object {$_.Name -eq $perm}

<#
GetSpecialRole() function in SharePoint can take enumerations from : 
[Microsoft.SharePoint.Administration.SPPolicyRoleType], 
Such as: FullControl, FullRead, DenyAll	DenyWrite FullControl FullRead
Here is my another article which adds Full Read and Full control web application user policies using Central Administration site and PowerShell: PowerShell to Add web application user policy in SharePoint
https://www.sharepointdiary.com/2013/04/powershell-to-add-web-application-user-policy.html#ixzz6GOYkkySq
#>
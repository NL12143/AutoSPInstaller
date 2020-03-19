https://www.sharepointdiary.com/2016/09/powershell-to-add-administrator-grant-permission-to-service-application.html

Grant-SPObjectSecurity $ServiceAppSecurity -Principal $UserPrincipal -Rights $AccessRights
Set-SPServiceApplicationSecurity $ServiceApp $ServiceAppSecurity -Admin

PowerShell to Add Service Application Administrator 

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Configuration Variables
$ServiceAppName="Managed Metadata Service Application"
$UserAccount="Crescent\Salaudeen"
$AccessRights = "Full Control"
 
#Get the service application
$ServiceApp = Get-SPServiceApplication -Name $ServiceAppName

#Convert user account to claims
$UserPrincipal = New-SPClaimsPrincipal -Identity $UserAccount -IdentityType WindowsSamAccountName
 
#Get the Service Application Security collection
$ServiceAppSecurity = Get-SPServiceApplicationSecurity $ServiceApp -Admin

#Add user & rights to the collection
Grant-SPObjectSecurity $ServiceAppSecurity -Principal $UserPrincipal -Rights $AccessRights
 
#Apply the Security changes
Set-SPServiceApplicationSecurity $ServiceApp $ServiceAppSecurity -Admin

<#
Get-SPServiceApplication
Get-SPServiceApplication -Name $ServiceAppName
#>
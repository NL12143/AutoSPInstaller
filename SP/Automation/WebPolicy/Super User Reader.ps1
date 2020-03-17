Configure SharePoint 2013 Object Cache Super User, Super Reader Accounts
https://www.sharepointdiary.com/2014/12/configure-sharepoint-2013-object-cache-superuser-superreader-accounts.html#ixzz6GOd6n8Sj

#Region Create user accounts in AD
#Step 1: Create user accounts for "Portal Super Reader" and "Portal Super User" in your active directory
Go to your active directory, create two user accounts. 
In my case, I've created these accounts in my domain: "Crescent" as:
SPS_SuperUser
SPS_SuperReader
I've used the below PowerShell script to create these accounts in  Active directory:

Import-Module ActiveDirectory -ErrorAction SilentlyContinue
  
#Set configurations
$AccountPassword = "Password1"
#Convert to Secure string
$Password = ConvertTo-SecureString -AsPlainText $AccountPassword -Force
  
$Domain = "YourDomain.com"
#Specify the OU
$AccountPath= "ou=SharePoint,DC=YourDomain,DC=com"
  
#Create Super Reader Account
$Account="SPS_SuperReader"
New-ADUser -SamAccountName $Account -name $Account -UserPrincipalName $Account@$domain -Accountpassword $Password -Enabled $true -PasswordNeverExpires $true -path $AccountPath -OtherAttributes @{Description="SharePoint 2013 Super Reader Account for object cache."}
 
#Create Super User Account 
$Account="SPS_SuperUser"
New-ADUser -SamAccountName $Account -name $Account -UserPrincipalName $Account@$domain -Accountpassword $Password -Enabled $true -PasswordNeverExpires $true -path $AccountPath -OtherAttributes @{Description="SharePoint 2013 Super User Account for object cache."}

#EndRegion 

#Region Grant-UserPolicy
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue 
Function Grant-UserPolicy($UserID, $WebAppURL, $Role)
{
    #Get the Web Application
    $WebApp = Get-SPWebApplication $WebAppURL
  
    #Convert UserID to Claims - If Web App is claims based! Domain\SPS_SuperReader to i:0#.w|Domain\SPS_SuperReader
    if($WebApp.UseClaimsAuthentication)
    {
        $UserAccount = (New-SPClaimsPrincipal -identity $UserID -identitytype 1).ToEncodedString()
    }
  
    #Crate FULL Access Web Application User Policy
    $ZonePolicies = $WebApp.ZonePolicies("Default")
    #Add sharepoint 2013 web application user policy with powershell
    $Policy = $ZonePolicies.Add($UserAccount ,$UserAccount)
    #Policy Role such as "FullControl", "FullRead"
    $PolicyRole =$WebApp.PolicyRoles.GetSpecialRole($Role)
    $Policy.PolicyRoleBindings.Add($PolicyRole)
    $WebApp.Update()
  
    Write-Host "Web Application Policy for $($UserID) has been Granted!"
}
 
#Get all Web Applications
$WebAppsColl = Get-SPWebApplication
ForEach ($webApp in $WebAppsColl)
{
    #Call function to grant web application user policy
    Grant-UserPolicy "Crescent\SPS_SuperReader" $webapp.URL "FullRead"
    Grant-UserPolicy "Crescent\SPS_SuperUser"   $webapp.URL "FullControl"
}
#EndRegion

#https://www.sharepointdiary.com/2014/12/configure-sharepoint-2013-object-cache-superuser-superreader-accounts.html#ixzz6GOa29bkp

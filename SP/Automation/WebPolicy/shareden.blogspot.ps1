
    $account = "i:0#.w|" + $sOrigUser
    $superUserAcc = 'i:0#.w|' + $superUserAcc
  
https://shareden.blogspot.com/2016/10/add-super-user-and-super-reader-via.html

$sUser = "i:0#.w|" + $sOrigUser
$sRead = "i:0#.w|" + $sOrigRead

   $policy = $app.Policies.Add($sUser, $sUserName)
   $policyRole = $app.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 
   $policy.PolicyRoleBindings.Add($policyRole)
   $app.Properties["portalsuperuseraccount"] = $sUser
   $app.Update()

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

#SUPER USER ACCOUNT – Use your own Account (NB: NOT A SHAREPOINT ADMIN)
$sOrigUser= "domain\SP_SuperUser"
$sUserName = "SP_SuperUser"

#SUPER READER ACCOUNT – Use your own Account (NB: NOT A SHAREPOINT ADMIN)
$sOrigRead = "domain\SP_SuperRead"
$sReadName = "SP_SuperRead"

$apps = get-spwebapplication 
foreach ($app in $apps) {
   #DISPLAY THE URL IT IS BUSY WITH
   $app.Url
   if ($app.UseClaimsAuthentication -eq $true)
   {
    # IF CLAIMS THEN SET THE IDENTIFIER
    $sUser = "I:0#.w|" + $sOrigUser
    $sRead = "I:0#.w|" + $sOrigRead
   }
   else
   {
   # CLASSIC AUTH USED
     $sUser = $sOrigUser
     $sRead = $sOrigRead
   }
   
   # ADD THE SUPER USER ACC – FULL CONTROL (Required for writing the Cache)
   $policy = $app.Policies.Add($sUser, $sUserName)
   $policyRole = $app.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 
   $policy.PolicyRoleBindings.Add($policyRole)
   $app.Properties["portalsuperuseraccount"] = $sUser
   $app.Update()

   # ADD THE SUPER READER ACC – READ ONLY
   $policy = $app.Policies.Add($sRead, $sReadName)
   $policyRole = $app.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullRead) 
   $policy.PolicyRoleBindings.Add($policyRole)
   $app.Properties["portalsuperreaderaccount"] = $sRead
   $app.Update()
 }

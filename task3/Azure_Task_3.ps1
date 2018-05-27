param(
    [string] $Profile
)
if ($Profile) {
    Import-AzureRmContext -Path $Profile -ErrorAction SilentlyContinue
    $subs= Get-AzureRmSubscription -ErrorAction SilentlyContinue
if($subs){
    Write-Host "Your have already saved your profile. Enjoy your life :)"
}
else {
    Login-AzureRmAccount
    Save-AzureRmProfile -Path $profile -ErrorAction SilentlyContinue
    Write-Host "Hey, your Azure profile has been saved"
}
}
else {
    Login-AzureRmAccount
    Save-AzureRmProfile -Path $profile  -ErrorAction SilentlyContinue
    Write-Host "Hey, your Azure profile has been saved"
}


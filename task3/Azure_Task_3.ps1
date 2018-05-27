param(
    [string] $Profile
)
if ($Profile) {
    Import-AzureRmContext -Path $Profile
    Write-Host "Your have already saved your profile. Enjoy your life :)"
}
else {
    Login-AzureRmAccount
    Save-AzureRmProfile -Path $profile
    Write-Host "Hey, the your Azure profile has been saved"
}#for use this credentila to login
Get-AzureRmResourceGroup


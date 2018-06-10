 Login-AzureRmAccount
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string] $resourcegroup,
    [Parameter(Mandatory = $true)]
    [string]$location,
    [Parameter(Mandatory = $true)]
    [string]$storageaccunt,
    [Parameter(Mandatory = $true)]
    [string]$container,
    [Parameter(Mandatory = $true)]
    [string]$source
)
New-AzureRmResourceGroup -Name $resourcegroup -Location $location
New-AzureRmStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccunt -Location $location -Kind Storage -SkuName Standard_LRS
Set-AzureRmCurrentStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccunt
New-AzureStorageContainer -Name $container -Permission Blob
Get-ChildItem -File -Recurse $source | Set-AzureStorageBlobContent -Container $container

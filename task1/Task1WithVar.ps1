Login-AzureRmAccount
$resourcegroup = "JARG"
$location = "westeurope"
$storageaccunt = "jastorage007"
$container = "jacontainer007"
$source = "C:\Users\ja\Desktop\Azure\JA_TASK"
###
New-AzureRmResourceGroup -Name $resourcegroup -Location $location
New-AzureRmStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccunt -Location $location -Kind Storage -SkuName Standard_LRS
Set-AzureRmCurrentStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccunt
New-AzureStorageContainer -Name $container -Permission Blob
Get-ChildItem -File -Recurse $source | Set-AzureStorageBlobContent -Container $container

#Remove-AzureRmResourceGroup -Name $resourcegroup -Force 
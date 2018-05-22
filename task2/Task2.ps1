$resourcegroup = "JASQL"
$location = "westus"
$storageaccount = "janewstorage007"
$container = "sql"
$mainserver = "jaserver001"
$backupserver = "jaserver002"
$adminlogin = "jaadmin"
$password = "Password123!"   
$startip = "0.0.0.0"  
$endip = "255.255.255.255"
Login-AzureRmAccount
New-AzureRmResourceGroup -Name $resourcegroup -Location $location
New-AzureRmStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccount -SkuName Standard_LRS -Location $location
Set-AzureRmCurrentStorageAccount -ResourceGroupName $resourcegroup -Name $storageaccount
New-AzureStorageContainer -Name $container -Permission Blob
#servers
New-AzureRmSqlServer -ResourceGroupName $resourcegroup `
    -ServerName $mainserver `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
        -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

New-AzureRmSqlServer -ResourceGroupName $resourcegroup `
    -ServerName $backupserver `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
        -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

#firewall
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroup `
    -ServerName $mainserver `
    -FirewallRuleName "AllowAll" -StartIpAddress $startip -EndIpAddress $endip

New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroup `
    -ServerName $backupserver `
    -FirewallRuleName "AllowAll" -StartIpAddress $startip -EndIpAddress $endip

#db
foreach ($i in $database) {
    New-AzureRmSqlDatabase -ResourceGroupName $resourcegroup `
        -ServerName $mainserver `
        -DatabaseName $i `
        -SampleName "AdventureWorksLT" `
        -RequestedServiceObjectiveName "S0"
}
#Export
$key = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourcegroup -Name $storageaccount).Value[0]
foreach ($i in $database) {
    $uri = "https://$storageaccount.blob.core.windows.net/$container/$i.bacpac"
    New-AzureRmSqlDatabaseExport -ResourceGroupName $resourcegroup -ServerName $mainserver `
        -DatabaseName $i -StorageKeyType "StorageAccessKey" -StorageKey $key `
        -StorageUri $uri `
        -AdministratorLogin $adminlogin -AdministratorLoginPassword (ConvertTo-SecureString -String $password -AsPlainText -Force)
}

#Import
do {
    Start-Sleep -Seconds 5
    $backfile = Get-AzureStorageBlob -Container $container -Blob "testdb3.bacpac" -ErrorAction SilentlyContinue
}
until($backfile)

Write-Host "Start Importing from backup"

foreach ($i in $database) {
    $uri = "https://$storageaccount.blob.core.windows.net/$container/$i.bacpac"
    New-AzureRmSqlDatabaseImport -ResourceGroupName $resourcegroup `
        -ServerName $backupserver `
        -DatabaseName $i `
        -DatabaseMaxSizeBytes "262144000" `
        -StorageKeyType "StorageAccessKey" `
        -StorageKey $key `
        -StorageUri $uri `
        -Edition "Standard" `
        -ServiceObjectiveName "S0" `
        -AdministratorLogin "$adminlogin" `
        -AdministratorLoginPassword $(ConvertTo-SecureString -String "$password" -AsPlainText -Force) `
        -ErrorAction SilentlyContinue
}
# Remove-AzureRmResourceGroup -Name JASQL

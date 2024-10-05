# deploy infrastructure via bicep
param (
    [string]$resourceGroupName = "rg-vm-sql",
    [string]$location = "eastus2",
    [string]$adminUsername = "vmadmin",
    [string]$adminPassword = "P@ssw0rd1234",
    [string]$databaseUsername = "dbadmin",
    [string]$databasePassword = "P@sSw0rd1234"
)

$deploymentName = "infra-deployment"
az group create --name $resourceGroupName `
    --location $location

az deployment group create --name $deploymentName `
    --resource-group $resourceGroupName `
    --template-file main.bicep `
    --parameters adminUsername=$adminUsername `
    --parameters adminPassword=$adminPassword `
    --parameters databaseUsername=$adminUsername `
    --parameters databasePassword=$adminPassword
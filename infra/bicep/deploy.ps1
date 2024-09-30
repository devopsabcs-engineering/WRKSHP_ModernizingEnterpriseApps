# deploy using the bicep file
param(
    [string]$resourceGroupName = "rg-bch-modernize-apps",
    [string]$location = "canadacentral",
    [string]$deploymentName = "bch-modernize-apps-deployment",
    [string]$templateFile = "main.bicep",
    [string]$sqlAdminPassword = "P@ssw0rd1"
)

# create the resource group
az group create --name $resourceGroupName --location $location

az deployment group create `
    --resource-group $resourceGroupName `
    --name $deploymentName `
    --template-file $templateFile `
    --parameters sqlAdminPassword=$sqlAdminPassword
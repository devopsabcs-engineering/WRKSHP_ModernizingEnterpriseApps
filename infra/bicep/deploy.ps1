# deploy using the bicep file
param(
    [string]$resourceGroupName = "rg-bch-modernize-apps",
    [string]$location = "canadacentral",
    [string]$deploymentName = "bch-modernize-apps-deployment",
    [string]$templateFile = "main.bicep"
)

# create the resource group
az group create --name $resourceGroupName --location $location

az deployment group create `
    --resource-group $resourceGroupName `
    --name $deploymentName `
    --template-file $templateFile
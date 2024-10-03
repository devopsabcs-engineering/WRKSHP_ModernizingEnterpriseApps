# deploy infrastructure via bicep
param (
    [string]$resourceGroupName = "rg-rnd-weather-appservice",
    [string]$location = "eastus2",
    [string]$baseName = "rndweather-api",
    [string]$imageName = "rndweatherapi"
)

$deploymentName = "infra-deployment"
az group create --name $resourceGroupName `
    --location $location

az deployment group create --name $deploymentName `
    --resource-group $resourceGroupName `
    --template-file main.bicep `
    --parameters baseName=$baseName `
    --parameters imageName=$imageName
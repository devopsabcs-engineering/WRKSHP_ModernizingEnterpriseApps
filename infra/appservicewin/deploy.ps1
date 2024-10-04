# deploy using the bicep file
param(
    [string]$resourceGroupName = "rg-bch-modernize-apps-win",
    [string]$location = "canadacentral",
    [string]$deploymentName = "bch-modernize-apps-deployment-win",
    [string]$templateFile = "mainv3.bicep",
    #[string]$sqlAdministratorLogin = "sqladmin",
    #[string]$sqlAdministratorLoginPassword = "P@ssw0rd!"
    [string]$login = "azureSqlDBAdmins", # change this to your Azure AD group name    
    [string]$sid = "1a01e160-ef04-42e7-b0de-d2dedacab317" # change this to your Azure AD group object id
)

# create the resource group
az group create --name $resourceGroupName --location $location

az deployment group create `
    --resource-group $resourceGroupName `
    --name $deploymentName `
    --template-file $templateFile `
    --parameters login=$login `
    --parameters sid=$sid

#$groupid = az ad group create --display-name $groupName --mail-nickname $groupName --query id --output tsv
#$groupid = az ad group show --group $login --query id --output tsv
$groupid = $sid
Write-Output "Group Id: $groupid"

# get the webapp name from the deployment
$webAppName = az deployment group show --resource-group $resourceGroupName --name $deploymentName --query properties.outputs.webAppName.value --output tsv
Write-Output "Web App Name: $webAppName"

$msiobjectid = az webapp identity show --resource-group $resourceGroupName --name $webAppName --query principalId --output tsv
Write-Output "MSI Object Id: $msiobjectid"

# add the MSI to the group
Write-Output "Adding MSI to the group"
az ad group member add --group $groupid --member-id $msiobjectid
Write-Output "MSI added to the group"
az ad group member list -g $groupid -o table
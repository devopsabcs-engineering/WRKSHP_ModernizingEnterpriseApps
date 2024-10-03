# deploy using the bicep file
param(
    [string]$resourceGroupName = "rg-bch-modernize-apps",
    [string]$location = "canadacentral",
    [string]$deploymentName = "bch-modernize-apps-deployment",
    [string]$templateFile = "main.bicep",
    [string]$groupName = "azureSqlDBAdmins"
)

# create the resource group
az group create --name $resourceGroupName --location $location

az deployment group create `
    --resource-group $resourceGroupName `
    --name $deploymentName `
    --template-file $templateFile

#$groupid = az ad group create --display-name $groupName --mail-nickname $groupName --query id --output tsv
$groupid = az ad group show --group $groupName --query id --output tsv
Write-Output $groupid

# get the webapp name from the deployment
$webAppName = az deployment group show --resource-group $resourceGroupName --name $deploymentName --query properties.outputs.webAppName.value --output tsv
Write-Output $webAppName

$msiobjectid = az webapp identity show --resource-group $resourceGroupName --name $webAppName --query principalId --output tsv
Write-Output $msiobjectid

# do the same for dev slot
$msiobjectidDev = az webapp identity show --resource-group $resourceGroupName --name $webAppName --slot dev --query principalId --output tsv
Write-Output $msiobjectidDev

# do the same for staging slot
$msiobjectidStaging = az webapp identity show --resource-group $resourceGroupName --name $webAppName --slot staging --query principalId --output tsv
Write-Output $msiobjectidStaging

# add the MSI to the group

az ad group member add --group $groupid --member-id $msiobjectid
az ad group member add --group $groupid --member-id $msiobjectidDev
az ad group member add --group $groupid --member-id $msiobjectidStaging
az ad group member list -g $groupid -o table

# # list the members of the group that are service principals
# az ad group member list --group $groupid --query "[?objectType=='ServicePrincipal']"
# az ad group member list --group $groupid --only-show-errors --query "[].{displayName:displayName,ObjectType:objectType}" -o table
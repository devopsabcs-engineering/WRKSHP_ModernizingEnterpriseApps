@description('Location of the resource. By default use resource group\'s location, unless the resource provider is not supported there.')
@metadata({ _parameterType: 'location' })
param location string = resourceGroup().location

@description('Name of the main resource to be created by this template.')
param websiteName string = 'app-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('Name of the app service plan.')
param appServicePlanName string = 'asp-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('Name of the SQL server.')
param sqlServerName string = 'sql-server-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('Name of the SQL database.')
param sqlDatabaseName string = 'SampleWebApplicationCore_db'

resource webSite 'Microsoft.Web/sites@2023-12-01' = {
  location: location
  name: websiteName
  tags: {
    'hidden-related:${appServicePlan.id}': 'empty'
  }
  kind: 'app'
  properties: {
    httpsOnly: true
    reserved: false
    serverFarmId: appServicePlan.id
    siteConfig: {
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  location: location
  name: appServicePlanName
  sku: {
    name: 'S1'
    tier: 'Standard'
    family: 'S'
    size: 'S1'
  }
  properties: {}
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  location: location
  name: sqlServerName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 10
  }
  location: location
  name: sqlDatabaseName
}

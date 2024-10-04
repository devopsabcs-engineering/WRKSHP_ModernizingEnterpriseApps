param location string = resourceGroup().location
param sqlServerName string = 'sql-server-samplewebapp-${uniqueString(resourceGroup().id)}'
param sqlDatabaseName string = 'SampleWebApplicationCore_db'
param websiteName string = 'samplewebapp-${uniqueString(resourceGroup().id)}'
param appServicePlanName string = 'samplewebapp-${uniqueString(resourceGroup().id)}'

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' = {
  name: sqlServerName
  location: location
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  properties: {
    //collation: 'collation'
    edition: 'Basic'
    //maxSizeBytes: 'maxSizeBytes'
    requestedServiceObjectiveName: 'Basic'
  }
}

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: websiteName
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

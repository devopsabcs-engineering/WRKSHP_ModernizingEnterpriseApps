targetScope = 'resourceGroup'

@description('Name of the main resource to be created by this template.')
param webAppName string = 'app-samplewebapp-${uniqueString(resourceGroup().id)}'

// appServicePlan_name_var
@description('Name of the app service plan to be created by this template.')
param appServicePlanName string = 'asp-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('Location of the resource. By default use resource group\'s location, unless the resource provider is not supported there.')
param location string = resourceGroup().location

@description('Name of the database to be created by this template.')
param databaseName string = 'SampleWebApplicationCore_db'

@description('Name of the SQL server to be created by this template.')
param sqlServerName string = 'sql-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('Name of the SQL server admin login.')
param sqlAdminLogin string = 'sqladmin'

@description('Password for the SQL server admin login.')
@secure()
param sqlAdminPassword string
//Server=tcp:sql-samplewebapp-oyqorqpnsspf4.database.windows.net,1433;Database=SampleWebApplicationCore_db;Persist Security Info=False;User ID=sqladmin;Password=******;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
var connectionString = 'Server=tcp:${sqlServer.name}${environment().suffixes.sqlServerHostname},1433;Database=${databaseName};Persist Security Info=False;User ID=${sqlAdminLogin};Password=${sqlAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;'

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  location: location
  name: webAppName
  kind: 'app'
  properties: {
    httpsOnly: true
    reserved: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }

  resource connectionstrings 'config@2023-12-01' = {
    name: 'connectionstrings'
    properties: {
      SampleWebApplicationCoreContext: {
        value: connectionString
        type: 'SQLAzure'
      }
    }
  }

  resource basicPublishingCredentialsPolicies 'basicPublishingCredentialsPolicies@2023-12-01' = {
    name: 'scm'
    //kind: 'string'
    properties: {
      allow: true
    }
  }

  // add deployment slot for dev
  resource webAppSlotDev 'slots@2023-12-01' = {
    location: location
    name: 'dev'
    properties: {
      httpsOnly: true
      reserved: true
      serverFarmId: appServicePlan.id
      siteConfig: {
        alwaysOn: true
        linuxFxVersion: 'DOTNETCORE|8.0'
      }
    }

    resource basicPublishingCredentialsPoliciesDev 'basicPublishingCredentialsPolicies@2023-12-01' = {
      name: 'scm'
      //kind: 'string'
      properties: {
        allow: true
      }
    }

    // add connection string for dev
    resource connectionstrings_dev 'config@2023-12-01' = {
      name: 'connectionstrings'
      properties: {
        SampleWebApplicationCoreContext: {
          value: connectionString
          type: 'SQLAzure'
        }
      }
    }
  }

  // add deployment slot for staging
  resource webAppSlotStaging 'slots@2023-12-01' = {
    location: location
    name: 'staging'
    properties: {
      httpsOnly: true
      reserved: true
      serverFarmId: appServicePlan.id
      siteConfig: {
        alwaysOn: true
        linuxFxVersion: 'DOTNETCORE|8.0'
      }
    }

    resource basicPublishingCredentialsPoliciesStaging 'basicPublishingCredentialsPolicies@2023-12-01' = {
      name: 'scm'
      //kind: 'string'
      properties: {
        allow: true
      }
    }

    // add connection string for staging
    resource connectionstrings_staging 'config@2023-12-01' = {
      name: 'connectionstrings'
      properties: {
        SampleWebApplicationCoreContext: {
          value: connectionString
          type: 'SQLAzure'
        }
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  location: location
  name: appServicePlanName
  kind: 'linux'
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: true
  }
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  location: location
  name: sqlServerName
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }

  resource sqlServer_FirewallRule 'firewallRules@2023-08-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }

  resource database 'databases@2023-08-01-preview' = {
    sku: {
      name: 'Standard'
      tier: 'Standard'
      capacity: 10
    }
    location: location
    name: databaseName
  }
}

output webAppName string = webApp.name
output appServicePlanId string = appServicePlan.id
output sqlServerId string = sqlServer.id
output databaseId string = sqlServer::database.id
output sqlServer_FirewallRuleId string = sqlServer::sqlServer_FirewallRule.id

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

// @description('Name of the SQL server admin login.')
// param sqlAdminLogin string = 'sqladmin'

// @description('Password for the SQL server admin login.')
// @secure()
// param sqlAdminPassword string

param login string = 'azureSqlDBAdmins'
param sid string = '1a01e160-ef04-42e7-b0de-d2dedacab317'

@description('log analytics workspace name')
param logAnalyticsWorkspaceName string = 'log-samplewebapp-${uniqueString(resourceGroup().id)}'

@description('application insights name')
param appInsightsName string = 'appinsights-samplewebapp-${uniqueString(resourceGroup().id)}'

//Server=tcp:sql-samplewebapp-oyqorqpnsspf4.database.windows.net,1433;Database=SampleWebApplicationCore_db;Persist Security Info=False;User ID=sqladmin;Password=******;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
//var connectionString = 'Server=tcp:${sqlServer.name}${environment().suffixes.sqlServerHostname},1433;Database=${databaseName};Persist Security Info=False;User ID=${sqlAdminLogin};Password=${sqlAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;'
// AZURE_SQL_CONNECTIONSTRING should be one of the following:
// For system-assigned managed identity:"Server=tcp:<server-name>.database.windows.net;Database=<database-name>;Authentication=Active Directory Default;TrustServerCertificate=True"
// For user-assigned managed identity: "Server=tcp:<server-name>.database.windows.net;Database=<database-name>;Authentication=Active Directory Default;User Id=<client-id-of-user-assigned-identity>;TrustServerCertificate=True"
var connectionString = 'Server=tcp:${sqlServer.name}${environment().suffixes.sqlServerHostname},1433;Database=${databaseName};Authentication=Active Directory Default;Persist Security Info=False;User ID=${sid};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;'

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
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'Logging__LogLevel__Default'
          value: 'Information'
        }
        {
          name: 'Logging__LogLevel__Microsoft.AspNetCore'
          value: 'Warning'
        }
        {
          name: 'Logging__ApplicationInsights__LogLevel__Default'
          value: 'Debug'
        }
        {
          name: 'Logging__ApplicationInsights__LogLevel__Microsoft'
          value: 'Error'
        }
        {
          name: 'AllowedHosts'
          value: '*'
        }
        {
          name: 'ApplicationInsights__InstrumentationKey'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'ApplicationInsights__ConnectionString'
          value: appInsights.properties.ConnectionString
        }
      ]
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
        appSettings: [
          {
            name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
            value: appInsightsDev.properties.InstrumentationKey
          }
          {
            name: 'Logging__LogLevel__Default'
            value: 'Information'
          }
          {
            name: 'Logging__LogLevel__Microsoft.AspNetCore'
            value: 'Warning'
          }
          {
            name: 'Logging__ApplicationInsights__LogLevel__Default'
            value: 'Debug'
          }
          {
            name: 'Logging__ApplicationInsights__LogLevel__Microsoft'
            value: 'Error'
          }
          {
            name: 'AllowedHosts'
            value: '*'
          }
          {
            name: 'ApplicationInsights__InstrumentationKey'
            value: appInsightsDev.properties.InstrumentationKey
          }
          {
            name: 'ApplicationInsights__ConnectionString'
            value: appInsightsDev.properties.ConnectionString
          }
        ]
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
        appSettings: [
          {
            name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
            value: appInsightsStaging.properties.InstrumentationKey
          }
          {
            name: 'Logging__LogLevel__Default'
            value: 'Information'
          }
          {
            name: 'Logging__LogLevel__Microsoft.AspNetCore'
            value: 'Warning'
          }
          {
            name: 'Logging__ApplicationInsights__LogLevel__Default'
            value: 'Debug'
          }
          {
            name: 'Logging__ApplicationInsights__LogLevel__Microsoft'
            value: 'Error'
          }
          {
            name: 'AllowedHosts'
            value: '*'
          }
          {
            name: 'ApplicationInsights__InstrumentationKey'
            value: appInsightsStaging.properties.InstrumentationKey
          }
          {
            name: 'ApplicationInsights__ConnectionString'
            value: appInsightsStaging.properties.ConnectionString
          }
        ]
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
    //administratorLogin: sqlAdminLogin
    //administratorLoginPassword: sqlAdminPassword
    version: '12.0'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: login
      sid: sid
      tenantId: tenant().tenantId
      azureADOnlyAuthentication: true
    }
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

  // resource azureADOnlyAuthentications 'azureADOnlyAuthentications@2023-08-01-preview' = {
  //   name: 'Default'
  //   properties: {
  //     azureADOnlyAuthentication: true
  //   }
  // }

  // resource symbolicname 'administrators@2023-08-01-preview' = {
  //   name: 'ActiveDirectory'
  //   properties: {
  //     administratorType: 'ActiveDirectory'
  //     login: 'string'
  //     sid: webApp.identity.principalId
  //   }
  // }
}

// create log analytics workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  location: location
  name: logAnalyticsWorkspaceName
  properties: {
    retentionInDays: 30
  }
}

// create log analytics workspace for dev slot
resource logAnalyticsWorkspaceDev 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  location: location
  name: '${logAnalyticsWorkspaceName}-dev'
  properties: {
    retentionInDays: 30
  }
}

// create log analytics workspace for staging slot
resource logAnalyticsWorkspaceStaging 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  location: location
  name: '${logAnalyticsWorkspaceName}-staging'
  properties: {
    retentionInDays: 30
  }
}

// create application insights by linking to log analytics workspace
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  location: location
  name: appInsightsName
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// create application insights for dev slot
resource appInsightsDev 'Microsoft.Insights/components@2020-02-02' = {
  location: location
  name: '${appInsightsName}-dev'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspaceDev.id
  }
}

// create application insights for staging slot
resource appInsightsStaging 'Microsoft.Insights/components@2020-02-02' = {
  location: location
  name: '${appInsightsName}-staging'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspaceStaging.id
  }
}

output webAppName string = webApp.name
output appServicePlanId string = appServicePlan.id
output sqlServerId string = sqlServer.id
output databaseId string = sqlServer::database.id
output sqlServer_FirewallRuleId string = sqlServer::sqlServer_FirewallRule.id
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output appInsightsId string = appInsights.id
output logAnalyticsWorkspaceDevId string = logAnalyticsWorkspaceDev.id
output appInsightsDevId string = appInsightsDev.id
output logAnalyticsWorkspaceStagingId string = logAnalyticsWorkspaceStaging.id
output appInsightsStagingId string = appInsightsStaging.id
// managed identity
output sid string = sid // webApp.identity.principalId
output login string = login // webApp.name

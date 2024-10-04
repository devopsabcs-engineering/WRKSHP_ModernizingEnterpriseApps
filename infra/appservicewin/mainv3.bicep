@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param skuName string = 'P1' // 'F1'

@description('Describes plan\'s instance count')
@minValue(1)
@maxValue(3)
param skuCapacity int = 1

// @description('The admin user of the SQL Server')
// param sqlAdministratorLogin string

// @description('The password of the admin user of the SQL Server')
// @secure()
// param sqlAdministratorLoginPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

param login string //= 'azureSqlDBAdmins' // change this to your Azure AD group name
param sid string //= '1a01e160-ef04-42e7-b0de-d2dedacab317' // change this to your Azure AD group object id

var hostingPlanName = 'asp-samplewebapp-${uniqueString(resourceGroup().id)}'
var websiteName = 'app-samplewebapp-${uniqueString(resourceGroup().id)}'
var sqlserverName = 'sql-samplewebapp-${uniqueString(resourceGroup().id)}'
var logAnalyticsWorkspaceName = 'log-samplewebapp-${uniqueString(resourceGroup().id)}'
var appInsightsName = 'appi-samplewebapp-${uniqueString(resourceGroup().id)}'
var databaseName = 'SampleWebApplicationCore_db'

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlserverName
  location: location
  tags: {
    displayName: 'SQL Server'
  }
  properties: {
    //administratorLogin: sqlAdministratorLogin
    //administratorLoginPassword: sqlAdministratorLoginPassword
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

  resource sqlDatabase 'databases@2023-08-01-preview' = {
    name: databaseName
    location: location
    tags: {
      displayName: 'Database'
    }
    sku: {
      name: 'Basic'
    }
    properties: {
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      maxSizeBytes: 1073741824
    }
  }

  resource allowAllWindowsAzureIps 'firewallRules@2023-08-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: hostingPlanName
  location: location
  tags: {
    displayName: 'HostingPlan'
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource website 'Microsoft.Web/sites@2023-12-01' = {
  name: websiteName
  location: location
  tags: {
    'hidden-related:${hostingPlan.id}': 'empty'
    displayName: 'Website'
  }
  properties: {
    serverFarmId: hostingPlan.id
  }

  identity: {
    type: 'SystemAssigned'
  }

  resource basicPublishingCredentialsPolicies 'basicPublishingCredentialsPolicies@2023-12-01' = {
    name: 'scm'
    //kind: 'string'
    properties: {
      allow: true
    }
  }
}

resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    SampleWebApplicationCoreDemoContext: {
      value: 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Database=${databaseName};Authentication=Active Directory Default;TrustServerCertificate=True;'
      //value: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlAdministratorLogin}@${sqlServer.properties.fullyQualifiedDomainName};Password=${sqlAdministratorLoginPassword};'
      type: 'SQLAzure'
    }
  }
}

// create log analytics workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  location: location
  name: logAnalyticsWorkspaceName
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

output webAppName string = website.name
output appServicePlanId string = hostingPlan.id
output sqlServerId string = sqlServer.id
output databaseId string = sqlServer::sqlDatabase.id
output sqlServer_FirewallRuleId string = sqlServer::allowAllWindowsAzureIps.id
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output appInsightsId string = appInsights.id
// managed identity
output sid string = sid // webApp.identity.principalId
output login string = login // webApp.name
output webAppSystemAssignedIdentityId string = website.identity.principalId

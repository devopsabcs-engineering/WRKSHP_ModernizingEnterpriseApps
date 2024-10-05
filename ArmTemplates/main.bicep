@description('Name for the Virtual Machine.')
param vmName string = 'vm-win-sql'

@description('Size for the Virtual Machine.')
param vmSize string = 'Standard_B2s'

@description('Location for the Virtual Machine.')
param location string = resourceGroup().location

@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

param databaseUsername string = 'sqladmin'
@secure()
param databasePassword string

@description('The Windows version for the VM.')
@allowed([
  '2012-R2-Datacenter'
  '2016-Datacenter'
  '2012-R2-Datacenter-smalldisk'
  '2016-Datacenter-smalldisk'
  '2019-Datacenter'
  '2019-Datacenter-smalldisk'
  '2019-Datacenter-core'
  '2019-Datacenter-core-smalldisk'
  '2022-Datacenter'
  '2022-Datacenter-smalldisk'
  '2022-Datacenter-core'
  '2022-Datacenter-core-smalldisk'
])
param windowsOSVersion string = '2022-Datacenter-smalldisk'

param databaseName string = 'mydatabase'
//param databaseEdition string = 'Basic'

var vmInsightsName = 'vmInsights-${vmName}'
var databaseServerName = 'sql-server-${vmName}-${uniqueString(resourceGroup().id)}'
var storageAccountName = 'stvm${uniqueString(resourceGroup().id)}'
var nicName = 'nic-${vmName}'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'mySubnet'
var subnetPrefix = '10.0.0.0/24'
var publicIPAddressName = 'pip-${vmName}'
var networkSecurityGroupName = 'nsg-${vmName}'
var virtualNetworkName = 'vnet-${vmName}'
//var vnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
var customScriptExtension = 'customScriptExtension'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {}
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: '${toLower(vmName)}${uniqueString(resourceGroup().id)}'
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIPAddresses', publicIPAddressName)
          }
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
    }
  }
  dependsOn: [
    publicIPAddress
    virtualNetwork
  ]
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          description: 'Allow RDP'
          priority: 100
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'web_rule'
        properties: {
          description: 'Allow WEB'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vmInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: vmInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'AzureTfsExtensionAzureProject'
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts/', storageAccountName)).primaryEndpoints.blob
      }
    }
  }
  dependsOn: [
    storageAccount
  ]

  resource vmName_customScriptExtension 'extensions@2024-07-01' = {
    name: customScriptExtension
    location: location
    properties: {
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.9'
      autoUpgradeMinorVersion: true
      protectedSettings: {
        commandToExecute: 'powershell.exe setx /m APPINSIGHTS_INSTRUMENTATIONKEY ${reference(vmInsights.id,'2015-05-01').InstrumentationKey}; Import-Module servermanager; Add-WindowsFeature Web-Server, Web-Asp-Net45; Invoke-WebRequest https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi -outfile $env:temp\\WebDeploy_amd64_en-US.msi; Start-Process $env:temp\\WebDeploy_amd64_en-US.msi -ArgumentList "/quiet" -Wait'
      }
    }
  }
}

resource databaseServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: databaseServerName
  location: location
  properties: {
    administratorLogin: databaseUsername
    administratorLoginPassword: databasePassword
    version: '12.0'
  }

  resource database 'databases@2023-08-01-preview' = {
    name: databaseName
    location: location
    properties: {
      //edition: databaseEdition
      collation: 'SQL_Latin1_General_CP1_CI_AS'
    }
  }

  resource AllowAllWindowsAzureIps 'firewallRules@2023-08-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

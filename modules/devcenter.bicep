param location string = resourceGroup().location
param networkConnectionName string
param subnetId string
param networkingResourceGroupName string
param devCenterName string
param projectName string
param projectDescription string
param projectAdministrators array
param devBoxUsers array

var devboxdefinitions = [
  {
    name: 'Win11'
    imageId: 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os'
    skuName: 'general_a_8c32gb_v1'
    osStorageType: 'ssd_256gb'
  }
  {
    name: 'Win11-M365'
    imageId: 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365'
    skuName: 'general_a_8c32gb_v1'
    osStorageType: 'ssd_256gb'
  }
  {
    name: 'Win11-VS2022-M365'
    imageId: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    skuName: 'general_a_8c32gb_v1'
    osStorageType: 'ssd_256gb'
  }
]

var devCenterProjectAdmin = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '331c37c6-af14-46d9-b9f4-e1909e1b95a0')
var devCenterDevBoxUser = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45d50f46-0b78-4001-a660-4198cbe8cd05')

resource networkConnection 'Microsoft.DevCenter/networkConnections@2022-09-01-preview' = {
  name: networkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: subnetId
    networkingResourceGroupName: networkingResourceGroupName
  }
}

resource devCenter 'Microsoft.DevCenter/devcenters@2022-11-11-preview' = {
  name: devCenterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}

  resource attachedNetworks 'attachednetworks' = {
    name: 'default'
    properties: {
      networkConnectionId: networkConnection.id
    }
  }

  resource definitions 'devboxdefinitions' = [for definition in devboxdefinitions: {
    name: definition.name
    location: location
    properties: {
      imageReference: {
        id: '${devCenter.id}/galleries/default/images/${definition.imageId}'
      }
      sku: {
        name: definition.skuName
      }
      osStorageType: definition.osStorageType
    }
  }]
}

resource project 'Microsoft.DevCenter/projects@2022-11-11-preview' = {
  name: projectName
  location: location
  properties: {
    description: projectDescription
    devCenterId: devCenter.id
  }

  resource pool 'pools' = [for definition in devboxdefinitions: {
    name: definition.name
    location: location
    properties: {
      devBoxDefinitionName: definition.name
      licenseType: 'Windows_Client'
      localAdministrator: 'Enabled'
      networkConnectionName: 'default'
    }
  }]
}

resource adminRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principal in projectAdministrators: {
  scope: project
  name: guid(project.id, principal.id, devCenterProjectAdmin)
  properties: {
    principalId: principal.id
    roleDefinitionId: devCenterProjectAdmin
    principalType: principal.type
  }
}]

resource userRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principal in devBoxUsers: {
  scope: project
  name: guid(project.id, principal.id, devCenterDevBoxUser)
  properties: {
    principalId: principal.id
    roleDefinitionId: devCenterDevBoxUser
    principalType: principal.type
  }
}]

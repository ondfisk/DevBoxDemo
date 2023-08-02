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
    imageId: 'microsoftvisualstudio_windowsplustools_base-win11-gen2'
    skuName: 'general_i_8c32gb256ssd_v2'
    hibernateSupport: 'Enabled'
  }
]

var devCenterProjectAdmin = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '331c37c6-af14-46d9-b9f4-e1909e1b95a0')
var devCenterDevBoxUser = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45d50f46-0b78-4001-a660-4198cbe8cd05')

resource networkConnection 'Microsoft.DevCenter/networkConnections@2023-04-01' = {
  name: networkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: subnetId
    networkingResourceGroupName: networkingResourceGroupName
  }
}

resource devCenter 'Microsoft.DevCenter/devcenters@2023-04-01' = {
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
      hibernateSupport: definition.hibernateSupport
    }
  }]
}

resource project 'Microsoft.DevCenter/projects@2023-04-01' = {
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

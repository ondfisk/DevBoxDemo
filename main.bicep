param location string = resourceGroup().location
param devCenterName string
param projectName string
param projectDescription string
param projectAdministrators array
param devBoxUsers array
param devboxDefinitions array

var devCenterProjectAdmin = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '331c37c6-af14-46d9-b9f4-e1909e1b95a0'
)
var devCenterDevBoxUser = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '45d50f46-0b78-4001-a660-4198cbe8cd05'
)

resource devCenter 'Microsoft.DevCenter/devcenters@2024-02-01' = {
  name: devCenterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}

  resource definitions 'devboxdefinitions' = [
    for definition in devboxDefinitions: {
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
    }
  ]
}

resource project 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: projectName
  location: location
  properties: {
    description: projectDescription
    devCenterId: devCenter.id
  }

  resource pool 'pools' = [
    for definition in devboxDefinitions: {
      name: definition.name
      location: location
      properties: {
        displayName: definition.displayName
        devBoxDefinitionName: definition.name
        managedVirtualNetworkRegions: definition.locations
        licenseType: 'Windows_Client'
        localAdministrator: 'Enabled'
        stopOnDisconnect: {
          status: 'Enabled'
          gracePeriodMinutes: 60
        }
        singleSignOnStatus: 'Enabled'
        virtualNetworkType: 'Managed'
        networkConnectionName: 'managedNetwork'
      }
    }
  ]
}

resource adminRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for principal in projectAdministrators: {
    scope: project
    name: guid(project.id, principal.id, devCenterProjectAdmin)
    properties: {
      principalId: principal.id
      roleDefinitionId: devCenterProjectAdmin
      principalType: principal.type
    }
  }
]

resource userRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for principal in devBoxUsers: {
    scope: project
    name: guid(project.id, principal.id, devCenterDevBoxUser)
    properties: {
      principalId: principal.id
      roleDefinitionId: devCenterDevBoxUser
      principalType: principal.type
    }
  }
]

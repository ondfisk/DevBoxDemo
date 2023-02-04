param location string = resourceGroup().location
param projectName string
param projectDescription string
param devCenter string
param admins array
param users array

var devCenterProjectAdmin = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '331c37c6-af14-46d9-b9f4-e1909e1b95a0')
var devCenterDevBoxUser = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45d50f46-0b78-4001-a660-4198cbe8cd05')

resource project 'Microsoft.DevCenter/projects@2022-11-11-preview' = {
  name: projectName
  location: location
  properties: {
    description: projectDescription
    devCenterId: devCenter
  }
}

resource adminRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principal in admins: {
  scope: project
  name: guid(project.id, principal.id, devCenterProjectAdmin)
  properties: {
    principalId: principal.id
    roleDefinitionId: devCenterProjectAdmin
    principalType: principal.type
  }
}]

resource userRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principal in users: {
  scope: project
  name: guid(project.id, principal.id, devCenterDevBoxUser)
  properties: {
    principalId: principal.id
    roleDefinitionId: devCenterDevBoxUser
    principalType: principal.type
  }
}]

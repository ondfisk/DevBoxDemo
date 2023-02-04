param location string = resourceGroup().location
param managedIdentityName string
param networkConnectionName string
param subnetId string
param networkingResourceGroupName string
param devCenterName string
param computeGalleryName string
param devCenterProjects array

var devboxdefinitions = [
  {
    name: 'Win11'
    imageId: 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os'
    skuName: 'general_a_4c16gb_v1'
    osStorageType: 'ssd_256gb'
  }
  {
    name: 'Win11-M365'
    imageId: 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365'
    skuName: 'general_a_4c16gb_v1'
    osStorageType: 'ssd_256gb'
  }
  {
    name: 'Win11-VS2022-M365'
    imageId: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    skuName: 'general_a_4c16gb_v1'
    osStorageType: 'ssd_256gb'
  }
]

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: managedIdentityName
  location: location
}

resource networkConnection 'Microsoft.DevCenter/networkConnections@2022-11-11-preview' = {
  name: networkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: subnetId
    networkingResourceGroupName: networkingResourceGroupName
  }
}

resource computeGallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: computeGalleryName
  location: location
  properties: {}
}

resource computeGalleryRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, computeGallery.id)
  properties: {
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  }
}

resource devcenter 'Microsoft.DevCenter/devcenters@2022-11-11-preview' = {
  name: devCenterName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {}

  resource attachedNetworks 'attachednetworks' = {
    name: 'default'
    properties: {
      networkConnectionId: networkConnection.id
    }
  }

  resource galleries 'galleries' = {
    name: computeGallery.name
    properties: {
      galleryResourceId: computeGallery.id
    }
  }

  resource definitions 'devboxdefinitions' = [for definition in devboxdefinitions: {
    name: definition.name
    location: location
    properties: {
      imageReference: {
        id: '${devcenter.id}/galleries/default/images/${definition.imageId}'
      }
      sku: {
        name: definition.skuName
      }
      osStorageType: definition.osStorageType
    }
  }]
}

module projects 'project.bicep' = [for project in devCenterProjects: {
  name: 'project-${project.name}'
  params: {
    location: location
    projectName: project.name
    projectDescription: project.description
    devCenter: devcenter.id
    admins: project.admins
    users: project.users
  }
}]

targetScope = 'subscription'

param location string = deployment().location
param networkResourceGroupName string
param devCenterResourceGroupName string

param virtualNetworkName string
param virtualNetworkAddressPrefix string
param subnetAddressPrefix string
param networkSecurityGroupName string

param managedIdentityName string
param networkConnectionName string
param networkingResourceGroupName string
param devCenterName string
param computeGalleryName string
param devCenterProjects array

resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: networkResourceGroupName
  location: location
}

resource devCenterResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: devCenterResourceGroupName
  location: location
}

module network 'modules/network.bicep' = {
  name: 'Network'
  scope: networkResourceGroup
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    subnetAddressPrefix: subnetAddressPrefix
    networkSecurityGroupName: networkSecurityGroupName
  }
}

module devCenter 'modules/devcenter.bicep' = {
  name: 'DevCenter'
  scope: devCenterResourceGroup
  params: {
    location: location
    managedIdentityName: managedIdentityName
    networkConnectionName: networkConnectionName
    subnetId: network.outputs.subnetId
    networkingResourceGroupName: networkingResourceGroupName
    devCenterName: devCenterName
    computeGalleryName: computeGalleryName
    devCenterProjects: devCenterProjects
  }
}

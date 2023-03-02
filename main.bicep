targetScope = 'subscription'

param location string = deployment().location
param networkResourceGroupName string
param devCenterResourceGroupName string

param virtualNetworkName string
param virtualNetworkAddressPrefix string
param subnetAddressPrefix string
param networkSecurityGroupName string

param networkConnectionName string
param networkingResourceGroupName string
param devCenterName string
param devCenterProjectName string
param devCenterProjectDescription string
param devCenterProjectAdministrators array
param devCenterDevBoxUsers array

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
    networkConnectionName: networkConnectionName
    subnetId: network.outputs.subnetId
    networkingResourceGroupName: networkingResourceGroupName
    devCenterName: devCenterName
    projectName: devCenterProjectName
    projectDescription: devCenterProjectDescription
    projectAdministrators: devCenterProjectAdministrators
    devBoxUsers: devCenterDevBoxUsers
  }
}

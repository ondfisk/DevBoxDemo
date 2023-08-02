param location string = resourceGroup().location
param virtualNetworkName string
param virtualNetworkAddressPrefix string
param subnetAddressPrefix string
param networkSecurityGroupName string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: []
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

output subnetId string = virtualNetwork.properties.subnets[0].id

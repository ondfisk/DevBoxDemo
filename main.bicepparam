using './main.bicep' /*TODO: Provide a path to a bicep template*/

param networkResourceGroupName = 'Network'

param devCenterResourceGroupName = 'DevCenter'

param virtualNetworkName = 'devcenter-vnet'

param virtualNetworkAddressPrefix = '10.0.0.0/16'

param subnetAddressPrefix = '10.0.0.0/24'

param networkSecurityGroupName = 'devcenter-nsg'

param networkConnectionName = 'devcenter-connection'

param networkingResourceGroupName = 'NetworkInterfaces'

param devCenterName = 'devcenter'

param devCenterProjectName = 'myproject'

param devCenterProjectDescription = 'My Project'

param devCenterProjectAdministrators = [
  {
    id: '99031c8f-8e21-47b6-b477-304c37a7b10d'
    type: 'User'
  }
]

param devCenterDevBoxUsers = [
  {
    id: '99031c8f-8e21-47b6-b477-304c37a7b10d'
    type: 'User'
  }
  {
    id: '95eb9635-41c1-45b3-992b-37d18b37205f'
    type: 'User'
  }
]

using './main.bicep'

param devCenterName = 'devcenter'

param projectName = 'myproject'

param projectDescription = 'My Project'

param projectAdministrators = [
  {
    id: '90ef115c-e3dd-4c7e-8712-1abeb515a88e'
    type: 'User'
  }
]

param devBoxUsers = [
  {
    id: '90ef115c-e3dd-4c7e-8712-1abeb515a88e'
    type: 'User'
  }
]

param devboxDefinitions = [
  {
    displayName: 'Windows 11'
    name: 'Win11'
    imageId: 'microsoftwindowsdesktop_windows-ent-cpc_win11-23h2-ent-cpc'
    skuName: 'general_i_8c32gb256ssd_v2'
    hibernateSupport: 'Enabled'
    locations: [
      'swedencentral'
    ]
  }
  {
    displayName: 'Visual Studio 2022 on Windows 11'
    name: 'VisualStudio2022onWin11'
    imageId: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    skuName: 'general_i_8c32gb256ssd_v2'
    hibernateSupport: 'Enabled'
    locations: [
      'swedencentral'
    ]
  }
]

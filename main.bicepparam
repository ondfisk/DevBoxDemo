using './main.bicep'

param devCenterName = 'devcenter'

param projectName = 'project'

param projectDescription = 'Project'

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
    name: 'win11'
    imageId: 'microsoftvisualstudio_windowsplustools_base-win11-gen2'
    skuName: 'general_i_8c32gb256ssd_v2'
    hibernateSupport: 'Enabled'
    locations: [
      'swedencentral'
    ]
  }
  {
    displayName: 'Visual Studio 2022 on Windows 11'
    name: 'vs2022'
    imageId: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    skuName: 'general_i_8c32gb256ssd_v2'
    hibernateSupport: 'Enabled'
    locations: [
      'swedencentral'
    ]
  }
]

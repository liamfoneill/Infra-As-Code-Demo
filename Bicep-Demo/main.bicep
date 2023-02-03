targetScope = 'subscription'

param location string = 'westeurope' 

resource stgResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'demo-rg'
  location: location
}

module storageAcct 'storage.bicep' = {
  name: 'storageModule'
  scope: stgResourceGroup
  params: {
    location: location
    stgName: 'fdsdlkfsg'
  }
}

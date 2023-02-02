targetScope='subscription'

param resourceGroupName string = 'tfstate'
param resourceGroupLocation string = 'uksouth'
param storageName string = 'tfstatefdbdfb'
param storageLocation string = 'uksouth'

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module storageAcct 'storage.bicep' = {
  name: 'storageModule'
  scope: newRG
  params: {
    storageLocation: storageLocation
    storageName: storageName
  }
}

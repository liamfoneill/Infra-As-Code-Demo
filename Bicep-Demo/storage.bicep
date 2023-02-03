param location string = resourceGroup().location
param stgName string

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stgName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

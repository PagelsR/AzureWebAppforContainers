param location string
param containerregistryName string

@description('Enable an admin user that has push/pull permission to the registry.')
param acrAdminUserEnabled bool = true

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Tier of your Azure Container Registry.')
param acrSku string = 'Basic'

// azure container registry
resource containerregistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: containerregistryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Container Registry'
    'container.registry': containerregistryName
  }
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

var acr_username = containerregistry.listCredentials().username
var acr_pass = containerregistry.listCredentials().passwords[0].value

output acrLoginServer string = containerregistry.properties.loginServer
output output_acr_username string = acr_username
output output_acr_pass string = acr_pass

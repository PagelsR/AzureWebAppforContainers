param containerAppName string
param principalId string

// Add role assigment for Service Identity - acrPull
// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
param roleDefinitionId string = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
var secretUserRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)

// Reference Existing resource
resource existing_ContainerApp 'Microsoft.App/containerApps@2022-10-01' existing = {
  name: containerAppName
}

// Add role assignment to Container App
resource roleAssignmentForContainerApp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existing_ContainerApp.id, secretUserRole)
  scope: existing_ContainerApp
  properties: {
    principalId: principalId
    roleDefinitionId: secretUserRole
  }
}

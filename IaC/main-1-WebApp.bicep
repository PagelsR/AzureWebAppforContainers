param skuName string = 'B1'
param location string
param webAppPlanName string
param webSiteName string
param defaultTags object
param appInsightsName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: webAppPlanName // app serivce plan name
  location: location // Azure Region
  tags: defaultTags
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: skuName
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webSiteName // Globally unique app serivce name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
      netFrameworkVersion: 'v6.0'
      alwaysOn: true
      autoHealEnabled: true
    }
  }
}

// resource webAppName_stagingSlotName 'Microsoft.Web/sites/slots@2022-03-01' = {
//   parent: appService
//   name: 'dev'
//   identity: {
//     type: 'SystemAssigned'
//   }
//   tags: {
//     displayName: 'webAppSlots'
//   }
//   location: location
//   properties: {
//     siteConfig: {
//       minTlsVersion: '1.2'
//       healthCheckPath: '/healthy'
//       netFrameworkVersion: 'v6.0'
//       alwaysOn: true
//       autoHealEnabled: true
//     }
//     serverFarmId: appServicePlan.id
//   }
// }

resource standardWebTestPageHome  'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'Home Page Ping Test'
  location: location
  tags: {
    'hidden-link:${subscription().id}/resourceGroups/${resourceGroup().name}/providers/microsoft.insights/components/${appInsightsName}': 'Resource'
   }
  kind: 'ping'
  properties: {
    SyntheticMonitorId: appInsightsName
    Name: 'Page Home'
    Description: null
    Enabled: true
    Frequency: 300
    Timeout: 120 
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-va-ash-azr'  // East US
      }
      {
        Id: 'us-fl-mia-edge' // Central US
      }
      {
        Id: 'us-ca-sjc-azr' // West US
      }
    ]
    Configuration: null
    Request: {
      RequestUrl: 'https://${appService.name}.azurewebsites.net/'
      Headers: null
      HttpVerb: 'GET'
      RequestBody: null
      ParseDependentRequests: false
      FollowRedirects: null
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

resource standardWebTestPagePrivacy  'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'Privacy Page Ping Test'
  location: location
  tags: {
    'hidden-link:${subscription().id}/resourceGroups/${resourceGroup().name}/providers/microsoft.insights/components/${appInsightsName}': 'Resource'
   }
  kind: 'ping'
  properties: {
    SyntheticMonitorId: appInsightsName
    Name: 'Page Privacy'
    Description: null
    Enabled: true
    Frequency: 300
    Timeout: 120 
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-va-ash-azr'  // East US
      }
      {
        Id: 'us-fl-mia-edge' // Central US
      }
      {
        Id: 'us-ca-sjc-azr' // West US
      }
    ]
    Configuration: null
    Request: {
      RequestUrl: 'https://${appService.name}.azurewebsites.net/Home/Privacy'
      Headers: null
      HttpVerb: 'GET'
      RequestBody: null
      ParseDependentRequests: false
      FollowRedirects: null
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

output out_appService string = appService.id
output out_webSiteName string = appService.properties.defaultHostName
// output out_webSiteSlotName string = webAppName_stagingSlotName.properties.defaultHostName
output out_appServiceprincipalId string = appService.identity.principalId
// output out_appServiceSlotServiceprincipalId string = webAppName_stagingSlotName.identity.principalId

import radius as radius

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'internet-gateway'
  properties: {
    application: application
    routes: [
      {
        path: '/'
        destination: 'http://webui:3000'
      }
    ]
  }
}

resource webui 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'webui'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      backend: {
        source: 'http://basket-api:80'
      }
    }
  }
}

resource basketApi 'Applications.Core/containers@2023-10-01-preview'= {
  name: 'basket-api'
  properties: {
    application: application
    container: {
      // Temporarily using a long-running container like nginx until we finalize the demo scenario
      image: 'nginx:latest'
      ports: {
        api: {
          containerPort: 80
        }
      }
    }
    connections: {
      cache: {
        source: basketCache.id
      }
    }
  }
}

resource basketCache 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'basket-cache'
  properties: {
    environment: environment
    application: application
  }
}

resource inventoryApi 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'inventory-api'
  properties: {
    application: application
    container: {
      // Temporarily using a long-running container like nginx until we finalize the demo scenario
      image: 'nginx:latest'
      ports: {
        api: {
          containerPort: 80
        }
      }
    }
    connections: {
      db: {
        source: inventoryDb.id
      }
    }
  }
}

resource inventoryDb 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'inventory-db'
  properties: {
    environment: environment
    application: application
  }
}

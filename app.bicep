// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The env ID of your Radius Application. Set automatically by the rad CLI.')
param environment string

resource myapp 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource demo2 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo2'
  properties: {
    application: myapp.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}

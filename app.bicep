import radius as radius

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'dsrp-resources-env-recipe-env'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'dsrp-resources-env-recipe-env' 
    }
    simulated: true
    recipes: {
      'Applications.Datastores/redisCaches':{
        rediscache: {
          templateKind: 'bicep'
          templatePath: 'recipetest.azurecr.io/recipes/local-dev/redis-recipe:latest' 
        }
      }
    }
  }
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dsrp-resources-redis-recipe'
  location: 'global'
  properties: {
    environment: env.id
    extensions: [
      {
          kind: 'kubernetesNamespace'
          namespace: 'dsrp-resources-redis-recipe-app'
      }
    ]
  }
}

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'rds-recipe'
  location: 'global'
  properties: {
    environment: env.id
    application: app.id
    recipe: {
      name: 'rediscache'
    }
  }
}

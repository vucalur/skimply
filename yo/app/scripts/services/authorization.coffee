'use strict'

angular.module('skimply.authorization')
# This service provides guard methods to support AngularJS routes.
# You can add them as resolves to routes to require authorization levels
# before allowing a route change to complete
.provider('securityAuthorization', {
      requireAuthenticatedUser: ['securityAuthorization', (securityAuthorization) ->
         return securityAuthorization.requireAuthenticatedUser()
      ]

      $get: ['security', 'securityRetryQueue', (security, queue) ->
         service =

         # Require that there is an authenticated user
         # (use this in a route resolve to prevent non-authenticated users from entering that route)
            requireAuthenticatedUser: ->
               promise = security.requestCurrentUser().then((userInfo) =>
                  if !security.isAuthenticated()
                     return queue.pushRetryFn('unauthenticated-client', service.requireAuthenticatedUser)
               )
               return promise

         return service
      ]
   })
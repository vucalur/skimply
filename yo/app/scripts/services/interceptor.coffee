'use strict'

angular.module('skimply.interceptor', ['skimply.retryQueue'])
# This http interceptor listens for authentication failures
.factory('securityInterceptor', ['$injector', 'securityRetryQueue', ($injector, securityRetryQueue) ->
      return (promise) =>
         # Intercept failed requests
         return promise.then(null, (originalResponse) =>
            if (originalResponse.status == 401)
               # The request bounced because it was not authorized - add a new request to the retry queue
               promise = securityRetryQueue.pushRetryFn('unauthorized-server', () =>
                  # We must use $injector to get the $http service to prevent circular dependency
                  return $injector.get('$http')(originalResponse.config)
               )

            return promise
         )
   ])

# We have to add the interceptor to the queue as a string because the interceptor depends upon service instances that are not available in the config block
.config(['$httpProvider', ($httpProvider) ->
      $httpProvider.responseInterceptors.push('securityInterceptor')
   ])
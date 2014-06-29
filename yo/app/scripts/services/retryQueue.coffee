'use strict'

angular.module('skimply.retryQueue')
# This is a generic retry queue for security failures.  Each item is expected to expose two functions: retry and cancel.
.factory('securityRetryQueue', ['$q', '$log', ($q, $log) ->
      retryQueue = []
      retryQueue.hasMore = -> retryQueue.length > 0

      service =
      # The security service puts its own handler in here!
         onItemAddedCallbacks: []

         hasMore: =>
            return retryQueue.hasMore()

         push: (retryItem) =>
            retryQueue.push(retryItem)
            # Call all the onItemAdded callbacks
            angular.forEach(service.onItemAddedCallbacks, (cb) =>
               try
                  cb retryItem
               catch e
                  $log.error('securityRetryQueue.push(retryItem): callback threw an error' + e)
            )

         pushRetryFn: (reason, retryFn) ->
#            TODO(vucalur): eliminate this hack with params swapping
            # The reason parameter is optional
            if arguments.length == 1
               retryFn = reason
               reason = undefined

            # The deferred object that will be resolved or rejected by calling retry or cancel
            deferred = $q.defer()
            retryItem =
               reason: reason
               retry: =>
                  # Wrap the result of the retryFn into a promise if it is not already
                  $q.when(retryFn()).then(
                     (value) =>
                        # If it was successful then resolve our deferred
                        deferred.resolve(value)
                  , (value) =>
                     # Othewise reject it
                     deferred.reject(value)
                  )
               cancel: () =>
                  # Give up on retrying and reject our deferred
                  deferred.reject()

            service.push(retryItem)
            return deferred.promise


         retryReason: =>
            return retryQueue.hasMore() && retryQueue[0].reason

         cancelAll: =>
            while retryQueue.hasMore()
               retryQueue.shift().cancel()

         retryAll: =>
            while retryQueue.hasMore()
               retryQueue.shift().retry()


      return service
   ])
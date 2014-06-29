'use strict'

angular.module('skimply.service')
.factory('account', ['$resource',
      ($resource) ->
         $resource('backend/auth/account')
   ])

#TODO(vucalur): rewrite to service class
angular.module('skimply.service')
.factory('security', [
      'vertxEventBusService', '$q', '$location', 'securityRetryQueue', '$modal', '$rootScope',
      (vertxEventBusService, $q, $location, securityRetryQueue, $modal, $rootScope) ->
         redirect = (url) =>
            url = url || '/'
            $location.path url

         # Login form modal stuff
         loginModal = null
         openLoginModal = =>
            if !loginModal
               loginModal = $modal.open(
                  templateUrl: 'template/SKIMPLY/login-form.html'
                  controller: 'LoginFormCtrl'
               )
               loginModal.result.then(onLoginModalClose)

         closeLoginModal = (loginSuccessful) =>
            if loginModal
               loginModal.close loginSuccessful
               loginModal = null

         onLoginModalClose = (success) =>
            if success
               securityRetryQueue.retryAll()
            else
               securityRetryQueue.cancelAll()
               redirect()

         # Register a handler for when an item is added to the retry queue
         securityRetryQueue.onItemAddedCallbacks.push((retryItem) =>
            if (securityRetryQueue.hasMore())
               service.openLoginModal()
         )

         service =
            getLoginReason: =>
               securityRetryQueue.retryReason()
            openLoginModal: =>
               openLoginModal()

         # Attempt to authenticate a user by the given login and password
            login: (login, password) =>
               vertxEventBusService.login(login, password)
               .then((response) ->
                  if response.status == 'ok'
#                     TODO(vucalur): and here I'm dumping mod-auth-mgr approach
                     service.currentUser = undefined
               )

         # Give up trying to login and clear the retry queue
            cancelLogin: ->
               closeLoginModal false
               redirect()

         # Logout the current user and redirect
            logout: (redirectTo) ->
               request = vertxEventBusService.post('/backend/auth/logout', service.currentUser.login)
               request.then(() =>
                  service.currentUser = null
                  redirect redirectTo
               )

         # Ask the backend to see if a user is already authenticated - this may be from a previous session.
            requestCurrentUser: ->
               if service.isAuthenticated()
                  return $q.when service.currentUser
               else
                  return vertxEventBusService.get('/backend/auth/current-user').then((response) =>
                     service.currentUser = response.data
                     return service.currentUser
                  )

         # Information about the current user
            currentUser: null

         # Is the current user authenticated?
            isAuthenticated: ->
               return !!service.currentUser

         return service
   ])
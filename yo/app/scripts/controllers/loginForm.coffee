'use strict'

angular.module('skimply.controller')
.controller 'LoginFormCtrl',
   class LoginFormCtrl
      @$inject: ['$scope', 'security']
      constructor: (@$scope, @security) ->
         # The model for this form
         @$scope.user = {}

         # Any error message from failing to login
         @$scope.authError = null

         # The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
         # We could do something diffent for each reason here but to keep it simple...
         @$scope.authReason = null
         if @security.getLoginReason()
            @$scope.authReason = if @security.isAuthenticated()
            then 'Current user not authorized'
            else 'Invalid credentials'

         @$scope.login = () =>
            # Clear any previous security errors
            @$scope.authError = null

            # Try to login
            @security.login(@$scope.user.login, @$scope.user.password, (loggedIn) =>
               if !loggedIn
                  # If we get here then the login failed due to bad credentials
                  @$scope.authError = 'Invalid credentials'
            )

         @$scope.clearForm = () =>
            @$scope.user = {}

         @$scope.cancelLogin = () =>
            @security.cancelLogin()
'use strict'

angular.module('skimply.controller')
.controller 'RootCtrl',
   class Ctrl
      @$inject: ['$scope', 'security']
      constructor: (@$scope, @security) ->
         @$scope.$watch(
            () =>
               return @security.currentUser
         , (currentUser) =>
            @$scope.currentUser = currentUser
         )

      isAuthenticated: -> @security.isAuthenticated()

      login: -> @security.openLoginModal()

      logout: -> @security.logout()



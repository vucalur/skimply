'use strict'

###*
 # @ngdoc function
 # @name skimplyApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the skimplyApp
###
angular.module('skimplyApp')
.controller 'AboutCtrl', ($scope) ->
   $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
   ]

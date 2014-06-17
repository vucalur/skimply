'use strict'

###*
 # @ngdoc function
 # @name skimplyApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the skimplyApp
###
angular.module('skimplyApp')
.controller 'MainCtrl', ($scope) ->
   $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
   ]

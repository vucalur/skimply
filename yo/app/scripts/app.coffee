'use strict'

###*
 # @ngdoc overview
 # @name skimplyApp
 # @description
 # # skimplyApp
 #
 # Main module of the application.
###
angular
.module('skimplyApp', [
      'ngAnimate',
      'ngCookies',
      'ngResource',
      'ngRoute',
      'ngSanitize',
      'ngTouch'
   ])
.config ($routeProvider) ->
   $routeProvider
   .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
   .when '/about',
      templateUrl: 'views/about.html'
      controller: 'AboutCtrl'
   .otherwise
         redirectTo: '/'


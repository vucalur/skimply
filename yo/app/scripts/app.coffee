'use strict'

angular.module('skimply', [
   'ui.router'
   'knalli.angular-vertxbus'
   'skimply.service'
   'skimply.interceptor'
   'skimply.login'
   'skimply.authorization'
   'skimply.controller'
   'skimply.directive'
])
angular.module('skimply.service', [
   'skimply.retryQueue' # Keeps track of failed requests that need to be retried once the user logs in
   'skimply.controller' # Contains the login form template and controller
   'ui.bootstrap.modal' # Used to display the login form as a modal
])
angular.module('skimply.login', [
   'skimply.controller'
   'skimply.directive'
])
angular.module('skimply.retryQueue', [
])
angular.module('skimply.controller', [
   'ui.bootstrap.modal'
])
angular.module('skimply.interceptor', [
   'skimply.retryQueue'
])
angular.module('skimply.authorization', [
   'skimply.service'
])
angular.module('skimply.directive', [
   'skimply.service'
   'ngAnimate'
])

angular.module('skimply')
.config ($urlRouterProvider, $stateProvider) ->

   $urlRouterProvider.otherwise "/"

   $stateProvider
   .state 'main',
      url: '/'
      templateUrl: 'template/SKIMPLY/main.html'
   .state 'accounts',
      url: '/accounts'
      templateUrl: 'template/SKIMPLY/accounts.html'
      controller: 'AccountsCtrl as ctrl'

# workaround. See https://github.com/angular-ui/ui-router/issues/679
.run(($state) ->)

.config (vertxEventBusProvider) ->
   vertxEventBusProvider
   .useDebug(true)
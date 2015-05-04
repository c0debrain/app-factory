angular.module('app-factory', [
	'angular-meteor'
	'ui.router'
	'ui.bootstrap'
	'toaster'
])

angular.module('app-factory').run(['$rootScope', '$state', ($rootScope, $state) ->
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		console.error('Unauthorized route - redirecting to login')
		$state.go('login') if (error is 'AUTH_REQUIRED')
])
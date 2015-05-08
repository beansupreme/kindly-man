factoids = angular.module('factoids', [
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

factoids.config(['$routeProvider', 'flashProvider',
  ($routeProvider, flashProvider)->
    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
    .when('/',
      templateUrl: "index.html"
      controller: 'FactsController'
    ).when('/facts/new',
      templateUrl: 'form.html'
      controller: 'FactController'
    ).when('/facts/:factId',
      templateUrl: 'show.html'
      controller: 'FactController'
    ).when('/facts/:factId/edit',
      templateUrl: 'form.html'
      controller: 'FactController'
    )
])

facts = [
  {
    id: 1
    title: 'Bats roost in the millions'
  },
  {
    id: 2
    title: 'Bats eat a large number of mosquitos',
  },
  {
    id: 3
    title: 'Bats are not blind',
  },
  {
    id: 4
    title: 'Earthworms come out during the rain',
  },
]
controllers = angular.module('controllers', [])

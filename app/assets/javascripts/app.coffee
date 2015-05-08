factoids = angular.module('factoids',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

factoids.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
    .when('/',
      templateUrl: "index.html"
      controller: 'FactsController'
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
controllers = angular.module('controllers',[])

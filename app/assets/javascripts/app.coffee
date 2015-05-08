factoids = angular.module('factoids',[
  'templates',
  'ngRoute',
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
controllers.controller("FactsController", [ '$scope', '$routeParams', '$location',
  ($scope,$routeParams,$location)->
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)

    if $routeParams.keywords
      keywords = $routeParams.keywords.toLowerCase()
      $scope.facts = facts.filter (fact)-> fact.title.toLowerCase().indexOf(keywords) != -1
    else
      $scope.facts = []
])

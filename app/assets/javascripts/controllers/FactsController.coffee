controllers = angular.module('controllers')
controllers.controller("FactsController", [ '$scope', '$routeParams', '$location', '$resource'
  ($scope,$routeParams,$location, $resource)->
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)
    Fact = $resource('/facts/:factID', {factId: '@id', format: 'json'})

    if $routeParams.keywords
      Fact.query(keywords: $routeParams.keywords, (results)-> $scope.facts = results)
    else
      $scope.facts = []

    $scope.view = (factId)-> $location.path("/facts/#{factId}")
])
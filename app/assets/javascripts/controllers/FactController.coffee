controllers = angular.module('controllers')
controllers.controller('FactController', ['$scope', '$routeParams', '$resource', '$location', 'flash'
  ($scope, $routeParams, $resource, $location, flash)->
    $scope.search = (keywords)-> $location.path("/").search('keywords', keywords)
    Fact = $resource('/facts/:factId', {factId: '@id', format: 'json'})

    Fact.get({factId: $routeParams.factId},
      ( (fact)-> $scope.fact = fact),
      ( (httpResponse)->
        $scope.fact = null
        flash.error = "There is no fact with ID #{$routeParams.factId}"
      )
    )

    $scope.back = -> $location.path('/')
])
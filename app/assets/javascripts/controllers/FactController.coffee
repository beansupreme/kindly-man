controllers = angular.module('controllers')
controllers.controller('FactController', ['$scope', '$routeParams', '$resource', '$location', 'flash'
  ($scope, $routeParams, $resource, $location, flash)->
    $scope.search = (keywords)-> $location.path("/").search('keywords', keywords)
    Fact = $resource('/facts/:factId', {factId: '@id', format: 'json'},
      {
        'save': {method: 'PUT'},
        'create': {method: 'POST'}
      }
    )

    if $routeParams.factId
      Fact.get({factId: $routeParams.factId},
        ( (fact)-> $scope.fact = fact),
        ( (httpResponse)->
          $scope.fact = null
          flash.error = "There is no fact with ID #{$routeParams.factId}"
        )
      )
    else
      $scope.fact = {}

    $scope.back = -> $location.path('/')
    $scope.edit = -> $location.path("/facts/#{$scope.fact.id}/edit")
    $scope.cancel = ->
      if $scope.fact.id
        $location.path("/facts/#{$scope.fact.id}")
      else
        $location.path('/')

    $scope.save = ->
      onError = (_httpResponse)-> flash.error = 'Something went wrong'
      if $scope.fact.id
        $scope.fact.$save(
          ( ()-> $location.path("/facts/#{$scope.fact.id}")),
          onError
        )
      else
        Fact.create($scope.fact,
          ( (newFact) -> $location.path("/facts/#{newFact.id}")),
          onError
        )

    $scope.delete = ->
      $scope.fact.$delete()
      $scope.back()
])
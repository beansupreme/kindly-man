describe 'FactController', ->
  scope = null
  ctrl = null
  routeParams = null
  httpBackend = null
  flash = null
  factId = 42

  fakeFact =
    id: factId
    title: 'Mock bird'
    subject: 'Mockingbirds can mimic the songs of other birds and insects'


  setupController = (factExists=true)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller, _flash_)->
      scope = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.factId = factId
      flash = _flash_

      request = new RegExp("\/facts/#{factId}")
      results = if factExists
        [200, fakeFact]
      else
        [404]

      httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl = $controller('FactController',
        $scope: scope)
    )

  beforeEach(module('factoids'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'fact is found', ->
      beforeEach(setupController())
      it 'loads the given fact', ->
        httpBackend.flush()
        expect(angular.equals(scope.fact, fakeFact)).toBeTruthy()

    describe 'fact is not found', ->
      beforeEach(setupController(false))
      it 'loads no fact', ->
        httpBackend.flush()
        expect(scope.fact).toBe(null)
        expect(flash.error).toBe("There is no fact with ID #{factId}")
describe 'FactController', ->
  scope = null
  ctrl = null
  routeParams = null
  httpBackend = null
  flash = null
  location = null
  factId = 42

  fakeFact =
    id: factId
    title: 'Mock bird'
    subject: 'Mockingbirds can mimic the songs of other birds and insects'


  setupController = (factExists=true, factId=42)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller, _flash_)->
      scope = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.factId = factId if factId
      flash = _flash_

      if factId
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

  describe 'create', ->
    newFact =
      id: 42
      title: 'Storms'
      subject: 'Are common in the Spring'

    beforeEach ->
      setupController(false, false)
      request = new RegExp("\/facts")
      httpBackend.expectPOST(request).respond(201, newFact)

    it 'posts to the backend', ->
      scope.fact.title = newFact.title
      scope.fact.subject = newFact.subject
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/facts/#{newFact.id}")

  describe 'update', ->
    updatedFact =
      name: 'Storms'
      subject: 'Can cause lightning'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/facts")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.fact.title = updatedFact.title
      scope.fact.subject = updatedFact.subject
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/facts/#{scope.fact.id}")

  describe 'delete', ->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/facts/#{scope.fact.id}")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe('/')
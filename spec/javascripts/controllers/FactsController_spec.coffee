describe 'FactsController', ->
  scope = null
  ctrl = null
  location = null
  routeParams = null
  resource = null

  httpBackend = null

  setupController = (keywords, results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller)->
      scope = $rootScope.$new()
      location = $location
      resource = $resource
      routeParams = $routeParams
      routeParams.keywords = keywords

      httpBackend = $httpBackend

      if results
        request = if keywords
          new RegExp("\/facts.*keywords=#{keywords}")
        else
          new RegExp("\/facts")
        httpBackend.expectGET(request).respond(results)

      ctrl = $controller('FactsController',
        $scope: scope,
        $location: location)
    )

  beforeEach(module('factoids'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    facts = [
      {
        id: 2,
        title: 'Bears'
      },
      {
        id: 4,
        title: 'Tigers'
      }
    ]

    describe 'when no keywords present', ->
      beforeEach ->
        setupController('', facts)
        httpBackend.flush()

      it 'calls the back-end for all facts', ->
        expect(angular.equals(scope.facts, facts)).toBeTruthy()

    describe 'with keywords', ->
      keywords = 'foo'

      beforeEach ->
        setupController(keywords, facts)
        httpBackend.flush()

      it 'calls the back-end', ->
#        TODO: move this to a matcher in spec_helper.coffee
        expect(angular.equals(scope.facts, facts)).toBeTruthy()

  describe 'search()', ->
    beforeEach ->
      setupController('', [])
      httpBackend.flush()

    it 'redirects to itself with a keyword param', ->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe('/')
      expect(location.search()).toEqual({keywords: keywords})

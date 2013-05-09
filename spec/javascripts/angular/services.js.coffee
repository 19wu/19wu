describe "participants", ->
  participants = null
  beforeEach ->
    module '19wu' # fixed jasmine: Error: Unknown provider: participantsProvider <- participants
    inject ($rootScope, $injector, $http) ->
      $rootScope.event = {id: 1}
      data = [{"id":1,"login":"demo","created_at":"2013-03-09T08:36:49+08:00","avatar_url":"","profile":{"name":"","website":"","bio_html":""}}]
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.when('GET', '/api/events/1/participants').respond(200, data)
      participants = $injector.get('participants')
      $httpBackend.flush()

  it 'should load the data', () ->
    expect(participants.data.length).toBe(1)

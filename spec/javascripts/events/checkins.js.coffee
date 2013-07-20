describe "event checkins", ->
  scope = $httpBackend = null
  beforeEach(inject(($rootScope, $controller, $injector, $http) ->
    $rootScope.event = {id: 1}
    $rootScope.user = {checkin: false}
    scope = $rootScope.$new()
    scope.code = '666'
    $httpBackend = $injector.get('$httpBackend')
    ctrl = $controller(CheckinCtrl, {$scope: scope, $http: $http})
  ))

  it "should be success", ->
    $httpBackend.when('GET', '/events/1/checkin/666').respond({message_body: 'success', keep: false})
    scope.checkin()
    $httpBackend.flush()
    expect(scope.message).toEqual 'success'
    expect(scope.user.checked_in).toEqual true
    expect(scope.keep).toEqual false
    expect(scope.alert).toEqual true

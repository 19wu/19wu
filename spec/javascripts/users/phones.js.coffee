describe "user phones send code", ->
  scope = $httpBackend = null
  beforeEach(inject(($rootScope, $controller, $injector, $http) ->
    scope = $rootScope.$new()
    scope.phone = '13928452888'
    $httpBackend = $injector.get('$httpBackend')
    ctrl = $controller(UserPhonesCtrl, {$scope: scope, $http: $http})
  ))

  it "should be success", ->
    $httpBackend.when('POST', '/user_phone/send_code').respond({})
    scope.send_code()
    $httpBackend.flush()
    expect(scope.showed).toEqual true
    expect(scope.wait).toEqual true
    expect(scope.timeleft).toBeLessThan 60

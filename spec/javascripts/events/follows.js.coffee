describe "event", ->
  scope = $httpBackend = null
  beforeEach ->
    inject ($rootScope, $controller, $injector, $http) ->
      $rootScope.event = {id: 1}
      scope = $rootScope.$new()
      $httpBackend = $injector.get('$httpBackend')
      ctrl = $controller(FollowsCtrl, {$scope: scope, $http: $http})

  describe 'user', ->
    beforeEach -> inject ($rootScope) -> $rootScope.user = {id: 1}
    describe "follow", ->
      beforeEach ->
        scope.init([1, {true: '已关注', false: '关注'}, false])
        $httpBackend.when('POST', '/events/1/follow').respond(count: 2)
        scope.follow()
      it "should change label and count", ->
        $httpBackend.flush()
        expect(scope.count).toBe(2)
    describe "unfollow", ->
      beforeEach ->
        scope.init([1, {true: '已关注', false: '关注'}, true])
        $httpBackend.when('POST', '/events/1/unfollow').respond(count: 0)
        scope.follow()
      it "should change label and count", ->
        $httpBackend.flush()
        expect(scope.count).toBe(0)

  describe 'guest', ->
    describe "follow", ->
      beforeEach -> scope.init([1, {true: '已关注', false: '关注'}, false])
      it "should be disabled", ->
        expect(scope.disabled).toBe(true)
        expect(scope.title).toBe('您需要登录后才能关注活动')
        expect(scope.href).toMatch(/\/users\/sign_in/)

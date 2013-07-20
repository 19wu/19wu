describe "event", ->
  scope = $httpBackend = participants = null
  controller = ($rootScope, $injector, $http, $window, $controller) ->
    $rootScope.event = {id: 1}
    scope = $rootScope.$new()
    $httpBackend = $injector.get('$httpBackend')
    participants = data: [], reload: ->
    spyOn participants, 'reload' # http://git.io/57NirA
    spyOn($window, 'confirm').andReturn(true) # https://coderwall.com/p/elevha
    ctrl = $controller(JoinCtrl, {$scope: scope, $http: $http, $window: $window, participants: participants})

  describe 'user', ->
    beforeEach ->
    describe "join", ->
      beforeEach ->
        inject ($rootScope, $injector, $http, $window, $controller) ->
          $rootScope.user = {id: 1, joined: false}
          controller $rootScope, $injector, $http, $window, $controller
        scope.labels = {true: '已报名', false: '我要参加', event_end: '已结束'}
        scope.titles = {true: '记得准时来参加哦', false: '赶快报名吧', event_end: '活动已结束'}
        $httpBackend.when('POST', '/events/1/join').respond(200, {count: 2, joined: true})
        scope.join()
      it "should be success", ->
        $httpBackend.flush()
        expect(scope.user.joined).toBe(true)
        expect(participants.reload).toHaveBeenCalled()
    describe "quit", ->
      beforeEach ->
        inject ($rootScope, $injector, $http, $window, $controller) ->
          $rootScope.user = {id: 1, joined: true}
          controller $rootScope, $injector, $http, $window, $controller
        $httpBackend.when('POST', '/events/1/quit').respond(200, {count: 0, joined: false})
        scope.join()
      it "should be success", ->
        $httpBackend.flush()
        expect(scope.user.joined).toBe(false)
        expect(participants.reload).toHaveBeenCalled()
    describe "event end", ->
      beforeEach ->
        inject ($rootScope, $injector, $http, $window, $controller) ->
          $rootScope.user = {id: 1, joined: 'event_end'}
          controller $rootScope, $injector, $http, $window, $controller
          spyOn scope, 'disabled'
        scope.join()
      it "should be nothing to done", ->
        expect(scope.disabled).not.toHaveBeenCalled()

  describe 'guest', ->
    describe "follow", ->
      beforeEach ->
        inject ($rootScope, $injector, $http, $window, $controller) ->
          controller $rootScope, $injector, $http, $window, $controller
      it "should be disabled", ->
        expect(scope.disabled).toBe(true)
        expect(scope.title).toBe('您需要登录后才能关注活动')
        expect(scope.href).toMatch(/\/users\/sign_in/)


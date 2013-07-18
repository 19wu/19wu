describe "event", ->
  scope = $httpBackend = participants = null
  beforeEach ->
    inject ($rootScope, $controller, $injector, $http) ->
      $rootScope.event = {id: 1}
      scope = $rootScope.$new()
      $httpBackend = $injector.get('$httpBackend')
      participants = data: [], reload: ->
      spyOn participants, 'reload' # http://git.io/57NirA
      ctrl = $controller(JoinCtrl, {$scope: scope, $http: $http, participants: participants})

  describe 'user', ->
    beforeEach ->
      inject ($rootScope) -> $rootScope.user = {id: 1}
    describe "join", ->
      beforeEach ->
        scope.init([1, {true: '已报名', false: '我要参加', event_end: '已结束'}, {true: '记得准时来参加哦', false: '赶快报名吧', event_end: '活动已结束'}, false])
        $httpBackend.when('POST', '/events/1/join').respond(200, {count: 2, joined: true})
        scope.join()
      it "should joined and count number to 2", ->
        $httpBackend.flush()
        expect(scope.count).toBe(2)
        expect(scope.joined).toBe(true)
        expect(participants.reload).toHaveBeenCalled()
    describe "quit", ->
      beforeEach ->
        scope.init([1, {true: '已报名', false: '我要参加', event_end: '已结束'}, {true: '记得准时来参加哦', false: '赶快报名吧', event_end: '活动已结束'}, true])
        $httpBackend.when('POST', '/events/1/quit').respond(200, {count: 0, joined: false})
        scope.join()
      it "should quited and count number to zero", ->
        $httpBackend.flush()
        expect(scope.count).toBe(0)
        expect(scope.joined).toBe(false)
    describe "event end", ->
      beforeEach ->
        scope.init([1, {true: '已报名', false: '我要参加', event_end: '已结束'}, {true: '记得准时来参加哦', false: '赶快报名吧', event_end: '活动已结束'}, 'event_end'])
        scope.join()
      it "should be nothing to done", ->
        expect(scope.count).toBe(1)
        expect(scope.joined).toBe('event_end')

  describe 'guest', ->
    describe "follow", ->
      beforeEach -> scope.init([1, {true: '已报名', false: '我要参加', event_end: '已结束'}, {true: '记得准时来参加哦', false: '赶快报名吧', event_end: '活动已结束'}, false])
      it "should be disabled", ->
        expect(scope.disabled).toBe(true)
        expect(scope.title).toBe('您需要登录后才能关注活动')
        expect(scope.href).toMatch(/\/users\/sign_in/)


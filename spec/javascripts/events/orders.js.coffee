describe "orders", ->
  scope = $httpBackend = null
  controller = ($rootScope, $injector, $http, $window, $controller) -> # disabled was inited
    scope = $rootScope.$new()
    scope.name = 'saberma'
    scope.phone = '13928452888'
    $httpBackend = $injector.get('$httpBackend')
    $controller(OrdersCtrl, {$scope: scope, $http: $http, $window: $window})

  describe "create", ->
    describe 'when user logined', ->
      beforeEach -> inject ($rootScope) -> $rootScope.user = {id: 1, name: '张三', phone: '13928452888'}
      describe 'when event is not start', ->
        beforeEach ->
          inject ($rootScope, $injector, $http, $window, $controller) ->
            $rootScope.event = {id: 1, started: false}
            controller $rootScope, $injector, $http, $window, $controller
        it "should not be diabled", ->
          expect(scope.disabled).toBe(false)
        describe 'with tickets', ->
          beforeEach ->
            scope.tickets = [{"id":1,"name":"个人票","price":0.01,"require_invoice":false,"description":"","quantity":1}]
            $httpBackend.when('POST', '/events/1/orders').respond(200, {result: 'ok', id: 1, link: 'https://alipay.com'})
            scope.create()
          it "should be success", ->
            $httpBackend.flush()
            expect(scope.id).toBe(1)
            expect(scope.pay_url).toBe('https://alipay.com')
        describe 'without tickets', ->
          beforeEach ->
            scope.tickets = [{"id":1,"name":"个人票","price":0.01,"require_invoice":false,"description":"","quantity":0}]
            scope.create()
          it "should be fail", ->
            expect(scope.errors['tickets']).toBe(true)
      describe 'when event is started', ->
        beforeEach ->
          inject ($rootScope, $injector, $http, $window, $controller) ->
            $rootScope.event = {id: 1, started: true}
            controller $rootScope, $injector, $http, $window, $controller
          scope.create()
        it "should be diabled", ->
          expect(scope.disabled).toBe(true)
          expect(scope.errors['tickets']).toBeUndefined()

describe "orders", ->
  scope = $httpBackend = null
  beforeEach ->
    inject ($rootScope, $injector, $http, $window, $controller) ->
      $rootScope.event = {id: 1}
      scope = $rootScope.$new()
      $httpBackend = $injector.get('$httpBackend')
      ctrl = $controller(OrdersCtrl, {$scope: scope, $http: $http, $window: $window})

  describe "create", ->
    describe 'when user logined', ->
      beforeEach -> inject ($rootScope) -> $rootScope.user = {id: 1}
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
          expect(scope.error).toBe(true)

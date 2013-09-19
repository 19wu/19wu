describe "orders", ->
  scope = $httpBackend = null
  beforeEach ->
    inject ($rootScope, $controller, $injector, $http) ->
      $rootScope.event = {id: 1}
      scope = $rootScope.$new()
      scope.orders = [
        { id: 1 },
        { id: 2 }
      ]
      $httpBackend = $injector.get('$httpBackend')
      ctrl = $controller(OrderRefundSubmitCtrl, {$scope: scope, $http: $http})

  describe 'refund', ->
    describe "show form", ->
      beforeEach ->
        scope.show(0)
      it "should be show", ->
        expect(scope.orders[0].submit_refund_form).toEqual(true)

      describe "after another submit", ->
        beforeEach ->
          $httpBackend.when('POST', '/events/1/orders/1/refund/submit').respond({id: 1, amount: '10', reason: 'test'})
          order0 = scope.orders[0]
          order0.amount = '10'
          order0.reason = 'test'
          scope.submit(0)
          $httpBackend.flush()
        it "should be show with default values", ->
          scope.show(1)
          order1 = scope.orders[1]
          expect(order1.amount).toEqual('10')
          expect(order1.reason).toEqual('test')

    describe "submit", ->
      beforeEach ->
        $httpBackend.when('POST', '/events/1/orders/1/refund/submit').respond({id: 1, amount: '10', reason: 'test'})
        scope.submit(0)
        $httpBackend.flush()
      it "should be success", ->
        order = scope.orders[0]
        expect(order.refund).toEqual({id: 1, amount: '10', reason: 'test'})

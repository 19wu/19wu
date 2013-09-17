@OrderRefundSubmitCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.show = (index) ->
    order = $scope.orders[index]
    order.submit_refund_form = !order.submit_refund_form
  $scope.do = (index) ->
    order = $scope.orders[index]
    request = $http.post("/events/#{$scope.event.id}/orders/#{order.id}/refund/submit", refund: { amount: order.amount, reason: order.reason })
    request.success (data) ->
      order['refund'] = data
    request.error (data) ->
      alert data['errors']
]

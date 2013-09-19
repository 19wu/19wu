@OrderRefundSubmitCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.amount = null
  $scope.reason = null

  $scope.show = (index) ->
    order = $scope.orders[index]
    order.submit_refund_form = !order.submit_refund_form
    if order.submit_refund_form
      order.amount = $scope.amount unless order.amount
      order.reason = $scope.reason unless order.reason
  $scope.submit = (index) ->
    order = $scope.orders[index]
    request = $http.post("/events/#{$scope.event.id}/orders/#{order.id}/refund/submit", refund: { amount: order.amount, reason: order.reason })
    request.success (data) ->
      order['refund'] = data
      $scope.amount = data['amount']
      $scope.reason = data['reason']
    request.error (data) ->
      alert data['errors']
]

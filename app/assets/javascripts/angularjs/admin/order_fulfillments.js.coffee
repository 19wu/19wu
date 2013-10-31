@OrderFulfillmentsCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.submit = (index) ->
    order = $scope.orders[index]
    request = $http.post("/admin/fulfillments", order_id: order.id, fulfillment: { tracking_number: order.fulfillment_tracking_number })
    request.success (data) ->
      order['fulfillment'] = data
    request.error (data) ->
      alert data['errors']
]

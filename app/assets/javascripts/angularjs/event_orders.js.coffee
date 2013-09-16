@EventOrdersCtrl = ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.show = (index) ->
    order = $scope.orders[index]
    order.submit_refund_form = !order.submit_refund_form
]

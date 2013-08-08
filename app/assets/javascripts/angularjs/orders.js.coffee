@OrdersCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.create = ->
    $scope.error = false
    tickets = []
    for ticket in $scope.tickets
      quantity = parseInt(ticket.quantity)
      tickets.push { id: ticket.id, quantity: quantity } if quantity > 0
    if tickets.length > 0
      $http.post("/events/#{$scope.event.id}/orders", tickets: tickets).success (data) ->
        if data['result'] == 'ok'
          $scope.id = data['id']
          $scope.pay_url = data['link']
    else
      $scope.error = true
]

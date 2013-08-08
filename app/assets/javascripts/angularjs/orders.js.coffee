@OrdersCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.create = ->
    tickets = []
    for ticket in $scope.tickets
      tickets.push { id: ticket.id, quantity: parseInt(ticket.quantity) }
    $http.post("/events/#{$scope.event.id}/orders", tickets: tickets).success (data) ->
      if data['result'] == 'ok'
        $scope.id = data['id']
        $scope.pay_url = data['link']
]

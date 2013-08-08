@OrdersCtrl = ['$scope', '$http', '$location', '$window', ($scope, $http, $location, $window) ->
  $scope.create = ->
    tickets = []
    for ticket in $scope.tickets
      tickets.push { id: ticket.id, quantity: parseInt(ticket.quantity) }
    $http.post("/events/#{$scope.event.id}/orders", tickets: tickets).success (data) ->
      console.log data
]

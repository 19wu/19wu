@OrdersCtrl = ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.disabled = $scope.event.started
  $scope.errors = {}

  $scope.create = ->
    $scope.errors = {}
    return if $scope.disabled
    return if $scope.validate_login()
    return if $scope.validate_quantity()
    return if $scope.validate_user_info()
    $http.post("/events/#{$scope.event.id}/orders", tickets: $scope.tickets_with_quantity(), user: { name: $scope.name, phone: $scope.phone } ).success (data) ->
      if data['result'] == 'ok'
        $scope.id = data['id']
        $scope.status = data['status']
        $scope.pay_url = data['link']
      else # error
        alert data['errors']

  # private

  $scope.validate_quantity = ->
    if $scope.tickets_with_quantity().length == 0
      $scope.errors['tickets'] = true
      return true
    false

  $scope.validate_user_info = ->
    unless $scope.name && $scope.phone
      $scope.errors['user_info'] = true
      return true
    false

  $scope.validate_login = ->
    if !($scope.user? && $scope.user.id)
      $window.location.href = "/users/sign_in"
      return true
    false

  $scope.tickets_with_quantity = ->
    tickets = []
    for ticket in $scope.tickets
      quantity = parseInt(ticket.quantity)
      tickets.push { id: ticket.id, quantity: quantity } if quantity > 0
    tickets
]

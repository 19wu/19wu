@OrdersCtrl = ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.disabled = $scope.event.started
  $scope.errors = {}

  $scope.create = ->
    $scope.errors = {}
    return if $scope.disabled
    return if $scope.validate_login()
    return if $scope.validate_quantity()
    return if $scope.validate_user_info()

    request = $http.post("/events/#{$scope.event.id}/orders", $scope.postData())
    request.success (data) ->
      $scope.id = data['id']
      $scope.status = data['status']
      $scope.pay_url = data['link']
    request.error (data) ->
      alert data['errors']

  # private
  $scope.validate_quantity = ->
    for ticket in $scope.tickets
      return false if parseInt(ticket.quantity, 10) > 0

    $scope.errors['tickets'] = true
    true

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

  $scope.postData = ->
    items = []
    for ticket in $scope.tickets
      quantity = parseInt(ticket.quantity, 10)
      items.push { ticket_id: ticket.id, quantity: quantity } if quantity > 0

    order:
      items_attributes: items
    user:
      phone: $scope.phone
      profile_attributes:
        name: $scope.name
]

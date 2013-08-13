@OrdersCtrl = ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.disabled = $scope.event.started
  $scope.errors = {}

  $scope.create = ->
    $scope.errors = {}
    return if $scope.disabled
    return if $scope.validate_login()
    return if $scope.validate_quantity()
    return if $scope.validate_form()
    return if $scope.validate_invoice_info()

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

  $scope.validate_form = ->
    $scope.validate_user_info()
    $scope.validate_invoice_info()
    $scope.errors['user_info'] || $scope.errors['invoice_info']

  $scope.validate_user_info = ->
    $scope.errors['user_info'] = true unless $scope.name && $scope.phone

  $scope.require_invoice = ->
    for ticket in $scope.tickets
      return true if parseInt(ticket.quantity, 10) > 0 && ticket.require_invoice
    false

  $scope.validate_invoice_info = ->
    if $scope.require_invoice()
      unless $scope.invoice_title && $scope.province && $scope.city && $scope.district && $scope.address && $scope.shipping_name && $scope.shipping_phone
        $scope.errors['invoice_info'] = true

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

    shipping_address = if $scope.require_invoice()
      invoice_title: $scope.invoice_title,
      province:      $scope.province,
      city:          $scope.city,
      district:      $scope.district,
      address:       $scope.address,
      name:          $scope.shipping_name,
      phone:         $scope.shipping_phone
    else
      null

    order:
      items_attributes: items,
      shipping_address_attributes: shipping_address
    user:
      phone: $scope.phone
      profile_attributes:
        name: $scope.name
]

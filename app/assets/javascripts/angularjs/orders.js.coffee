@OrdersCtrl = ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.disabled = $scope.event.started
  $scope.user_form = 'register'
  $scope.errors = {}

  $scope.use_login_form = ->
    $scope.user_form = 'login'

  $scope.use_register_form = ->
    $scope.user_form = 'register'

  $scope.signup = ->
    request = $http.post("/users", user: { login: $scope.user_login, email: $scope.user_email, password: $scope.user_password })
    request.success (data) ->
      $scope.user_login_with data
    request.error (data) ->
      alert data['errors']

  $scope.login = ->
    request = $http.post("/users/sign_in", user: { email: $scope.email, password: $scope.password })
    request.success (data) ->
      $scope.user_login_with data
    request.error (data) ->
      alert data['error'] # http://git.io/C-1_Iw

  $scope.create = ->
    $scope.errors = {}
    return if $scope.disabled
    return if $scope.validate_quantity()
    return if $scope.validate_user_session()
    return if $scope.validate_form()
    return if $scope.validate_invoice_info()

    request = $http.post("/events/#{$scope.event.id}/orders", $scope.postData())
    request.success (data) ->
      $scope.id = data['id']
      $scope.number = data['number']
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

  $scope.validate_user_session = ->
    $scope.errors['user_session'] = true unless ($scope.user? && $scope.user.id)

  $scope.validate_form = ->
    $scope.validate_user_info()
    $scope.validate_invoice_info()
    $scope.errors['user_info'] || $scope.errors['invoice_info']

  $scope.validate_user_info = ->
    $scope.errors['user_info'] = true unless $scope.user.name && $scope.user.phone

  $scope.require_invoice = ->
    for ticket in $scope.tickets
      return true if parseInt(ticket.quantity, 10) > 0 && ticket.require_invoice
    false

  $scope.validate_invoice_info = ->
    if $scope.require_invoice()
      unless $scope.invoice_title && $scope.province && $scope.city && $scope.district && $scope.address && $scope.shipping_name && $scope.shipping_phone
        $scope.errors['invoice_info'] = true

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
      phone: $scope.user.phone
      profile_attributes:
        name: $scope.user.name

  $scope.user_login_with = (data) ->
    $scope.update_csrf_token(data['token'])
    $scope.user = data
    $scope.create()

  $scope.update_csrf_token = (token) ->
    $('meta[name="csrf-token"]').attr('content', token)
    $http.defaults.headers.common['X-CSRF-Token'] = token
]

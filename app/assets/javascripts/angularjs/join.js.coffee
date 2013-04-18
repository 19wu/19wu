@JoinCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  btn_classes = { true: 'btn-warning', false: 'btn-success'}
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.titles, $scope.joined] = data
    $scope.updateLabel()
    $scope.disabled = !$scope.user?
    $scope.href= "#"
    if $scope.disabled
      $scope.title = "您需要登录后才能关注活动"
      $scope.href = "/users/sign_in?return_to=#{$location.absUrl()}"
  $scope.updateLabel = ->
    $scope.label = " #{$scope.labels[$scope.joined]}"
    $scope.btn_class = "#{btn_classes[$scope.joined]}"
    $scope.title = "#{$scope.titles[$scope.joined]}"
  $scope.join = ->
    return if $scope.disabled
    action = if $scope.joined then 'quit' else 'join'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) -> 
      $scope.count = data.count
      $scope.notice = data.notice
      $scope.joined = data.joined
      $scope.updateLabel()
]
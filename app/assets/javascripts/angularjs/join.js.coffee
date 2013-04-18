@JoinCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.titles, $scope.joined] = data
    $scope.disabled = !$scope.user?
    $scope.href= "#"
    if $scope.disabled
      $scope.title = "您需要登录后才能关注活动"
      $scope.href = "/users/sign_in?return_to=#{$location.absUrl()}"
  $scope.join = ->
    return if $scope.disabled
    action = if $scope.joined then 'quit' else 'join'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) -> 
      $scope.count = data.count
      $scope.notice = data.notice
      $scope.joined = data.joined
]
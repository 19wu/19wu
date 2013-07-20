@JoinCtrl = ['$scope', '$http', '$location', '$window', 'participants', ($scope, $http, $location, $window, participants) ->
  $scope.disabled = !($scope.user? && $scope.user.id)
  if $scope.disabled
    $scope.title = "您需要登录后才能关注活动"
    $scope.href = "/users/sign_in"
  $scope.join = ->
    return if $scope.user.joined == "event_end"
    return if $scope.disabled
    return if $scope.user.joined && !$window.confirm("您确定要取消报名?")
    action = if $scope.user.joined then 'quit' else 'join'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) ->
      $scope.notice = data.notice
      $scope.user.joined = data.joined
      $scope.user.checked_in = false
      participants.reload()
]

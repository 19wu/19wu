@FollowsCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.followed] = data
    $scope.disabled = !$scope.user?
    $scope.title = "新活动发布时会给您发送邮件通知"
    if $scope.disabled
      $scope.title = "您需要登录后才能关注活动"
      $scope.href = "/users/sign_in"
  $scope.follow = ->
    return if $scope.disabled
    $scope.followed = !$scope.followed
    action = if $scope.followed then 'follow' else 'unfollow'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) -> $scope.count = data.count
]

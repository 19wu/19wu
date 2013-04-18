@JoinCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  btn_classes = { true: 'btn-warning disabled', false: 'btn-success'}
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.joined] = data
    $scope.updateLabel()
    $scope.disabled = !$scope.user? || $scope.joined
    $scope.title = '登录后马上报名'
    if $scope.disabled
      $scope.title = "记得准时来参加哦"
      $scope.href = "/users/sign_in?return_to=#{$location.absUrl()}"
  $scope.updateLabel = ->
    $scope.label = " #{$scope.labels[$scope.joined]}"
    $scope.btn_class = "#{btn_classes[$scope.joined]}"
  $scope.join = ->
    return if $scope.disabled
    $scope.joined = !$scope.joined if !$scope.joined
    $scope.updateLabel()
    #action = if $scope.joined then 'join'
    $http.post("/events/#{$scope.event.id}/join").success (data) -> 
      $scope.count = data.count
      $scope.notice = data.notice
]
@JoinCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  btn_classes = { true: 'btn-warning disabled', false: 'btn-success'}
  $scope.init = (data) ->
    [$scope.labels, $scope.joined] = data
    $scope.updateLabel()
    $scope.disabled = !$scope.user? || $scope.joined
  $scope.updateLabel = ->
    $scope.label = " #{$scope.labels[$scope.joined]}"
    $scope.btn_class = "#{btn_classes[$scope.joined]}"
  $scope.join = ->
    return if $scope.disabled
    $scope.joined = !$scope.joined if !$scope.joined
    $scope.updateLabel()
    #action = if $scope.joined then 'join'
    $http.post("/events/#{$scope.event.id}/join").success (data) -> $scope.notice = data.notice
]
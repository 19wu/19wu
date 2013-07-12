@UserPhonesCtrl = ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->
  LIMIT_TIME = $scope.timeleft = 60
  $scope.showed = $scope.wait = false
  $scope.send_code = ->
    if $scope.phone
      $http.post("/user_phone/send_code", phone: $scope.phone).success (data) ->
        $scope.showed = $scope.wait = true
        $scope.timeleft = LIMIT_TIME
        $scope.tick()
  $scope.tick = ->
    $scope.timeleft--
    if $scope.timeleft > 0
      $timeout($scope.tick, 1000)
    else
      $scope.wait = false
]

@UserPhonesCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.showed = false
  $scope.send_code = ->
    if $scope.phone
      $http.post("/user_phone/send_code", phone: $scope.phone).success (data) ->
        $scope.showed = true
]

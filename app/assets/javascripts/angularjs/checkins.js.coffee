@CheckinCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.alert = false
  $scope.keep = true
  $scope.checkin = ->
    if $scope.code
      $http.get("/events/#{$scope.event.id}/checkin/#{$scope.code}").success (data) ->
        $scope.message = data.message_body
        $scope.alert = true
        $scope.keep = data.keep
]

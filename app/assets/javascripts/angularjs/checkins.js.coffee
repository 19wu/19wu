@CheckinCtrl = ['$scope', '$http', ($scope, $http) ->
  update = ->
    $scope.alert = $scope.user.checked_in
    $scope.keep = (!$scope.outdate && !$scope.user.checked_in)
  angular.forEach ['outdate', 'user.checked_in'], (name) ->
    $scope.$watch name, update
  $scope.outdate = false
  $scope.checkin = ->
    if $scope.code
      $http.get("/events/#{$scope.event.id}/checkin/#{$scope.code}").success (data) ->
        $scope.message = data.message_body
        $scope.user.checked_in = !data.keep
        $scope.keep = data.keep
        $scope.alert = true
]

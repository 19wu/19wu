@ParticipantsCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.checkin = ->
    $scope.wait = true
    $scope.error = $scope.data = null
    request = $http.post("/events/#{$scope.event.id}/participants", code: $scope.code)
    request.success (data) ->
      $scope.code = ''
      $scope.data = data
      $scope.wait = false # TODO: use always
    request.error (data) ->
      $scope.error = data['error']
      $scope.wait = false
]

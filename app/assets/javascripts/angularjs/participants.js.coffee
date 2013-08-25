@ParticipantsCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.checkin = ->
    return unless $scope.code
    $scope.wait = true
    $scope.error = $scope.data = null
    request = $http.post("/events/#{$scope.event.id}/participants", code: $scope.code)
    request.success (data) ->
      $scope.code = ''
      $scope.data = data
      $scope.wait = false # TODO: use always method
    request.error (data) ->
      $scope.error = data['errors'].join(',')
      $scope.wait = false
]

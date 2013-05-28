@CollaboratorsCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.error = false
  $scope.load = (query, callback) -> # TODO: cancellable
    $http.get("/autocomplete/users?q=#{query}").success (data) -> callback(data)
  $scope.add = -> # TODO: only real login can be add
    unless $scope.exists($scope.login)
      $http.post("/events/#{$scope.event.id}/collaborators", login: $scope.login).success (data) ->
        $scope.items.push data
        $scope.login = ''
  $scope.remove = (index) ->
    item = $scope.items[index]
    $http.delete("/events/#{$scope.event.id}/collaborators/#{item.id}").success (data) ->
      $scope.items.splice(index, 1)
  $scope.exists = (login) ->
    $scope.error = false
    $scope.error = true for item in $scope.items when item.login is login
    $scope.error
]

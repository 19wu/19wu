@ParticipantedUsersCtrl = ['$scope', 'participated_users', ($scope, participated_users) ->
  $scope.participated_users= participated_users.data
]

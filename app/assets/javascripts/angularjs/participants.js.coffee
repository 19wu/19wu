@ParticipantsCtrl = ['$scope', 'participants', ($scope, participants) ->
  $scope.participants= participants.data
]

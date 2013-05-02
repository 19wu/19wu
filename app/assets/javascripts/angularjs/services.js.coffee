@app.factory 'participated_users', ['$rootScope', '$http', ($rootScope, $http) ->
  data = []
  load = ->
    $http.get("/api/events/#{$rootScope.event.id}/participated_users").success (users) ->
      data.length = 0
      $.each users, (index, item) ->
        data.push item
  load()
  data: data, reload: -> load()
]

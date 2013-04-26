#= require angular
#= require angular-resource
#= require_self
#= require_tree ./angularjs

angular.module('19wu', []).
  config(["$httpProvider", (provider) ->
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  ])

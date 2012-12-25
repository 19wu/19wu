# https://gist.github.com/2022574

# TODO: add method to create Spine Model directly.

@Factory = Factory = {}

ids = {}
sequences = {}
sequence = (name, callback) -> sequences[name] = callback

define = (name, defaults = {}) ->
  Factory[name] = (attrs = {}) ->
    result = $.extend {}, defaults, attrs
    for k, v of result
      if typeof v is 'function'
        result[k] = v.call(result, result)
    result

next = (name) ->
  ->
    ids[name] = (ids[name] ? 0) + 1
    console.log ids[name]
    sequences[name]?(ids[name])
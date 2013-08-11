@app.filter 'money', () ->
  (input) ->
    if parseFloat(input) == 0
      '免费'
    else
      input

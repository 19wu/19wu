describe "filters", ->
  money = null
  beforeEach ->
    module '19wu'
    inject ($filter) ->
      money = $filter('money')

  it 'should load the data', () ->
    expect(money('0.0')).toEqual('免费')
    expect(money('0.01')).toEqual('0.01')

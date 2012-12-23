beforeEach ->
  @htmlSandbox = $("<div></div>").appendTo($("body"))

afterEach ->
  @htmlSandbox.remove()
  @htmlSandbox = null

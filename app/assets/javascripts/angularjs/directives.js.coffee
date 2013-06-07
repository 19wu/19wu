@app.directive 'bsPopoverCustom', () ->
  (scope, element, attrs) ->
    attrs.$observe 'target', (value) ->
      options = {}
      if value
        $target = $(value)
        options =
          html: true
          title: $target.find('.popover-title').html()
          content: $target.find('.popover-content').html()
      element.popover options

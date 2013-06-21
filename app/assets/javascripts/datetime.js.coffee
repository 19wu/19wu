$(document).ready ->
  body = $("body")
  datepickerDefaults =
    autoclose: true
    language: I18n.locale
    format: I18n.date.formats.datepicker
    weekStart: parseInt(I18n.date.weekstart, 10)

  body.on "click", ".datepicker-trigger", ->
    el = $(this).closest(".date").find('.datepicker')
    datepicker = el.data("datepicker")
    unless datepicker?
      el.datepicker(datepickerDefaults)
      el.off 'focus'

    el.datepicker "show"

  body.on "click", ".timepicker-trigger", (e) ->
    $this = $(this)
    el = $this.closest(".time").find(".timepicker")

    # Init and show it the first time. After time picker is initialized, it
    # will register events handlers.
    timepicker = el.data("timepicker")
    unless timepicker?
      el.timepicker({minuteStep: 5, defaultTime: false})
      # Set default meridian, otherwise the picker shows undefined in the text field.
      timepicker = el.data("timepicker")
      timepicker.meridian = 'AM'

      setTimeout (-> $this.trigger('click')), 0

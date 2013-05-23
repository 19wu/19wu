#= require jquery
#= require jquery_ujs
#= require angularjs
#= require bootstrap-custom
#= require bootstrap-datepicker/core
#= require jquery-fileupload/basic
#= require jquery.textarea.caret
#= require bootstrap-timepicker
#= require_self
$ ->
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

  $(".fileupload").each ->
    $(this).fileupload
      dataType: "json"
      dropZone: $(this).closest(".uploadable-input") # #206 http://git.io/DuKo8A
      add: (e, data) ->
        el = $(this).parent()
        el.hide()
        el.next(".uploading").show()
        data.submit()

      done: (e, data) ->
        $.each data.result.files, (index, file) ->
          targetTextarea = $(e.target).closest(".control-group").find("textarea")
          markdownImage = "![" + file.name + "](" + file.url + ")"
          markdownImage = "\n" + markdownImage + "\n"  unless targetTextarea.val() is ""
          targetTextarea.insertAtCursor markdownImage

        el = $(this).parent()
        el.show()
        el.next(".uploading").hide()


  $("textarea.uploadable").on("focus", ->
    $(this).next("p").addClass "focused"
  ).on "blur", ->
    $(this).next("p").removeClass "focused"



  $(".uploadable-input").each ->
    $this = $(this)

    #get textarea's id
    id = $this.find('textarea').attr('id')

    #set write-tab's link
    writeTab = $this.find('.write-tab:first a')
    writeTab.attr('href', '#'+id)

    #set preview-tab's link
    previewTabId = id + '_preview_bucket'
    previewTab = $this.find('.preview-tab')
    previewTab.find('a').attr('href', '#'+previewTabId)

    #set write-section's id
    writeSec = $this.find('.tab-content>.active')
    writeSec.attr('id',id)
    #set preview-section's id
    previewSec = writeSec.siblings()
    previewSec.attr('id',previewTabId)

    #preview content in the write section
    previewTab.click ->
      writeBits = writeSec.find('textarea').val()
      previewSec.find('.previews').empty()
      if writeBits is ''
        previewSec.find('.preview-nothing').show()
      else
        $.ajax({
          url: "/content/preview"
          type: "POST"
          data: "content="+writeBits
          beforeSend: ->
              previewSec.find('.preview-nothing').hide()
              previewSec.find('.preview-loading').show()
          success: (data) ->
              previewSec.find('.preview-loading').hide()
              previewSec.find('.previews').append(data.result)
        })

  $('[rel=popover]').each ->
    options = {}
    $this = $(this)
    if $this.data('target')
      $target = $($this.data('target'))
      options = {
        html: true
        title: $target.find('.popover-title').html()
        content: $target.find('.popover-content').html()
      }

    $this.popover(options)

  $("a[data-toggle='tooltip']").tooltip()

  updateMap = (location) ->
    markers = map.getOverlays()
    i = 0
    while i < markers.length
      map.removeOverlay markers[i]
      i++

    myGeo.getPoint location, ((point) ->
      if point
        map.centerAndZoom point, 17
        map.addOverlay new BMap.Marker(point)
    ), "中国"

  $("#event_location").keyup ->
    updateMap(@value)

  updateMap $("#event_location").val() unless $("#event_location").val() is ""
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require bootstrap-datepicker/core
#= require jquery-fileupload/basic
#= require jquery.textarea.caret
#= require_self
$ ->
  body = $("body")
  datepickerDefaults =
    language: I18n.locale
    format: I18n.date.formats.datepicker
    weekStart: parseInt(I18n.date.weekstart, 10)

  body.on "click", ".datepicker-trigger", ->
    el = $(this).closest(".date").find(".datepicker")
    datepicker = el.data("datepicker")
    unless datepicker?
      el.datepicker(datepickerDefaults).on "changeDate", ->
        el.datepicker "hide"

    el.datepicker "show"

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

   # previewTab.attr('href', '#'+previewTabId)
     
    #set write-section's id
    writeSec = $this.find('.tab-content>.active')
    writeSec.attr('id',id)
    #set preview-section's id
    previewSec = writeSec.siblings()
    previewSec.attr('id',previewTabId)

    previewTab.click ->
      writeBits = writeSec.find('textarea').val()
      previewSec.empty()
      previewStyle = "1px solid #cccccc"
      if writeBits is ''
         previewSec.append('<p>无内容预览</p>')
         previewSec.css('border',previewStyle)
      else 
        $.ajax({
          url: "/content/preview",
          type: "POST",
          data: "content="+writeBits
        }).done (data) ->
              previewSec.append(data.result)
              previewSec.css('border',previewStyle)



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


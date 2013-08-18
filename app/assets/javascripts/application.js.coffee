#= require jquery
#= require jquery_ujs
#= require jquery.qrcode.min
#= require jquery-fileupload/basic
#= require jquery.textarea.caret
#= require jquery.ba-throttle-debounce.min
#= require rails-timeago
#= require china_city/jquery.china_city
#= require locales/jquery.timeago.zh-CN.js
#= require bootstrap-custom
#= require bootstrap-datepicker/core
#= require bootstrap-timepicker
#= require angularjs
#= require datetime
#= require upload
#= require map
#= require checkin
#= require_self
$ ->
  $("a[data-toggle='tooltip']").tooltip()
  $("a[rel='popover']").each ->
    $target = $($(this).data('target'))
    $(this).popover
      html: true
      title: $target.find('.popover-title').html()
      content: $target.find('.popover-content').html()

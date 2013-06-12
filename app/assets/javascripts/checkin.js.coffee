$(document).ready ->
  if $("#qrcode").length
    $qrcode = $("#qrcode")
    $qrcode.qrcode
      text: $qrcode.data("checkin-url")
      width: 360
      height: 360

  $("div.checkin button").on "click", ->
    checkin_code = $("div.checkin button").siblings("input").val()
    return false  if checkin_code is ""
    checkin_url = window.location.pathname + "/checkin/" + checkin_code
    $.getJSON checkin_url, (data) ->
      $message = $("<div class=\"alert\" title=\"Alert\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\">×</a><div></div></div>")
      $message.children("div").text data.message_body
      $message.addClass "alert-success"  if data.message_type is "notice"
      $("#flash").detach()
      $flash = $("<div id=\"flash\"></div>")
      $flash.append($message).prependTo "#content .container"
      $("div.checkin").slideToggle()  if data.keep is false

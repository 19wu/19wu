$(document).ready ->
  if $("#qrcode").length
    $qrcode = $("#qrcode")
    $qrcode.qrcode
      text: $qrcode.data("checkin-url")
      width: 360
      height: 360

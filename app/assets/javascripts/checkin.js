$(document).ready(function() {
  if ($(".checkin-info").length) {
    var $qrcode = $("#qrcode")
    $qrcode.qrcode({text: $qrcode.data("checkin-url"), width: 180, height: 180});
  }
});
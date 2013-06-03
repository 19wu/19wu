$(document).ready(function() {
  if ($(".checkin-info").length) {
    var $qrcode = $("#qrcode")
    $qrcode.qrcode({text: $qrcode.data("checkin-url"), width: 180, height: 180});
  }

  $("div.checkin button").on("click", function () {
    var checkin_code = $("div.checkin button").siblings("input").val();
    if (checkin_code == "") {
      return false;
    }

    checkin_url = window.location.pathname + "/checkin/" + checkin_code;
    $.getJSON(checkin_url, function(data) {
      $message = $('<div class="alert" title="Alert"><a href="#" class="close" data-dismiss="alert">×</a><div></div></div>');
      $message.children('div').text(data.message_body);
      if (data.message_type == "notice") {
        $message.addClass('alert-success');
      }
      $('#flash').detach();
      $flash = $('<div id="flash"></div>');
      $flash.append($message).prependTo('#content .container')

      if (data.keep == false) {
        $("div.checkin").slideToggle();
      }
    });
  });
});

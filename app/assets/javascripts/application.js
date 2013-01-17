//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker/core
//= require jquery-fileupload/basic
//= require jquery.textarea.caret
//= require_self

$(function() {
  var body = $('body');
  var datepickerDefaults = {
    language: I18n.locale,
    format: I18n.date.formats.datepicker,
    weekStart: parseInt(I18n.date.weekstart, 10)
  };

  body.on('click', '.datepicker-trigger', function() {
    var el = $(this).closest('.date').find('.datepicker');
    var datepicker = el.data('datepicker');
    if (datepicker === null || datepicker === undefined) {
      el.datepicker(datepickerDefaults).on('changeDate', function() {
        el.datepicker('hide');
      });
    }

    el.datepicker('show');
  });

  $('.fileupload').each(function(){
    $(this).fileupload({
      dataType: 'json',
      dropZone: $(this).closest('.uploadable-input'), // #206 http://git.io/DuKo8A
      add: function(e, data) {
        var el = $(this).parent();
        el.hide();
        el.next(".uploading").show();
        data.submit();
      },
      done: function (e, data) {
        $.each(data.result.files, function (index, file) {
          targetTextarea = $(e.target).closest('.control-group').find('textarea');
          markdownImage = "![" + file.url + "](" + file.url + ")";
          if (targetTextarea.val() != '') {
            markdownImage = "\n" + markdownImage + "\n";
          }
          targetTextarea.insertAtCursor(markdownImage);
        });
        var el = $(this).parent();
        el.show();
        el.next(".uploading").hide();
      }
    });
  });

  $('textarea.uploadable').
    on('focus', function() {
      $(this).next('p').addClass('focused');
    }).
    on('blur', function() {
      $(this).next('p').removeClass('focused');
    });
});

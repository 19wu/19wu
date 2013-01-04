//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker/core
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
});

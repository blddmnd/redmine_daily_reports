function showNotificationSettings (el) {
  if (el.checked) {
    $(el).closest('.fields-group').find('.group').fadeIn();
  } else {
    $(el).closest('.fields-group').find('.group').fadeOut();
  }
}

$(document).ready(function() {

  $('.js-daily-report-notify').on('click', function () {
    showNotificationSettings(this)
  });

  $('.js-daily-report-notify').each(function () {
    showNotificationSettings(this)
  });

});

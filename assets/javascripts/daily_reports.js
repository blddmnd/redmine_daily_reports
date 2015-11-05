function changeUrl () {
  var url = window.location.href.replace(window.location.search,'');
  url += '?date=';
  url += $('#datepicker').val();
  history.pushState({}, '', url);
}

function truncateReportText () {
  $('.daily-report-text').truncate({max_length: 100});
}

function setFormDatepicker () {
  var minDate = new Date($('#daily-report-date').data('min'));
  $('#daily-report-date').datepicker({
    maxDate: '0',
    minDate: minDate,
    dateFormat: 'yy-mm-dd'
  });
}

$(document).ready(function() {
  $('#datepicker').datepicker({
    maxDate: '0',
    dateFormat: 'yy-mm-dd',
    defaultDate: $('#report_date').val(),
    onSelect: function() {
      $.ajax({
        type: 'GET',
        url: window.location.href,
        data: { date: $(this).val() },
        dataType: 'script'
      });
    }
  });

  setFormDatepicker();
  truncateReportText();
});

$(document).on('change', '#daily_report_author_id, #daily-report-date', function () {
  $.ajax({
    type: 'GET',
    url: $('#daily_report_reload_form_url').val(),
    data: { date: $('#daily-report-date').val(), author_id: $('#daily_report_author_id').val() },
    dataType: 'script'
  });
});

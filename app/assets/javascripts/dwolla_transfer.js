jQuery(function($) {
  $('#payment_amount').on('keyup', function(e) {
    if ($('#payment_amount').val() != '') {
      tutor_id = $('#payment_payee_id').val();
      rate = $('#' + tutor_id + '_tutor_hourly_rate').val();
      var hours = parseFloat($('#payment_amount').val()) / parseFloat(rate);
      $('#tutor_hours').val(hours);
    }
  });

  $('#tutor_hours').on('keyup', function(e) {
    if ($('#tutor_hours').val() != '' && $('#tutor_hours').val() >= 0) {
      tutor_id = $('#payment_payee_id').val();
      rate = $('#' + tutor_id + '_tutor_hourly_rate').val();
      var total = parseFloat($('#tutor_hours').val()) * parseFloat(rate);
      $('#payment_amount').val(total);
    }
  });
});

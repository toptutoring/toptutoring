jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    // Disable the submit button to prevent repeated clicks
    $form.find('.payment_submit').prop('disabled', true);

    // Request a token from Stripe:
    Stripe.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });

  $('#amount').on('keydown', function(e) {
    $('#hours').val('0');
    $('#hourly_rate').val('0');
  });

  $('#hours').on('keyup', function(e) {
    if ($('#hourly_rate').val() != '') {
      console.log(parseInt($('#hours').val()))
      console.log(parseInt($('#hourly_rate').val()))
      console.log($('#hourly_rate').val())
      console.log(parseInt($('#hours').val()) * parseInt($('#hourly_rate').val()))
      var total = parseInt($('#hours').val()) * parseInt($('#hourly_rate').val());
      $('#amount').val(total);
    }
  });

  $('#hourly_rate').on('keyup', function(e) {
    if ($('#hours').val() != '') {
      console.log(parseInt($('#hours').val()))
      console.log(parseInt($('#hourly_rate').val()))
      console.log($('#hourly_rate').val())
      console.log(parseInt($('#hours').val()) * parseInt($('#hourly_rate').val()))
      var total = parseInt($('#hours').val()) * parseInt($('#hourly_rate').val());
      $('#amount').val(total);
    }
  });

});

var stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form');
  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $form.find('.payment_submit').prop('disabled', false);
  } else {
    // token contains id, last4, and card type
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};

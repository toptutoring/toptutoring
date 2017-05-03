jQuery(function($) {
  setHourlyRate();

  // Client Payment page
  function setHourlyRate() {
    var type = $('.payment-academic-type').val();
    if (type == 'Academic') {
      $('.hourly-rate').text($('.hourly-rate').data('academic'));
    } else {
      $('.hourly-rate').text($('.hourly-rate').data('test-prep'));
    }
  }

  $('.payment-academic-type').on('change', function() {
    setHourlyRate();
  })

  // Admin/Director Payment page

  $('.tutor').on('change', function() {
    var rate = $('.tutor').find(":selected").data('hourly-rate');
    $('.hourly-rate').val(rate);
  })

  $('.payment-form').submit(function(event) {
    var publishable_key = $(this).find('#stripe_publishable_key').val();
    Stripe.setPublishableKey(publishable_key);
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('.payment_submit').prop('disabled', true);

    // Request a token from Stripe:
    Stripe.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });

  // Global payment side

  $('.amount').on('keyup', function(e) {
    var hourly_rate = parseFloat($('.hourly-rate').val() || $('.hourly-rate').text());
    if (!!hourly_rate) {
      var hours = (parseFloat($(this).val()) / hourly_rate) || 0;
      $('.hours').val(hours);
    }
  });

  $('.hours').on('keyup', function(e) {
    if (!!$('.hourly-rate').text()) {
      var hourly_rate = $('.hourly-rate').text();
    } else {
      var hourly_rate = $('.hourly-rate').val();
    }
    if (!!hourly_rate) {
      var total = parseFloat($(this).val()) * parseFloat(hourly_rate);
      $('.amount').val(total);
    }
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('.payment-form');
  if (response.error) {
    // Show the errors on the form
    $('.page-content').prepend("<div class='alert alert-danger alert-dismissible text-center' role='alert'>" +
    "<button type='button' class='close' data-dismiss='alert'><span aria-hidden='true'>×</span>" +
    "<span class='sr-only'>Close</span></button>" + response.error.message + "</div>");
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

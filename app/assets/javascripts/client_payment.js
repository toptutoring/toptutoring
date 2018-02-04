$(function() {
  if (document.getElementById('new_payment')) {
    setBalanceTypeForPayment();
    calculateHoursForPayment();
    setHourlyRateForPayment();
    calculateAmountForPayment();

    // Sets Stripe Key
    var publishable_key = $('#stripe_publishable_key').data('key');
    var stripe = Stripe(publishable_key)

    // Create an instance of Elements
    var elements = stripe.elements();

    var card = elements.create('card', {
      style: {
        base: {
          color: '#555',
          fontFamily: 'inherit',
          fontSmoothing: 'antialiased',
          fontSize: '14px',
          '::placeholder': {
            color: '#999'
          }
        }
      }
    });

    // Add an instance of the card Element into the `card-element` <div>
    card.mount('#card-element');

    // Show live error feedback
    card.addEventListener('change', function(event) {
      var displayError = $('#card-error');
      if (event.error) {
        displayError.text(event.error.message);
      } else {
        displayError.text('');
      }
    });

    // Create Stripe Token upon submit
    var form = document.getElementById('new_payment');

    form.addEventListener('submit', function(event) {
      $('input[type=submit]').attr('disabled', true);
      event.preventDefault();
      var options = { name: document.getElementById('payment_card_holder_name').value }

      stripe.createToken(card, options).then(function(result) {
        if (result.error) {
          // Inform the customer that there was an error
          var errorElement = document.getElementById('card-error');
          errorElement.textContent = result.error.message;
          $('input[type=submit]').attr('disabled', false);
        } else {
          // Send the token to your server
          stripeTokenHandler(result.token);
        }
      });
    });

    $('#payment_hours_type').on('change', function() {
      setBalanceTypeForPayment();
      calculateHoursForPayment();
      setHourlyRateForPayment();
      calculateAmountForPayment();
    });

    $('#payment_hours_purchased').on('change', function() {
      calculateHoursForPayment();
      calculateAmountForPayment();
    });
  }

  function setBalanceTypeForPayment() {
    var type = $('#payment_hours_type').val();
    var hours;
    if (type == 'online_academic') {
      $('#hour-type').text("Online Academic Hours");
      hours = $('#current-hours').data('online-academic');
    } else if (type == 'online_test_prep') {
      $('#hour-type').text("Online Test Prep Hours");
      hours = $('#current-hours').data('online-test');
    } else if (type == 'in_person_academic') {
      $('#hour-type').text("In-Person Academic Hours");
      hours = $('#current-hours').data('in-person-academic');
    } else if (type == 'in_person_test_prep') {
      $('#hour-type').text("In-Person Test Prep Hours");
      hours = $('#current-hours').data('in-person-test');
    }
    hours = parseFloat(hours).toFixed(2);
    $('#current-hours').text(hours);
  }

  function calculateHoursForPayment() {
    var type = $('#payment_hours_type').val();
    var currentHours;
    var purchaseHours;
    if (type == 'online_academic') {
      currentHours = $('#current-hours').data('online-academic');
    } else if (type == 'online_test_prep') {
      currentHours = $('#current-hours').data('online-test');
    } else if (type == 'in_person_academic') {
      currentHours = $('#current-hours').data('in-person-academic');
    } else if (type == 'in_person_test_prep') {
      currentHours = $('#current-hours').data('in-person-test');
    }

    currentHours = parseFloat(currentHours);
    purchaseHours = parseFloat($("#payment_hours_purchased").val());
    if (isNaN(purchaseHours)) {
      purchaseHours = 0
    }
    newHours = (currentHours + purchaseHours).toFixed(2);
    $('#after-purchase-hours').text(newHours);
  }

  function setHourlyRateForPayment() {
    var type = $('#payment_hours_type').val();
    if (type == 'online_academic') {
      rate = $('#hourly-rate-display').data('online-academic');
    } else if (type == 'online_test_prep') {
      rate = $('#hourly-rate-display').data('online-test');
    } else if (type == 'in_person_academic') {
      rate = $('#hourly-rate-display').data('in-person-academic');
    } else if (type == 'in_person_test_prep') {
      rate = $('#hourly-rate-display').data('in-person-test');
    }
    rate = parseFloat(rate).toFixed(2);
    $('#hourly-rate-display').text("$".concat(rate));
  };

  function calculateAmountForPayment() {
    var type = $('#payment_hours_type').val();
    var rate;
    if (type == 'online_academic') {
      rate = $('#hourly-rate-display').data('online-academic');
    } else if (type == 'online_test_prep') {
      rate = $('#hourly-rate-display').data('online-test');
    } else if (type == 'in_person_academic') {
      rate = $('#hourly-rate-display').data('in-person-academic');
    } else if (type == 'in_person_test_prep') {
      rate = $('#hourly-rate-display').data('in-person-test');
    }
    rate = parseFloat(rate);
    var hours = parseFloat($("#payment_hours_purchased").val());
    var total = (hours * rate).toFixed(2);
    total = isNaN(total) ? '0.00' : total;
    $('#payment-total-display').text("$".concat(total));
  };

  function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var tokenInput = document.createElement('input');
    var lastFourInput = document.createElement('input');
    var cardBrandInput = document.createElement('input');

    tokenInput.setAttribute('type', 'hidden');
    tokenInput.setAttribute('name', 'stripe_token');
    tokenInput.setAttribute('value', token.id);
    form.appendChild(tokenInput);

    lastFourInput.setAttribute('type', 'hidden');
    lastFourInput.setAttribute('name', 'payment[last_four]');
    lastFourInput.setAttribute('value', token.card.last4);
    form.appendChild(lastFourInput);

    cardBrandInput.setAttribute('type', 'hidden');
    cardBrandInput.setAttribute('name', 'payment[card_brand]');
    cardBrandInput.setAttribute('value', token.card.brand);
    form.appendChild(cardBrandInput);

    // Submit the form
    form.submit();
  }
});

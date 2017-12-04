jQuery(function($) {
  setBalanceType();
  calculateHours();
  setHourlyRate();
  calculateAmount();

  $('#academic_type').on('change', function() {
    setBalanceType();
    calculateHours();
    setHourlyRate();
    calculateAmount();
  })

  $('#hours_desired').on('change', function() {
    calculateHours();
    calculateAmount();
  })

  function setBalanceType() {
    var type = $('#academic_type').val();
    var hours;
    if (type == 'academic') {
      $('#hour-type').text("Academic Hours");
      hours = $('#current-hours').data('academic');
    } else {
      $('#hour-type').text("Test Prep Hours");
      hours = $('#current-hours').data('test');
    }
    hours = parseFloat(hours).toFixed(2);
    $('#current-hours').text(hours);
  }

  function calculateHours() {
    var type = $('#academic_type').val();
    var currentHours;
    var purchaseHours;
    if (type == 'academic') {
      currentHours = $('#current-hours').data('academic');
    } else {
      currentHours = $('#current-hours').data('test');
    }
    currentHours = parseFloat(currentHours);
    purchaseHours = parseFloat($("#hours_desired").val());
    newHours = (currentHours + purchaseHours).toFixed(2);
    $('#after-purchase-hours').text(newHours);
  }

  function setHourlyRate() {
    var type = $('#academic_type').val();
    if (type == 'academic') {
      rate = $('#hourly-rate-display').data('academic');
    } else {
      rate = $('#hourly-rate-display').data('test');
    }
    rate = parseFloat(rate).toFixed(2);
    $('#hourly-rate-display').text(`$${rate}`);
  };

  function calculateAmount() {
    var type = $('#academic_type').val();
    var rate;
    if (type == 'academic') {
      rate = $('#hourly-rate-display').data('academic');
    } else {
      rate = $('#hourly-rate-display').data('test');
    }
    rate = parseFloat(rate);
    var hours = parseFloat($("#hours_desired").val());
    var total = (hours * rate).toFixed(2);
    total = isNaN(total) ? '0.00' : total;
    $('#payment-total-display').text(`$${total}`);
  };

  var publishable_key = $('#stripe_publishable_key').data('key');
  var stripe = Stripe(publishable_key)
  // Create an instance of Elements
  var elements = stripe.elements();

  var card = elements.create('card', {
    style: {
      base: {
          color: '#32325d',
          lineHeight: '24px',
          fontFamily: 'inherit',
          fontSmoothing: 'antialiased',
          fontWeight: '300',
          fontSize: '24px',
          '::placeholder': {
            color: '#aab7c4'
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

    stripe.createToken(card).then(function(result) {
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

  function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token.id);
    form.appendChild(hiddenInput);

    // Submit the form
    form.submit();
  }
});

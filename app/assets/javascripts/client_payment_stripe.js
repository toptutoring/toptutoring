$(function() {
  if (document.getElementById('card_parameters')) {
    // Sets Stripe Key
    var publishable_key = $('#stripe_publishable_key').data('key');
    var stripe = Stripe(publishable_key)

    // Create an instance of Elements
    var elements = stripe.elements();

    var card = elements.create('card', {
      hidePostalCode: true,
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
    var form = document.getElementsByClassName('stripe_form')[0];

    form.addEventListener('submit', function(event) {
      $('input[type=submit]').attr('disabled', true);
      event.preventDefault();
      if (document.getElementById("use_new_card").checked) {
        var options = { name: document.getElementById('card_holder_name').value,
          address_line1: document.getElementById('card_address').value,
          address_line2: document.getElementById('card_unit_number').value,
          address_zip: document.getElementById('card_zip_code').value,
          address_city: document.getElementById('card_city').value,
          address_state: document.getElementById('card_state').value }

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
      }
    });
  }

  function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var tokenInput = document.createElement('input');

    tokenInput.setAttribute('type', 'hidden');
    tokenInput.setAttribute('name', 'stripe_token');
    tokenInput.setAttribute('value', token.id);
    form.appendChild(tokenInput);

    // Submit the form
    form.submit();
  }
});

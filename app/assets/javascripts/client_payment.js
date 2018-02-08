$(function() {
  if (document.getElementById('new_payment')) {
    setBalanceTypeForPayment();
    calculateHoursForPayment();
    setHourlyRateForPayment();
    calculateAmountForPayment();
    toggleCardView()

    var new_card = document.getElementById('use_new_card')
    if (new_card) {
      new_card.addEventListener('click', toggleCardView)
    }

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

  function toggleCardView() {
    var cardParams = document.getElementById("card_parameters");
    if (document.getElementById('use_new_card').checked) {
      cardParams.classList.remove("hidden");
      document.getElementById('card_holder_name').required = true
      document.getElementById('card_address').required = true
      document.getElementById('card_zip_code').required = true
      document.getElementById('card_city').required = true
    } else {
      cardParams.classList.add("hidden");
      document.getElementById('card_holder_name').required = false
      document.getElementById('card_address').required = false
      document.getElementById('card_zip_code').required = false
      document.getElementById('card_city').required = false
    }
  };
});

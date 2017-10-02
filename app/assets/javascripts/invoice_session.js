$(function() {
  setHoursDropDown();
  processTutorType();

  function setHoursDropDown() {
    $('.hours').empty();
    $('.hours').append($('<option>', {
      value: 0,
      text : "24 hour Cancellation (No hours are charged)"
    }));
    $('.hours').append($('<option>', {
      value: 0.5,
      text : "No show (Client will be charged for 30 mins)"
    }));
    create_hour_options(5);
  }

  function create_hour_options(limit) {
    for(var i = 0.5; i <= limit; i+= 0.5) {
      $('.hours').append($('<option>', {
        value: i,
        text : i
      }));
    }
  }
  function setHoursDropDownForContractor() {
    $('.hours').empty();
    create_hour_options(160);
  }

  function processTutorType() {
    var $selectedOption = $('.student').find(":selected");
    var creditAcademic  = $selectedOption.data('academic');
    var creditTestPrep  = $selectedOption.data('test-prep');
    var assigned        = $selectedOption.data('assigned');

    $('.academic_type').empty();

    if(assigned == 'Academic') {
      $('.academic_type').append($('<option>', {
        value: "Academic",
        text : "Academic - " + creditAcademic + " hours"
      }));
    }

    if(assigned == 'Test_Prep') {
      $('.academic_type').append($('<option>', {
        value: "Test_Prep",
        text : "Test Preparation - " + creditTestPrep + " hours"
      }));
    }
  }

  $(document).on('change', '.student', function() {
    processTutorType();
  });

  $(document).on('change', '#invoice_submitter_type', function() {
    var submitter_type  = $('#invoice_submitter_type').val()
    if(submitter_type === 'by_contractor') {
      $('.only-for-tutors').addClass('hidden');
      setHoursDropDownForContractor();
    } else if(submitter_type === 'by_tutor') {
      $('.only-for-tutors').removeClass('hidden');
      setHoursDropDown();
    }
  });
})

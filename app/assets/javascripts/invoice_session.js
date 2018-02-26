$(function() {
  update_form_for_submitter_type();
  processTutorType();

  function setHoursDropDown() {
    $('.invoice_hours').empty();
    $('.invoice_hours').append($('<option>', {
      value: 0,
      text : "24 hour Cancellation (No hours are charged)"
    }));
    $('.invoice_hours').append($('<option>', {
      value: 'no_show',
      text : "No show"
    }));
    create_hour_options(5);
  };

  function create_hour_options(limit) {
    for(var i = 0.5; i <= limit; i+= 0.5) {
      $('.invoice_hours').append($('<option>', {
        value: i,
        text : i
      }));
    }
  };

  function setHoursDropDownForContractor() {
    $('.invoice_hours').empty();
    create_hour_options(160);
  };

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
  };

  function update_form_for_submitter_type() {
    var submitter_type  = $('#invoice_submitter_type').val()
    var description = document.getElementById('invoice_description')
    if(submitter_type === 'by_contractor') {
      $('.only-for-tutors').addClass('hidden');
      $('#invoice_engagement_id').attr("required", false);
      $('#invoice_subject').attr("required", false);
      $('#invoice_session_rating_5').attr('required', false)
      description.placeholder = "Please give a description of the work that was completed."
      setHoursDropDownForContractor();
    } else if(submitter_type === 'by_tutor') {
      $('.only-for-tutors').removeClass('hidden');
      $('#invoice_engagement_id').attr("required", true);
      $('#invoice_subject').attr("required", true);
      $('#invoice_session_rating_5').attr('required', true)
      description.placeholder = "What went well?\nDo you see any improvement?\nWhat does your student need to work on?\nHow could you improve upon the session?"
      setHoursDropDown();
    }
  }

  $(document).on('change', '.invoice_tutor_student', function() {
    processTutorType();
  });

  $(document).on('change', '#invoice_submitter_type', update_form_for_submitter_type);
});

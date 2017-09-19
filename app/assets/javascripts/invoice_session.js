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
    for(var i = 1; i <= 5; i+= 0.5) {
      $('.hours').append($('<option>', {
        value: i,
        text : i
      }));
    }
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
})

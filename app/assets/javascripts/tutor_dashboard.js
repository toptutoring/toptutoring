$(function() {
  'use strict'

  setHoursDropDown();
  processTutorType();

  function setHoursDropDown() {
    $('.hours').empty();
    $('.hours').append($('<option>', {
      value: 0,
      text : "24 hour Cancelation"
    }));
    $('.hours').append($('<option>', {
      value: 0.5,
      text : "No show"
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
    $('.academic_type').empty();
    $('.academic_type').append($('<option>', {
      value: "Academic",
      text : "Academic - " + creditAcademic + "hours"
    }));
    $('.academic_type').append($('<option>', {
      value: "Test_Prep",
      text : "Test PreParation - " + creditTestPrep + "hours"
    }));
  }

  $(document).on('change', '.student', function() {
    processTutorType();
  });
  
})
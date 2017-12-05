$( window ).load(function() {
  $(".actions a[href$='#finish']").on("click", function() {
    $(".hidden-submit").click();
  });
  $("#cvv").popover({
    trigger: 'hover'
  });
});

$(document).ready(function(){
  $('#form-vertical').steps({
    headerTag: 'h3',
    bodyTag: 'fieldset',
    transitionEffect: 'slide',
    stepsOrientation: 'vertical',
    onStepChanging: function(event, currentIndex, newIndex) {
      if (newIndex < currentIndex) {
        return true;
      } else if (!$('#form-vertical').parsley().validate({group: 'block-' + currentIndex})) {
        return false;
      } else {
        return true;
      }
    }
  });
});

$(window).load(function() {
  var $sections = $('#form-vertical fieldset');

  function navigateTo(index) {
   // Mark the current section with the class 'current'
   $sections
     .removeClass('current')
     .eq(index)
       .addClass('current');
  }

  // Prepare sections by setting the `data-parsley-group` attribute to 'block-0', 'block-1', etc.
  $sections.each(function(index, section) {
    $(section).find(':input').attr('data-parsley-group', 'block-' + index);
  });
  navigateTo(0); // Start at the beginning
});

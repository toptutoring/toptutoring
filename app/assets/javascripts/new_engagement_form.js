jQuery(function($) {
  require_email();

  function require_email() {
    var name = $('#create_user_account').is(":checked");
    if (name == true) {
      $('#student_user_email').attr("required", true);
    } else {
      $('#student_user_email').attr("required", false);
    }
  }

  $('#create_user_account').on('change', function() {
    require_email();
  })

});

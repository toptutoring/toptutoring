jQuery(function($) {
  require_email();

  function require_email() {
    var name = $('#create_user_account').is(":checked");
    if (name == true) {
      $('#user_email').attr("required", true);
    } else {
      $('#user_email').attr("required", false);
    }
  }

  $('#create_user_account').on('change', function() {
    require_email();
  })

});

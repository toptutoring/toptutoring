// User sign-up form javascript
function SignUp() {

  $( "#user-sign-up" ).submit(function( event ) {

      // Stop form from submitting
      event.preventDefault();

      // Get values from sign-up form
      var $name = $('#first-name').val() + " " + $('#last-name').val();
      var $email = $('#email').val();
      var $password = $('#password').val();
      var $password_confirmation = $('#password-confirm').val();
      var $academic_type = $('select#academic-type').val();

      if($password != $password_confirmation) {
        // Append errors.
        $('.form-errors').html('Passwords must match!');
      }
      else {
      $.ajax({
        type: "POST",
        url: "https://toptutoring.herokuapp.com/api/signups/users",
        data: { user: { name: $name, email: $email, password: $password , student_attributes: { academic_type: $academic_type } } },
        success: function(response) {
          // Submit message.
          $('.sign-up-container').html('<h3>Your account has been created.</h3><a class="btn btn-lg mb32 mt-xs-40" href="https://toptutoring.herokuapp.com/sign_in">Login</a>');
        },
        error: function(XMLHttpRequest, textStatus) {
          // Append errors.
          errors = JSON.parse(XMLHttpRequest.responseText)
          $('.form-errors').html(errors);
        }
      });
    }
  });

  $( "#tutor-sign-up" ).submit(function( event ) {

      // Stop form from submitting
      event.preventDefault();

      // Get values from sign-up form
      var $name = $('#first-name').val() + " " + $('#last-name').val();
      var $email = $('#email').val();
      var $password = $('#password').val();
      var $password_confirmation = $('#password-confirm').val();
      var $academic_type = $('select#academic-type').val();

      if($password != $password_confirmation) {
        // Append errors.
        $('.form-errors').html('Passwords must match!');
      }
      else {
        $.ajax({
          type: "POST",
          url: "https://toptutoring.herokuapp.com/api/signups/tutors",
          data: { user: { name: $name, email: $email, password: $password , tutor_attributes: { academic_type: $academic_type } } },
          success: function(response) {
            // Submit message.
            $('.sign-up-container').html('<h3>Your account has been created.</h3><a class="btn btn-lg mb32 mt-xs-40" href="https://toptutoring.herokuapp.com/sign_in">Login</a>');
          },
          error: function(XMLHttpRequest, textStatus) {
            // Append errors.
            errors = JSON.parse(XMLHttpRequest.responseText)
            $('.form-errors').html(errors);
          }
        });
      }
    });
}

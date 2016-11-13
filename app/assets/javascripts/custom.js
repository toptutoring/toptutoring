$(document).ready(function() {
  custom.fixLayoutPadding();
});

var custom = {};

custom.fixLayoutPadding = function() {
  var targetElems = ['.alert', '#feature_slider'];
  targetElems.forEach(function(element) {
    if ($(element).length)
      $('body').addClass('no-padding');
  });
}

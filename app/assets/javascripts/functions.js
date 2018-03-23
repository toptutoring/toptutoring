renderTopTutoringFlashes = function(html) {
  document.getElementById('top-tutoring-flashes').innerHTML = html;
}

copyToClipboard = function(copy_id) {
  var copyText = document.getElementById(copy_id);
  copyText.select();
  document.execCommand("Copy");
  var copyConfirm = document.getElementById("copy-confirm");
  copyConfirm.classList.add("show-confirm");

  setTimeout(function() {
    copyConfirm.classList.remove('show-confirm');
  }, 600);
}

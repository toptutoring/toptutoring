renderTopTutoringFlashes = function(html) {
  document.getElementById('top-tutoring-flashes').innerHTML = html;
}

copyToClipboard = function(copyId, confirmId) {
  var copyText = document.getElementById(copyId);
  copyText.select();
  document.execCommand('Copy');
  var copyConfirm = document.getElementById(confirmId);
  confirmDialogShow(copyConfirm);
}

confirmDialogShow = function(confirmElement) {
  confirmElement.classList.add('show-confirm');
  
  setTimeout(function() {
    confirmElement.classList.remove('show-confirm');
  }, 600);
}

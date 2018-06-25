renderTopTutoringFlashes = function(html) {
  document.getElementById('top-tutoring-flashes').innerHTML = html;
};

copyToClipboard = function(copyId, confirmId) {
  var copyText = document.getElementById(copyId);
  copyText.select();
  document.execCommand('Copy');
  var copyConfirm = document.getElementById(confirmId);
  confirmDialogShow(copyConfirm);
};

confirmDialogShow = function(confirmElement) {
  confirmElement.classList.add('show-confirm');
  
  setTimeout(function() {
    confirmElement.classList.remove('show-confirm');
  }, 600);
};

updateBadges = function(title_id, count) {
  badge = document.getElementById(title_id);
  if (count > 0) {
    badge.innerHTML = count;
  } else {
    badge.parentNode.removeChild(badge);
  };
};

smoothScroll = function(e, link) {
  e.preventDefault();
  document.querySelector(link.attributes.href.value).scrollIntoView({ behavior: 'smooth', block: 'start' });
}

createDataTable = function(tableID, order, lengthOption) {
  var lengthMenu

  if (lengthOption == "5") {
    lengthMenu =  [[5, 10, 15, -1], [5, 10, 15, "All"]]
  } else {
    lengthMenu = [[10, 20, 50, -1], [10, 20, 50, "All"]] 
  }

  $(tableID).DataTable({
    order:[0, order],
    "lengthMenu": lengthMenu
  });
}

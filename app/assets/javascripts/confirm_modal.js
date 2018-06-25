showConfirmModal = function(event, confirmTitle, body, path, method, remote, warning) {
  event.preventDefault();
  var modal = $("#confirm-modal");
  var header = document.getElementById("confirm-modal-header");
  var bodyParagraph = document.getElementById("confirm-modal-body");
  var warningParagraph = document.getElementById("confirm-modal-warning");

  header.innerText = confirmTitle;
  if(warning !== "false") {
    header.parentNode.classList.add("bg-danger");
    header.parentNode.classList.remove("bg-primary");
    warningParagraph.innerText = warning;
    warningParagraph.classList.remove("hide");
  } else {
    header.parentNode.classList.add("bg-primary");
    header.parentNode.classList.remove("bg-danger");
    warningParagraph.classList.add("hide");
  }

  bodyParagraph.innerText = body;
  var confirmLink = document.getElementById("confirm-modal-link");
  confirmLink.href = path;
  confirmLink.setAttribute("data-method", method);

  if(remote) {
    confirmLink.setAttribute("data-remote", "remote");
  }
  modal.modal("toggle");
};

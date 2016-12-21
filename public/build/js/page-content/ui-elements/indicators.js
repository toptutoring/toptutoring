$(document).ready(function() {
    $(function() {
        var i = -1;
        var toastCount = 0;
        var $toastlast;
        var getMessage = function() {
            var msgs = ['You have 6 notifications', 'You have 3 unread emails'];
            i++;
            if (i === msgs.length) {
                i = 0;
            }
            return msgs[i];
        };
        var getMessageWithClearButton = function(msg) {
            msg = msg ? msg : 'Clear itself?';
            msg += '<br /><br /><button type="button" class="btn clear">Yes</button>';
            return msg;
        };
        $('#showtoast').click(function() {
            var shortCutFunction = $("#toastTypeGroup input:radio:checked").val();
            var msg = $('#message').val();
            var title = $('#title').val() || 'Hello, my name is <strong>TOASTR</strong>';
            var $showDuration = $('#showDuration');
            var $hideDuration = $('#hideDuration');
            var $timeOut = $('#timeOut');
            var $extendedTimeOut = $('#extendedTimeOut');
            var $showEasing = $('#showEasing');
            var $hideEasing = $('#hideEasing');
            var $showMethod = $('#showMethod');
            var $hideMethod = $('#hideMethod');
            var toastIndex = toastCount++;
            var addClear = $('#addClear').prop('checked');
            toastr.options = {
                closeButton: $('#closeButton').prop('checked'),
                debug: $('#debugInfo').prop('checked'),
                newestOnTop: $('#newestOnTop').prop('checked'),
                progressBar: $('#progressBar').prop('checked'),
                positionClass: $('#positionGroup input:radio:checked').val() || 'toast-top-right',
                preventDuplicates: $('#preventDuplicates').prop('checked'),
                onclick: null
            };
            if ($('#addBehaviorOnToastClick').prop('checked')) {
                toastr.options.onclick = function() {
                    alert('You can perform some custom action after a toast goes away');
                };
            }
            if ($showDuration.val().length) {
                toastr.options.showDuration = $showDuration.val();
            }
            if ($hideDuration.val().length) {
                toastr.options.hideDuration = $hideDuration.val();
            }
            if ($timeOut.val().length) {
                toastr.options.timeOut = addClear ? 0 : $timeOut.val();
            }
            if ($extendedTimeOut.val().length) {
                toastr.options.extendedTimeOut = addClear ? 0 : $extendedTimeOut.val();
            }
            if ($showEasing.val().length) {
                toastr.options.showEasing = $showEasing.val();
            }
            if ($hideEasing.val().length) {
                toastr.options.hideEasing = $hideEasing.val();
            }
            if ($showMethod.val().length) {
                toastr.options.showMethod = $showMethod.val();
            }
            if ($hideMethod.val().length) {
                toastr.options.hideMethod = $hideMethod.val();
            }
            if (addClear) {
                msg = getMessageWithClearButton(msg);
                toastr.options.tapToDismiss = false;
            }
            if (!msg) {
                msg = getMessage();
            }
            $('#toastrOptions').text('Command: toastr["' + shortCutFunction + '"]("' + msg + (title ? '", "' + title : '') + '")\n\ntoastr.options = ' + JSON.stringify(toastr.options, null, 2));
            var $toast = toastr[shortCutFunction](msg, title); // Wire up an event handler to a button in the toast, if it exists
            $toastlast = $toast;
            if (typeof $toast === 'undefined') {
                return;
            }
            if ($toast.find('#okBtn').length) {
                $toast.delegate('#okBtn', 'click', function() {
                    alert('you clicked me. i was toast #' + toastIndex + '. goodbye!');
                    $toast.remove();
                });
            }
            if ($toast.find('#surpriseBtn').length) {
                $toast.delegate('#surpriseBtn', 'click', function() {
                    alert('Surprise! you clicked me. i was toast #' + toastIndex + '. You could perform an action here.');
                });
            }
            if ($toast.find('.clear').length) {
                $toast.delegate('.clear', 'click', function() {
                    toastr.clear($toast, {
                        force: true
                    });
                });
            }
        });

        function getLastToast() {
            return $toastlast;
        }
        $('#clearlasttoast').click(function() {
            toastr.clear(getLastToast());
        });
        $('#cleartoasts').click(function() {
            toastr.clear();
        });
    });

    $('#sweet-1').on('click', function() {
        swal({
            title: 'Here\'s a message!',
            confirmButtonClass: 'btn-raised btn-primary',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-2').on('click', function() {
        swal({
            title: 'Here\'s a message!',
            text: 'It\'s pretty, isn\'t it?',
            confirmButtonClass: 'btn-raised btn-primary',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-3').on('click', function() {
        swal({
            title: 'Good job!',
            text: 'You clicked the button!',
            type: 'success',
            confirmButtonClass: 'btn-raised btn-success',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-4').on('click', function() {
        swal({
            title: 'Good job!',
            text: 'You clicked the button!',
            type: 'info',
            confirmButtonClass: 'btn-raised btn-info',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-5').on('click', function() {
        swal({
            title: 'Good job!',
            text: 'You clicked the button!',
            type: 'warning',
            confirmButtonClass: 'btn-raised btn-warning',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-6').on('click', function() {
        swal({
            title: 'Good job!',
            text: 'You clicked the button!',
            type: 'error',
            confirmButtonClass: 'btn-raised btn-danger',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-7').on('click', function() {
        swal({
            title: 'Are you sure?',
            text: 'Your will not be able to recover this imaginary file!',
            type: 'warning',
            showCancelButton: true,
            cancelButtonClass: 'btn-raised btn-default',
            cancelButtonText: 'Cancel!',
            confirmButtonClass: 'btn-raised btn-danger',
            confirmButtonText: 'Yes, delete it!',
            closeOnConfirm: false
        }, function() {
            swal({
                title: 'Deleted!',
                text: 'Your imaginary file has been deleted.',
                type: 'success',
                confirmButtonClass: 'btn-raised btn-success',
                confirmButtonText: 'OK'
            });
        });
    });

    $('#sweet-8').on('click', function() {
        swal({
            title: 'Are you sure?',
            text: 'You will not be able to recover this imaginary file!',
            type: 'warning',
            showCancelButton: true,
            confirmButtonClass: 'btn-raised btn-danger',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonClass: 'btn-raised btn-default',
            cancelButtonText: 'No, cancel plx!',
            closeOnConfirm: false,
            closeOnCancel: false
        }, function(isConfirm) {
            if (isConfirm) {
                swal({
                    title: 'Deleted!',
                    text: 'Your imaginary file has been deleted.',
                    type: 'success',
                    confirmButtonClass: 'btn-raised btn-success',
                    confirmButtonText: 'OK'
                });
            } else {
                swal({
                    title: 'Cancelled',
                    text: 'Your imaginary file is safe :)',
                    type: 'error',
                    confirmButtonClass: 'btn-raised btn-danger',
                    confirmButtonText: 'OK'
                });
            }
        });
    });

    $('#sweet-9').on('click', function() {
        swal({
            title: 'Auto close alert!',
            text: 'I will close in 2 seconds.',
            timer: 2000,
            confirmButtonClass: 'btn-raised btn-primary',
            confirmButtonText: 'OK'
        });
    });

    $('#sweet-10').on('click', function() {
        swal({
            title: 'Sweet!',
            text: 'Here\'s a custom image.',
            imageUrl: 'build/images/logo/logo-dark.png',
            confirmButtonClass: 'btn-raised btn-primary',
            confirmButtonText: 'OK'
        });
    });

});
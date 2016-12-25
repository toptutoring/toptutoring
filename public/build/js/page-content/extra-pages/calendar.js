$(document).ready(function() {

    // External Events
    // --------------------------------------------------

    $('.draggable li').each(function() {
        $(this).data('event', {
            title: $.trim($(this).text()),
            stick: true
        });
        $(this).draggable({
            zIndex: 999,
            revert: true,
            revertDuration: 0
        });
    });
    $('#fullcalendar').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        buttonIcons: {
            prev: ' ion-arrow-left-c',
            next: ' ion-arrow-right-c'
        },
        defaultDate: '2016-03-15',
        editable: true,
        droppable: true,
        selectable: true,
        select: function(start, end, allDay) {
            $('#start').val(moment(start).format('YYYY/MM/DD hh:mm a'));
            $('#end').val(moment(end).format('YYYY/MM/DD hh:mm a'));
            $('#inputTitleEvent').val('');
            $('#addNewEvent').modal('show');
        },
        eventColor: '#1F364F',
        eventLimit: true,
        events: [{
            title: 'Biology with Sarah',
            start: '2016-03-18',
            color: '#8E23E0'
        }, {
            title: 'Math with Jessica',
            start: '2016-03-07',
            end: '2016-03-10',
            color: '#E5343D'
        }, {
            id: 999,
            title: 'Math with Paul',
            start: '2016-03-28T16:00:00',
            color: '#FFB61E'
        }, {
            id: 999,
            title: 'Math with Paul',
            start: '2016-03-16T16:00:00',
            color: '#FFB61E'
        }],
        drop: function() {
            if ($('#drop-remove').is(':checked')) {
                $(this).remove();
            }
        }
    });
    $('#btnAddNewEvent').on('click', function(e) {
        e.preventDefault();
        addNewEvent();
    });

    function addNewEvent() {
        $('#addNewEvent').modal('hide');
        $('#fullcalendar').fullCalendar('renderEvent', {
            title: $('#inputTitleEvent').val(),
            start: new Date($('#start').val()),
            end: new Date($('#end').val()),
            color: $('#inputBackgroundEvent').val()
        }, true);
    }

    // jQuery Minicolors
    // --------------------------------------------------

    $('#inputBackgroundEvent').minicolors({
        theme: 'bootstrap'
    });

});

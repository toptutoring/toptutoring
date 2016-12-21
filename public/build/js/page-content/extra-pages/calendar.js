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
            title: 'All Day Event',
            start: '2016-03-18',
            color: '#8E23E0'
        }, {
            title: 'Long Event',
            start: '2016-03-07',
            end: '2016-03-10',
            color: '#E5343D'
        }, {
            id: 999,
            title: 'Repeating Event',
            start: '2016-03-28T16:00:00',
            color: '#FFB61E'
        }, {
            id: 999,
            title: 'Repeating Event',
            start: '2016-03-16T16:00:00',
            color: '#FFB61E'
        }, {
            title: 'Conference',
            start: '2016-03-11',
            end: '2016-03-13',
            color: '#17A88B'
        }, {
            title: 'Meeting',
            start: '2016-03-12T10:30:00',
            end: '2016-03-12T12:30:00',
            color: '#0667D6'
        }, {
            title: 'Lunch',
            start: '2016-03-12T12:00:00',
            color: '#1F364F'
        }, {
            title: 'Meeting',
            start: '2016-03-12T14:30:00',
            color: '#E5343D'
        }, {
            title: 'Happy Hour',
            start: '2016-03-12T17:30:00',
            color: '#888888'
        }, {
            title: 'Dinner',
            start: '2016-03-12T20:00:00',
            color: '#0667D6'
        }, {
            title: 'Birthday Party',
            start: '2016-03-13T07:00:00',
            color: '#8E23E0'
        }, {
            title: 'Click for Google',
            url: 'http://google.com/',
            start: '2016-03-28',
            color: '#0667D6'
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
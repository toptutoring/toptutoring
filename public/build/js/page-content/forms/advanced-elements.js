$(document).ready(function() {

    // Bootstrap Maxlength
    // --------------------------------------------------

    $('#default-maxlength').maxlength()

    $('#threshold-maxlength').maxlength({
        threshold: 20
    })

    $('#moreoptions-maxlength').maxlength({
        alwaysShow: true,
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-warning"
    })

    $('#alloptions-maxlength').maxlength({
        alwaysShow: true,
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-warning",
        separator: ' of ',
        preText: 'You have ',
        postText: ' chars remaining.',
        validate: true
    })

    $('#textarea-maxlength').maxlength({
        alwaysShow: true
    })

    $('#placement-maxlength').maxlength({
        alwaysShow: true,
        placement: 'centered-right'
    })

    // jQuery Minicolors
    // --------------------------------------------------

    $('#hue-minicolors').minicolors({
        theme: 'bootstrap'
    })

    $('#saturation-minicolors').minicolors({
        control: 'saturation',
        theme: 'bootstrap'
    })

    $('#brightness-minicolors').minicolors({
        control: 'brightness',
        theme: 'bootstrap'
    })

    $('#wheel-minicolors').minicolors({
        control: 'wheel',
        theme: 'bootstrap'
    })

    $('#hidden-minicolors').minicolors({
        theme: 'bootstrap'
    })

    $('#inline-minicolors').minicolors({
        inline: true,
        theme: 'bootstrap'
    })

    $('#bottom-right-minicolors').minicolors({
        position: 'bottom right',
        theme: 'bootstrap'
    })

    $('#top-left-minicolors').minicolors({
        position: 'top left',
        theme: 'bootstrap'
    })

    $('#top-right-minicolors').minicolors({
        position: 'top right',
        theme: 'bootstrap'
    })

    $('#rgba-minicolors').minicolors({
        format: 'rgb',
        opacity: 0.5,
        theme: 'bootstrap'
    })

    $('#input-group-minicolors').minicolors({
        theme: 'bootstrap'
    })

    // Bootstrap Touchspin
    // --------------------------------------------------

    $('#postfix-touchspin').TouchSpin({
        min: 0,
        max: 100,
        step: 0.1,
        decimals: 2,
        boostat: 5,
        maxboostedstep: 10,
        postfix: '%',
        buttondown_class: 'btn btn-outline btn-default',
        buttonup_class: 'btn btn-outline btn-default',
    })

    $('#prefix-touchspin').TouchSpin({
        min: -1000000000,
        max: 1000000000,
        stepinterval: 50,
        maxboostedstep: 10000000,
        prefix: '$',
        buttondown_class: 'btn btn-outline btn-default',
        buttonup_class: 'btn btn-outline btn-default',
    })

    $('#vertical-touchspin').TouchSpin({
        verticalbuttons: true,
        verticalupclass: 'ti-plus',
        verticaldownclass: 'ti-minus',
        buttondown_class: 'btn btn-outline btn-default',
        buttonup_class: 'btn btn-outline btn-default',
    })

    $('#button-touchspin').TouchSpin({
        postfix: 'a button',
        postfix_extraclass: 'btn btn-outline btn-default',
        buttondown_class: 'btn btn-outline btn-default',
        buttonup_class: 'btn btn-outline btn-default',
    })

    $('#group-touchspin').TouchSpin({
        prefix: "pre",
        postfix: "post",
        buttondown_class: 'btn btn-outline btn-default',
        buttonup_class: 'btn btn-outline btn-default',
    })

    $('#change-touchspin').TouchSpin({
        buttondown_class: "btn btn-outline btn-black",
        buttonup_class: "btn btn-outline btn-black"
    })

    // Bootstrap Date Range Picker
    // --------------------------------------------------

    $('#daterangepicker').daterangepicker({
        ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
            'Last 7 Days': [moment().subtract('days', 6), moment()],
            'Last 30 Days': [moment().subtract('days', 29), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        },
        opens: 'left',
        startDate: moment().subtract(29, 'days'),
        endDate: moment(),
        applyClass: 'btn-raised btn-black',
        cancelClass: 'btn-raised btn-default'
    }, function(start, end, label) {
        $('#daterangepicker span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    });
    $('#daterangepicker span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));

    // Bootstrap Datetime Picker
    // --------------------------------------------------

    $('#datetimepicker1').datetimepicker();

    $('#datetimepicker3').datetimepicker({
        format: 'LT'
    });

    $('#datetimepicker5').datetimepicker({
        defaultDate: "11/1/2016",
        disabledDates: [
            moment("12/25/2016"),
            new Date(2013, 11 - 1, 21),
            "11/22/2016 00:53"
        ]
    });

    $('#datetimepicker8').datetimepicker({
        icons: {
            time: 'ti-time',
            date: 'ti-calendar',
            up: 'ti-arrow-up',
            down: 'ti-arrow-down',
            previous: 'ti-arrow-left',
            next: 'ti-arrow-right',
            today: 'ti-target',
            clear: 'ti-trash',
            close: 'ti-close'
        }
    });

    $('#datetimepicker9').datetimepicker({
        viewMode: 'years'
    });

    $('#datetimepicker12').datetimepicker({
        inline: true,
        sideBySide: true
    });

    // Geocomplete
    // --------------------------------------------------

    $("#geocomplete").geocomplete({
        map: ".map_canvas",
        details: ".attribute",
        detailsAttribute: "data-geo",
        location: "NYC"
    });
})
$(document).ready(function() {

    // Global Analytics
    // --------------------------------------------------

    var dataSale = {
        'AU': 12190,
        'AR': 3510,
        'BR': 2023,
        'CA': 1563,
        'CN': 5745,
        'FR': 2555,
        'DE': 3305,
        'JP': 5390,
        'RU': 2476,
        'US': 14624
    };
    var dataMapMarker = [{
        latLng: [41.90, 12.45],
        name: 'Vatican City',
        earnings: '500'
    }, {
        latLng: [43.73, 7.41],
        name: 'Monaco',
        earnings: '32'
    }, {
        latLng: [-0.52, 166.93],
        name: 'Nauru',
        earnings: '432'
    }, {
        latLng: [-8.51, 179.21],
        name: 'Tuvalu',
        earnings: '321'
    }, {
        latLng: [43.93, 12.46],
        name: 'San Marino',
        earnings: '510'
    }, {
        latLng: [47.14, 9.52],
        name: 'Liechtenstein',
        earnings: '130'
    }, {
        latLng: [7.11, 171.06],
        name: 'Marshall Islands',
        earnings: '234'
    }, {
        latLng: [17.3, -62.73],
        name: 'Saint Kitts and Nevis',
        earnings: '329'
    }, {
        latLng: [3.2, 73.22],
        name: 'Maldives',
        earnings: '120'
    }, {
        latLng: [35.88, 14.5],
        name: 'Malta',
        earnings: '435'
    }, {
        latLng: [12.05, -61.75],
        name: 'Grenada',
        earnings: '321'
    }, {
        latLng: [13.16, -61.23],
        name: 'Saint Vincent and the Grenadines',
        earnings: '110'
    }, {
        latLng: [13.16, -59.55],
        name: 'Barbados',
        earnings: '90'
    }, {
        latLng: [17.11, -61.85],
        name: 'Antigua and Barbuda',
        earnings: '230'
    }, {
        latLng: [-4.61, 55.45],
        name: 'Seychelles',
        earnings: '200'
    }, {
        latLng: [7.35, 134.46],
        name: 'Palau',
        earnings: '320'
    }, {
        latLng: [42.5, 1.51],
        name: 'Andorra',
        earnings: '123'
    }, {
        latLng: [14.01, -60.98],
        name: 'Saint Lucia',
        earnings: '500'
    }, {
        latLng: [6.91, 158.18],
        name: 'Federated States of Micronesia',
        earnings: '310'
    }, {
        latLng: [1.3, 103.8],
        name: 'Singapore',
        earnings: '23'
    }, {
        latLng: [1.46, 173.03],
        name: 'Kiribati',
        earnings: '58'
    }, {
        latLng: [-21.13, -175.2],
        name: 'Tonga',
        earnings: '90'
    }, {
        latLng: [15.3, -61.38],
        name: 'Dominica',
        earnings: '239'
    }, {
        latLng: [-20.2, 57.5],
        name: 'Mauritius',
        earnings: '100'
    }, {
        latLng: [26.02, 50.55],
        name: 'Bahrain',
        earnings: '225'
    }, {
        latLng: [0.33, 6.73],
        name: 'São Tomé and Príncipe',
        earnings: '150'
    }];
    $('#world-map').vectorMap({
        map: 'world_mill',
        backgroundColor: 'rgba(0,0,0,0)',
        zoomOnScroll: false,
        regionStyle: {
            initial: {
                fill: '#1F364F',
                "fill-opacity": 0.1,
                stroke: '#1F364F',
                'stroke-width': 1
            }
        },
        markers: dataMapMarker,
        markerStyle: {
            initial: {
                fill: '#E5343D',
                stroke: '#E5343D',
                'fill-opacity': 1,
                'stroke-width': 10,
                'stroke-opacity': 0.2,
                r: 5
            },
            hover: {
                stroke: '#1F364F',
                'stroke-width': 2,
                cursor: 'pointer'
            }
        },
        onRegionTipShow: function(e, el, code) {
            if (dataSale.hasOwnProperty(code)) {
                el.html(el.html() + ' ($' + dataSale[code] + ')');
            }
        },
        onMarkerTipShow: function(e, el, code) {
            el.html(el.html() + ' ($' + dataMapMarker[code].earnings + ')');
        }
    });

    // Sales Analytics
    // --------------------------------------------------

    var dataStore1 = [
        [0, 106],
        [1, 150],
        [2, 165],
        [3, 170],
        [4, 188],
        [5, 300],
        [6, 280]
    ];
    var dataStore2 = [
        [0, 254],
        [1, 306],
        [2, 297],
        [3, 367],
        [4, 400],
        [5, 456],
        [6, 449]
    ];
    var dataStore3 = [
        [0, 43],
        [1, 94],
        [2, 128],
        [3, 183],
        [4, 260],
        [5, 219],
        [6, 238]
    ];
    var xticksOrder = [
        [0, 'Monday'],
        [1, 'Tuesday'],
        [2, 'Wednesday'],
        [3, 'Thursday'],
        [4, 'Friday'],
        [5, 'Saturday'],
        [6, 'Sunday']
    ];
    var datasetOrder = [{
        label: 'Store 1',
        data: dataStore1,
        color: '#ED4D6E',
        lines: {
            show: true,
            fill: false,
            lineWidth: 2
        },
        curvedLines: {
            apply: true,
            monotonicFit: true
        }
    }, {
        data: dataStore1,
        color: '#ED4D6E',
        lines: {
            show: true,
            lineWidth: 0
        },
        points: {
            show: true,
        }
    }, {
        label: 'Store 2',
        data: dataStore2,
        color: '#0667D6',
        lines: {
            show: true,
            fill: false,
            lineWidth: 2
        },
        curvedLines: {
            apply: true,
            monotonicFit: true
        }
    }, {
        data: dataStore2,
        color: '#0667D6',
        lines: {
            show: true,
            lineWidth: 0
        },
        points: {
            show: true,
        }
    }, {
        label: 'Store 3',
        data: dataStore3,
        color: '#17A88B',
        lines: {
            show: true,
            fill: false,
            lineWidth: 2
        },
        curvedLines: {
            apply: true,
            monotonicFit: true
        }
    }, {
        data: dataStore3,
        color: '#17A88B',
        lines: {
            show: true,
            lineWidth: 0
        },
        points: {
            show: true,
        }
    }];
    var optionsOrder = {
        series: {
            curvedLines: {
                active: true
            },
            shadowSize: 5
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            labelMargin: 15,
            tickColor: '#F5F5F5'
        },
        xaxis: {
            ticks: xticksOrder,
            font: {
                color: '#9a9a9a',
                size: 11
            }
        },
        yaxis: {
            tickLength: 0,
            font: {
                color: '#9a9a9a',
                size: 11
            }
        },
        tooltip: {
            show: false
        },
        legend: {
            show: true,
            container: $('#flot-sale-legend'),
            noColumns: 3,
            labelBoxBorderColor: 'rgba(0,0,0,0)',
            margin: 0
        }
    };
    $.plot($('#flot-sale'), datasetOrder, optionsOrder);
    $('#flot-sale').bind('plothover', function(event, pos, item) {
        if (item) {
            $('.flotTip').text(item.datapoint[1].toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' sales').css({
                top: item.pageY + 15,
                left: item.pageX + 10
            }).show();
        } else {
            $('.flotTip').hide();
        }
    });

    $('#esp-store1').easyPieChart({
        barColor: '#ED4D6E',
        trackColor: '#FFF',
        scaleColor: false,
        scaleLength: 0,
        lineCap: 'round',
        lineWidth: 2,
        size: 220,
        animate: {
            duration: 2000,
            enabled: true
        }
    });

    $('#esp-store2').easyPieChart({
        barColor: '#0667D6',
        trackColor: '#FFF',
        scaleColor: false,
        scaleLength: 0,
        lineCap: 'round',
        lineWidth: 2,
        size: 240,
        animate: {
            duration: 2000,
            enabled: true
        }
    });

    $('#esp-store3').easyPieChart({
        barColor: '#17A88B',
        trackColor: '#FFF',
        scaleColor: false,
        scaleLength: 0,
        lineCap: 'round',
        lineWidth: 2,
        size: 200,
        animate: {
            duration: 2000,
            enabled: true
        }
    });

    // Order Status
    // --------------------------------------------------

    var table = $('#order-table').DataTable({
        lengthChange: false,
        pageLength: 5,
        colReorder: true,
        buttons: ['copy', 'excel', 'pdf', 'print'],
        language: {
            search: '',
            searchPlaceholder: 'Search records'
        },
        columnDefs: [{
            orderable: false,
            targets: 6
        }]
    });

    table.buttons().container().appendTo('#order-table_wrapper .col-sm-6:eq(0)');

    $('<div class=\'flotTip\'></div>').appendTo('body').css({
        'position': 'absolute',
        'display': 'none'
    });

});
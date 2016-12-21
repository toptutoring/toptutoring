$(document).ready(function() {
    // Bar chart
    // --------------------------------------------------
    Morris.Bar({
        element: 'barchart',
        data: [{
            y: '2006',
            a: 100,
            b: 90
        }, {
            y: '2007',
            a: 75,
            b: 65
        }, {
            y: '2008',
            a: 50,
            b: 40
        }, {
            y: '2009',
            a: 75,
            b: 65
        }, {
            y: '2010',
            a: 50,
            b: 40
        }, {
            y: '2011',
            a: 75,
            b: 65
        }, {
            y: '2012',
            a: 100,
            b: 90
        }],
        xkey: 'y',
        ykeys: ['a', 'b'],
        labels: ['Series A', 'Series B'],
        hideHover: 'auto',
        barColors: ['#5195E2', '#5DC2AE'],
        gridLineColor: '#F5F5F5',
        gridTextColor: '#9A9A9A',
        gridTextSize: 11,
        gridTextFamily: '\'Poppins\', sans-serif',
        resize: true
    });

    // Stack bar chart
    // --------------------------------------------------
    Morris.Bar({
        element: 'stackbarchart',
        data: [{
            x: '2011 Q1',
            y: 3,
            z: 2,
            a: 3
        }, {
            x: '2011 Q2',
            y: 2,
            z: null,
            a: 1
        }, {
            x: '2011 Q3',
            y: 0,
            z: 2,
            a: 4
        }, {
            x: '2011 Q4',
            y: 2,
            z: 4,
            a: 3
        }],
        xkey: 'x',
        ykeys: ['y', 'z', 'a'],
        labels: ['Y', 'Z', 'A'],
        stacked: true,
        hideHover: 'auto',
        barColors: ['#5DC2AE', '#5195E2', '#F2829A'],
        gridLineColor: '#F5F5F5',
        gridTextColor: '#9A9A9A',
        gridTextSize: 11,
        gridTextFamily: '\'Poppins\', sans-serif',
        resize: true
    });

    // Donut chart
    // --------------------------------------------------
    Morris.Donut({
        element: 'donutchart',
        data: [{
            label: 'Download Sales',
            value: 25
        }, {
            label: 'In-Store Sales',
            value: 40
        }, {
            label: 'Mail-Order Sales',
            value: 35
        }],
        resize: true,
        colors: ['#5DC2AE', '#5195E2', '#F2829A'],
        formatter: function(x) {
            return x + '%';
        }
    });

    // Area chart
    // --------------------------------------------------
    Morris.Area({
        element: 'areachart',
        data: [{
            y: '2006',
            a: 100,
            b: 90
        }, {
            y: '2007',
            a: 75,
            b: 65
        }, {
            y: '2008',
            a: 50,
            b: 40
        }, {
            y: '2009',
            a: 75,
            b: 65
        }, {
            y: '2010',
            a: 50,
            b: 40
        }, {
            y: '2011',
            a: 75,
            b: 65
        }, {
            y: '2012',
            a: 100,
            b: 90
        }],
        xkey: 'y',
        ykeys: ['a', 'b'],
        labels: ['Series A', 'Series B'],
        hideHover: 'auto',
        lineColors: ['#5DC2AE', '#5195E2'],
        fillOpacity: 0.4,
        behaveLikeLine: true,
        lineWidth: 2,
        pointSize: 4,
        gridLineColor: '#fff',
        gridTextColor: '#9A9A9A',
        gridTextSize: 11,
        gridTextFamily: '\'Poppins\', sans-serif',
        resize: true
    });

    // Line chart
    // --------------------------------------------------
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    Morris.Line({
        element: 'linechart',
        data: [{
            date: '2015-01',
            ord: 145,
            cus: 150
        }, {
            date: '2015-02',
            ord: 135,
            cus: 210
        }, {
            date: '2015-03',
            ord: 135,
            cus: 235
        }, {
            date: '2015-04',
            ord: 234,
            cus: 239
        }, {
            date: '2015-05',
            ord: 231,
            cus: 212
        }, {
            date: '2015-06',
            ord: 123,
            cus: 221
        }, {
            date: '2015-07',
            ord: 123,
            cus: 345
        }, {
            date: '2015-08',
            ord: 124,
            cus: 344
        }, {
            date: '2015-09',
            ord: 332,
            cus: 234
        }, {
            date: '2015-10',
            ord: 234,
            cus: 123
        }, {
            date: '2015-11',
            ord: 321,
            cus: 421
        }, {
            date: '2015-12',
            ord: 321,
            cus: 435
        }],
        xkey: 'date',
        ykeys: ['ord', 'cus'],
        labels: ['Orders', 'Customers'],
        hideHover: 'auto',
        lineColors: ['#5DC2AE', '#5195E2'],
        behaveLikeLine: true,
        lineWidth: 2,
        pointSize: 4,
        gridLineColor: '#F5F5F5',
        gridTextColor: '#9A9A9A',
        gridTextSize: 11,
        gridTextFamily: '\'Poppins\', sans-serif',
        resize: true,
        xLabels: 'month',
        xLabelFormat: function(x) {
            return months[x.getMonth()];
        },
        dateFormat: function(x) {
            return months[new Date(x).getMonth()];
        }
    });
});
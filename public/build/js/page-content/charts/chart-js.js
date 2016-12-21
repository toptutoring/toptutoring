$(document).ready(function() {

    // Line chart data
    // --------------------------------------------------

    var lineChartData = {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
        datasets: [{
            label: 'My First dataset',
            fillColor: '#5DC2AE',
            strokeColor: '#5DC2AE',
            pointColor: '#5DC2AE',
            pointStrokeColor: '#5DC2AE',
            pointHighlightFill: '#5DC2AE',
            pointHighlightStroke: '#5DC2AE',
            data: [65, 59, 80, 81, 56, 55, 40]
        }, {
            label: 'My Second dataset',
            fillColor: '#5195E2',
            strokeColor: '#5195E2',
            pointColor: '#5195E2',
            pointStrokeColor: '#5195E2',
            pointHighlightFill: '#5195E2',
            pointHighlightStroke: '#5195E2',
            data: [28, 48, 40, 19, 86, 27, 90]
        }]
    };

    // Bar chart data
    // --------------------------------------------------

    var barChartData = {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
        datasets: [{
            label: 'My First dataset',
            fillColor: '#5195E2',
            strokeColor: '#5195E2',
            highlightFill: '#5195E2',
            highlightStroke: '#5195E2',
            data: [65, 59, 80, 81, 56, 55, 40]
        }, {
            label: 'My Second dataset',
            fillColor: '#5DC2AE',
            strokeColor: '#5DC2AE',
            highlightFill: '#5DC2AE',
            highlightStroke: '#5DC2AE',
            data: [28, 48, 40, 19, 86, 27, 90]
        }]
    };

    // Rada chart data
    // --------------------------------------------------

    var radarChartData = {
        labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],
        datasets: [{
            label: 'My First dataset',
            fillColor: '#5195E2',
            strokeColor: '#5195E2',
            pointColor: '#5195E2',
            pointStrokeColor: '#5195E2',
            pointHighlightFill: '#5195E2',
            pointHighlightStroke: '#5195E2',
            data: [65, 59, 90, 81, 56, 55, 40]
        }, {
            label: 'My Second dataset',
            fillColor: '#5DC2AE',
            strokeColor: '#5DC2AE',
            pointColor: '#5DC2AE',
            pointStrokeColor: '#5DC2AE',
            pointHighlightFill: '#5DC2AE',
            pointHighlightStroke: '#5DC2AE',
            data: [28, 48, 40, 19, 96, 27, 100]
        }]
    };

    // Polar chart data
    // --------------------------------------------------

    var polarChartData = [{
        value: 300,
        color: '#5DC2AE',
        highlight: '#5DC2AE',
        label: 'Success'
    }, {
        value: 70,
        color: '#B065E9',
        highlight: '#B065E9',
        label: 'Info'
    }, {
        value: 100,
        color: '#5195E2',
        highlight: '#5195E2',
        label: 'Primary'
    }, {
        value: 60,
        color: '#FFCC62',
        highlight: '#FFCC62',
        label: 'Warning'
    }, {
        value: 120,
        color: '#F2829A',
        highlight: '#F2829A',
        label: 'Default'
    }];

    // Pie chart data
    // --------------------------------------------------

    var pieChartData = [{
        value: 300,
        color: '#5DC2AE',
        highlight: '#5DC2AE',
        label: 'Success'
    }, {
        value: 50,
        color: '#5195E2',
        highlight: '#5195E2',
        label: 'Primary'
    }, {
        value: 100,
        color: '#F2829A',
        highlight: '#F2829A',
        label: 'Danger'
    }];
    window.onload = function() {
        // Global chart configuration
        Chart.defaults.global.responsive = true;
        Chart.defaults.global.maintainAspectRatio = false;
        Chart.defaults.global.scaleFontFamily = '\'Poppins\', sans-serif';
        Chart.defaults.global.scaleFontSize = 11;
        Chart.defaults.global.scaleFontColor = '#9a9a9a';
        Chart.defaults.global.scaleLineColor = '#f1f1f1';
        Chart.defaults.global.tooltipTitleFontFamily = '\'Poppins\', sans-serif';
        Chart.defaults.global.tooltipTitleFontSize = 11;
        Chart.defaults.global.tooltipCornerRadius = 2;
        // Line chart
        var ctxLine = document.getElementById('linechart').getContext('2d');
        window.myLine = new Chart(ctxLine).Line(lineChartData, {
            scaleGridLineColor: '#f1f1f1',
            scaleOverride: true,
            scaleSteps: 5,
            scaleStepWidth: 20,
            scaleStartValue: 0,
            scaleLabel: '<%= value %>',
            multiTooltipTemplate: '<%= datasetLabel %>: <%= value %>',
            datasetFill: true
        });
        // Bar chart
        var ctxBar = document.getElementById('barchart').getContext('2d');
        window.myBar = new Chart(ctxBar).Bar(barChartData, {
            scaleOverride: true,
            scaleSteps: 5,
            scaleStepWidth: 20,
            scaleStartValue: 0,
            scaleLabel: '<%= value %>',
            multiTooltipTemplate: '<%= datasetLabel %>: <%= value %>',
            datasetFill: true
        });
        // Radar chart
        window.myRadar = new Chart(document.getElementById('radarchart').getContext('2d')).Radar(radarChartData, {
            pointLabelFontSize: 11,
            pointLabelFontFamily: '\'Poppins\', sans-serif'
        });
        // Polar chart
        var ctxPolar = document.getElementById('polarchart').getContext('2d');
        window.myPolarArea = new Chart(ctxPolar).PolarArea(polarChartData);
        // Pie chart
        var ctxPie = document.getElementById('piechart').getContext('2d');
        window.myPie = new Chart(ctxPie).Pie(pieChartData);
        // Doughnut chart
        var ctxDoughnut = document.getElementById('doughnutchart').getContext('2d');
        window.myDoughnut = new Chart(ctxDoughnut).Doughnut(pieChartData);
    };
});
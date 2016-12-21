$(document).ready(function() {
    function year(year) {
        return new Date(year, 1, 1).getTime();
    }

    // Line chart
    // --------------------------------------------------
    //Total visits
    var dataLine1 = [
        [year(2010), 63000],
        [year(2011), 74000],
        [year(2012), 91000],
        [year(2013), 117000],
        [year(2014), 138000]
    ];
    //Change
    var dataLine2 = [
        [year(2010), 12.5],
        [year(2011), 17.46],
        [year(2012), 22.97],
        [year(2013), 28.57],
        [year(2014), 17.95]
    ];
    var datasetLine = [{
        label: 'Total Visits',
        data: dataLine1,
        points: {
            symbol: 'triangle'
        },
        color: '#5195E2'
    }, {
        label: 'Change',
        data: dataLine2,
        yaxis: 2,
        points: {
            symbol: 'diamond'
        },
        color: '#5DC2AE'
    }];
    var optionsLine = {
        series: {
            lines: {
                show: true
            },
            points: {
                show: true
            },
            shadowSize: 0
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#F5F5F5',
            labelMargin: 15
        },
        xaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            mode: 'time',
            tickSize: [1, 'year'],
            timeformat: '%Y'
        },
        yaxes: [{
            font: {
                color: '#9A9A9A',
                size: 11
            },
            tickFormatter: function(v, axis) {
                if (v > 0) {
                    return (v / 1000).toFixed(axis.tickDecimals) + ' K';
                } else {
                    return (v / 1000).toFixed(axis.tickDecimals);
                }
            }
        }, {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            position: 'right',
            tickFormatter: function(v, axis) {
                return v + '%';
            }
        }],
        tooltip: {
            show: true,
            content: '%s: %y visitors in %x',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#line-chart-legend'),
            noColumns: 4,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    $.plot($('#line-chart'), datasetLine, optionsLine);


    // Stacked chart
    // --------------------------------------------------

    var dataStack1 = [
        [year(1996), 44],
        [year(2000), 37],
        [year(2004), 35],
        [year(2008), 36],
        [year(2012), 46]
    ];
    var dataStack2 = [
        [year(1996), 32],
        [year(2000), 24],
        [year(2004), 40],
        [year(2008), 38],
        [year(2012), 29]
    ];
    var dataStack3 = [
        [year(1996), 25],
        [year(2000), 33],
        [year(2004), 26],
        [year(2008), 36],
        [year(2012), 29]
    ];

    var datasetStack = [{
        label: 'Gold Medals',
        data: dataStack1,
        color: '#5DC2AE',
        points: {
            symbol: 'diamond'
        }
    }, {
        label: 'Silver Medals',
        data: dataStack2,
        color: '#5195E2',
        points: {
            symbol: 'cross'
        }
    }, {
        label: 'Bronze Medals',
        data: dataStack3,
        color: '#F2829A',
        points: {
            symbol: 'square'
        }
    }];
    var optionsStackArea = {
        series: {
            stack: true,
            lines: {
                show: true,
                fill: 1
            }
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#FFF',
            labelMargin: 15
        },
        xaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            mode: 'time',
            tickSize: [4, 'year'],
            timeformat: '%Y'
        },
        yaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        tooltip: {
            show: true,
            content: '%y %s in %x',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#stack-area-chart-legend'),
            noColumns: 6,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    var optionsStackBar = {
        series: {
            stack: true,
            bars: {
                show: true,
                fill: 1,
                align: 'center',
                lineWidth: 0,
                barWidth: 24 * 60 * 60 * 365 * 4 * 500
            }
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#F5F5F5',
            labelMargin: 15
        },
        xaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            mode: 'time',
            tickSize: [4, 'year'],
            timeformat: '%Y'
        },
        yaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        tooltip: {
            show: true,
            content: '%y %s in %x',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#stack-bar-chart-legend'),
            noColumns: 6,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };

    // Stacked horizontal chart
    // --------------------------------------------------

    var dataStackHoz1 = [
        [44, year(1996)],
        [37, year(2000)],
        [35, year(2004)],
        [36, year(2008)],
        [46, year(2012)]
    ];
    var dataStackHoz2 = [
        [32, year(1996)],
        [24, year(2000)],
        [40, year(2004)],
        [38, year(2008)],
        [29, year(2012)]
    ];
    var dataStackHoz3 = [
        [25, year(1996)],
        [33, year(2000)],
        [26, year(2004)],
        [36, year(2008)],
        [29, year(2012)]
    ];
    var datasetStackHoz = [{
        label: 'Gold Medals',
        data: dataStackHoz1,
        color: '#5DC2AE'
    }, {
        label: 'Silver Medals',
        data: dataStackHoz2,
        color: '#5195E2'
    }, {
        label: 'Bronze Medals',
        data: dataStackHoz3,
        color: '#F2829A'
    }];
    var optionsStackHozBar = {
        series: {
            stack: true,
            bars: {
                show: true,
                fill: 1,
                align: 'center',
                lineWidth: 0,
                horizontal: true,
                barWidth: 24 * 60 * 60 * 365 * 4 * 500
            }
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#FFF',
            labelMargin: 15
        },
        yaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            mode: 'time',
            tickSize: [4, 'year'],
            timeformat: '%Y',
            min: year(1995),
            max: year(2013)
        },
        xaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        tooltip: {
            show: true,
            content: '%x %s in %y',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#stack-hoz-bar-chart-legend'),
            noColumns: 6,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    $.plot($('#stack-area-chart'), datasetStack, optionsStackArea);
    $.plot($('#stack-bar-chart'), datasetStack, optionsStackBar);
    $.plot($('#stack-hoz-bar-chart'), datasetStackHoz, optionsStackHozBar);

    // Bar chart 
    // --------------------------------------------------

    var dataBar = [
        [0, 11],
        [1, 15],
        [2, 25],
        [3, 24],
        [4, 13],
        [5, 18]
    ];
    var datasetBar = [{
        label: '2014 Average Temperature',
        data: dataBar,
        color: '#5DC2AE'
    }];
    var ticksBar = [
        [0, 'London'],
        [1, 'New York'],
        [2, 'New Delhi'],
        [3, 'Taipei'],
        [4, 'Beijing'],
        [5, 'Sydney']
    ];
    var optionsBar = {
        series: {
            bars: {
                show: true,
                fill: 1,
                align: 'center',
                barWidth: 0.3,
                lineWidth: 0
            }
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#F5F5F5',
            labelMargin: 15
        },
        xaxis: {
            font: {
                color: '#9A9A9A',
                size: 11
            },
            ticks: ticksBar
        },
        yaxis: {
            tickSize: 10,
            font: {
                color: '#9A9A9A',
                size: 11
            },
            tickFormatter: function(v, axis) {
                return v + '°C';
            }
        },
        tooltip: {
            show: true,
            content: '%x: %y',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#bar-chart-legend'),
            noColumns: 2,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    $.plot($('#bar-chart'), datasetBar, optionsBar);

    // Horizontal bar chart
    // --------------------------------------------------

    var dataHozBar = [
        [1582.3, 0],
        [28.95, 1],
        [1603, 2],
        [774, 3],
        [1245, 4],
        [85, 5]
    ];
    var dataSetHozBar = [{
        label: 'Precious Metal Price',
        data: dataHozBar,
        color: '#5DC2AE'
    }];
    var ticksHozBar = [
        [0, 'Gold'],
        [1, 'Silver'],
        [2, 'Platinum'],
        [3, 'Palldium'],
        [4, 'Rhodium'],
        [5, 'Ruthenium']
    ];
    var optionsHozBar = {
        series: {
            bars: {
                show: true,
                fill: 1,
                align: 'center',
                barWidth: 0.5,
                horizontal: true,
                lineWidth: 0
            }
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#F5F5F5',
            labelMargin: 15
        },
        xaxis: {
            tickFormatter: function(v, axis) {
                return v.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',');
            },
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        yaxis: {
            ticks: ticksHozBar,
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        tooltip: {
            show: true,
            content: '%y: %x USD/oz',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#hoz-bar-chart-legend'),
            noColumns: 2,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    $.plot($('#hoz-bar-chart'), dataSetHozBar, optionsHozBar);

    // Pie chart
    // --------------------------------------------------

    var dataSetPie = [{
        label: 'Asia',
        data: 4119630000,
        color: '#5DC2AE'
    }, {
        label: 'Latin America',
        data: 590950000,
        color: '#B065E9'
    }, {
        label: 'Africa',
        data: 1012960000,
        color: '#5195E2'
    }, {
        label: 'Europe',
        data: 727080000,
        color: '#FFCC62'
    }, {
        label: 'North America',
        data: 344120000,
        color: '#F2829A'
    }];
    var optionsPie = {
        series: {
            pie: {
                show: true,
                stroke: {
                    width: 0
                },
                label: {
                    show: true
                },
                highlight: {
                    opacity: 0
                }
            }
        },
        grid: {
            hoverable: true
        },
        tooltip: {
            show: true,
            content: '%s: %p.0%',
            defaultTheme: false
        },
        legend: {
            show: true,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    var optionsDonut = {
        series: {
            pie: {
                show: true,
                stroke: {
                    width: 0
                },
                innerRadius: 0.4,
                label: {
                    show: true
                },
                highlight: {
                    opacity: 0
                }
            }
        },
        grid: {
            hoverable: true
        },
        tooltip: {
            show: true,
            content: '%s: %p.0%',
            defaultTheme: false
        },
        legend: {
            show: true,
            labelBoxBorderColor: '#FFF',
            margin: 0
        }
    };
    $.plot($('#pie-chart'), dataSetPie, optionsPie);
    $.plot($('#donut-chart'), dataSetPie, optionsDonut);

    // Combine chart
    // --------------------------------------------------

    // New visitors
    var dataCombine1 = [
        [0, 8926],
        [1, 6997],
        [2, 5858],
        [3, 6782],
        [4, 7460],
        [5, 9443],
        [6, 9519],
        [7, 6666],
        [8, 6895],
        [9, 8070],
        [10, 8008],
        [11, 7628]
    ];
    // Returning visitors
    var dataCombine2 = [
        [0, 13671],
        [1, 15796],
        [2, 16080],
        [3, 18274],
        [4, 17881],
        [5, 14852],
        [6, 14317],
        [7, 16637],
        [8, 19510],
        [9, 15486],
        [10, 11303],
        [11, 16181]
    ];
    // Page views
    var dataCombine3 = [
        [0, 29964],
        [1, 22702],
        [2, 24893],
        [3, 24015],
        [4, 21332],
        [5, 25782],
        [6, 26268],
        [7, 20427],
        [8, 22148],
        [9, 20000],
        [10, 23067],
        [11, 27901]
    ];
    // Total visits
    var dataCombine4 = [
        [0, 1.27],
        [1, 5.69],
        [2, 0.65],
        [3, 8.13],
        [4, 6.56],
        [5, 5.91],
        [6, 2.76],
        [7, 6.65],
        [8, 4.21],
        [9, 7.93],
        [10, 4.68],
        [11, 8.31]
    ];
    var ticksCombine = [
        [0, 'Jan'],
        [1, 'Feb'],
        [2, 'Mar'],
        [3, 'Apr'],
        [4, 'May'],
        [5, 'Jun'],
        [6, 'Jul'],
        [7, 'Aug'],
        [8, 'Sep'],
        [9, 'Oct'],
        [10, 'Nov'],
        [11, 'Dec']
    ];
    var datasetCombine = [{
        label: 'Page Views',
        data: dataCombine3,
        color: '#EEE',
        bars: {
            show: true,
            align: 'center',
            barWidth: 0.5,
            lineWidth: 0,
            fill: 1
        }
    }, {
        label: 'New Visitors',
        data: dataCombine1,
        color: '#8E23E0',
        points: {
            symbol: 'diamond',
            show: true,
            fillColor: '#8E23E0'
        },
        lines: {
            show: true
        },
        idx: 1
    }, {
        label: 'Returning Visitors',
        data: dataCombine2,
        color: '#E5343D',
        points: {
            symbol: 'square',
            show: true,
            fillColor: '#E5343D'
        },
        lines: {
            show: true
        },
        idx: 2
    }, {
        label: 'Total Visits',
        data: dataCombine4,
        yaxis: 2,
        points: {
            symbol: 'triangle',
            show: false
        },
        color: '#5DC2AE',
        lines: {
            show: true,
            fill: 0.4,
            lineWidth: 0
        },
        idx: 3
    }];
    somePlot = null;
    togglePlot = function(seriesIdx) {
        if (seriesIdx !== null) {
            var someData = somePlot.getData();
            someData[seriesIdx].lines.show = !someData[seriesIdx].lines.show;
            somePlot.setData(someData);
            somePlot.draw();
        }
    };
    var optionsCombine = {
        series: {
            shadowSize: 0
        },
        grid: {
            borderWidth: 0,
            hoverable: true,
            tickColor: '#FFF',
            labelMargin: 15
        },
        xaxis: {
            ticks: ticksCombine,
            font: {
                color: '#9A9A9A',
                size: 11
            }
        },
        yaxes: [{
            tickSize: 5000,
            max: 30000,
            font: {
                color: '#9A9A9A',
                size: 11
            },
            tickFormatter: function(v, axis) {
                return v.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',');
            }
        }, {
            tickSize: 2,
            position: 'right',
            font: {
                color: '#9A9A9A',
                size: 11
            },
            tickFormatter: function(v, axis) {
                return v + '%';
            }
        }],
        tooltip: {
            show: true,
            content: '%s: %y',
            defaultTheme: false
        },
        legend: {
            show: true,
            container: $('#combine-chart-legend'),
            noColumns: 8,
            labelBoxBorderColor: '#FFF',
            margin: 0,
            labelFormatter: function(label, series) {
                return '<a style="color: #545454" href="javascript:;" onClick="togglePlot(' + series.idx + '); return false;">' + label + '</a>';
            }
        }
    };
    somePlot = $.plot($('#combine-chart'), datasetCombine, optionsCombine);

});
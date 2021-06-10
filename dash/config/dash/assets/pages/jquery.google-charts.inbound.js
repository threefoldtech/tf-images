/**
 * Theme: Zircos Admin Template
 * Author: Coderthemes
 * Module/App: Flot-Chart
 */

! function($) {
    "use strict";

    var GoogleChart = function() {
        this.$body = $("body")
    };

    //creates line graph
    GoogleChart.prototype.createLineChart = function(selector, data, axislabel, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 340,
            curveType: 'function',
            fontSize: 14,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 300
            },
            pointSize: 4,
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            vAxis: {
                title: axislabel,
                titleTextStyle: {
                    fontSize: 14,
                    italic: false
                },
                gridlines:{
                    color: '#f5f5f5',
                    count: 10
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'center',
                textStyle: {
                    fontSize: 14
                }
            },
            lineWidth: 3,
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var line_chart = new google.visualization.LineChart(selector);
        line_chart.draw(google_chart_data, options);
        return line_chart;
    },
    //creates area graph
    GoogleChart.prototype.createAreaChart = function(selector, data, axislabel, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 340,
            curveType: 'function',
            fontSize: 14,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 300
            },
            pointSize: 4,
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            vAxis: {
                title: axislabel,
                titleTextStyle: {
                    fontSize: 14,
                    italic: false
                },
                gridarea: {
                    color: '#f5f5f5',
                    count: 10
                },
                gridlines: {
                    color: '#f5f5f5'
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'end',
                textStyle: {
                    fontSize: 14
                }
            },
            lineWidth: 2,
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var area_chart = new google.visualization.AreaChart(selector);
        area_chart.draw(google_chart_data, options);
        return area_chart;
    },
    //creates Column graph
    GoogleChart.prototype.createColumnChart = function(selector, data, axislabel, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 400,
            fontSize: 13,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 350
            },
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            vAxis: {
                title: axislabel,
                titleTextStyle: {
                    fontSize: 14,
                    italic: false
                },
                gridlines:{
                    color: '#f5f5f5',
                    count: 10
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'center',
                textStyle: {
                    fontSize: 13
                }
            },
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var column_chart = new google.visualization.ColumnChart(selector);
        column_chart.draw(google_chart_data, options);
        return column_chart;
    },
    //creates bar graph
    GoogleChart.prototype.createBarChart = function(selector, data, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 400,
            fontSize: 14,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 350
            },
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            vAxis: {
                gridlines:{
                    color: '#f5f5f5',
                    count: 10
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'center',
                textStyle: {
                    fontSize: 13
                }
            },
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var bar_chart = new google.visualization.BarChart(selector);
        bar_chart.draw(google_chart_data, options);
        return bar_chart;
    },
    //creates Column Stacked
    GoogleChart.prototype.createColumnStackChart = function(selector, data, axislabel, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 400,
            fontSize: 13,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 350
            },
            isStacked: true,
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            vAxis: {
                title: axislabel,
                titleTextStyle: {
                    fontSize: 14,
                    italic: false
                },
                gridlines:{
                    color: '#f5f5f5',
                    count: 10
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'center',
                textStyle: {
                    fontSize: 13
                }
            },
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var stackedcolumn_chart = new google.visualization.ColumnChart(selector);
        stackedcolumn_chart.draw(google_chart_data, options);
        return stackedcolumn_chart;
    },
    //creates Bar Stacked
    GoogleChart.prototype.createBarStackChart = function(selector, data, colors) {
        var options = {
            fontName: 'Hind Madurai',
            height: 400,
            fontSize: 13,
            chartArea: {
                left: '5%',
                width: '90%',
                height: 350
            },
            isStacked: true,
            tooltip: {
                textStyle: {
                    fontName: 'Hind Madurai',
                    fontSize: 14
                }
            },
            hAxis: {
                gridlines: {
                    color: '#f5f5f5',
                    count: 10
                },
                minValue: 0
            },
            legend: {
                position: 'top',
                alignment: 'center',
                textStyle: {
                    fontSize: 13
                }
            },
            colors: colors
        };


        var google_chart_data = google.visualization.arrayToDataTable(data);
        var stackedbar_chart = new google.visualization.BarChart(selector);
        stackedbar_chart.draw(google_chart_data, options);
        return stackedbar_chart;
    },
    //creates pie chart
    GoogleChart.prototype.createPieChart = function(selector, data, colors, is3D, issliced) {
        var options = {
            fontName: 'Hind Madurai',
            fontSize: 13,
            height: 300,
            width: 500,
            chartArea: {
                left: 50,
                width: '90%',
                height: '90%'
            },
            colors: colors
        };

        if(is3D) {
            options['is3D'] = true;
        }

        if(issliced) {
            options['is3D'] = true;
            options['pieSliceText'] = 'label';
            options['slices'] = {
                2: {offset: 0.15},
                5: {offset: 0.1}
            };
        }

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var pie_chart = new google.visualization.PieChart(selector);
        pie_chart.draw(google_chart_data, options);
        return pie_chart;
    },

    //creates donut chart
    GoogleChart.prototype.createDonutChart = function(selector, data, colors) {
        var options = {
            fontName: 'Hind Madurai',
            fontSize: 13,
            height: 300,
            pieHole: 0.55,
            width: 500,
            chartArea: {
                left: 50,
                width: '90%',
                height: '90%'
            },
            colors: colors
        };

        var google_chart_data = google.visualization.arrayToDataTable(data);
        var pie_chart = new google.visualization.PieChart(selector);
        pie_chart.draw(google_chart_data, options);
        return pie_chart;
    },
    //init
    GoogleChart.prototype.init = function () {
        var $this = this;

     

        //creating pie chart
        var pie_data = [
            ['Task', 'Hours per Day'],
            ['2018973248',     11],
            ['2018973248',      2],
            ['2018973248',  2],
            ['2018973248', 2],
            ['2018973248',    7]
        ];
        $this.createPieChart($('#pie-chart')[0], pie_data, ['#188ae2', '#4bd396', '#f9c851', '#f5707a', '#6b5fb5'], false, false);


        //on window resize - redrawing all charts
        $(window).on('resize', function() {
          
            $this.createPieChart($('#pie-chart')[0], pie_data, ['#188ae2', '#4bd396', '#f9c851', '#f5707a', '#6b5fb5'], false, false);
          
        });
    },
    //init GoogleChart
    $.GoogleChart = new GoogleChart, $.GoogleChart.Constructor = GoogleChart
}(window.jQuery),

//initializing GoogleChart
function($) {
    "use strict";
    //loading visualization lib - don't forget to include this
    google.load("visualization", "1", {packages:["corechart"]});
    //after finished load, calling init method
    google.setOnLoadCallback(function() {$.GoogleChart.init();});
}(window.jQuery);

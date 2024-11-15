Ext.onReady(function () {
    var jsonData = [
        {
            date: '1/1/2009',
            IE: 44.8,
            Firefox: 45.5,
            Chrome: 3.9,
            Safari: 3,
            Opera: 2.3,
            Other: 0.5
        },
        {
            date: '2/1/2009',
            IE: 43.6,
            Firefox: 46.4,
            Chrome: 4,
            Safari: 3,
            Opera: 2.2,
            Other: 0.8
        },
        {
            date: '3/1/2009',
            IE: 43.3,
            Firefox: 46.5,
            Chrome: 4.2,
            Safari: 3.1,
            Opera: 2.3,
            Other: 0.6
        },
        {
            date: '4/1/2009',
            IE: 42.1,
            Firefox: 47.1,
            Chrome: 4.9,
            Safari: 3,
            Opera: 2.2,
            Other: 0.7
        },
        {
            date: '5/1/2009',
            IE: 41,
            Firefox: 47.7,
            Chrome: 5.5,
            Safari: 3,
            Opera: 2.2,
            Other: 0.6
        },
        {
            date: '6/1/2009',
            IE: 40.7,
            Firefox: 47.3,
            Chrome: 6,
            Safari: 3.1,
            Opera: 2.1,
            Other: 0.8
        },
        {
            date: '7/1/2009',
            IE: 39.4,
            Firefox: 47.9,
            Chrome: 6.5,
            Safari: 3.3,
            Opera: 2.1,
            Other: 0.8
        },
        {
            date: '8/1/2009',
            IE: 39.3,
            Firefox: 47.4,
            Chrome: 7,
            Safari: 3.3,
            Opera: 2.1,
            Other: 0.9
        },
        {
            date: '9/1/2009',
            IE: 39.6,
            Firefox: 46.6,
            Chrome: 7.1,
            Safari: 3.6,
            Opera: 2.2,
            Other: 0.9
        },
        {
            date: '10/1/2009',
            IE: 37.5,
            Firefox: 47.5,
            Chrome: 8,
            Safari: 3.8,
            Opera: 2.3,
            Other: 0.9
        },
        {
            date: '11/1/2009',
            IE: 37.7,
            Firefox: 47,
            Chrome: 8.5,
            Safari: 3.8,
            Opera: 2.3,
            Other: 0.7
        },
        {
            date: '12/1/2009',
            IE: 37.2,
            Firefox: 46.4,
            Chrome: 9.8,
            Safari: 3.6,
            Opera: 2.3,
            Other: 0.7
        },
        {
            date: '1/1/2010',
            IE: 36.2,
            Firefox: 46.3,
            Chrome: 10.8,
            Safari: 3.7,
            Opera: 2.2,
            Other: 0.8
        },
        {
            date: '2/1/2010',
            IE: 35.3,
            Firefox: 46.5,
            Chrome: 11.6,
            Safari: 3.8,
            Opera: 2.1,
            Other: 0.7
        },
        {
            date: '3/1/2010',
            IE: 34.9,
            Firefox: 46.2,
            Chrome: 12.3,
            Safari: 3.7,
            Opera: 2.2,
            Other: 0.7
        },
        {
            date: '4/1/2010',
            IE: 33.4,
            Firefox: 46.4,
            Chrome: 13.6,
            Safari: 3.7,
            Opera: 2.2,
            Other: 0.7
        },
        {
            date: '5/1/2010',
            IE: 32.2,
            Firefox: 46.9,
            Chrome: 14.5,
            Safari: 3.5,
            Opera: 2.2,
            Other: 0.7
        },
        {
            date: '6/1/2010',
            IE: 31,
            Firefox: 46.6,
            Chrome: 15.9,
            Safari: 3.6,
            Opera: 2.1,
            Other: 0.8
        },
        {
            date: '7/1/2010',
            IE: 30.4,
            Firefox: 46.4,
            Chrome: 16.7,
            Safari: 3.4,
            Opera: 2.3,
            Other: 0.8
        },
        {
            date: '8/1/2010',
            IE: 30.7,
            Firefox: 45.8,
            Chrome: 17,
            Safari: 3.5,
            Opera: 2.3,
            Other: 0.7
        },
        {
            date: '9/1/2010',
            IE: 31.1,
            Firefox: 45.1,
            Chrome: 17.3,
            Safari: 3.7,
            Opera: 2.2,
            Other: 0.6
        },
        {
            date: '10/1/2010',
            IE: 29.7,
            Firefox: 44.1,
            Chrome: 19.2,
            Safari: 3.9,
            Opera: 2.2,
            Other: 0.9
        },
        {
            date: '11/1/2010',
            IE: 28.6,
            Firefox: 44,
            Chrome: 20.5,
            Safari: 4.0,
            Opera: 2.3,
            Other: 0.6
        },
        {
            date: '12/1/2010',
            IE: 27.5,
            Firefox: 43.5,
            Chrome: 22.4,
            Safari: 3.8,
            Opera: 2.2,
            Other: 0.6
        }
    ];

    var fields = ['IE', 'Chrome', 'Firefox', 'Safari', 'Opera', 'Other'];
    
    var browserStore = new Ext.data.JsonStore({
        fields: fields,
        data: jsonData
    });
    
    var colors = ['rgb(47, 162, 223)',
                  'rgb(60, 133, 46)',
                  'rgb(234, 102, 17)',
                  'rgb(154, 176, 213)',
                  'rgb(186, 10, 25)',
                  'rgb(40, 40, 40)'];
    
    Ext.chart.theme.Browser = Ext.extend(Ext.chart.theme.Base, {
        constructor: function(config) {
            Ext.chart.theme.Base.prototype.constructor.call(this, Ext.apply({
                colors: colors
            }, config));
        }
    }); 
    
    chart = new Ext.chart.Chart({
        renderTo: Ext.getBody(),
        width: 800,
        height: 600,
        animate: true,
        theme: 'Browser:gradients',
        defaultInsets: 30,
        store: browserStore,
        legend: {
            position: 'right'
        },
        axes: [{
            type: 'Numeric',
            position: 'left',
            fields: fields,
            title: 'Usage %',
            grid: true,
            minimum: 0,
            maximum: 100
        }, {
            type: 'Category',
            position: 'bottom',
            fields: ['date'],
            title: 'Month of the Year',
            label: {
                renderer: function(v) {
                    return v.match(/([0-9]*)\/[0-9]*\/[0-9][0-9]([0-9]*)/).slice(1).join('/');
                }
            }
        }],
        series: [{
            type: 'area',
            axis: 'left',
            highlight: true,
            xField: 'name',
            yField: fields,
            style: {
                lineWidth: 1,
                stroke: '#666',
                opacity: 0.86
            }
        }]
    });
});
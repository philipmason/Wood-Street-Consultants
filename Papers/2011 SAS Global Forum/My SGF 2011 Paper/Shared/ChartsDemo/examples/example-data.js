function generateData(n){
    var data = [],
        p = (Math.random() *  11) + 1,
        i;
    for (i = 0; i < (n || 12); i++) {
        data.push({
            name: Ext.Date.monthNames[i],
            data1: Math.floor(Math.max((Math.random() * 100), 20)),
            data2: Math.floor(Math.max((Math.random() * 100), 20)),
            data3: Math.floor(Math.max((Math.random() * 100), 20)),
            data4: Math.floor(Math.max((Math.random() * 100), 20)),
            data5: Math.floor(Math.max((Math.random() * 100), 20)),
            data6: Math.floor(Math.max((Math.random() * 100), 20)),
            data7: Math.floor(Math.max((Math.random() * 100), 20)),
            data8: Math.floor(Math.max((Math.random() * 100), 20)),
            data9: Math.floor(Math.max((Math.random() * 100), 20))
        });
    }
    return data;
}
function generateDataNegative(n){
    var data = [],
        p = (Math.random() *  11) + 1,
        i;
    for (i = 0; i < (n || 12); i++) {
        data.push({
            name: Ext.Date.monthNames[i],
            data1: Math.floor(((Math.random() - 0.5) * 100)),
            data2: Math.floor(((Math.random() - 0.5) * 100)),
            data3: Math.floor(((Math.random() - 0.5) * 100)),
            data4: Math.floor(((Math.random() - 0.5) * 100)),
            data5: Math.floor(((Math.random() - 0.5) * 100)),
            data6: Math.floor(((Math.random() - 0.5) * 100)),
            data7: Math.floor(((Math.random() - 0.5) * 100)),
            data8: Math.floor(((Math.random() - 0.5) * 100)),
            data9: Math.floor(((Math.random() - 0.5) * 100))
        });
    }
    return data;
}

var store1 = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
    data: generateData()
});
var storeNegatives = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
    data: generateDataNegative()
});
var store3 = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
    data: generateData()
});
var store4 = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
    data: generateData()
});
var store5 = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
    data: generateData()
});
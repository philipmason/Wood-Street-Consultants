proc stream outfile=_webout prescol ;
BEGIN
<!DOCTYPE html>
<html lang="en">
<head>
    <title>dc.js - Our modified example</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/dc/1.7.5/dc.css"/>
</head>
<body>

<div id="chart-ring-year"></div>
<div id="chart-hist-spend"></div>
<div id="chart-row-spenders"></div>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.14/d3.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/crossfilter/1.3.12/crossfilter.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/dc/1.7.5/dc.min.js"></script>
<script type="text/javascript">
var yearRingChart   = dc.pieChart("#chart-ring-year"),
    spendHistChart  = dc.barChart("#chart-hist-spend"),
    spenderRowChart = dc.rowChart("#chart-row-spenders");

d3.csv("http://d351tq92/SASStoredProcess/do?_program=%2FUser+Folders%2Fphil%2FMy+Folder%2Fcsv1", 
	function(error, spendData) {

// normalize/parse data
spendData.forEach(function(d) {
    d.Spent = d.Spent.match(/\d+/);
});
// set crossfilter
var ndx = crossfilter(spendData),
    yearDim  = ndx.dimension(function(d) {return +d.Year;}),
    spendDim = ndx.dimension(function(d) {return Math.floor(d.Spent/10);}),
    nameDim  = ndx.dimension(function(d) {return d.Name;}),
    spendPerYear = yearDim.group().reduceSum(function(d) {return +d.Spent;}),
    spendPerName = nameDim.group().reduceSum(function(d) {return +d.Spent;}),
    spendHist    = spendDim.group().reduceCount();
yearRingChart
    .width(&w).height(&h).dimension(yearDim)
    .group(spendPerYear)
    .innerRadius(50);
spendHistChart
    .width(&w).height(&h).dimension(spendDim)
    .group(spendHist)
    .x(d3.scale.linear().domain([0,10]))
    .elasticY(true);
spendHistChart.xAxis().tickFormat(function(d) {return d*10}); // convert back to base unit
spendHistChart.yAxis().ticks(2);
spenderRowChart
    .width(&w).height(&h).dimension(nameDim)
    .group(spendPerName)
    .elasticX(true);
dc.renderAll();
});

</script>

</body>
</html>
;;;;
run ;
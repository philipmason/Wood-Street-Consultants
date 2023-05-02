*ProcessBody;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css"/>
<script type="text/javascript" src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/ext-3.2.1/ext-all-debug.js"></script> 

<script type="text/javascript">
	Ext.ns('Example');
	 
	Ext.BLANK_IMAGE_URL = '/ext-3.2.1/resources/images/default/s.gif';
	 
	Example.Grid = Ext.extend(Ext.grid.GridPanel, {
  	initComponent:function() {
  	// hard coded - cannot be changed from outside
	var config = {
  	store: new Ext.data.SimpleStore({
    	id:0
    	,fields:[
;;;;
run ;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
    	{name: 'company'}
    	,{name: 'price', type: 'float'}
    	,{name: 'change', type: 'float'}
    	,{name: 'pctChange', type: 'float'}
    	,{name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
    	,{name: 'industry'}
    	,{name: 'desc'}
    	]
  	,data:[
          	['3m Co',71.72,0.02,0.03,'8/1 12:00am', 'Manufacturing'],
          	['Alcoa Inc',29.01,0.42,1.47,'9/1 12:00am', 'Manufacturing'],
          	['Altria Group Inc',83.81,0.28,0.34,'10/1 12:00am', 'Manufacturing'],
          	['American Express Company',52.55,0.01,0.02,'9/1 10:00am', 'Finance'],
          	['American International Group, Inc.',64.13,0.31,0.49,'9/1 11:00am', 'Services'],
          	['AT&T Inc.',31.61,-0.48,-1.54,'9/1 12:00am', 'Services'],
          	['Boeing Co.',75.43,0.53,0.71,'9/1 12:00am', 'Manufacturing'],
          	['Caterpillar Inc.',67.27,0.92,1.39,'9/1 12:00am', 'Services'],
          	['Citigroup, Inc.',49.37,0.02,0.04,'9/1 12:00am', 'Finance'],
          	['E.I. du Pont de Nemours and Company',40.48,0.51,1.28,'9/1 12:00am', 'Manufacturing'],
          	['Exxon Mobil Corp',68.1,-0.43,-0.64,'9/1 12:00am', 'Manufacturing'],
          	['General Electric Company',34.14,-0.08,-0.23,'9/1 12:00am', 'Manufacturing'],
          	['General Motors Corporation',30.27,1.09,3.74,'9/1 12:00am', 'Automotive'],
          	['Hewlett-Packard Co.',36.53,-0.03,-0.08,'9/1 12:00am', 'Computer'],
            ['Honeywell Intl Inc',38.77,0.05,0.13,'9/1 12:00am', 'Manufacturing'],
          	['Walt Disney Company (The) (Holding Company)',29.89,0.24,0.81,'9/1 12:00am', 'Services']
          ]
	})
	,columns:[
          	{id:'company',header: "Company", width: 40, sortable: true, dataIndex: 'company'}
          	,{header: "Price", width: 20, sortable: true, renderer: Ext.util.Format.usMoney, dataIndex: 'price'}
          	,{header: "Change", width: 20, sortable: true, dataIndex: 'change'}
          	,{header: "% Change", width: 20, sortable: true, dataIndex: 'pctChange'}
          	,{header: "Last Updated", width: 20, sortable: true, renderer: Ext.util.Format.dateRenderer('m/d/Y'), dataIndex: 'lastChange'}
          	]
;;;;
run ;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
	,viewConfig:{forceFit:true}
	}; // eo config object
	 
	// apply config
	Ext.apply(this, Ext.apply(this.initialConfig, config));
	 
	// call parent
	Example.Grid.superclass.initComponent.apply(this, arguments);
	} // eo function initComponent
	 
	});
	 
	Ext.reg('examplegrid', Example.Grid);
	 
	// application main entry point
	Ext.onReady(function() {
	 
	Ext.QuickTips.init();
	 
	// create and show window
	var win = new Ext.Window({
	renderTo:  Ext.getBody()
            ,title:Ext.get('page-title').dom.innerHTML
            ,width:560
            ,height:380
            ,plain:true
            ,layout:'accordion'
            ,border:false
            ,closable:false
            ,buttonAlign:'center'
            ,items:[{ title:'Info'
                      ,id:'infopanel'
                      ,iconCls:'icon-info'
                      ,bodyStyle:'padding:10px'
                      ,html:'Click on Grid title or Expand Grid button to instantiate and render the grid.'
                    },
                    {  title:'Grid'
                      ,id:'gridpanel'
                      ,iconCls:'icon-grid'
                    	,xtype:'examplegrid'
                    	,autoScroll:true
                    	}]
          	,buttons:[{ text:'Expand Grid'
                     	,iconCls:'icon-grid'
                      ,handler:function(){Ext.getCmp('gridpanel').expand();}
                      },{
                      text:'Expand Info'
                      ,iconCls:'icon-info'
                      ,handler:function(){Ext.getCmp('infopanel').expand();}
                      }]
                      });
  win.show();
  }); // eo function onReady
	// eof
</script>

<title id="page-title">My Grid</title>
</head>
<body>

</body>
</html>
;;;;
run ;

filename cmd pipe 'pwd' ;
data _null_ ;
  file _webout ;
  infile cmd ;
  input ;
  put '<h1>' _infile_ '</h1>' ;
run ;

%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

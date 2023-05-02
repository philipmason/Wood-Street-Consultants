*  Begin EG generated code (do not edit this line);
*
*  Stored process registered by
*  Enterprise Guide Stored Process Manager v4.1
*
*  ====================================================================
*  Stored process name: MenuToolbar_sp
*  ====================================================================
*;

*ProcessBody;
*  End EG generated code (do not edit this line);

proc printto log='/home/sasusers/gagorr/logs/TreePanel_sp.log' new;
run;

options mprint notes sasautos=("/home/sasusers/gagorr" sasautos);

data _null_;
	file _webout;
	input;
	put _infile_;
	cards4;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Panel Tree example</title>

    <!-- ** CSS ** -->

    <!-- base library -->
    <link rel="stylesheet" type="text/css" href="/ext-js/resources/css/ext-all.css" />
	<!-- page specific: use ColumnNodeUI for creation of a Column Tree -->
	<link rel="stylesheet" type="text/css" href="/cmis2011/ColumnNodeUI.css" />

    <!-- ** Javascript ** -->
    <!-- ExtJS library: base/adapter -->
    <script type="text/javascript" src="/ext-js/adapter/ext/ext-base.js"></script>

    <!-- ExtJS library: all widgets -->
    <script type="text/javascript" src="/ext-js/ext-all-debug.js"></script>

    <!-- page specific: use ColumnNodeUI for creation of a Column Tree -->
	<script type="text/javascript" src="/cmis2011/ColumnNodeUI.js"></script>

<script>

	Ext.BLANK_IMAGE_URL = '/ext-js/resources/images/default/s.gif';

	// application main entry point
	Ext.onReady(function(){
		Ext.QuickTips.init();
;;;;
run;

%macro sashelp_stores_maker;

	/* Create SASHELP dataset, which contains a list of all tables in SASHELP sas library and splits them into some dummy categories (folders).	*/
	proc sql;
		create table sashelp as
			select 
				memname, memlabel, modate, nobs,
				case
					when substr(upcase(memname),1,1) in ('A','B','C') then 'ABC'
					when substr(upcase(memname),1,1) in ('D','E','F') then 'DEF'
					when substr(upcase(memname),1,1) in ('G','H','I') then 'GHI'
					else 'Other'
				end as type
			from dictionary.tables 
				where 
					upcase(libname) eq 'SASHELP'
					and
					upcase(memtype) eq 'DATA'
				order by type, memname
	;
	quit;

	data _null_;
		set sashelp;
			call execute('%jsonstore_maker(sprefix='||strip(memname)||'_,dsetloc=sashelp.'||strip(memname)||', totprop=totalCount, loadlimit=)');
	run;

%mend sashelp_stores_maker;
%sashelp_stores_maker

data _null_ ;
	file _webout;
	input;
	put _infile_;
	cards4;
		// Define a variable ppcombo, which will contain info about a combobox used for defining the number of rows to be displayed on a single page.
		var ppcombo = new Ext.form.ComboBox({
			name : 'perpage',
			width: 40,
			store: new Ext.data.ArrayStore({
				fields: ['id'],
				data  : [
					['25'],
					['50'],
					['100']
				]
			}),
			mode : 'local',
			value: '25',
			listWidth     : 40,
			triggerAction : 'all',
			displayField  : 'id',
			valueField    : 'id',
			editable      : false,
			forceSelection: true
		});

		// Define a tree panel with the cool column/table layout.
	    var tree = new Ext.ux.tree.ColumnTree({
	        //width: 550,
	        //height: 300,
	        title: 'Sashelp Tables',
			iconCls:'nav',
	        rootVisible:false,
	        autoScroll:true,
			bodyStyle:'background-color: #DFE8F6', //D6ADD6
			border: false,
	        animate: true,
	        columns:[{
	            header:'Name',
	            width:200,
	            dataIndex:'memname'
	        },{
	            header:'Modyfication Date',
	            width:100,
	            dataIndex:'modate'
	        },{
	            header:'No. of Obs.',
	            width:80,
	            dataIndex:'nobs',
				anchor:'right 60%'
	        }],
	        loader: new Ext.tree.TreeLoader({
				preloadChildren: true,
	            uiProviders:{
	                'col': Ext.ux.tree.ColumnNodeUI
	            }
	        }),
	        root: new Ext.tree.AsyncTreeNode({
				allowChildren: true,
				children:
;;;;
run;

/* Create all relevant tree nods using the information from the 'sashelp' table. */
	data _null_;
		set sashelp end=eof;
			by type;
			file _webout ;
			if _n_ eq 1 then put "[{";
			if first.type then do;
				put "	memname:'" type +(-1) "',";
				put "	memlabel:'',";
				put "	modate:'',";
				put "	nobs:'',";
				put "	uiProvider:'col',";
		    	put "	cls:'master-task',";
		    	put "	iconCls:'task-folder',";
				put "	children:[{";
			end;
			put "		memname:'" memname +(-1) "',";
			put "		memlabel:'" memlabel +(-1) "',";
			put "		modate:'" modate +(-1) "',";
			put "		nobs:'" nobs +(-1) "',";
			put "		uiProvider:'col',";
	    	put "		leaf:true,";
	    	put "		iconCls:'tree-new-icon'";
			if ^last.type then put "	},{";
				else do;
					put "	}] //children closure"; 
					if ^eof then put "},{ //type closure";
				end;
			if eof then put "}] //final closure";

	run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
	        }),
			// Define the 'click' event and action to be taken on this event.
			// A single click on a given sashelp table nod will activate a new window showing the relevant data.
	        listeners: {
	            click: function(n) {
					if (n.attributes.nobs != '') {
						var mystore = eval(n.attributes.memname +'_store');
						// Define a paging toolbar.
						var mytoolbar = new Ext.PagingToolbar({
							pageSize: 25,
							items: [
								'-',
								'Records Per Page: ',
								ppcombo
							],
							displayInfo: true,
							emptyMsg: 'No data found',
							store: mystore,
							displayMsg: 'Displaying rows {0} - {1} of {2}'
						});
						// Apply the info stored in 'ppcombo' variable within the paging toolbar.
						ppcombo.on('select', function(ppcombo, record) { 
							mytoolbar.pageSize = parseInt(record.get('id'), 10); 
							mytoolbar.doLoad(mytoolbar.cursor); 
						}, this);

						var myGrid = new Ext.grid.GridPanel({
							xtype : 'grid',
							store : mystore,
							cm : eval(n.attributes.memname + '_colModel'),
							stripeRows: true, //assigning the stripes to the rows 
							autoScroll: true,
							//viewConfig: {
							//	forceFit: true
							//},
							loadMask : true,
							bbar : mytoolbar
						});
						// create and show window
						var myWin = new Ext.Window({
							title: n.attributes.memname,
							height: 550,
							width: 800,
							border: false,
							layout: 'fit',
							items: [myGrid]
						});
						myWin.show();
						mystore.on('beforeload', function(s) { 
	    					s.setBaseParam('dset', 'sashelp.'+n.attributes.memname);
						}); 
						mystore.reload({
							params : {
								start : 0,
								limit : 25
							}
						});
					} //if
				} //click
	        } //listeners
	    });

		// Define a simple layout of our application
	    new Ext.Viewport({
	        layout:'border',
			id: 'myViewport',
	        items:[{
	            region:'west',
	            id:'west-panel',
	            title:"Tree Panel",
				tabtip:"Tree Panel",
	            split:true,
	            width: 380,
	            minSize: 120,
	            maxSize: 400,
	            collapsible: true,
	            margins:'5 0 5 5',
	            cmargins:'5 0 5 5',
	            layout:'accordion',
	            layoutConfig:{
	                animate:true
	            },
				bodyStyle:'background-color: #DFE8F6',
				// West wing components:
	            items: [tree]
	        },{
				region:'center',
				html:'<b style="font-family:tahoma; font-size:12;">Center Panel</b>',
				border:true,
				bodyStyle:'background-color:#DFE8F6;',
				title:'Center'
	        }] // viewport items
	    }); // viewport
	}); //ext.onready

</script>
</head>
<body>
</body>
</html>
;;;;
run;

%let _result=streamfragment;
%STPBEGIN;
*';*";*/;run;
%STPEND

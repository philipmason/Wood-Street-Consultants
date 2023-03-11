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

proc printto log='/home/sasusers/gagorr/logs/MenuToolbar_sp.log' new;
run;

options mprint notes sasautos=("/home/sasusers/gagorr" sasautos);

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Phil's Paper - MenuToolbar example</title>

    <!-- ** CSS ** -->

    <!-- base library -->

    <link rel="stylesheet" type="text/css" href="/ext-js/resources/css/ext-all.css" />

	<!-- overrides to base library -->
    <link rel="stylesheet" type="text/css" href="/cmis2011/portal.css" />

    <!-- ** Javascript ** -->
    <!-- ExtJS library: base/adapter -->
    <script type="text/javascript" src="/ext-js/adapter/ext/ext-base.js"></script>

    <!-- ExtJS library: all widgets -->
    <script type="text/javascript" src="/ext-js/ext-all-debug.js"></script>

    <!-- extensions -->
    <script type="text/javascript" src="/ext-js/examples/ux/Portal.js"></script>
    <script type="text/javascript" src="/ext-js/examples/ux/PortalColumn.js"></script>
    <script type="text/javascript" src="/ext-js/examples/ux/Portlet.js"></script>

<script>

	Ext.BLANK_IMAGE_URL = '/ext-js/resources/images/default/s.gif';

	Ext.onReady(function(){

		Ext.QuickTips.init();

		var storetoload = new Ext.data.JsonStore({
			root: 'rows',
			totalProperty: 'totalCount',
			id: 'dset-jstore',
			autoLoad: {params: {start: 0, limit: 1}},
			remoteSort: true,
			fields: [
				'info'
			],
			// Access data
			url: 'http://tcensas1:8080/SASStoredProcess12a/do?_program=//Foundation/cmis/cmis2011/gridgetdata'
		});

		var colModeltouse = new Ext.grid.ColumnModel([
			{id: 'info', header: 'info', dataIndex: 'info', sortable: true, width: 150}
		]);

;;;;
run;

data dset_list;
	length dset_name $ 32;
	dset_name='Sashelp.Class'; output;
	dset_name='Sashelp.Prdsal2'; output;
run;
/* Create a simple store */
%simplestore_maker(newvar=Y, sprefix=dset_, dsetloc=work.dset_list, vars=)

proc sql;
	create table country as
		select unique
			country
		from sashelp.prdsal2
			order by country
;
quit;
%simplestore_maker(newvar=Y, sprefix=country_, dsetloc=work.country, vars=country)

proc sql;
	create table state as
		select unique
			country,
			state
		from sashelp.prdsal2
			order by country, state
;
quit;
%simplestore_maker(newvar=Y, sprefix=state_, dsetloc=work.state, vars=country state)

proc sql;
	create table name as
		select unique
			name
		from sashelp.class
			order by name
;
quit;
%simplestore_maker(newvar=Y, sprefix=name_, dsetloc=work.name, vars=)

proc sql;
	create table sex as
		select unique
			sex
		from sashelp.class
			order by sex
;
quit;
%simplestore_maker(newvar=Y, sprefix=sex_, dsetloc=work.sex, vars=)

data _null_;
	set dset_list;
		table=strip(scan(dset_name,2,.));
		call execute('%jsonstore_maker(sprefix='||strip(table)||'_,dsetloc='||strip(dset_name)||', totprop=totalCount, loadlimit=)');
run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
		var country_label = new Ext.Toolbar.TextItem('<b style="font-family:arial;">Country:</b>');
		var state_label = new Ext.Toolbar.TextItem('<b style="font-family:arial;">State:</b>');
		var name_label = new Ext.Toolbar.TextItem('<b style="font-family:arial;">Name:</b>');
		var sex_label = new Ext.Toolbar.TextItem('<b style="font-family:arial;">Sex:</b>');

		var country_combo = new Ext.form.ComboBox({
			store: country_store,
			id: 'country_combo',
			editable: false,
			//fieldLabel:'Country',
			displayField: 'country',
			valueField:'country',
			emptyText:'Select A Country...',
			selectOnFocus:true,
	        getListParent: function() {
	            return this.el.up('.x-menu');
	        },
			triggerAction:'all',
			resizable:true, // make the drop down list resizable
			mode:'local',
			listeners:{
				select: function(combo, record, index) {
					if (subBut.disabled) {subBut.enable();}
					// Reset the "state" combo: no value selected and the list of available values limited to the relevant entries for the current 'country' only.
					var combostate = Ext.getCmp('state_combo');
					combostate.clearValue();
					combostate.store.filter('country', combo.getValue());
				} //select
			}, //listeners
			lastQuery:''
		});

		var state_combo = new Ext.form.ComboBox({
			store: state_store,
			id: 'state_combo',
			editable: false,
			//fieldLabel:'State',
			displayField: 'state',
			valueField:'state',
			emptyText:'Select A State...',
			selectOnFocus:true,
	        getListParent: function() {
	            return this.el.up('.x-menu');
	        },
			//iconCls: 'no-icon',
			//width:135
			triggerAction:'all',
			resizable:true, // make the drop down list resizable
			mode:'local',
			listeners:{
				select: function() {
					if (subBut.disabled) {subBut.enable();}
				}
			},
			lastQuery:''
		});

		var geog_menu = new Ext.Toolbar.SplitButton({
	        text: '<b>Geography Menu<b>',
			id: 'geog_menu',
	        tooltip: {text:'To expand please select an arrow on the right', title:'Geography Menu'},
	        iconCls: 'blist',
	        // Menus can be built/referenced by using nested menu config objects
	        menu : {
		        style: {
		            overflow: 'visible'     // For the Combo popup
		        },
	            items: [
					'Country:', country_combo,
					'State:', state_combo
	            ]
	        }
	    });

		var name_combo = new Ext.form.ComboBox({
			store: name_store,
			id: 'name_combo',
			editable: false,
			//fieldLabel:'Name',
			displayField: 'Name',
			valueField:'Name',
			emptyText:'Select A Name...',
			selectOnFocus:true,
	        getListParent: function() {
	            return this.el.up('.x-menu');
	        },
			//iconCls: 'no-icon',
			//width:135
			triggerAction:'all',
			resizable:true, // make the drop down list resizable
			mode:'local',
			listeners:{
				select: function() {
					if (subBut.disabled) {subBut.enable();}
				}
			},
			lastQuery:''
		});

		var sex_combo = new Ext.form.ComboBox({
			store: sex_store,
			id: 'sex_combo',
			editable: false,
			//fieldLabel:'Sex',
			displayField: 'Sex',
			valueField:'Sex',
			emptyText:'Select A Gender...',
			selectOnFocus:true,
	        getListParent: function() {
	            return this.el.up('.x-menu');
	        },
			triggerAction:'all',
			resizable:true, // make the drop down list resizable
			mode:'local',
			listeners:{
				select: function() {
					if (subBut.disabled) {subBut.enable();}
				}
			},
			lastQuery:''
		});

		var menuToolbar = new Ext.Toolbar();
		var tbFiller = new Ext.Toolbar.TextItem('<p> </p>');

		subBut = new Ext.Button({
		    text: '&nbsp;&nbsp;SUBMIT&nbsp;&nbsp;',
			cls: 'x-btn-text-icon',
			icon: '/cmis2011/images/famfamfam/icons/accept.png',
			tooltip: 'Submit the form',
			id: 'subButton',
			disabled: true,
			listeners:{
				click: function() {
					var whr='1';
					if (curr_dset == 'Sashelp.Class') {
						currname=Ext.getCmp('name_combo').getValue();
						currsex=Ext.getCmp('sex_combo').getValue();
						if (currname != '') {var whr='name eq "'+currname+'"'}
						if (whr != '1' && currsex != '') {whr=whr+' and sex eq "'+currsex+'"'}
							else if (currsex != '') {whr='sex eq "'+currsex+'"'}
					} else if (curr_dset == 'Sashelp.Prdsal2') {
						currcountry=Ext.getCmp('country_combo').getValue();
						currstate=Ext.getCmp('state_combo').getValue();
						if (currcountry != '') {var whr='country eq "'+currcountry+'"'}
						if (whr != '' && currstate != '') {whr=whr+' and state eq "'+currstate+'"'}
							else if (currstate != '') {whr='state eq "'+currstate+'"'}
					}
					Ext.MessageBox.alert('whr',whr);
					/* Update the Grid */
					var mytable= Ext.getCmp('myViewport').findById('myTable');
					mytable.reconfigure(storetoload,colModeltouse);
					mytable.show();
					/* Pass some parameters 'forward'... */
					storetoload.on('beforeload', function(s) {
					    s.setBaseParam('dset', curr_dset);
					    s.setBaseParam('whr', whr);
					});
					storetoload.reload({params: {start: 0, limit: 25}})
					pagingToolbar.bind(storetoload);
				}
			},
		    anchor:'70%',
			autoHeight: true
		});

		var dset_combo = new Ext.form.ComboBox({
			editable: false,
			fieldLabel:'Dataset',
			displayField:'dset_name',
			emptyText:'Select a dataset...',
			valueField:'dset_name',
			id:'combo-dset',
			store: dset_store,
			triggerAction:'all',
			resizable:true, // make the drop down list resizable
			mode:'local',
			// Define actions to be performed on the selection of an item within the 'dataset' drop-down list:
			listeners:{
				select: function() {
					subBut.disable();
					// Clear some combo's values:
					country_combo.clearValue();
					state_combo.clearValue();
					name_combo.clearValue();
					sex_combo.clearValue();
					curr_dset=Ext.getCmp('combo-dset').getValue();

					if (curr_dset == 'Sashelp.Class') {
						storetoload=Class_store;
						colModeltouse=Class_colModel;
						var mytable= Ext.getCmp('myViewport').findById('myTable');
						mytable.reconfigure(storetoload,colModeltouse);
						mytable.show();
						storetoload.on('beforeload', function(s) { 
		    				s.setBaseParam('dset', curr_dset); 
						}); 
						storetoload.reload({ params: {start: 0, limit: 25} })
						pagingToolbar.bind(storetoload);

						geog_menu.hide();
						//selectionsMade('')
						name_label.show(); name_combo.show();
						sex_label.show(); sex_combo.show();
						tbFiller.show(); subBut.show();
						menuToolbar.doLayout();

					} else if (curr_dset == 'Sashelp.Prdsal2') {
						storetoload=Prdsal2_store;
						colModeltouse=Prdsal2_colModel;
						var mytable= Ext.getCmp('myViewport').findById('myTable');
						mytable.reconfigure(storetoload,colModeltouse);
						mytable.show();
						storetoload.on('beforeload', function(s) { 
		    				s.setBaseParam('dset', curr_dset);
						}); 
						storetoload.reload({ params: {start: 0, limit: 25} })
						pagingToolbar.bind(storetoload);

						name_label.hide(); name_combo.hide();
						sex_label.hide(); sex_combo.hide();
						//selectionsMade('')
						geog_menu.show();
						tbFiller.show(); subBut.show();
						menuToolbar.doLayout();

					} // else if
				} // select
			} // listeners

		}); // dset_combo

		menuToolbar.addField('<b> Dataset:</b>');
		menuToolbar.addField(dset_combo);
		menuToolbar.add('-');

		// Add and hide some other components stright away. Doesn't make much sense? Or does it?
		menuToolbar.add(geog_menu); geog_menu.hide();
		menuToolbar.addField(name_label); name_label.hide();
		menuToolbar.addField(name_combo); name_combo.hide();
		menuToolbar.addField(sex_label); sex_label.hide();
		menuToolbar.add(sex_combo); sex_combo.hide();
		menuToolbar.addItem(tbFiller); tbFiller.hide();
		menuToolbar.addField(subBut); subBut.hide();
		menuToolbar.doLayout();

		var pagingToolbar = new Ext.PagingToolbar({
			id: 'toolbar',
			pageSize: 25,
			displayInfo: true,
			emptyMsg: 'No data found',
			store: storetoload,
			displayMsg: 'Displaying rows {0} - {1} of {2}'
		});

		// The main look and feel of the application layout will be defined here [with the 'viewport' object].
	    new Ext.Viewport({
	        layout:'border',
			id: 'myViewport',
	        items:[{
				region:'west',
	            id:'west-panel',
	            title:"West Panel",
				tabtip:"West Panel",
	            split:true,
	            width: 180,
	            minSize: 120,
	            maxSize: 400,
	            collapsible: true,
				collapsed: true,
	            margins:'5 0 5 5',
	            cmargins:'5 0 5 5',
	            layout:'accordion',
	            layoutConfig:{
	                animate:true
	            }
			},{
				// Main part of the visualisation tool:
	            xtype:'portal',
	            region:'center',
	            margins:'5 0 0 0',
				items:[{
					columnWidth: 1,
					items:[{
						title: 'Data Filter',
						id: 'DataFilter',
						height: 60,
						//layout: 'fit',
						// Define all relevant combos - selections:
						items:[{
							xtype: 'toolbar',
							defaults:{bodyStyle:'padding:5px 0px 5px 0px; background-color:#DFE8F6;'},
							id: 'tpanel',
							items: menuToolbar
						}] //items data filter
					}] //items column layout
				},{ 
				// Continue with the definition of all other items to be displayed in the 'center' of this application.
					columnWidth:1,
					items:[{
						title: 'MyGrid',
						draggable:true,
						collapsible: true,
						anchor:'100%',
						height: 400,
						xtype: 'grid',
						id: 'myTable',
						store: storetoload,
						cm: colModeltouse,
						stripeRows: true, //assigning the stripes to the rows 
						loadMask: {msg:'Loading... Please wait.'},
						bbar : pagingToolbar
					}] // grid items
				}] // portal items
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


%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND

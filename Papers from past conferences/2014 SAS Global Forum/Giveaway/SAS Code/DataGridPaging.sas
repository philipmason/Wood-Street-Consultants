*  Begin EG generated code (do not edit this line);
*
*  Stored process registered by
*  Enterprise Guide Stored Process Manager v4.1
*
*  ====================================================================
*  Stored process name: DataGridPaging
*  ====================================================================
*;


*ProcessBody;
*  End EG generated code (do not edit this line);

%macro defaults ;
	libname dtemp 'D:\Temp' ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dset)=0 %then %do;
		%global dset;
		%let dset=dtemp.logcard;
	%end;
%mend defaults;
%defaults

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<html>
<head>
<title>Data Grid - Paging Example</title>
<link rel="stylesheet" type="text/css" href="/ext-3.4.0/resources/css/ext-all.css" />
<script src="/ext-3.4.0/adapter/ext/ext-base.js"></script>
<script src="/ext-3.4.0/ext-all.js"></script>
</head>

<body>
<script type="text/javascript">
Ext.onReady(function(){

    // create the Data Store
    var store = new Ext.data.JsonStore({
        root: 'rows',
        totalProperty: 'totalCount',
        //idProperty: 'id',
        remoteSort: false,
;;;;
run;

data _null_;
	file _webout;
	dsid=open("&dset");
	nvars=attrn(dsid,'nvars');
	put 
		"fields: [" / ;
	rc=fetch(dsid) ;
	do col=1 to nvars;
		vname=varname(dsid,col);
		put "'" vname +(-1) "'" @;
		if col ne nvars then put ', ' @;
			else put / "],";
	end;
	put '// Access data';
	put "url: 'http://inbn235.d50.intra:8080/SASStoredProcess/do?_program=/STAA/DataGridProvider" '&dset=' "&dset.'";
run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
    });
//    store.setDefaultSort('Age','desc');

    var grid = new Ext.grid.EditorGridPanel({
        width:700,
        height:500,
        store: store,
        trackMouseOver:false,
        disableSelection:true,
        loadMask: true,
		clicksToEdit: 1,
;;;;
run;

data _null_;
	length type $ 1;
	file _webout;
	dsid=open("&dset");
	nvars=attrn(dsid,'nvars');
	put 
      "title: '&dset'," /
		"// grid columns" /
		"columns:[{"
	;
	rc=fetch(dsid) ;
	do col=1 to nvars;
		vname=varname(dsid,col);
		put 'header: "' vname +(-1) '",';
		put 'dataIndex: "' vname +(-1) '",';
		put 'width: 100,';
		type=vartype(dsid,col);
		if type eq 'N' then put "align: 'right'," /
								"editor: new Ext.form.NumberField({" /
												"allowBlank: false," /
												"allowNegative: false," /
												"maxValue: 100000" /
											"})," ;
		else put 'editor: new Ext.form.TextField({ allowBlank: false }),' ;
		put 'sortable: true';
		if col ne nvars then put '},{';
			else put '}],';
	end;
run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
       // paging bar on the bottom
       bbar: new Ext.PagingToolbar({
            pageSize: 25,
            store: store,
            displayInfo: true,
            displayMsg: 'Displaying rows {0} - {1} of {2}',
            emptyMsg: "No data to display"
        })
    });

    // render it
    grid.render('row-grid');

    // trigger the data store load
    store.load({params:{start:0, limit:25}});

	new Ext.Button({
		text: 'Save',
		handler: function() {
								var data = [];
								Ext.each(grid.getStore().getModifiedRecords(), function(record){
									data.push(record.data);
								});
								Ext.Ajax.request({
									url: 'http://inbn235.d50.intra:8080/SASStoredProcess/do?_program=/STAA/test_save&dset=dtemp.logcard&idvar=logcardid',
									params: {data: Ext.encode(data)},
									success: function(){
										Ext.Msg.alert('success') ;
									},
									failure: function(){
										Ext.Msg.alert('failed') ;
									}
								});	
		},
		id: 'submit_button',
		renderTo: document.body
	});	

	new Ext.Button({
		text: 'Add',
		handler: function() {
								var u = new store.recordType({
								    id: "-1",
									Name : 'Phil Mason',
									Sex: 'M',
									Age : 0,
									Height : 0,
									Weight : 0
								});
								grid.stopEditing();
								grid.store.insert(0, u);
								grid.startEditing(0, 1);
		},
		id: 'add_button',
		renderTo: document.body
	});	


	
	
});
</script>
<div id="row-grid"></div>
</body>
</html>
;;;;
run ;
%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

*  Begin EG generated code (do not edit this line);
*';*";*/;run;

*  End EG generated code (do not edit this line);

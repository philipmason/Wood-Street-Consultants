%macro jsonstore_maker(sprefix=, dsetloc=, totprop=, loadlimit=);

	%* split the IN dataset name into libname and memname components for using against data dictionary;
/*	%if %index(&dsetloc,.)>0 %then %do;*/
/*		%let libname=%scan(&dsetloc,1,.);*/
/*		%let memname=%scan(&dsetloc,2,.);*/
/*	%end;*/
/*		%else %do;*/
/*			%let libname=work;*/
/*			%let memname=&in;*/
/*		%end;*/
	*** Remove all empty variables from the input dataset frist! ***;
/*	%drop_miss_vars(in=&dsetloc, out=&memname)*/

	data _null_;
		file _webout;

		put "	var &sprefix.store = new Ext.data.JsonStore({";
		put "	root: 'rows',";
		put "	totalProperty: '&totprop',";
		put "	id: '&sprefix.-jstore',";
		%if &loadlimit ne %then put "	autoLoad: {params: {start: 0, limit: &loadlimit}},";
			%else put "	autoLoad: true,";
		;
		put "	remoteSort: true,";

		dsid=open("&dsetloc");
		nvars=attrn(dsid,'nvars');
		put 
			"fields: ["
/*			"'id', " @*/
		;
		rc=fetch(dsid) ;
		do col=1 to nvars;
			vname=varname(dsid,col);
			vtype=vartype(dsid,col);
			vfmt=varfmt(dsid,col);
			if vname eq 'wh_load_dte' then put "{ name: '" vname +(-1) "', type: 'date', dateFormat: 'd/m/Y'}" @;
				else if vtype eq 'N' then do;
					if vfmt eq 'DATE9.' then put "{ name: '" vname +(-1) "', type: 'date', dateFormat: 'd/m/Y'}" @;
					else if vfmt eq: 'ROLES' then put "'" vname +(-1) "'" @;
					else put "{ name: '" vname +(-1) "', type: 'float'}" @;
				end;
				else put "'" vname +(-1) "'" @;
			if col ne nvars then put ', ' @;
				else put / "],";
		end;
		put '// Access data';
		put "url: 'http://&_SRVNAME:&_SRVPORT&_URL?_program=//Foundation/cmis/cmis2011/gridgetdata'";
		put '});';
		put "var &sprefix.colModel = new Ext.grid.ColumnModel([";
/*		put "{id:'id',header: 'ID', dataIndex: 'id', sortable: true},";*/
		do col=1 to nvars;
			vname=varname(dsid,col);
			vlabel=varlabel(dsid,col); /* This requires a label for each column on a input dataset. */
			if vlabel eq '' then vlabel=vname; /* But if variable does not have any label, then use variable's name instead. */
			vtype=vartype(dsid,col);
			vfmt=upcase(varfmt(dsid,col));
			put "{id: '" vname +(-1) "', header: '" vlabel +(-1) "', dataIndex: '" vname +(-1) "', sortable: true";
			if vname eq 'wh_load_dte' then put ", renderer: function(date) { return date.format('d-m-Y'); }";
				else if vname in ('period_total','period_total_to_date') then put ",align: 'right', renderer: change";
				else if vname eq 'info' then put ", width: 150";
				else if vtype eq 'N' then do;
					if vfmt eq 'DATE9.' then put ", renderer: function(date) { return date.format('d-m-Y'); }";
						else if vfmt in ('BEST12.','COMMA12.') then put ", align: 'right', renderer: number";
						else if vfmt eq: 'ROLES' then put ", renderer: jobtitles";
						else put ", align: 'right'";
				end;
				else if vtype eq 'C' then do;
					if vname eq 'kpi_type' then put ", hidden: true";
					if vfmt eq '$COUNTRY.' then put ", renderer: country";
						else if vfmt eq '$GOR.' then put ", renderer: gor";
						else if vfmt eq '$LAD.' then put ", renderer: lad";
				end;
			put '}' @;
			if col ne nvars then put ', ';
				else put "]);";
		end;
	run;

%mend;

/*%jsonstore_maker(sprefix=dset, dsetloc=refer2.nokpigrid, totprop=totalCount, loadlimit=1);*/


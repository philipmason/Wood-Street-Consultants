%macro jsonstore_maker(sprefix=, dsetloc=, totprop=, loadlimit=);

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
			if vtype eq 'N' then do;
				if vfmt eq 'DATE9.' then put "{ name: '" vname +(-1) "', type: 'date', dateFormat: 'd/m/Y'}" @;
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
		do col=1 to nvars;
			vname=varname(dsid,col);
			vlabel=varlabel(dsid,col); /* This requires a label for each column on a input dataset. */
			if vlabel eq '' then vlabel=vname; /* But if variable does not have any label, then use variable's name instead. */
			vlabel=translate(vlabel,"'",'"'); /* Convert all double quotes into single quotes, to avoid javascript errors. */
			vtype=vartype(dsid,col);
			vfmt=upcase(varfmt(dsid,col));
			put '{id: "' vname +(-1) '", header: "' vlabel +(-1) '", dataIndex: "' vname +(-1) '", sortable: true';
			if vtype eq 'N' then do;
				if vfmt eq 'DATE9.' then put ", renderer: function(date) { return date.format('d-m-Y'); }";
					else if vfmt in ('BEST12.','COMMA12.') then put ", align: 'right', renderer: Ext.util.Format.number()";
					else put ", align: 'right'";
			end;
			put '}' @;
			if col ne nvars then put ', ';
				else put "]);";
		end;
	run;

%mend;

/*%jsonstore_maker(sprefix=dset, dsetloc=refer2.nokpigrid, totprop=totalCount, loadlimit=1);*/


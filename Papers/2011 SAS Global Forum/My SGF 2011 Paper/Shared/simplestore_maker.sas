%macro simplestore_maker(newvar=,sprefix=, dsetloc=, vars=);

	data _null_;
		file _webout;
		set &dsetloc end=eof;
		dsid=open("&dsetloc");
		nvars=attrn(dsid,'nvars');
		if _n_ eq 1 then do;
			%if &newvar eq Y %then 	put "	var &sprefix.store = ";;
			put "new Ext.data.SimpleStore({";
			put 
				"fields: [" @/
			;
			%if &vars eq %then %do;
			rc=fetch(dsid) ;
				do col=1 to nvars;
					vname=varname(dsid,col);
					put "'" vname +(-1) "'" @;
					if col ne nvars then put ', ' @;
						else put / "],";
				end;
			%end;
				%else %do;
					%do col=1 %to %sysfunc(countw(%bquote(&vars),%str( )));
						length vname $ 32;
						vname="%scan(%bquote(&vars),&col,%str( ))";
						put "'" vname +(-1) "'" @;
						if &col ne %sysfunc(countw(%bquote(&vars),%str( ))) then put ', ' @;
							else put / "],";
					%end;
				%end;
		end;
		if _n_ eq 1 then put "data: [";
		put '[' @;
		%if &vars eq %then %do;
			do col=1 to nvars;
				vname=varname(dsid,col);
				vval=vvaluex(vname);
				put "'" vval +(-1) "'," @;
			end;
		%end;
			%else %do;
				%do col=1 %to %sysfunc(countw(%bquote(&vars),%str( )));
					vname="%scan(%bquote(&vars),&col,%str( ))";
					vval=vvaluex(vname);
					put "'" vval +(-1) "'," @;
				%end;
			%end;
		put +(-1) '],' @;
		if ^eof then put +(-1) @/;
		if eof then put +(-1) "]});";
	run;

%mend;



/*%simplestore_maker(sprefix=kpitypes, dsetloc=refer2.kpi_types, vars=)*/
/*%simplestore_maker(sprefix=kpi, dsetloc=refer.kpi, vars=kpi_id kpi_type kpi_name kpi_description)*/

/*%simplestore_maker(sprefix=users, dsetloc=refer.users, vars=userid username comments)*/

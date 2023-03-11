*  Begin EG generated code (do not edit this line);
*
*  Stored process registered by
*  Enterprise Guide Stored Process Manager v4.1
*
*;

*ProcessBody;
*  End EG generated code (do not edit this line);

/* A temporary measure to capture the log. This will be later replaced with proper access via SAS Log Analysis Tool. */
proc printto log='/home/sasusers/gagorr/logs/gridgetdata.log' new;
run;

/* The options below should go to a relevant stored process server autoexec file. */
options mprint sasautos=("/sasoma/&Lev_env/SMP/Macros/cmis2011" "/sasoma/&Lev_env/SMP/Macros/cmis" sasautos);

/* Set the default macro variables. */

%put dset=&dset;
%put whr=&whr;

%macro getdata;

	%if ^%symexist(dset) %then %do;
		data info;
			info='Please select a dataset.';
		run;
		%let dset=info;
	%end;
	%let first=%eval(&start+1);
	%let last=%eval(&start+&limit);

	/* Apply a relevant 'where' clause on the input file, if necessary... */
	data subset;
		set &dset 
			%if %symexist(whr) %then 
				%if &whr ne %then (where=(%sysfunc(strip(&whr))));
		;
	run;

	%if %symexist(sort) %then %do;
		%if &dir eq DESC %then %let dir=descending;
			%else %let dir=;
		proc sort data=subset out=subset;
			by &dir &sort;
		run;
	%end;
		%else %put No sorting order specified.;

	/* Only a relevant subset of information will be extracted from the server at a given time. */
	data _null_ ;
		dsid=open("subset");
		nobs=attrn(dsid,'nobs');
		call symput('nobs',strip(put(nobs,8.)));
		if &last gt nobs then call symput('last',nobs);
		dsid=close(dsid);
	run;

	%put ;
	%put first=&first last=&last nobs=&nobs;
	%put ;

	data subset;
		set subset (firstobs=&first obs=&last);
	run;

	/* Stream all requested information back to web browser. */
	data _null_ ;
		length char $ 128;
		file _webout;
		dsid=open("subset");
		nvars=attrn(dsid,'nvars');
		put 
			'{' /
			"'totalCount':'&nobs'," /
			'"rows":['
		;
		do row=&first to &last;
			put
				'{' @
			;
			rc=fetch(dsid) ;
			do col=1 to nvars;
				vname=varname(dsid,col);
				vtype=vartype(dsid,col);
				vfmt=varfmt(dsid,col);
				put '"' vname +(-1) '":' @;
				if vtype eq 'C' then do;
					char=getvarc(dsid,col);
					put '"' char +(-1) '"' @;
					if col ne nvars then put ',' @;
				end;
					else do;
						if vfmt eq 'DATE9.' then num=put(getvarn(dsid,col),ddmmyy10.);
							else num=getvarn(dsid,col);
						put '"' num +(-1) '"' @;
						if col ne nvars then put ',' @;
					end;
			end;
			if row ne &last then put '},';
				else put 
						'}' /
						']' /
						'}'
				;
		end;

		%if &nobs eq 0 %then 
			put 
				'	]' /
				'}'
			;
		;

		dsid=close(dsid);

	run;


%mend;
%getdata


%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

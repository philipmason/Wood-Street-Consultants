*  Begin EG generated code (do not edit this line);
*
*  Stored process registered by
*  Enterprise Guide Stored Process Manager v4.1
*
*  ====================================================================
*  Stored process name: DataGridProvider
*  ====================================================================
*;


*ProcessBody;
*  End EG generated code (do not edit this line);

*ProcessBody;

libname dtemp 'D:\Temp' ;


%macro defaults ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dset)=0 %then %do;
		%global dset;
		%let dset=sashelp.class;
	%end;
	%if ^%symexist(start) %then %do; %global start; %let start=0; %end;
	%if ^%symexist(limit) %then %do; %global limit; %let limit=160; %end;
%mend defaults;
%defaults

data _null_ ;
	dsid=open("&dset");
	nobs=attrn(dsid,'nobs');
	call symput('nobs',strip(put(nobs,8.)));
run;

%let first=%eval(&start+1);
%let last=%eval(&start+&limit);
/*%let first=1;*/
/*%let last=&nobs;*/

%put first=&first last=&last nobs=&nobs;

data subset;
	set &dset (firstobs=&first obs=&last);
run;

data _null_ ;
	length type $ 1 char $ 128 /*tcount*/ num 8;
	file _webout;
	dsid=open("subset");
	nvars=attrn(dsid,'nvars');
	*nobs=attrn(dsid,'nobs');
	*tcount=ceil(nobs/25);
	put 
		'{' /
		"'totalCount':'&nobs'," /*tcount +(-1) '",'*/ /
		'"rows":['
	;
	do row=&first to &last/*nobs*/;
*		put '{"id":"' row +(-1) '",' @ ;
		put '{' @ ;
		rc=fetch(dsid) ;
		do col=1 to nvars;
			vname=varname(dsid,col);
			put '"' vname +(-1) '":' @;
			type=vartype(dsid,col);
			if type eq 'C' then do;
				char=getvarc(dsid,col);
				put '"' char +(-1) '"' @;
				if col ne nvars then put ',' @;
			end;
				else do;
					num=getvarn(dsid,col);
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

	dsid=close(dsid);

run;


%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;


*  Begin EG generated code (do not edit this line);
*';*";*/;run;

*  End EG generated code (do not edit this line);

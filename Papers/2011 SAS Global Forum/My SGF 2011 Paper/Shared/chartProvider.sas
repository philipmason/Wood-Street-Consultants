*ProcessBody;

%macro defaults ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dset)=0 %then %do;
		%global dset;
		%let dset=sashelp.class;
	%end;
%mend defaults;
%defaults

data _null_ ;
	dsid=open("&dset");
	nobs=attrn(dsid,'nobs');
	call symput('nobs',strip(put(nobs,8.)));
run;

 *********** ;
 *** XML *** ;
 *********** ;

%let pathname=%sysfunc(pathname(work)) ;
libname test xml "&pathname/temp.xml" ;
data test.test ;
  set &dset ;
run ;
libname test ;
data _null_ ;
  infile "&pathname/temp.xml" ;
  file _webout ;
  input ;
  put _infile_ ;
run ;

/*data _null_ ;*/
/*	length type $ 1 char $ 128 num 8;*/
/*	file _webout;*/
/*	dsid=open("&dset");*/
/*	nvars=attrn(dsid,'nvars');*/
/*	put '{' /*/
/*		  'data: [' ;*/
/*	do row=1 to &nobs ;*/
/*		put*/
/*			'{' @*/
/*		;*/
/*		rc=fetch(dsid) ;*/
/*		do col=1 to nvars;*/
/*			vname=varname(dsid,col);*/
/*			put vname +(-1) ': ' @ ;*/
/*			type=vartype(dsid,col);*/
/*			if type eq 'C' then do;*/
/*				char=getvarc(dsid,col);*/
/*				put '"' char +(-1) '"' ;*/
/*				if col ne nvars then put ', ' ;*/
/*			end;*/
/*				else do;*/
/*					num=getvarn(dsid,col);*/
/*					put num +(-1) ;*/
/*					if col ne nvars then put ', ' ;*/
/*				end;*/
/*		end;*/
/*		if row ne &nobs then put '},' ;*/
/*			else put */
/*					'}' /*/
/*					']' /*/
/*					'}'*/
/*			;*/
/*	end;*/
/**/
/*	dsid=close(dsid);*/
/**/
/*run;*/

/* ************ ;*/
/* *** JSON *** ;*/
/* ************ ;*/
/*data _null_ ;*/
/*	length type $ 1 char $ 128 num 8;*/
/*	file _webout;*/
/*	dsid=open("&dset");*/
/*	nvars=attrn(dsid,'nvars');*/
/*	put '{' /*/
/*		  'data: [' ;*/
/*	do row=1 to &nobs ;*/
/*		put*/
/*			'{' @*/
/*		;*/
/*		rc=fetch(dsid) ;*/
/*		do col=1 to nvars;*/
/*			vname=varname(dsid,col);*/
/*			put vname +(-1) ': ' @ ;*/
/*			type=vartype(dsid,col);*/
/*			if type eq 'C' then do;*/
/*				char=getvarc(dsid,col);*/
/*				put '"' char +(-1) '"' ;*/
/*				if col ne nvars then put ', ' ;*/
/*			end;*/
/*				else do;*/
/*					num=getvarn(dsid,col);*/
/*					put num +(-1) ;*/
/*					if col ne nvars then put ', ' ;*/
/*				end;*/
/*		end;*/
/*		if row ne &nobs then put '},' ;*/
/*			else put */
/*					'}' /*/
/*					']' /*/
/*					'}'*/
/*			;*/
/*	end;*/
/**/
/*	dsid=close(dsid);*/
/**/
/*run;*/


%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

*';*";*/;run;

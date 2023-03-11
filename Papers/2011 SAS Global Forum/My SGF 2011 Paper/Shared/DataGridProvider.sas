*ProcessBody;
%* Use the WHERE passed in, so that this can be used more generically ;

%macro datagridprovider ;

	%* these defaults may be passed in, or else they default ;
	%if %symexist(dataset)=0 %then %do;
		%global dataset;
		%let dataset=sashelp.class;
	%end;

  %if %symexist(where)=0 %then %let where=1 ;

  %if %index(%lowcase(&dataset),cmis)>0 %then %do ;
/*    %global where ;*/
    options sasautos=('/home/sasusers/masonp1/cmis/macros' sasautos) ;
    %allocate_db ;
/*    %var_to_macvar(cmis.where,geog_where) ;*/
/*    %var_to_macvar(cmis.where,type) ;*/
/*    %let type=%eval(&type+1) ; %* add date dimension ;*/
    %let flag=0 ;
    %end ;
  %else %do ;
    %let flag=1 ;
    %end ;

  %let first=%eval(&start+1);
  %let last=%eval(&start+&limit);
  %put first=&first last=&last ;

/*%let dataset=%scan(%superq(dataset),1,%str(%()) ;*/
  
  %if &flag %then %do ;
    %if %index(&dataset,%str(%())>0 %then %do ;
      %let a=%scan(%superq(dataset),1,%str(%()) ;
      %let b=%scan(%superq(dataset),2,%str(%()) ;
      %let dataset=&a(firstobs=&first obs=&last) ;
      %end ;
    data subset;
    	set &dataset ;
    run;
    data _null_ ;
    	dsid=open("&dataset");
    	nobs=attrn(dsid,'nobs');
    	call symput('nobs',strip(put(nobs,8.)));
    run;
    %end ;
  %else %do ;
   * make a subset so that we can apply any where clause info ;
    data subset0 ;
    	set %unquote(&dataset) ;
        where %unquote(&where) ;
    run ;
    data _null_ ;
    	dsid=open("subset0");
    	nobs=attrn(dsid,'nobs');
    	call symput('nobs',strip(put(nobs,8.)));
    run;
    data subset(drop=_type_ _freq_) ;
      set subset0(firstobs=&first obs=&last) ;
    run;
    %end ;

  data _null_ ;
  	length type $ 1 varfmt string $ 32 char $ 128 /*tcount*/ num 8;
  	file _webout;
  	dsid=open("subset");
  	nvars=attrn(dsid,'nvars');
  	put 
  		'{' /
  		"'totalCount':'&nobs'," /*tcount +(-1) '",'*/ /
  		'"rows":['
  	;
    _last=min(&last,&nobs) ;
  	do row=&first to _last /*nobs*/ ;
  		put
  			'{"id":' row +(-1) ',' @
  		;
  		rc=fetch(dsid) ;
  		do col=1 to nvars;
  			vname=varname(dsid,col);
  			put '"' vname +(-1) '":' @;
  			type=vartype(dsid,col);
  			if type eq 'C' then do;
  				char=getvarc(dsid,col);
          varfmt=varfmt(dsid,col) ;
          if varfmt='' then put num @ ;
          else do ;
            string=putc(char,varfmt) ;
    				put '"' string +(-1) '"' @;
            end ;
/*  				put '"' char +(-1) '"' @;*/
  				if col ne nvars then put ',' @;
  			end;
  				else do;
  					num=getvarn(dsid,col);
            varfmt=varfmt(dsid,col) ;
            if varfmt='' then put num @ ;
            else do ;
              string=putn(num,varfmt) ;
    					put '"' string +(-1) '"' @;
              end ;
  					if col ne nvars then put ',' @;
  				end;
  		end;
  		if row ne _last then put '},';
  			else put 
  					'}' /
  					']' /
  					'}'
  			;
  	end;

  	dsid=close(dsid);
  run;

  %let _result=streamfragment ;

%mend datagridprovider ;
options mprint ;
%datagridprovider ;
*';*";*/;run;

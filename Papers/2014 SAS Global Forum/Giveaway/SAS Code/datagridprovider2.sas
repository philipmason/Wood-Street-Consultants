*ProcessBody;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
{
    "metaData": {
        "totalProperty": "total",
        "root": "records",
        "id": "id",
        "fields": [
            {
                "name": "id",
                "type": "int"
            },
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "age",
                "type": "int"
            },
            {
                "name": "sex",
                "type": "string"
            },
            {
                "name": "height",
                "type": "float"
            },
            {
                "name": "weight",
                "type": "float"
            }
        ]
    },
    "success": true,
    "total": 4,
    "records": [
        {
            "id": 1,
            "name": "Alfred",
            "age": 14,
            "sex": "M",
            "height": 69.00,
            "weight": 112.5
        },
        {
            "id": 2,
            "name": "Alice",
            "age": 13,
            "sex": "F",
            "height": 56.50,
            "weight": 84
        },
        {
            "id": 3,
            "name": "Barbara",
            "age": 13,
            "sex": "F",
            "height": 65.30,
            "weight": 98
        },
        {
            "id": 4,
            "name": "Henry",
            "age": 12,
            "sex": "M",
            "height": 57.30,
            "weight": 83
        }
    ],
    "columns": [
        {
            "header": "id",
            "dataIndex": "id"
        },
        {
            "header": "Name",
            "dataIndex": "name"
        },
        {
            "header": "Age",
            "dataIndex": "age"
        },
        {
            "header": "Sex",
            "dataIndex": "sex"
        },
        {
            "header": "Height",
            "dataIndex": "height"
        },
        {
            "header": "Weight",
            "dataIndex": "weight"
        }
    ]
}
;;;;
run ;

%macro datagridprovider ;
  %return ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dataset)=0 %then %do;
		%global dataset;
		%let dataset=sashelp.class;
	%end;

  %if %lowcase(%scan(&dataset,1,.))=cmis or 
      %lowcase(%scan(&dataset,1,.))=cmis2011 %then %do ;
    %global where ;
    options sasautos=('/home/sasusers/masonp1/cmis/macros' sasautos) ;
    %allocate_db ;
    %var_to_macvar(cmis.where,geog_where) ;
    %var_to_macvar(cmis.where,type) ;
    %let type=%eval(&type+1) ; %* add date dimension ;
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
    data subset0 ;
    	set %unquote(&dataset) ;
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
  	do row=&first to _last/*nobs*/;
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
  				put '"' char +(-1) '"' @;
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

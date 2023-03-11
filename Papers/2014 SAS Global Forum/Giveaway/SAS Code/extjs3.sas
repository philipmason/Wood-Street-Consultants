*ProcessBody;

%macro defaults ;
  %* these defaults may be passed in, or else they default ;
  %if %symexist(dset)=0 %then %do ;
    %global dset ;
    %let dset=sashelp.class ;
    %end ;
  %if %symexist(height)=0 %then %do ;
    %global height ;
    %let height=600 ;
    %end ;
  %if %symexist(width)=0 %then %do ;
    %global width ;
    %let width=800 ;
    %end ;
%mend defaults ;
%defaults ;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css"/>
<script type="text/javascript" src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/ext-3.2.1/ext-all-debug.js"></script> 
<script type="text/javascript">
;;;;
run ;

data _null_ ;
  length char dslabel label $ 128
         num 8 ;
  file _webout ;
  dsid=open("&dset") ;
  nvars=attrn(dsid,'nvars') ;
  put 'var store = new Ext.data.Store({' /
      'data: [' ;
  nobs=attrn(dsid,'nobs') ;
  do row=1 to nobs ;
    put '[' row +(-1) ', ' @ ;
    rc=fetch(dsid) ;
    do col=1 to nvars ;
      type=vartype(dsid,col) ;
      if type='C' then do ;
        char=getvarc(dsid,col) ;
        put "'" char +(-1) "'" @ ;
        if col^=nvars then put ',' @ ;
        end ;
      else do ;
        num=getvarn(dsid,col) ;
        put num +(-1) @ ;
        if col^=nvars then put ',' @ ;
        end ;
      end ;
    put ']' @ ;
    if row^=nobs then put ',' ;
    else put / '], ' ;
    end ;
  put "reader: new Ext.data.ArrayReader({id:'id'}," /
      '[ "id",' ;
  do col=1 to nvars ;
    varname=varname(dsid,col) ;
    label=coalescec(varlabel(dsid,col),varname) ;
    put '"' varname +(-1) '"' @ ;
    if col^=nvars then put ',' ;
    else put / ']' ;
    end ;
  put ')' /
      '}) ;' ;
  put "Ext.onReady(function(){" ;
  put "// add your data store here" ;
  put "var grid = new Ext.grid.GridPanel({" ;
  put "renderTo: document.body," ;
  put "frame:true," ;
  dslabel=coalescec(attrc(dsid,'label'),"&dset") ;
  put "title: '" dslabel +(-1) "'," ;
  put "height:&height," ;
  put "width:&width," ;
  put "store: store," ;
  put "columns: [" ;
  do col=1 to nvars ;
    varname=varname(dsid,col) ;
    label=coalescec(varlabel(dsid,col),varname) ;
    put '{header: "' label +(-1) '", sortable: true, dataIndex: "' varname +(-1) '"}' @ ;
    if col^=nvars then put ',' ;
    else put ;
    end ;
  put "]" / "})" / "});" ;
  dsid=close(dsid) ;
run ;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
 
</script>

<title id="page-title">My Grid</title>
</head>
<body>

</body>
</html>
;;;;
run ;

%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

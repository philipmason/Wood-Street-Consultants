%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : makeformat.sas                                     **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : make format for one variable which divides range   **
%*                   of values into a number of segments and then       **
%*                   create a table which uses this to create color     **
%*                   coded bars using HTML along with figures for use   **
%*                   in tabular report with bars and traffic lighting   **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*                                                                      **
%*  Reference      : 001                                                **
%*  By             : Phil Mason                                         **
%*  Date           : 22Jan2009                                          **
%*  Details        : Added color support for RTF                        **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 14Aug2009                                          **
%*  Details        : Add PRE HTML tab to make bars correct length       **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 19Aug2009                                          **
%*  Details        : set size of bar and text using em to fix size      **
%*                                                                      **
%************************************************************************;
%*  ;


%macro makeformat(v) ;
  %if %symexist(_odsdest) %then
    %if %upcase(&_odsdest)=PDF %then
      %return ;

  data minmax(keep=start end label fmtname) ;
    retain fmtname "_&v._" ;
    merge min(keep=&v. rename=(&v.=min_&v.))
          max(keep=&v. rename=(&v.=max_&v.)) ;
    diff=max_&v.-min_&v. ;
    if diff>0 then
      do ;
        do i=min_&v. to max_&v. by diff/&width ;
          n+1 ;
          start=i ; 
          end=i+diff/&width ;
          label=n ;
          output ;
        end ;
        start=end ;
        end=end+999 ;
        label=label-1 ;
        output ;
      end ;
    else
      do ;
        hlo='o' ;
        label=. ;
        output ;
      end ;
  run ;

  proc format cntlin=minmax ;
  run ;

  data bar_table(rename=(&v.=__&v. _&v.=&v.)) ;
    length a b c d _&v. $ 256 ;
    set bar_table ;
    n0=put(&v.,_&v._.) ;
    n=input(n0,8.) ; * how many chars should be highlighted from left - 1 for min, 20 for max ;
    if n=. or n=0 then
      n=1 ;
    l=length(strip(&v.)) ;       * length of value to be displayed from right ;
    w=&width ;                   * width of field - set to 20, has implications if changed ;
    n2=w-l ;                     * number of unbreakable spaces to use in field before highlighted part ;
   * get highlighted spaces to be shown ;
    an=min(n,n2) ;
    a=repeat('&nbsp;',an-1) ;
   * get unhighlighted spaces ;
    bn=n2-n ;
    if bn<=0 then
      b='' ;
    else
      b=repeat('&nbsp;',bn-1) ;
   * get characters to be shown highlighted ;
    cn=n-n2 ;
    if cn<=0 then
      c='' ;
    else
      c=substr(strip(&v.),1,cn) ;
   * get characters to be shown unhighlighted ;
    dn=w-n ;
    if dn<=0 then
      d='' ;
    else
      d=reverse(substr(reverse(strip(&v.)),1,min(l,dn))) ;
   * get characters to be shown highlighted ;
    n4=w-n-l ;
    %if &minmax_fmts %then
      %do ;
        minc=put("%sysfunc(compress(%upcase(&v),_))",$min.) ;
        maxc=put("%sysfunc(compress(%upcase(&v),_))",$max.) ;
        min=coalesce(input(minc,8.),-9e99) ;
        max=coalesce(input(maxc,8.),9e99) ;
        anchor='<a title="ULN = '||maxc||'0d'x||'LLN = '||minc||'">' ;
        putlog 'WARNING-' minc= &v= maxc= n= l= w= an= bn= cn= c= dn= d= minc= maxc= ;
      %end ;
    %else
      %do ;
        min=0 ;
        max=9e99 ;
        anchor='<a>' ;
      %end ;
    %if %symexist(bypass)=0 %then
      %let bypass=0 ;
    %if &bypass=0 %then
      %do ;
        if &v=. then     _&v.=strip(anchor)||"&missing."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ; else
        if &v<min/2 then _&v.=strip(anchor)||"&lowest."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ; else
        if &v<min then   _&v.=strip(anchor)||"&low."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ; else
        if &v>2*max then _&v.=strip(anchor)||"&highest."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ; else
        if &v>max then   _&v.=strip(anchor)||"&high."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ; else
                         _&v.=strip(anchor)||"&normal."||compress(a)||compress(c)||"</a></span>"||compress(b)||compress(d) ;
        _&v.='<pre style="font-size: 1.3em">'||strip(_&v.)||'</pre>' ;
      %end ;
/* ref001 - start */
    %else
      %do ;
        if &v=. then     _&v.="@white@" ||compress(&v) ; else
        if &v<min/2 then _&v.="@&lowest2.@" ||compress(&v) ; else
        if &v<min then   _&v.="@&low2.@"    ||compress(&v) ; else
        if &v>2*max then _&v.="@&highest2.@"||compress(&v) ; else
        if &v>max then   _&v.="@&high2.@"   ||compress(&v) ; else
                         _&v.="@&normal2.@" ||compress(&v) ;
      %end ;
/* ref001 - end */
  run ;
%mend makeformat ;

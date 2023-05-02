%macro templt(x_dim,y_dim) ;
data templt ;
*  x_dim=2 ;
*  y_dim=2 ;
  x_max=100 ;
  y_max=100 ;
  x_seg=x_max/&x_dim ;
  y_seg=y_max/&y_dim ;
  call execute('proc greplay tc=sasuser.templt gout=sasuser.gout nofs;') ;
  call execute('tdelete T'||trim(left(putn(&x_dim,'2.')))||'x'||
                            trim(left(putn(&y_dim,'2.')))||';') ;
  call execute('tdef T'||trim(left(putn(&x_dim,'2.')))||'x'||
                         trim(left(putn(&y_dim,'2.')))) ;
  tdef=0 ;
  do a=1 to &x_dim ;
    do b=1 to &y_dim ;
      tdef+1 ;
      call execute(trim(left(putn(tdef,'2.')))||'/') ;
      llx=(a-1)*x_seg ;
      lly=(b-1)*y_seg ;
      lrx=a*x_seg ;
      lry=(b-1)*y_seg ;
      ulx=(a-1)*x_seg ;
      uly=b*y_seg ;
      urx=a*x_seg ;
      ury=b*y_seg ;
      output ;
      call execute('llx='||putn(llx,'4.1')||' lly='||putn(lly,'4.1')) ;
      call execute('lrx='||putn(lrx,'4.1')||' lry='||putn(lry,'4.1')) ;
      call execute('ulx='||putn(ulx,'4.1')||' uly='||putn(uly,'4.1')) ;
      call execute('urx='||putn(urx,'4.1')||' ury='||putn(ury,'4.1')) ;
    end ;
  end ;
  call execute('; run ; quit ;') ;
  call execute('proc greplay igout=sashelp.eisgrph') ;
  call execute('             gout=sasuser.gout') ;
  call execute('             tc=sasuser.templt') ;
  call execute('             template=T'||trim(left(putn(&x_dim,'2.')))||'x'||
                                          trim(left(putn(&y_dim,'2.')))||';') ;
  call execute('run ; quit ;') ;
run ;
%mend templt ;

%templt(4,4)

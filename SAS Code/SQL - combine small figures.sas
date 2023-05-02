options mprint ;

%macro limit(limit=0.1,
             class1=a,
             class2=b,
             anal=x,
             more=.) ;

* Limit ... values less that this percentage are combined ;
* class1 ... 1st classification variable ;
* class2 ... 2nd classification variable ;
* anal ... analysis variable ;
* more ... value to use for values that are combined ;

*** Create test data ;
  data test ;
    do &class1=1 to 5 ;
      do &class2=1 to 10 ;
        &anal=ranuni(b)*100 ;
        output ;
      end ;
    end ;
  run ;

  proc sql ;
    select &class1,
           &class2,
           sum(&anal) as &anal
    from
         (select &class1,
                 case when(&anal/sum(&anal)<&limit) then &more
                      else &class2
                 end as &class2,
                 &anal
          from test
          group by &class1)
    group by &class1,
             &class2 ;
  quit ;
%mend limit ;

%limit(limit=0.15) ;

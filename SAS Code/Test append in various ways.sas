*** Reset*** ; data work.test ; set serveur.gpobzc ; run ;

* Test datastep concatenate ;
data work.test ;
  set work.test
      serveur.motbase ;
run ;

*** Reset*** ; data work.test ; set serveur.gpobzc ; run ;

* Test proc append ;
proc append base=work.test
            data=serveur.motbase
            force ;
run ;

*** Reset*** ; data work.test ; set serveur.gpobzc ; run ;

* Test SQL append as an Outer Union ;
proc sql ;
  create table work.test as
    select a.* from work.test
    outer union corr
    select * from serveur.motbase ;
quit ;

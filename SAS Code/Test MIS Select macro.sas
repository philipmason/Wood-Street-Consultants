* This dataset is used to define subsetting information ;
data sub_test ;
  var='fund' ;
  num=.;
  char='05' ;
  output ;
  char='01' ;
  output ;
run ;

options mprint ;
%select(hos,act,hstate hprov,subset=sub_test)

%select(hos,act,fund hprov hstate sex,noform=fund)
%select(hos,act,fund hstate hprov,noform=hprov)

%select(hos,icd,fund,anal=ic:)
%select(hos,icd,fund caretp icd sex)

%select(mem,memspv,fundno,anal=an:)
%select(mem,memspv,fundno pdtomth,anal=an:)

%select(hcl,repgrp,fund hprov,anal=tot:)

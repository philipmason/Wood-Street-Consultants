Data Thurst(TYPE=CORR);
   Title "Example of THURSTONE resp. McDONALD (1985, p.57, p.105)";
      _TYPE_ = 'CORR'; Input _NAME_ $ Obs1-Obs9;
      Label Obs1='Sentences' Obs2='Vocabulary' Obs3='Sentence Completion'
            Obs4='First Letters' Obs5='Four-letter Words' Obs6='Suffices'
            Obs7='Letter series' Obs8='Pedigrees' Obs9='Letter Grouping';
      Datalines;
   Obs1  1.       .      .      .      .      .      .      .      .
   Obs2   .828   1.      .      .      .      .      .      .      .
   Obs3   .776   .779   1.      .      .      .      .      .      .
   Obs4   .439   .493    .460  1.      .      .      .      .      .
   Obs5   .432   .464    .425   .674  1.      .      .      .      .
   Obs6   .447   .489    .443   .590   .541  1.      .      .      .
   Obs7   .447   .432    .401   .381   .402   .288  1.      .      .
   Obs8   .541   .537    .534   .350   .367   .320   .555  1.      .
   Obs9   .380   .358    .359   .424   .446   .325   .598   .452  1.
   ;


   proc calis data=Thurst method=max edf=212 pestim se;
   Title2 "Identified Second Order Confirmatory Factor Analysis";
   Title3 "C = F1 * F2 * P * F2' * F1' + F1 * U2 * F1' + U1, With P=U2=Ide";   
   Lineqs                                                                      
      Obs1 = X1 F1 + E1,                                                        
      Obs2 = X2 F1 + E2,                                                        
      Obs3 = X3 F1 + E3,                                                        
      Obs4 = X4 F2 + E4,                                                        
      Obs5 = X5 F2 + E5,                                                        
      Obs6 = X6 F2 + E6,                                                        
      Obs7 = X7 F3 + E7,                                                        
      Obs8 = X8 F3 + E8,                                                        
      Obs9 = X9 F3 + E9,                                                        
      F1   = X10 F4 + E10,                                                      
      F2   = X11 F4 + E11,                                                      
      F3   = X12 F4 + E12;                                                      
   Std                                                                         
      F4      = 1. ,                                                            
      E1-E9   = U11-U19 ,                                                       
      E10-E12 = 3 * 1.;                                                         
   Bounds                                                                      
      0. <= U11-U19;                                                            
   run;


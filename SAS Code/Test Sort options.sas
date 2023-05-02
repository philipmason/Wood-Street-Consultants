*** Unsort dataset *** ; PROC SORT DATA=SERVEUR.MM ; BY askq ; RUN;

* Test normal sort of a large file: 23,585kb ;
PROC SORT DATA=SERVEUR.MM ;
  BY CURR RTDATE MTDATE;
RUN;

*** Unsort dataset *** ; PROC SORT DATA=SERVEUR.MM ; BY askq ; RUN;

* Do it again to make sure ;
PROC SORT DATA=SERVEUR.MM ;
  BY CURR RTDATE MTDATE;
RUN;

*** Unsort dataset *** ; PROC SORT DATA=SERVEUR.MM ; BY askq ; RUN;

* Do it again but with the NOEQUALS option ;
PROC SORT DATA=SERVEUR.MM noequals ;
  BY CURR RTDATE MTDATE;
RUN;

*** Unsort dataset *** ; PROC SORT DATA=SERVEUR.MM ; BY askq ; RUN;

* Test TAGSORT option on the same file ;
PROC SORT DATA=SERVEUR.MM tagsort ;
  BY CURR RTDATE MTDATE;
RUN;

*** Unsort dataset *** ; PROC SORT DATA=SERVEUR.MM ; BY askq ; RUN;

* Test SORTSIZE option on the same file ;
PROC SORT DATA=SERVEUR.MM sortsize=max ;
  BY CURR RTDATE MTDATE;
RUN;

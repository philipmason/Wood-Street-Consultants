/*** NEW CURRENCY FORMATS FOR UK AND OTHERS 
NLMNLAUD
NLMNLCAD
NLMNLCHF 
NLMNLCNY
NLMNLDKK
NLMNLEUR
NLMNLGBP 
NLMNLHKD
NLMNLILS 
NLMNLJPY 
NLMNLKRW 
NLMNLMYR 
NLMNLNOK 
NLMNLNZD 
NLMNLPLN 
NLMNLRUR 
NLMNLSEK 
NLMNLSGD 
NLMNLTWD 
NLMNLUSD 
NLMNLZAR
*/ 
 
DATA _NULL_;
x = 1234.56;
PUT 'UK - '          @20 x NLMNLGBP. @40 x NLMNIGBP.
  / 'Japan - '       @20 x NLMNLJPY. @40 x NLMNIJPY.
  / 'Australia - '   @20 x NLMNLAUD. @40 x NLMNIAUD.
  / 'Euro - '        @20 x NLMNLEUR. @40 x NLMNIEUR.
  / 'New Zealand - ' @20 x NLMNLNZD. @40 x NLMNINZD. ;
RUN;


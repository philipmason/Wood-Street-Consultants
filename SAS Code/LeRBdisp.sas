
options nosource nospool;

%annomac;

 /*
  libname gdevice0 'c:\SeUGI\my_drvrs';run;

options nocenter ls=80 pageno=1;title;footnote;
proc gdevice c=gdevice0.devices browse nofs;
list emfp;
run;
quit; 

*goptions reset=all;
*goptions device=emfp gsfmode=replace;

**goptions hsize=6.79 in hpos=80;
**goptions vsize=4.22 in vpos=37;
 */

options nomprint;

%MACRO NAM255PA(
grafname=,
coldata=,
colcount=,
colsplin=,
colsep=,
namevar=,
namelen=,
nameovhd=,
nameht=,
namefont=,
graftitl=,
titlovhd=,
titlht=,
titlfont=,
ymax=99,
xmin=1,
color=rgbname);
data _null_;
call symput('y1start',&ymax - &nameht);
temp2 = int((100 - &xmin - (&colsplin * &colsep)) / &colsplin);
call symput('barwidth',put(temp2,3.));
temp3 = &colcount / &colsplin;
if temp3 ne int(temp3) then temp3 = int(temp3) + 1;
temp4 = int((&ymax - (&nameht) - ((&nameovhd + &nameht) * temp3) - (&titlovhd + &titlht)) / temp3);
call symput('barht',put(temp4,3.));
run; 
data toshow; 
xsys = '3'; ysys = '3'; hsys = '3';
length function color $ 8 style $ 8 text $ 80; 
drop x1 y1 thisline;
retain x1 &xmin;
retain y1 &y1start;
retain thisline 0; 
set &coldata;
text = substr(&namevar,1,&namelen);
%label(x1, y1, text, BLACK, 0, 0, &nameht, &namefont, 3);
y1 = y1 - &barht;
color = &color;
%bar(x1, y1, x1 + &barwidth, y1 + &barht, *, 3, solid);
if _N_ lt &colcount then do;
  thisline + 1;
  if (thisline eq &colsplin) then do;
    thisline = 0; 
    x1 = &xmin;
	if y1 ge (&nameht + &nameovhd) then y1 = y1 - (&nameht + &nameovhd);
	else y1 = &y1start;
  end;
  else do;
    x1 = x1 + &barwidth + &colsep;
	y1 = y1 + &barht;
  end;
end;
else do;
  if y1 ge (&titlht + &titlovhd) then do;
    text = "&graftitl"; 
    %label(&xmin, y1 - (&titlht + &titlovhd), text, BLACK, 0, 0, &titlht, &titlfont, 3);
  end; 
  stop;
end;
run;

proc ganno anno=toshow; 
run;

%mend  NAM255PA;

data colpie06(keep=name fname hlsname rgbname value);
retain value 1; 
length rgbname hlsname name $ 8;
input @4 name $8.
      @15 r 3. @19 g 3. @23 b 3.
      @28 h 3. @32 l 3. @36 s 3.
      @43 fname $10.; 
rgbname =  'CX' || put(r,hex2.) || put(g,hex2.) || put(b,hex2.) ;
hlsname =  'H'  || put(h,hex3.) || put(l,hex2.) || put(s,hex2.) ;
cards;
   BLUE       000 000 255  000 128 255    Blue
   MAGENTA    255 000 255  060 128 255    Magenta
   RED        255 000 000  120 128 255    Red
   YELLOW     255 255 000  180 128 255    Yellow
   GREEN      000 255 000  240 128 255    Green
   CYAN       000 255 255  300 128 255    Cyan
;
run;

data _null_;
set colpie06;
call symput('sasname'||left(_N_),trim(left(name)));
run;

data _null_;
set colpie06;
call symput('hls'||left(_N_),trim(left(hlsname)));
run;

data _null_;
set colpie06;
call symput('rgb'||left(_N_),trim(left(rgbname)));
run;

goptions ftext='Arial' htext=1.5;

pattern1  v=psolid c=&rgb1;
pattern2  v=psolid c=&rgb2;
pattern3  v=psolid c=&rgb3;
pattern4  v=psolid c=&rgb4;
pattern5  v=psolid c=&rgb5;
pattern6  v=psolid c=&rgb6;

*goptions gsfname=rgb6;
*filename rgb6 "c:\TheBook\color\rgb6.emf";

title  j=l f='Arial' h=2.0 'The Six Basic Colors'; 
title2 j=l f='Arial' h=2.0 'Assigned Via SAS RGB Color Names (of the form CXrrggbb)';
footnote1 j=l f='Arial' h=2.0 'Counterclockwise "from 3 O''Clock": Alleged RGB Values';
footnote2 j=l f='Arial' h=2.0 'for SAS Predefined BLUE MAGENTA RED YELLOW GREEN CYAN';
footnote3 j=l f='Arial' h=2.0 'These RGB Codes & Black(000000) & White(FFFFFF) are Browser Safe';
proc gchart data=colpie06;
pie rgbname / midpoints="&rgb1" "&rgb2" "&rgb3" "&rgb4" "&rgb5" "&rgb6"
              sumvar=value coutline=black noheading slice=arrow value=none percent=none;
run;
quit;

pattern1  v=psolid c=&hls1;
pattern2  v=psolid c=&hls2;
pattern3  v=psolid c=&hls3;
pattern4  v=psolid c=&hls4;
pattern5  v=psolid c=&hls5;
pattern6  v=psolid c=&hls6;

*goptions gsfname=hls6;
*filename hls6 "c:\TheBook\color\hls6.emf";

title  j=l f='Arial' h=2.0 'The Six Basic Colors'; 
title2 j=l f='Arial' h=2.0 'Assigned Via SAS HLS Color Names (of the form Hhhhllss)';
footnote1 j=l f='Arial' h=2.0 ' ';
footnote2 j=l f='Arial' h=2.0 'Counterclockwise "from 3 O''Clock": Alleged HLS Values';
footnote3 j=l f='Arial' h=2.0 'for SAS Predefined BLUE MAGENTA RED YELLOW GREEN CYAN';

proc gchart data=colpie06;
pie hlsname / sumvar=value coutline=black noheading slice=arrow value=none percent=none;
run;
quit;

pattern1  v=psolid c=&sasname1;
pattern2  v=psolid c=&sasname2;
pattern3  v=psolid c=&sasname3;
pattern4  v=psolid c=&sasname4;
pattern5  v=psolid c=&sasname5;
pattern6  v=psolid c=&sasname6;

*goptions gsfname=sasname6;
*filename sasname6 "c:\TheBook\color\sasname6.emf";

title  j=l f='Arial' h=2.0 'The Six Basic Colors'; 
title2 j=l f='Arial' h=2.0 'Assigned Via SAS Predefined Color Names';
footnote1 j=l f='Arial' h=2.0 ' ';
footnote2 j=l f='Arial' h=2.0 ' ';
footnote3 j=l f='Arial' h=2.0 ' ';
proc gchart data=colpie06;
pie name / midpoints="&sasname1" "&sasname2" "&sasname3" "&sasname4" "&sasname5" "&sasname6"
           sumvar=value coutline=black noheading slice=arrow value=none percent=none;
run;
quit;

data colpie12(keep=name hlsname fname value);
retain value 1;
length hlsname $ 8;
input @4 name $8.
      @15 r 3. @19 g 3. @23 b 3.
      @28 h 3. @32 l 3. @36 s 3.
      @43 fname $20.; 
* rgbname =  'CX' || put(r,hex2.) || put(g,hex2.) || put(b,hex2.) ;
hlsname =  'H'  || put(h,hex3.) || put(l,hex2.) || put(s,hex2.) ;
cards;
   BLUE       000 000 000  000 128 255    000 BLUE
   XVIOLET    000 000 000  030 128 255    01E Purple?
   MAGENTA    000 000 000  060 128 255    03C MAGENTA
   XPINK      000 000 000  090 128 255    05A "OtherRed"
   RED        000 000 000  120 128 255    078 RED
   ORANGE     000 000 000  150 128 255    096 ORANGE
   YELLOW     000 000 000  180 128 255    0B4 YELLOW
   XYLLWGRN   000 000 000  210 128 255    0D2 MyYellowGreen
   GREEN      000 000 000  240 128 255    0F0 GREEN
   XBLUEGRN   000 000 000  270 128 255    10E "OtherGreen"
   CYAN       000 000 000  300 128 255    12C CYAN
   XOTHRBLU   000 000 000  330 128 255    14A "OtherBlue"
;
run;

data _null_;
set colpie12;
call symput('col'||left(_N_),trim(left(hlsname)));
run;

goptions ftext='Arial' htext=1.5;

pattern1  v=psolid c=&col1;
pattern2  v=psolid c=&col2;
pattern3  v=psolid c=&col3;
pattern4  v=psolid c=&col4;
pattern5  v=psolid c=&col5;
pattern6  v=psolid c=&col6;
pattern7  v=psolid c=&col7;
pattern8  v=psolid c=&col8;
pattern9  v=psolid c=&col9;
pattern10 v=psolid c=&col10;
pattern11 v=psolid c=&col11;
pattern12 v=psolid c=&col12;

*goptions gsfname=hls12;
*filename hls12 "c:\TheBook\color\hls12.emf";

title  j=l f='Arial' h=2.0 'Twelve-Color Wheel (with SAS HLS Color Names)';
title2 j=l f='Arial' h=2.0 'By increasing hue. All 50% Lightness (ll=80) & 100% Saturation (ss=FF)';
footnote;
proc gchart data=colpie12;
pie hlsname / sumvar=value coutline=black noheading slice=arrow value=none percent=none;
run;
quit;

*goptions gsfname=desc12;
*filename desc12 "c:\TheBook\color\desc12.emf";

title  j=l f='Arial' h=2.0 'Twelve-Color Wheel (with Descriptions)'; 
title2 j=l f='Arial' h=2.0 "With HLS hue values (hhh) and SAS or LeRB Descriptive Color Names";
footnote;
proc gchart data=colpie12;
pie fname  / sumvar=value coutline=black noheading slice=arrow value=none percent=none;
run;
quit;

title;

%MACRO PIcol180;

data toshow; 
xsys = '3'; ysys = '3'; hsys = '3';
length function color style $ 8 angle rotate size 4 position $ 1 text $ 80;
retain x1 50;
retain y1 50;
%do i = 0 %to 358 %by 2;
  %slice(x1, y1, &&huseq&i, 2, 25, &&Hcol&i, PSOLID);
%end;
text = 'Wheel of 180 SAS HLS Colors';
%label(1, 96, text, BLACK, 0, 0, 3, 'Arial', C);
text = 'Hue increases by 2 units every 2 degrees around the pie';
%label(1, 93, text, BLACK, 0, 0, 3, 'Arial', C);
text = 'All 50% Lightness (ll=80) & 100% Saturation (ss=FF)';
%label(1, 90, text, BLACK, 0, 0, 3, 'Arial', C);
text = 'Cannot display 360 colors due to SAS limit of 255 simultaneous colors';
%label(1, 3, text, BLACK, 0, 0, 2, 'Arial', C);
text = 'Any observable non-uniformity in gradation was NOT requested';
%label(1, 1, text, BLACK, 0, 0, 2, 'Arial', C);
run;

proc ganno anno=toshow; 
run;

%mend  PIcol180;

data _NULL_;
length hlsbyseq $ 8 hueseq 3 huevalhx $ 3;
do h = 0 to 358 by 2;
  hueseq   = put(h,3.);
  huevalhx = put(h,hex3.);
  hlsbyseq = 'H' || huevalhx || '80FF';
  call symput('huseq'||trim(left(hueseq)),trim(left(hueseq)));
  call symput('huhex'||trim(left(hueseq)),huevalhx);
  call symput('Hcol'||trim(left(hueseq)),hlsbyseq);
  output;
end;
run;

*goptions gsfname=hls180;
*filename hls180 "c:\TheBook\color\hls180.emf";

%PIcol180
run;


 /* list of color names and codes below was found at SAS.COM  */
 /* there are a few discrepancies between it and the manual   */
 /* but they are not the reason for unusual color experiences */      
data sascols(keep=name rgbname hlsname fname h l s);
   format h l s z3.; 
   length rgbname hlsname $ 8;
   length fname $ 30;
   input @4 name $8.
         @15 r 3. @19 g 3. @23 b 3.
         @28 h 3. @32 l 3. @36 s 3.
         @43 fname $30.; 
   fname = lowcase(fname); 
   if name in ('BL' 'WH' 'GRAY') then delete; 
   rgbname =  'CX' || put(r,hex2.) || put(g,hex2.) || put(b,hex2.) ;
   hlsname =  'H'  || put(h,hex3.) || put(l,hex2.) || put(s,hex2.) ;
   cards;
   BLACK      000 000 000  000 000 000    Black
   WHITE      255 255 255  000 255 000    White
   RED        255 000 000  120 128 255    Red
   GREEN      000 255 000  240 128 255    Green
   BLUE       000 000 255  000 128 255    Blue
   PURPLE     112 048 112  060 080 102    Purple
   VIOLET     176 144 208  030 176 103    Violet
   ORANGE     255 128 000  150 128 255    Orange
   YELLOW     255 255 000  180 128 255    Yellow
   PINK       255 000 128  089 128 255    Pink
   CYAN       000 255 255  300 128 255    Cyan
   MAGENTA    255 000 255  060 128 255    Magenta
   BROWN      160 080 000  150 080 255    Brown
   GOLD       255 170 000  160 128 255    Gold
   LIME       192 255 129  210 192 255    Lime
   GRAY       128 128 128  000 128 000    Gray
   LILAC      224 096 144  098 160 172    Lilac
   MAROON     112 000 000  120 056 255    Maroon
   SALMON     255 000 085  100 128 255    Salmon
   TAN        224 168 096  154 160 172    Tan
   ROSE       255 096 096  120 176 255    Rose
   CREAM      232 216 152  168 192 162    Cream
   VIPK       204 027 059  109 116 195    Vivid pink
   STPK       217 087 110  109 152 161    Strong pink
   DEPK       153 041 061  109 097 148    Deep pink
   LIPK       229 153 167  109 191 153    Light pink
   MOPK       186 124 135  109 155 079    Moderate pink
   DAPK       153 092 103  109 122 064    Dark pink
   PAPK       229 191 198  109 210 109    Pale pink
   GRPK       186 155 161  109 171 047    Grayish pink
   PKWH       237 221 224  109 229 078    Pinkish white
   PKGR       191 178 181  109 185 023    Pinkish gray
   VIR        051 007 015  109 029 195    Vivid red
   STR        115 023 039  109 069 170    Strong red
   DER        076 025 035  109 051 128    Deep red
   VDER       025 010 013  109 018 109    Very deep red
   MOR        115 046 058  109 080 109    Moderate red
   DAR        064 038 043  109 051 064    Dark red
   VDAR       025 018 019  109 022 045    Very dark red
   LIGRR      153 112 120  109 133 042    Light grayish red
   GRR        115 084 090  109 099 039    Grayish red
   DAGRR      069 060 061  109 064 018    Dark grayish red
   BLR        025 023 023  109 024 013    Blackish red
   RGR        140 131 133  109 136 010    Reddish gray
   DARGR      089 083 084  109 086 009    Dark reddish gray
   RBK        025 025 025  109 025 004    Reddish black
   VIYPK      204 043 027  125 116 195    Vivid yellowish pink
   STYPK      204 093 082  125 143 139    Strong yellowish pink
   DEYPK      153 051 041  125 097 148    Deep yellowish pink
   LIYPK      229 160 153  125 191 153    Light yellowish pink
   MOYPK      191 133 128  125 159 085    Moderate yellowish pink
   DAYPK      153 097 092  125 122 064    Dark yellowish pink
   PAYPK      229 197 194  125 212 104    Pale yellowish pink
   GRYPK      191 165 162  125 177 048    Grayish yellowish pink
   BRPK       191 185 166  165 178 042    Brownish pink
   VIRO       128 048 009  140 068 223    Vivid reddish orange
   STRO       140 065 028  140 084 170    Strong reddish orange
   DERO       102 047 020  140 061 170    Deep reddish orange
   MORO       140 084 056  140 098 109    Moderate reddish orange
   DARO       102 061 041  140 071 109    Dark reddish orange
   GRRO       140 103 084  140 112 064    Grayish reddish orange
   STRBR      076 039 020  140 048 148    Strong reddish brown
   DERBR      038 021 013  140 025 128    Deep reddish brown
   LIRBR      140 115 103  140 122 039    Light reddish brown
   MORBR      089 069 059  140 074 051    Moderate reddish brown
   DARBR      025 022 020  140 023 028    Dark reddish brown
   LIGRRBR    140 125 117  140 129 024    Light grayish reddish brown
   GRRBR      089 079 074  140 082 023    Grayish reddish brown
   DAGRRBR    051 046 044  140 048 018    Dark grayish reddish brown
   VIO        178 099 006  152 092 239    Vivid orange
   BIO        217 137 043  152 130 177    Brilliant orange
   STO        166 105 033  152 099 170    Strong orange
   DEO        128 081 026  152 077 170    Deep orange
   LIO        217 164 101  152 159 153    Light orange
   MOO        166 125 077  152 122 093    Moderate orange
   BRO        128 096 060  152 094 093    Brownish orange
   STBR       089 059 024  152 057 148    Strong brown
   DEBR       038 028 015  152 027 109    Deep brown
   LIBR       140 121 098  152 119 045    Light brown
   MOBR       089 078 065  152 077 039    Moderate brown
   DABR       025 023 020  152 023 028    Dark brown
   LIGRBR     140 136 122  165 131 019    Light grayish brown
   GRBR       089 086 077  165 083 018    Grayish brown
   DAGRBR     051 050 046  165 048 013    Dark grayish brown
   LIBRGR     140 136 131  152 136 010    Light brownish gray
   BRGR       089 087 083  152 086 009    Brownish gray
   BRBL       001 001 001  152 001 001    Brownish black
   VIOY       191 145 006  165 099 239    Vivid orange yellow
   BIOY       229 184 046  165 138 200    Brilliant orange yellow
   STOY       191 153 038  165 115 170    Strong orange yellow
   DEOY       153 122 031  165 092 170    Deep orange yellow
   LIOY       229 199 107  165 168 180    Light orange yellow
   MOOY       186 161 087  165 137 107    Moderate orange yellow
   DAOY       153 133 071  165 112 093    Dark orange yellow
   PAOY       229 212 161  165 195 146    Pale orange yellow
   STYBR      128 106 043  165 085 127    Strong yellowish brown
   DEYBR      051 046 020  170 036 109    Deep yellowish brown
   LIYBR      166 159 122  170 144 051    Light yellowish brown
   MOYBR      115 110 088  170 101 034    Moderate yellowish brown
   DAYBR      038 037 031  170 034 028    Dark yellowish brown
   LIGRYBR    166 161 138  170 152 034    Light grayish yellowish brown
   GRYBR      115 112 096  170 105 023    Grayish yellowish brown
   DAGRYBR    064 062 055  170 059 018    Dark grayish yellowish brown
   VIY        153 191 026  194 108 195    Vivid yellow
   BIY        198 229 092  194 161 186    Brilliant yellow
   STY        163 191 070  194 131 124    Strong yellow
   DEY        131 153 056  194 105 118    Deep yellow
   LIY        205 229 122  194 176 173    Light yellow
   MOY        171 191 102  194 147 105    Moderate yellow
   DAY        137 153 082  194 117 078    Dark yellow
   PAY        217 229 176  194 203 131    Pale yellow
   GRY        181 191 147  194 169 066    Grayish yellow
   DAGRY      142 153 107  194 130 047    Dark grayish yellow
   YWH        232 237 213  194 225 102    Yellowish white
   YGR        187 191 172  194 182 033    Yellowish gray
   LIOLBR     139 140 075  181 108 078    Light olive brown
   MOOLBR     089 089 054  181 071 064    Moderate olive brown
   DAOLBR     038 038 028  181 033 039    Dark olive brown
   VIGY       128 191 026  203 108 195    Vivid greenish yellow
   BIGY       174 229 084  203 157 189    Brilliant greenish yellow
   STGY       141 186 068  203 127 118    Strong greenish yellow
   DEGY       116 153 056  203 105 118    Deep greenish yellow
   LIGY       189 229 122  203 176 173    Light greenish yellow
   MOGY       157 191 102  203 147 105    Moderate greenish yellow
   DAGY       126 153 082  203 117 078    Dark greenish yellow
   PAGY       203 229 161  203 195 146    Pale greenish yellow
   GRGY       169 191 134  203 163 079    Grayish greenish yellow
   LIOL       098 128 051  203 089 109    Light olive
   MOOL       071 089 042  203 065 093    Moderate olive
   DAOL       022 025 017  203 021 051    Dark olive
   LIGROL     131 140 117  203 129 024    Light grayish olive
   GROL       084 089 074  203 082 023    Grayish olive
   DAGROL     048 051 044  203 048 018    Dark grayish olive
   LIOLGR     135 140 126  203 133 015    Light olive gray
   OLGR       087 089 083  203 086 009    Olive gray
   OLBL       025 025 025  203 025 000    Olive black
   VILG       068 166 022  221 094 195    Vivid yellow green
   BILG       136 229 092  221 161 186    Brilliant yellow green
   STLG       091 153 061  221 107 109    Strong yellow green
   DELG       060 102 041  221 071 109    Deep yellow green
   LILG       177 229 153  221 191 153    Light yellow green
   MOLG       118 153 102  221 127 051    Moderate yellow green
   PALG       209 229 199  221 214 096    Pale yellow green
   GRLG       139 153 133  221 143 023    Grayish yellow green
   STOLG      038 076 020  221 048 148    Strong olive green
   DEOLG      021 038 013  221 025 128    Deep olive green
   MOOLG      069 089 059  221 074 051    Moderate olive green
   DAOLG      031 038 028  221 033 039    Dark olive green
   GROLG      139 153 133  221 143 023    Grayish olive green
   DAGROLG    046 051 044  221 048 018    Dark grayish olive green
   VIYG       022 166 041  248 094 195    Vivid yellowish green
   BIYG       082 204 098  248 143 139    Brilliant yellowish green
   STYG       056 140 067  248 098 109    Strong yellowish green
   DEYG       024 089 032  248 057 148    Deep yellowish green
   VDEYG      010 038 014  248 024 148    Very deep yellowish green
   VLIYG      158 237 168  248 198 176    Very light yellowish green
   LIYG       128 191 136  248 159 085    Light yellowish green
   MOYG       093 140 100  248 117 051    Moderate yellowish green
   DAYG       059 089 063  248 074 051    Dark yellowish green
   VDAYG      023 033 024  248 028 045    Very dark yellowish green
   VIG        017 128 068  268 072 195    Vivid green
   BIG        077 191 129  268 134 121    Brilliant green
   STG        046 115 078  268 080 109    Strong green
   DEG        020 051 034  268 036 109    Deep green
   VLIG       153 229 188  268 191 153    Very light green
   LIG        110 166 136  268 138 060    Light green
   MOG        076 115 094  268 096 051    Moderate green
   DAG        054 076 064  268 065 045    Dark green
   VDAG       018 025 021  268 022 045    Very dark green
   VPAG       188 217 197  259 202 070    Very pale green
   PAG        144 166 154  268 155 028    Pale green
   GRG        099 115 106  268 107 018    Grayish green
   DAGRG      069 076 072  268 073 013    Dark grayish green
   BLG        023 025 024  268 024 013    Blackish green
   GWH        236 237 236  248 237 006    Greenish white
   LIGGR      191 191 191  248 191 001    Light greenish gray
   GGR        140 140 140  248 140 001    Greenish gray
   DAGGR      089 089 089  248 089 000    Dark greenish gray
   GBL        025 025 025  248 025 000    Greenish black
   VIBG       019 140 137  298 079 195    Vivid bluish green
   BIBG       077 191 188  298 134 121    Brilliant bluish green
   STBG       046 115 113  298 080 109    Strong bluish green
   DEBG       020 051 050  298 036 109    Deep bluish green
   VLIBG      144 217 215  298 181 124    Very light bluish green
   LIBG       110 166 164  298 138 060    Light bluish green
   MOBG       076 115 114  298 096 051    Moderate bluish green
   DABG       045 064 063  298 054 045    Dark bluish green
   VDABG      018 025 025  298 022 045    Very dark bluish green
   VIGB       019 071 140  334 079 195    Vivid greenish blue
   BIGB       077 126 191  334 134 121    Brilliant greenish blue
   STGB       046 076 115  334 080 109    Strong greenish blue
   DEGB       020 034 051  334 036 109    Deep greenish blue
   VLIGB      144 176 217  334 181 124    Very light greenish blue
   LIGB       110 134 166  334 138 060    Light greenish blue
   MOGB       076 093 115  334 096 051    Moderate greenish blue
   DAGB       042 052 064  334 053 051    Dark greenish blue
   VDAGB      018 021 025  334 022 045    Very dark greenish blue
   VIB        009 007 102  001 054 223    Vivid blue
   BIB        050 048 178  001 113 148    Brilliant blue
   STB        032 031 115  001 073 148    Strong blue
   DEB        016 015 038  001 027 109    Deep blue
   VLIB       118 116 217  001 166 145    Very light blue
   LIB        090 088 166  001 127 078    Light blue
   MOB        062 061 115  001 088 078    Moderate blue
   DAB        027 027 038  001 033 045    Dark blue
   VPAB       174 173 217  001 195 092    Very pale blue
   PAB        133 133 166  001 149 040    Pale blue
   GRB        092 092 115  001 103 028    Grayish blue
   DAGRB      055 055 064  001 059 018    Dark grayish blue
   BLB        023 023 025  001 024 013    Blackish blue
   BWH        222 221 237  001 229 078    Bluish white
   LIBGR      179 178 191  001 185 023    Light bluish gray
   BGR        131 131 140  001 136 010    Bluish gray
   DABGR      083 083 089  001 086 009    Dark bluish gray
   BBL        025 025 025  001 025 001    Bluish black
   VIPB       043 007 102  023 054 223    Vivid purplish blue
   BIPB       097 048 178  023 113 148    Brilliant purplish blue
   STPB       063 031 115  023 073 148    Strong purplish blue
   DEPB       024 015 038  023 027 109    Deep purplish blue
   VLIPB      163 122 229  023 176 173    Very light purplish blue
   LIPB       109 082 153  023 117 078    Light purplish blue
   MOPB       063 048 089  023 068 078    Moderate purplish blue
   DAPB       021 018 025  023 022 045    Dark purplish blue
   VPAPB      192 168 229  023 199 139    Very pale purplish blue
   PAPB       138 122 166  023 144 051    Pale purplish blue
   GRPB       074 065 089  023 077 039    Grayish purplish blue
   VIV        083 009 140  034 075 223    Vivid violet
   BIV        121 048 178  034 113 148    Brilliant violet
   STV        060 024 089  034 057 148    Strong violet
   DEV        027 013 038  034 025 128    Deep violet
   VLIV       172 116 217  034 166 145    Very light violet
   LIV        122 082 153  034 117 078    Light violet
   MOV        071 048 089  034 068 078    Moderate violet
   DAV        022 018 025  034 022 045    Dark violet
   VPAV       203 168 229  034 199 139    Very pale violet
   PAV        135 112 153  034 133 042    Pale violet
   GRV        079 065 089  034 077 039    Grayish violet
   VIP        111 009 128  052 068 223    Vivid purple
   BIP        160 048 178  052 113 148    Brilliant purple
   STP        103 031 115  052 073 148    Strong purple
   DEP        062 023 069  052 046 128    Deep purple
   VDEP       023 008 025  052 017 127    Very deep purple
   VLIP       203 116 217  052 166 145    Very light purple
   LIP        155 088 166  052 127 078    Light purple
   MOP        107 061 115  052 088 078    Moderate purple
   DAP        066 048 069  052 059 045    Dark purple
   VDAP       024 018 025  052 022 045    Very dark purple
   VPAP       211 173 217  052 195 092    Very pale purple
   PAP        161 133 166  052 149 040    Pale purple
   GRP        112 092 115  052 103 028    Grayish purple
   DAGRP      068 060 069  052 064 018    Dark grayish purple
   BLP        025 023 025  052 024 013    Blackish purple
   PWH        235 221 237  052 229 078    Purplish white
   LIPGR      189 178 191  052 185 023    Light purplish gray
   PGR        139 131 140  052 136 010    Purplish gray
   DAPGR      088 083 089  052 086 009    Dark purplish gray
   PBL        025 025 025  052 025 001    Purplish black
   VIRP       089 006 076  070 048 223    Vivid reddish purple
   STRP       115 031 101  070 073 148    Strong reddish purple
   DERP       069 023 062  070 046 128    Deep reddish purple
   VDERP      025 008 023  070 017 127    Very deep reddish purple
   LIRP       153 082 142  070 117 078    Light reddish purple
   MORP       115 061 106  070 088 078    Moderate reddish purple
   DARP       069 048 066  070 059 045    Dark reddish purple
   VDARP      025 018 024  070 022 045    Very dark reddish purple
   PARP       153 112 146  070 133 042    Pale reddish purple
   GRRP       115 084 110  070 099 039    Grayish reddish purple
   BIPPK      217 058 191  070 137 172    Brilliant purplish pink
   STPPK      178 048 158  070 113 148    Strong purplish pink
   DEPPK      153 031 133  070 092 170    Deep purplish pink
   LIPPK      217 116 201  070 166 145    Light purplish pink
   MOPPK      178 095 165  070 137 090    Moderate purplish pink
   DAPPK      153 082 120  088 117 078    Dark purplish pink
   PAPPK      229 184 208  088 207 121    Pale purplish pink
   GRPPK      178 143 162  088 161 048    Grayish purplish pink
   VIPR       076 005 044  088 041 223    Vivid purplish red
   STPR       115 023 073  088 069 170    Strong purplish red
   DEPR       069 018 046  088 044 148    Deep purplish red
   VDEPR      025 010 018  088 018 109    Very deep purplish red
   MOPR       115 046 083  088 080 109    Moderate purplish red
   DAPR       069 041 056  088 055 064    Dark purplish red
   VDAPR      025 018 022  088 022 045    Very dark purplish red
   LIGRPR     153 112 134  088 133 042    Light purplish red
   GRPR       115 076 097  088 096 051    Grayish purplish red
   WH         255 255 255  000 255 000    White
   LIGR       191 191 191  000 191 000    Light gray
   MEGR       140 140 140  000 140 000    Medium gray
   DAGR       089 089 089  000 089 000    Dark gray
   BL         000 000 000  000 000 000    Black
   LTGRAY     192 192 192  000 192 000    Light gray
   DAGRAY     064 064 064  000 064 000    Dark gray
   GREY       128 128 128  000 128 000    Gray
   ;
run;

data col24(keep=name fname hlsname rgbname namewhls namewrgb); 
length rgbname hlsname name $ 8 namewhls namewrgb $ 19;
input @4 name $8.
      @15 r 3. @19 g 3. @23 b 3.
      @28 h 3. @32 l 3. @36 s 3.
      @43 fname $10.; 
rgbname =  'CX' || put(r,hex2.) || put(g,hex2.) || put(b,hex2.) ;
hlsname =  'H'  || put(h,hex3.) || put(l,hex2.) || put(s,hex2.) ;
namewrgb = trim(name) || ' - ' || rgbname;
namewhls = trim(name) || ' - ' || hlsname;
cards;
   LTGRAY     192 192 192  000 192 000    Light Gray
   GRAY       128 128 128  000 128 000    Gray
   DAGRAY     064 064 064  000 064 000    Dark Gray
   BLACK      000 000 000  000 000 000    Black
   RED        255 000 000  120 128 255    Red
   GREEN      000 255 000  240 128 255    Green
   BLUE       000 000 255  000 128 255    Blue
   WHITE      255 255 255  000 255 000    White
   CYAN       000 255 255  300 128 255    Cyan
   YELLOW     255 255 000  180 128 255    Yellow
   MAGENTA    255 000 255  060 128 255    Magenta
   WHITE      255 255 255  000 255 000    White
   PINK       255 000 128  089 128 255    Pink
   SALMON     255 000 085  100 128 255    Salmon
   ORANGE     255 128 000  150 128 255    Orange
   GOLD       255 170 000  160 128 255    Gold
   ROSE       255 096 096  120 176 255    Rose
   MAROON     112 000 000  120 056 255    Maroon
   BROWN      160 080 000  150 080 255    Brown
   LIME       192 255 129  210 192 255    Lime
   PURPLE     112 048 112  060 080 102    Purple
   VIOLET     176 144 208  030 176 103    Violet
   LILAC      224 096 144  098 160 172    Lilac
   WHITE      255 255 255  000 255 000    White
   TAN        224 168 096  154 160 172    Tan
   CREAM      232 216 152  168 192 162    Cream
;
run;

*goptions gsfname=sasnam24;
*filename sasnam24 "c:\TheBook\color\sasnam24.emf";

%NAM255PA(
grafname=sasnam24,
coldata=col24,
colcount=26,
colsplin=4,
colsep=5,
namevar=name,
namelen=8,
nameovhd=3,
nameht=2,
namefont='Arial',
graftitl=SAS Predefined Color Names Assigned As COLOR=,
titlovhd=3,
titlht=3,
titlfont='Arial',
color=name)
RUN;

*goptions gsfname=sashls24;
*filename sashls24 "c:\TheBook\color\sashls24.emf";

%NAM255PA(
grafname=sashls24,
coldata=col24,
colcount=26,
colsplin=4,
colsep=5,
namevar=namewhls,
namelen=19,
nameovhd=3,
nameht=1.5,
namefont='Arial',
graftitl=SAS Predefined Colors But Assigned Via Alleged HLS-Equivalents,
titlovhd=3,
titlht=3,
titlfont='Arial',
color=hlsname)
RUN;

*goptions gsfname=sasrgb24;
*filename sasrgb24 "c:\TheBook\color\sasrgb24.emf";

%NAM255PA(
grafname=sasrgb24,
coldata=col24,
colcount=26,
colsplin=4,
colsep=5,
namevar=namewrgb,
namelen=19,
nameovhd=3,
nameht=1.5,
namefont='Arial',
graftitl=SAS Predefined Colors But Assigned Via Alleged RGB-Equivalents,
titlovhd=3,
titlht=3,
titlfont='Arial',
color=rgbname)
RUN;

%macro skipanlz;

data colanlyz;
set sascols(keep=l s fname);
if index(fname,'very dark') gt 0
then fname='very dark';
else
if index(fname,'dark') gt 0
then fname='dark';
else
if index(fname,'very deep') gt 0
then fname='very deep';
else
if index(fname,'deep') gt 0
then fname='deep';
else
if index(fname,'strong') gt 0
then fname='strong';
else
if index(fname,'moderate') gt 0
then fname='moderate';
else
if index(fname,'grayish') gt 0
then fname='grayish';
else
if index(fname,'blackish') gt 0
then fname='blackish';
else
if index(fname,'brilliant') gt 0
then fname='brilliant';
else
if index(fname,'vivid') gt 0
then fname='vivid';
else
if index(fname,'very pale') gt 0
then fname='very pale';
else
if index(fname,'pale') gt 0
then fname='pale';
else
if index(fname,'very light') gt 0
then fname='very light';
else
if index(fname,'light') gt 0
then fname='light';
else delete;
run;

options nocenter ls=64 pageno=1;title 'sas color qualifiers - lightness & saturation';footnote;
proc freq data=colanlyz; tables fname*l*s / list nopercent nocum;run;

options nocenter ls=64 pageno=1;title 'sas color qualifiers - lightness only';footnote;
proc freq data=colanlyz; tables fname*l / list nopercent nocum;run;

options nocenter ls=64 pageno=1;title 'sas color qualifiers - saturation only';footnote;
proc freq data=colanlyz; tables fname*s / list nopercent nocum;run;

options nocenter ls=64 pageno=1;title 'sas colors - distribution of lightness';footnote;
proc freq data=sascols; tables l / list;run;

%mend skipanlz;

data redllss(keep=bigname hlsname); 

length hlsname name $ 8 bigname $ 42;
input @4 name $8.
      @15 r 3. @19 g 3. @23 b 3.
      @28 h 3. @32 l 3. @36 s 3.
      @43 fname $31.; 
* rgbname =  'CX' || put(r,hex2.) || put(g,hex2.) || put(b,hex2.) ;
hlsname =  'H'  || put(h,hex3.) || put(l,hex2.) || put(s,hex2.) ;
bigname = hlsname || ' - ' || fname;
cards;
                           120 000 255    lightness 0%, saturation 100%
                           120 128 000    lightness 50%, saturation 0%
                           120 026 255    lightness 10%, saturation 100%
                           120 128 026    lightness 50%, saturation 10%
                           120 051 255    lightness 20%, saturation 100%
                           120 128 051    lightness 50%,saturation 20%
                           120 077 255    lightness 30%, saturation 100%
                           120 128 077    lightness 50%, saturation 30%
                           120 102 255    lightness 40%, saturation 100%
                           120 128 102    lightness 50%, saturation 40%
                           120 128 255    lightness 50%, saturation 100%
                           120 128 128    lightness 50%, saturation 50%
                           120 153 255    lightness 60%, saturation 100%
                           120 128 153    lightness 50%, saturation 60%
                           120 179 255    lightness 70%, saturation 100%
                           120 128 179    lightness 50%, saturation 70%
                           120 204 255    lightness 80%, saturation 100%
                           120 128 204    lightness 50%, saturation 80%
                           120 230 255    lightness 90%, saturation 100%
                           120 128 230    lightness 50%, saturation 90%
                           120 255 255    lightness 100%, saturation 100%
                           120 128 255    lightness 50%, saturation 100%
;
run;

*goptions gsfname=redls11;
*filename redls11 "c:\TheBook\color\redls11.emf";

%NAM255PA(
grafname=redls11,
coldata=redllss,
colcount=22,
colsplin=2,
colsep=5,
namevar=bigname,
namelen=42,
nameovhd=2,
nameht=1.7,
namefont='Arial',
graftitl=SAS HLS Red Hue with varying lightness and saturation,
titlovhd=3,
titlht=3,
titlfont='Arial',
color=hlsname)
RUN;

data violets violet;
keep name bigname bighlsnm bigrgbnm hlsname rgbname;
length bigname $ 24 bighlsnm bigrgbnm $ 35;
set sascols;
if index(upcase(fname),'VIOLET') gt 0;
bigname  = trim(name) || ' - ' || trim(fname);
bighlsnm = trim(name) || ' - ' || trim(fname) || ' - ' || hlsname;
bigrgbnm = trim(name) || ' - ' || trim(fname) || ' - ' || rgbname;
if upcase(name) eq 'VIOLET' then output violet;
else output violets;
run;

proc sort data=violets; by descending hlsname; run;

data violets;
set violet violets;
run;

*goptions gsfname=violets;
*filename violets "c:\TheBook\color\violets.emf";

%NAM255PA(
grafname=violets,
coldata=violets,
colcount=12,
colsplin=2,
colsep=5,
namevar=bigname,
namelen=24,
nameovhd=3,
nameht=2.3,
namefont='Arial',
graftitl=SAS Predefined Violet Color Names Assigned As COLOR=,
titlovhd=3,
titlht=2.8,
titlfont='Arial',
color=name)
RUN;

*goptions gsfname=viohls;
*filename viohls "c:\TheBook\color\viohls.emf";

%NAM255PA(
grafname=viohls,
coldata=violets,
colcount=12,
colsplin=2,
colsep=5,
namevar=bighlsnm,
namelen=35,
nameovhd=3,
nameht=2,
namefont='Arial',
graftitl=SAS Predefined Violet Colors But Assigned Via Alleged HLS-Equivalents,
titlovhd=3,
titlht=2.8,
titlfont='Arial',
color=hlsname)
RUN;

*goptions gsfname=viorgb;
*filename viorgb "c:\TheBook\color\viorgb.emf";

%NAM255PA(
grafname=viorgb,
coldata=violets,
colcount=12,
colsplin=2,
colsep=5,
namevar=bigrgbnm,
namelen=35,
nameovhd=3,
nameht=2,
namefont='Arial',
graftitl=SAS Predefined Violet Colors But Assigned Via Alleged RGB-Equivalents,
titlovhd=3,
titlht=2.8,
titlfont='Arial',
color=rgbname)
RUN;

data safecols(keep=rgbname rgbcode);
length rgbname $ 8 rgbcode $ 6 r g b 4;
do r = 0 to 255 by 51;
  do g = 0 to 255 by 51;
    do b = 0 to 255 by 51;	
      rgbcode = put(r,hex2.) || put(g,hex2.) || put(b,hex2.);
	  rgbname = 'CX' || rgbcode;
      output;
    end;
  end;
end;
run;
*goptions gsfname=safe216;
*filename safe216 "c:\TheBook\color\safe216.emf";

%NAM255PA(
grafname=safe216,
coldata=safecols,
colcount=216,
colsplin=12,
colsep=1.5,
namevar=rgbcode,
namelen=6,
nameovhd=1.3,
nameht=1.3,
namefont='Arial',
graftitl=Browser-Safe Colors with their RGB Values,
titlovhd=1.3,
titlht=2,
titlfont='Arial',
color=rgbname)
RUN;

proc sort data=sascols(keep=rgbname hlsname l) out=toselect(drop=l);
by descending l;
run;

data sas255(keep=rgbname rgbcode hlsname hlscode);
length rgbcode $ 6;
set toselect;
if _N_ lt 255;
rgbcode = substr(rgbname,3,6);
hlscode = substr(hlsname,2,7);
output;
if _N_ eq 254;
rgbname = 'CX000000';
rgbcode = '000000';
hlsname = 'H0000000';
output;
stop;
run;

*goptions gsfname=rgb255;
*filename rgb255 "c:\TheBook\color\rgb255.emf";

%NAM255PA(
grafname=rgb255,
coldata=sas255,
colcount=255,
colsplin=13,
colsep=1.1,
namevar=rgbcode,
namelen=6,
nameovhd=1.2,
nameht=1.4,
namefont='Arial',
graftitl=254 Lightest SAS Predefined Colors and BLACK with their RGB Values,
titlovhd=1.3,
titlht=2,
titlfont='Arial',
color=rgbname)
RUN;

*goptions gsfname=hls255;
*filename hls255 "c:\TheBook\color\hls255.emf";

%NAM255PA(
grafname=hls255,
coldata=sas255,
colcount=255,
colsplin=13,
colsep=1.1,
namevar=hlscode,
namelen=8,
nameovhd=1.0,
nameht=1.2,
namefont='Arial',
graftitl=254 Lightest SAS Predefined Colors and BLACK with their HLS Names,
titlovhd=1.3,
titlht=2,
titlfont='Arial',
color=hlsname)
RUN;

data rgbhdgs(keep=rgbname colname);
length colname rgbname $ 8;
colname = 'Red';
rgbname = 'CXFFFFFF';
output;
colname = 'Yellow';
rgbname = 'CXFFFFFF';
output;
colname = 'Green';
rgbname = 'CXFFFFFF';
output;
colname = 'Cyan';
rgbname = 'CXFFFFFF';
output;
colname = 'Blue';
rgbname = 'CXFFFFFF';
output;
colname = 'Magenta';
rgbname = 'CXFFFFFF';
output;
colname = 'Gray';
rgbname = 'CXFFFFFF';
output;
run;

data rgb6shad(keep=rgbname);
length rgbname $ 8 rgbcode $ 6;
rgbcode = 'FF0000'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF00'; rgbname = 'CX' || rgbcode; output;
rgbcode = '00FF00'; rgbname = 'CX' || rgbcode; output;
rgbcode = '00FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '0000FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF00FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '000000'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF3333'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF33'; rgbname = 'CX' || rgbcode; output;
rgbcode = '33FF33'; rgbname = 'CX' || rgbcode; output;
rgbcode = '33FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '3333FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF33FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '333333'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF6666'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF66'; rgbname = 'CX' || rgbcode; output;
rgbcode = '66FF66'; rgbname = 'CX' || rgbcode; output;
rgbcode = '66FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '6666FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF66FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '666666'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF9999'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF99'; rgbname = 'CX' || rgbcode; output;
rgbcode = '99FF99'; rgbname = 'CX' || rgbcode; output;
rgbcode = '99FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '9999FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF99FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '999999'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFCCCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCFFCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCCCFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFCCFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCCCCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
run;

data rgb6shad;
length colname $ 8;
set rgb6shad;
colname = rgbname;
run;

*goptions gsfname=rgb6shad;
*filename rgb6shad "c:\TheBook\color\rgb6shad.emf";

%NAM255PA(
grafname=rgb6shad,
coldata=rgb6shad,
colcount=42,
colsplin=7,
colsep=3,
namevar=colname,
namelen=8,
nameovhd=4,
nameht=1.6,
namefont='Arial',
graftitl=White and Six Shades of Seven Browser-Safe Colors with RGB Codes,
titlovhd=0,
titlht=2.5,
titlfont='Arial',
color=rgbname)
RUN;

data rgb5shad(keep=rgbname);
length rgbname $ 8 rgbcode $ 6;
rgbcode = 'FF0000'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF00'; rgbname = 'CX' || rgbcode; output;
rgbcode = '00FF00'; rgbname = 'CX' || rgbcode; output;
rgbcode = '00FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '0000FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF00FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '000000'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF6666'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF66'; rgbname = 'CX' || rgbcode; output;
rgbcode = '66FF66'; rgbname = 'CX' || rgbcode; output;
rgbcode = '66FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '6666FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF66FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '666666'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF9999'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFF99'; rgbname = 'CX' || rgbcode; output;
rgbcode = '99FF99'; rgbname = 'CX' || rgbcode; output;
rgbcode = '99FFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '9999FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FF99FF'; rgbname = 'CX' || rgbcode; output;
rgbcode = '999999'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFCCCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCFFCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCCCFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFCCFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'CCCCCC'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
rgbcode = 'FFFFFF'; rgbname = 'CX' || rgbcode; output;
run;

data rgb5shad;
length colname $ 8;
set rgb5shad;
colname = rgbname;
run;

*goptions gsfname=rgb5shad;
*filename rgb5shad "c:\TheBook\color\rgb5shad.emf";

%NAM255PA(
grafname=rgb5shad,
coldata=rgb5shad,
colcount=35,
colsplin=7,
colsep=3,
namevar=colname,
namelen=8,
nameovhd=7,
nameht=1.6,
namefont='Arial',
graftitl=White and Five Shades of Seven Browser-Safe Colors with RGB Codes,
titlovhd=0,
titlht=2.5,
titlfont='Arial',
color=rgbname)
RUN;


data sas2shad(keep=colname);
length colname $ 8;
colname = 'GRAY    ';output;
colname = 'LTGRAY  ';output;
colname = 'RED     ';output;
colname = 'PINK    ';output;
colname = 'GREEN   ';output;
colname = 'LIME    ';output;
colname = 'BLUE    ';output;
colname = 'CYAN    ';output;
colname = 'MAGENTA ';output;
colname = 'LILAC   ';output;
colname = 'PURPLE  ';output;
colname = 'VIOLET  ';output;
colname = 'TAN     ';output;
colname = 'CREAM   ';output;
run;

*goptions gsfname=sas2shad;
*filename sas2shad "c:\TheBook\color\sas2shad.emf";

%NAM255PA(
grafname=sas2shad,
coldata=sas2shad,
colcount=14,
colsplin=2,
colsep=5,
namevar=colname,
namelen=7,
nameovhd=2,
nameht=2,
namefont='Arial',
graftitl=Possible Dark-Light Pairs of SAS Predefined Colors,
titlovhd=3,
titlht=3,
titlfont='Arial',
color=colname)
RUN;

%macro colchart(color=,omit1=,omit2=,omit3=,omit4=,omit5=,omit6=,omit7=,omit8=,omit9=,omit10=);

%let testcol = %upcase(&color);
%if %length(&omit1&omit2&omit3&omit4&omit5&omit6&omit7&omit8&omit9&omit10) ne 0
%then %do;
  %let titlprfx = %str(Some of the );
  %let graph    = Z%substr(&color,2,%eval(%length(&color) - 1));	
%end;
%else %do;
  %let titlprfx =;
  %let graph    = &color;	
%end;

data colors color;
keep name bigname bighlsnm bigrgbnm hlsname rgbname;
length bigname $ 40 bighlsnm bigrgbnm $ 51;
set sascols;
testname = upcase(fname);
if index(testname,"&testcol") gt 0
or index(testname,"-&testcol") gt 0;
if index(testname,"&testcol.-") eq 0;
if index(testname,"&testcol GREEN") eq 0;
if index(testname,"&testcol YELLOW") eq 0;
if index(testname,"&testcol BROWN") eq 0;
if index(testname,"&testcol GRAY") eq 0;
if index(testname,"&testcol BLACK") eq 0;
if index(testname,"&testcol.ISH") eq 0;
if index(testname,"&testcol.DISH") eq 0;
%if %length(&omit1) ne 0 %then %do;
&omit1
%end;
%if %length(&omit2) ne 0 %then %do;
&omit2
%end;
%if %length(&omit3) ne 0 %then %do;
&omit3
%end;
%if %length(&omit4) ne 0 %then %do;
&omit4
%end;
%if %length(&omit5) ne 0 %then %do;
&omit5
%end;
%if %length(&omit6) ne 0 %then %do;
&omit6
%end;
%if %length(&omit7) ne 0 %then %do;
&omit7
%end;
%if %length(&omit8) ne 0 %then %do;
&omit8
%end;
%if %length(&omit9) ne 0 %then %do;
&omit9
%end;
%if %length(&omit10) ne 0 %then %do;
&omit10
%end;
bigname  = trim(name) || ' - ' || trim(fname);
bighlsnm = trim(name) || ' - ' || trim(fname) || ' - ' || hlsname;
bigrgbnm = trim(name) || ' - ' || trim(fname) || ' - ' || rgbname;
if upcase(name) eq "&testcol" then output color;
else output colors;
run;

proc sort data=colors; by descending hlsname; run;

data colors;
set color colors;
run;

data _null_;
if colcount gt 0 then do;
  call symput('howmany',colcount);
  if colcount le 26 then do;
    call symput('name','bigname');
	call symput('length',40);
	if colcount le 13 then do;
      call symput('perline',1);
      call symput('sep',52);
	end;
    else do;
	  call symput('perline',2);
      call symput('sep',5);
	end;
  end;
  else do;
    call symput('name','name');
	call symput('length',8);
	if colcount le 39
    then do;
	  call symput('perline',3);
      call symput('sep',3);
	end;
    else do;
	  call symput('perline',4);
      call symput('sep',2);
    end;
  end;
  put "&testcol Color Count is " colcount; 
  stop;
end;
set colors nobs=colcount;
run;

*goptions gsfname=&graph;
*filename &graph "c:\TheBook\color\&graph..emf";

%NAM255PA(
grafname=&graph,
coldata=colors,
colcount=&howmany,
colsplin=&perline,
colsep=&sep,
namevar=&name,
namelen=&length,
nameovhd=2,
nameht=2,
namefont='Arial',
graftitl=&titlprfx.SAS Predefined &testcol Colors,
titlovhd=2,
titlht=2.5,
titlfont='Arial',
color=name)
RUN;
%mend  colchart;

%colchart(color=black);run;
%colchart(color=blue);run;
%colchart(color=brown);run;
%colchart(color=gray);run;
%colchart(color=green);run;
%colchart(color=olive);run;
%colchart(color=orange);run;
%colchart(color=pink);run;
%colchart(color=purple);run;
%colchart(color=red);run;
%colchart(color=violet);run;
%colchart(color=white);run;
%colchart(color=yellow);run;
%colchart(color=green,
       /* omit1=%str(if index(testname,'YELLOW GREEN') gt 0 then delete;), */ /* specific   */
	   /* omit1=%str(if index(testname,'YELLOWISH') gt 0 then delete;),    */ /* specific   */ 
	   /* omit1=%str(if index(testname,'YELLOW') gt 0 then delete;),       */ /* omits both */ 
		  omit2=%str(if index(testname,'OLIVE') gt 0 then delete;),
		  omit3=%str(if index(testname,'BLACK') gt 0 then delete;),
		  omit4=%str(if index(testname,'VERY DARK') gt 0 then delete;),
		  omit5=%str(if index(testname,'DARK') gt 0 then delete;),
		  omit6=%str(if index(testname,'VERY DEEP') gt 0 then delete;),
		  omit7=%str(if index(testname,'DEEP') gt 0 then delete;),
          omit8=%str(if index(testname,'BLUISH') gt 0 then delete;),
		  omit9=%str(if index(testname,'GRAYISH') gt 0 then delete;))
run;
%colchart(color=yellow,
       /* omit1=%str(if index(testname,'YELLOW GREEN') gt 0 then delete;), */ /* specific   */
	   /* omit1=%str(if index(testname,'GREENISH') gt 0 then delete;),     */ /* specific   */ 
	      omit1=%str(if index(testname,'GREEN') gt 0 then delete;),           /* omits both */ 
		  omit2=%str(if index(testname,'ORANGE') gt 0 then delete;))
run;

%macro mychart (myname1=LTGRAY,mycol1=,
				myname2=GRAY,mycol2=,
				myname3=DAGRAY,mycol3=,
				myname4=BLACK,mycol4=,
				myname5=RED,mycol5=,
				myname6=GREEN,mycol6=,
				myname7=BLUE,mycol7=,
				myname8=XPURPLE,mycol8=CX703070,
				myname9=CYAN,mycol9=,
				myname10=YELLOW,mycol10=,
				myname11=MAGENTA,mycol11=,
				myname12=XVIOLET,mycol12=CXB090D0,
				myname13=MAROON,mycol13=,
				myname14=XORANGE,mycol14=CXFF8000,
				myname15=XLTORANG,mycol15=CXFFAA00,
				myname16=XLILAC,mycol16=VIOLET,
                myname17=XLTBROWN,mycol17=CXA05000,
				myname18=XTAN,mycol18=CXE0A860,
				myname19=XBEIGE,mycol19=TAN,
				myname20=CREAM,mycol20=,
				myname21=PINK,mycol21=,
                myname22=LIME,mycol22=,
				myname23=XLTGREEN,mycol23=CXC0FF81,
				myname24=WHITE,mycol24=); 
data my24cols;
length coldesc $ 19 sascolor $ 8;
%do i = 1 %to 24 %by 1;
  %if %length(&&mycol&i) ne 0 %then %do;
coldesc  = "&&myname&i - &&mycol&i";
sascolor = "&&mycol&i";
  %end;
  %else %do;
coldesc  = "&&myname&i";
sascolor = "&&myname&i";
  %end;
output;
%end;
run;
%mend  mychart;

%mychart
run;

*goptions gsfname=my24cols;
*filename my24cols "c:\TheBook\color\my24cols.emf";

%NAM255PA(
grafname=my24cols,
coldata=my24cols,
colcount=24,
colsplin=4,
colsep=2,
namevar=coldesc,
namelen=19,
nameovhd=3,
nameht=1.5,
namefont='Arial',
graftitl=%str(Some Useful Colors (X prefix: use SAS Color Name shown)),
titlovhd=3,
titlht=2.5,
titlfont='Arial',
color=sascolor)
RUN;

%macro hlstosho(hexordeg=hex, 
				huecount=6, /* this is the max */
                hue1=000,
				hue2=03C,
				hue3=078,
                hue4=0B4,
                hue5=0F0,
                hue6=12C);
%if %upcase(&hexordeg) eq HEX %then %do;
data _null_;
  %do i = 1 %to &huecount %by 1;
call symput("huehex&i","&&hue&i");
  %end;
run;
%end;
%else
%if %upcase(&hexordeg) eq DEG %then %do;
data _null_;
  %do i = 1 %to &huecount %by 1;
call symput("huehex&i",put(&&hue&i,hex3.));
  %end;
run;
%end;
data hlscols(keep=hlsname hlsdesc);
length hlsdesc $ 15 hlsname $ 8;
%do i = 1 %to &huecount %by 1;
hlsname = 'H' || "&&huehex&i" || '80FF';
hlsdesc = hlsname;
output;
%end;
%do i = 1 %to &huecount %by 1;
hlsname = 'H' || "&&huehex&i" || 'B3FF';
hlsdesc = hlsname;
output;
%end;
%do i = 1 %to &huecount %by 1; 
hlsname = 'H' || "&&huehex&i" || 'CCFF';
hlsdesc = hlsname;
output;
%end;
%do i = 1 %to &huecount %by 1; 
hlsname = 'H' || "&&huehex&i" || 'E6FF';
hlsdesc = hlsname;
output;
%end; 
%do i = 1 %to &huecount %by 1;
hlsname = 'H' || "&&huehex&i" || 'F3FF';
hlsdesc = hlsname;
output;
%end; 
run;
%mend  hlstosho;

%hlstosho(hexordeg=hex,huecount=6,
          hue1=000,hue2=03C,hue3=078,hue4=0B4,hue5=0F0,hue6=12C)
run;

*goptions gsfname=hlshex6;
*filename hlshex6 "c:\TheBook\color\hlshex6.emf";

%NAM255PA(
grafname=hlshex6,
coldata=hlscols,
colcount=30,
colsplin=6,
colsep=5,
namevar=hlsdesc,
namelen=8,
nameovhd=3,
nameht=1.5,
namefont='Arial',
graftitl=Six HLS Colors at Five Levels of Lightness,
titlovhd=3,
titlht=2.5,
titlfont='Arial',
color=hlsname)
RUN;

%hlstosho(hexordeg=deg,huecount=4,
          hue1=30,hue2=150,hue3=210,hue4=330)
run;

*goptions gsfname=hlsdeg4;
*filename hlsdeg4 "c:\TheBook\color\hlsdeg4.emf";

%NAM255PA(
grafname=hlsdeg4,
coldata=hlscols,
colcount=20,
colsplin=4,
colsep=5,
namevar=hlsdesc,
namelen=8,
nameovhd=3,
nameht=2,
namefont='Arial',
graftitl=Four HLS Colors at Five Levels of Lightness,
titlovhd=3,
titlht=2.5,
titlfont='Arial',
color=hlsname)
RUN;

 /* macro below is under development for future use */
%macro mycolist(myname1=XORANGE,sascol1=CXFF8000,
                myname2=XLTBROWN,sascol2=CXA05000,
				myname3=XLTGREEN,sascol3=CXC0FF81,
				myname4=XPURPLE,sascol4=CX703070,
				myname5=XVIOLET,sascol5=CXB090D0,
				myname6=XLILAC,sascol6=VIOLET,
				myname7=XTAN,sascol7=CXE0A860,
				myname8=XBEIGE,sascol8=TAN,
				myname9=XLTORANG,sascol9=CXFFAA00,
				myname10=,sascol10=,
				myname11=,sascol11=,
				myname12=,sascol12=,
				myname13=,sascol13=,
				myname14=,sascol14=,
				myname15=,sascol15=,
				myname16=,sascol16=,
				myname17=,sascol17=,
				myname18=,sascol18=,
				myname19=,sascol19=,
				myname20=,sascol20=);
data _null_;
%do i = 1 %to 20 %by 1;
  %if (%length(&&myname&i) ne 0) and (%length(&&sascol&i) ne 0)
  %then %do;
%global &&myname&i;
call symput("&&myname&i","&&sascol&i"); 
  %end;
%end;
run;
%mend  mycolist;

%mycolist
run;

%put &xorange &xltbrown &xltgreen &xltorang;

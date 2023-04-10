Daily Tip 76 13/10/2003 5:47 PM

**Producing multi-column reports**

From SAS 9 onwards there is a new ODS option called **columns=** which
allows you to choose the number of columns to produce in your output.
This works for some destinations including PDF, RTF & PS.

The following example shows how this can be used to send output to
various destinations & select various numbers of columns by using macro
variables.

***SAS Program***

%let dest=rtf; \* pdf, ps or rtf ;

%let cols=2 ;

ods &dest columns=&cols file=\"c:\\test.&dest\" ;

goptions rotate=landscape ;

**proc** **print** data=sashelp.shoes ;

var region stores sales ;

**run** ;

ods &dest close ;

***1^st^ page of Output***

**Obs**

**Region**

**Stores**

**Sales**

**1**

Africa

12

\$29,761

**2**

Africa

4

\$67,242

**3**

Africa

7

\$76,793

**4**

Africa

10

\$62,819

**5**

Africa

14

\$68,641

**6**

Africa

4

\$1,690

**7**

Africa

2

\$51,541

**8**

Africa

12

\$108,942

**9**

Africa

21

\$21,297

**10**

Africa

4

\$63,206

**11**

Africa

13

\$123,743

**12**

Africa

25

\$29,198

**13**

Africa

17

\$64,891

**14**

Africa

9

\$2,617

**15**

Africa

12

\$90,648

**16**

Africa

20

\$4,846

**17**

Africa

25

\$360,209

**18**

Africa

5

\$4,051

**19**

Africa

9

\$10,532

**20**

Africa

9

\$13,732

**21**

Africa

3

\$2,259

**22**

Africa

14

\$328,474

**23**

Africa

3

\$14,095

**24**

Africa

14

\$8,365

**25**

Africa

13

\$17,337

**26**

Africa

12

\$39,452

**27**

Africa

8

\$5,172

**28**

Africa

4

\$42,682

**29**

Africa

24

\$19,282

**30**

Africa

1

\$9,244

**31**

Africa

3

\$18,053

**32**

Africa

18

\$26,427

**33**

Africa

11

\$43,452

**34**

Africa

7

\$2,521

**35**

Africa

1

\$19,582

**36**

Africa

6

\$48,031

**37**

Africa

16

\$13,921

**38**

Africa

5

\$57,691

**39**

Africa

10

\$16,662

**40**

Africa

11

\$52,807

**41**

Africa

10

\$4,888

**42**

Africa

1

\$17,919

**43**

Africa

3

\$32,928

**44**

Africa

8

\$6,081

**45**

Africa

3

\$62,893

**46**

Africa

2

\$29,582

**47**

Africa

9

\$11,145

**48**

Africa

5

\$19,146

**49**

Africa

2

\$801

**50**

Africa

1

\$8,467

**51**

Africa

25

\$16,282

**52**

Africa

1

\$8,587

**53**

Africa

19

\$16,289

**54**

Africa

12

\$34,955

**55**

Africa

10

\$2,202

**56**

Africa

3

\$28,515

**57**

Asia

1

\$1,996

**58**

Asia

1

\$3,033

**59**

Asia

1

\$3,230

**60**

Asia

1

\$3,019

**61**

Asia

1

\$5,389

**62**

Asia

17

\$60,712

**63**

Asia

1

\$11,754

**64**

Asia

7

\$116,333

**65**

Asia

3

\$4,978

**66**

Asia

21

\$149,013

**67**

Asia

1

\$937

**68**

Asia

2

\$20,448

**69**

Asia

7

\$78,234

**70**

Asia

1

\$1,155

Example tested under SAS 9.1, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb

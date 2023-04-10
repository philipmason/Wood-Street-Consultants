Daily Tip 130 SAVEDATE 12/05/2005 16:45:00

**Traffic lighting a table with hot & cold**

Traffic lighting is a technique often applied to tables to indicate
visually whether something is good (green), OK (amber) or bad (red).
This can be very easily implemented in Proc Tabulate with ODS. Another
way to indicate good/bad is to use a graduated shading from Blue (cold)
to Red (hot) -- where blue is good and red is bad. The following example
shows how this is done.

The key to the technique is to use a feature within Proc Tabulate that
allows us to override the style attribute "background" using a format.
The number in each cell is then applied to this format to get the color
to use for the background color. I also create a format which smoothly
moves from blue to red. The result is impressive.

**Sample Program**

\* Create a format to display colors ranging from Blue (cold) to Red
(hot) ;

**data** \_null\_ ;

call execute(\'proc format fmtlib ; value pct\_\') ;

max=**1**;

maxloop=**255** ;

do i=**1** to maxloop ;

color=\'cx\'\|\|put(i/maxloop\***255**,hex2.)\|\|\'00\'\|\|put((maxloop-i)/maxloop\***255**,hex2.)
;

from=((i-**1**)/maxloop)\*max ;

to=(i/maxloop)\*max ;

call
execute(put(from,best.)\|\|\'-\'\|\|put(to,best.)\|\|\'=\'\|\|quote(color))
;

end ;

call execute(\'.=\"light gray\" other=\"cxd0d0d0\" ; run ;\') ;

**run** ;

\* get the maximum value of air ;

**proc** **sql** ;

select max(air),min(air) into :max,:min from sashelp.air ;

%let range=%sysevalf(&max-&min) ;

\* express values of air as a percentage of the maximum ;

**data** air ;

set sashelp.air ;

year=year(date) ;

month=month(date) ;

\* percentage is the level above the minimum ;

pct=(air-&min)/&range ;

**run** ;

\* tabulate the results indicating maximum as red, minimum as blue ;

ods html file=\'test.html\' ;

title \'Air Quality over the years\' ;

footnote \'Blue (cold) is best, Red (hot) is worst\' ;

**proc** **tabulate** data=air style={background=pct\_.} ;

class year month ;

var pct ;

label pct=\'Air Quality Percent of worst month\' ;

table sum=\'\'\*pct\*f=percent.,year=\'Year\',month=\'Month of Year\' ;

**run** ;

ods html close ;

**Output**

Air Quality over the years

Air Quality Percent of worst month

** **

**Month of Year**

**1**

**2**

**3**

**4**

**5**

**6**

**7**

**8**

**9**

**10**

**11**

**12**

**Year**

2%

3%

5%

5%

3%

6%

8%

8%

6%

3%

0%

3%

**1949**

**1950**

2%

4%

7%

6%

4%

9%

13%

13%

10%

6%

2%

7%

**1951**

8%

9%

14%

11%

13%

14%

18%

18%

15%

11%

8%

12%

**1952**

13%

15%

17%

15%

15%

22%

24%

27%

20%

17%

13%

17%

**1953**

18%

18%

25%

25%

24%

27%

31%

32%

26%

21%

15%

19%

**1954**

19%

16%

25%

24%

25%

31%

38%

36%

30%

24%

19%

24%

**1955**

27%

25%

31%

32%

32%

41%

50%

47%

40%

33%

26%

34%

**1956**

35%

33%

41%

40%

41%

52%

60%

58%

48%

39%

32%

39%

**1957**

41%

38%

49%

47%

48%

61%

70%

70%

58%

47%

39%

45%

**1958**

46%

41%

50%

47%

50%

64%

75%

77%

58%

49%

40%

45%

**1959**

49%

46%

58%

56%

61%

71%

86%

88%

69%

58%

50%

58%

**1960**

60%

55%

61%

69%

71%

83%

100%

97%

78%

69%

55%

63%

Blue (cold) is best, Red (hot) is worst

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. HYPERLINK \"mailto:tips@woodstreet.org.uk\"
[tips@woodstreet.org.uk]{.underline}

HYPERLINK \"http://www.woodstreet.org.uk\"
[www.woodstreet.org.uk]{.underline}

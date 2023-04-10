Daily Tip 31 10/06/2003 1:17 PM

**Adding space at start & end of cells in Proc Report**

Some simple things can be tricky to do in ODS. For instance if we wanted
to have some space before and after values in each column we could add
spaces to each variable, making sure we convert numerics to character -
but leading & trailing blanks are usually trimmed.

Using *asis=yes* will stop the spaces being trimmed. We can then put
spaces at the start and end of values using *pretext* & *posttext* --
this avoids the need to change the values of variables to incorporate
the spaces. *Cellpadding* can be used to define the white space on each
of the 4 sides of text in a cell -- in our case we want none.

Read more about style attributes here -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../odsug.hlp/a001044687.htm#a001047947]{.underline}

**SAS Program**

ods html file=\'test.html\' ;

**proc** **report** data=sashelp.class nowd

style={cellpadding=**0**}

style(header)={pretext=\" \" posttext=\" \" asis=yes}

style(column)={pretext=\" \" posttext=\" \" asis=yes} ;

define sex / order ;

define age / order ;

**run** ;

ods html close ;

**Output**

***The SAS System***

**Name**

**Sex**

**Age**

**Height**

**Weight**

Joyce

F

11

51.3

50.5

Jane

12

59.8

84.5

Louise

56.3

77

Alice

13

56.5

84

Barbara

65.3

98

Carol

14

62.8

102.5

Judy

64.3

90

Janet

15

62.5

112.5

Mary

66.5

112

Thomas

M

11

57.5

85

James

12

57.3

83

John

59

99.5

Robert

64.8

128

Jeffrey

13

62.5

84

Alfred

14

69

112.5

Henry

63.5

102.5

Ronald

15

67

133

William

66.5

112

Philip

16

72

150

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

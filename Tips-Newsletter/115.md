Daily Tip 115 08/12/2004 16:38:00

**Counting data multiple times using formats**

There is an option available in PROC FORMAT which enables you to define
multiple labels for the same value -- **multilabel**. A typical time you
may want to do this is when your data can be categorised in different
ways.

Once you have created a **multilabel** format, you then must use a
procedure which supports processing in this way, such as **Means**,
**Summary** & **Tabulate**. On the class statement in the procedure you
must specify the **mlf** option.

A colleague asked me about this at a conference recently and the
following example is based on his question. In this example we have
people with different racial backgrounds, including mixtures of various
races. We count them multiple times to tell who belongs to each racial
background.

**SAS Code**

**data** people ;

input id race ;

label id=\'Id number\'

race=\'Race code: 1=Black, 2=White, 3=Black/White, 4=Black/White/Other\'
;

cards ;

1 3

2 1

3 3

4 2

5 4

6 2

7 4

;;

**run** ;

**proc** **format** ;

value race (multilabel)

**1**=\'Black\'

**2**=\'White\'

**3**=\'Black\'

**3**=\'White\'

**4**=\'Black\'

**4**=\'White\'

**4**=\'Other\' ;

**run** ;

**proc** **means** data=people ;

format race race. ;

class race / mlf ;

**run** ;

**Output produced**

The MEANS Procedure

Analysis Variable : id Id number

Race code:

1=Black,

2=White,

3=Black/White,

4=Black/White/ N

Other Obs N Mean Std Dev Minimum Maximum

ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

Black 5 5 3.6000000 2.4083189 1.0000000 7.0000000

Other 2 2 6.0000000 1.4142136 5.0000000 7.0000000

White 6 6 4.3333333 2.1602469 1.0000000 7.0000000

ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

**For more information**

Multilabel formats ...
[http://support.sas.com/onlinedoc/912/getDoc/proc.hlp/a002473472.htm]{.underline}

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

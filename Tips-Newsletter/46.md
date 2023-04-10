Daily Tip 46 03/07/2003 10:12 PM

**Find in enhanced editor**

The enhanced editor in SAS 8 has been improved in various ways over the
old Program Editor. One improvement appears in the find window, which
can be accessed by pressing Ctrl-F or using the pull down menu
(Edit-Find).

There is now the opportunity to tell Find to look in: all the text, just
the code or just the comments.

There is also the chance to specify regular expression searches, which
allow pattern matching. If you are unfamiliar with this you can click on
the right-facing triangle next to the *Find text* box. This has
descriptions of things that can be specified in an expression. By
selecting one of these the code will be entered in the Find text box,
and can be customised.

This all works for Replace as well (Ctrl-H).

***Some examples of regular expressions in a FIND TEXT box***

***Regular expression***

***Explanation***

**\[sme\]date**

Match "sdate", "mdate" or "edate"

**\^data**

Match "data" when at the start of a line

**var\_\[abc123\]**

Match "var_a", "var_b", "var_c", "var_1", "var_2" or "var_3"

**\_\*name**

Match 0 or more "\*" characters, followed by "name" -- so it would match
"\_name", "name", "\_\_\_\_\_name", etc.

**proc \\w+**

Match "proc " followed by 1 or more word characters -- so it would match
"proc print", "proc datasets", etc. -- in fact "proc *anything"*

**data\\b+\\w+**

Match "data" followed by 1 or more write space characters and then 1 or
more word characters -- so it would match "data *anything*"

More information on regular expressions can be found at
[http://support.sas.com/rnd/base/topics/datastep/perl_regexp/regexp.motivation.html]{.underline}
though not all are supported by the Find dialog box.

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

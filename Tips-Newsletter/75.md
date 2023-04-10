Daily Tip 75 15/10/2003 11:33 AM

**Turning comments on & off**

The purpose of this tip is to enable you to set up comments which can be
activated and deactivated by setting a couple of macro variables at the
top of your program. This is achieved by defining macro variables which
contain parts of a begin comment symbol. We need to define a & b (see
below) separately since if we put them together they are treated as a
comment.

This is quite useful for debugging since debugging code can be enabled
or commented out easily.

**Enabling comments** - Set macro variables a & b to nulls, so that &a&b
resolves to a null and has no effect. \*/; also has no effect since it
behaves as a normal comment starting with a \* and ending in a
semi-colon.

**Disabling comments** - Set macro variable a to / and b to \*. When
they are put together as &a&b they produce /\* which starts a comment.
\*/ then ends the comment.

***SAS Program***

%let a=/; \* comments active ;

%let b=\*; \* comments active ;

\*\*\* to deactivate set A & B to blanks \*\*\*;

&a&b

proc print data=x ;

run ;

\*/;

data \_null\_ ;

run ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb

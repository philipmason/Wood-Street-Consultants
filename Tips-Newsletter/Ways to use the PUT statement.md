Daily Tip 40 24/06/2003 11:06 PM

**Ways to use the PUT statement**

The PUT statement is a very flexible tool in the data step programmers
toolkit. Here are some different ways of using it -- hopefully there may
be one or two you have not seen before.

*Statement*

Explanation

Put x y z ;

Write values of 3 variables out separated by a space

Put 'hello' '09'x ;

Write text followed by hexadecimal 09 -- which is a tab character (in
ASCII)

Put 132\*'\_' ;

Write 132 underscores

Put #3 \@44 cost ;

Write value of cost out beginning at line 3 column 44

Put var 1-5 ;

Write the value of var out into the columns from column 1 to column 5

Put cost dollar12.2 ;

Write the value of cost out using the dollar12.2 format

Put (a b) (1. ',' \$3.) ;

Write the value of a out using a 1. format, then a comma, then the value
of b using a \$3. format

Put \_infile\_ ;

Write out the current input buffer, as read by the last input statement

Put \_all\_ ;

Write out the values of all variables, including \_error\_ and \_n\_

Put \_ods\_ ;

Write out the default or previously defined variables to the ODS
destination

Put a b c @ ;

Write values of variables a, b & c out, separated by spaces & keep line
"open" so that next put statement will continue on. If we reach end of
data step iteration then line is "closed"

Put d e @@ ;

Write values of variables d & e out, separated by spaces & keep line
"open", even if we reach end of data step iteration.

Put \@10 name ;

Write value of name at column 10

Put \@pos name ;

Write value of name at column specified in variable pos

Put @(3\*pos) name ;

Write value of name at column calculated by value of pos multiplied by 3

Put a +3 b ;

Write value of a followed by 3 spaces and then value of b

Put a +gap b ;

Write value of a followed by a number of spaces specified in variable
gap, and then value of b

Put a +(2\*gap) b ;

Write value of a followed by a number of spaces calculated by value of
gap multiplied by 2, and then value of b

Put #2 text ;

Write value of text at line 2

Put #line text ;

Write value of text at line specified in variable line

Put #(line\*3) text ;

Write value of text at line calculated by value of line multiplied by 3

Put line1 / line2 ;

Write value of line1, then go to a new line and write value of line2

Put \@1 title overprint\
\@1 '\_\_\_\_\_\_\_\_' ;

Write value of title and then overprint underscores on that value. This
only works on some print destinations and usually looks wrong on the
screen.

Put \_blankpage\_ ;

Ensure that a totally blank page is produced. This means that if we had
written even 1 character on a page, then that page will be written as
well as another totally blank page.

Put \_page\_ ;

This finishes the current page, causing the next thing we write out to
be on a new page.

Put name= phone= ;

Write the text "name=" followed by the value of name, and then "phone="
followed by the value of phone.

Put my_big_array(\*) ;

Write each element of my_big_array in the form variable=value

For more information on PUT see
[http://v8doc.sas.com/sashtml/lgref/z0161869.htm]{.underline}

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

/**
@file
@brief This is the brief description of the code.
@version optional info
@copyright optional info

@details This is a more detailed description of what happens in the program.
Which can go over multiple lines,
and can have SAS code sections:
@code
Proc print ;
run;
@endcode
And then can continue on with more description.

   This is a highlighted block which could be used for code
   because it is indented by some spaces

And back to normal documentation when there is no indent.

I can highlight things like @b bold text, an @a argument, some @e emphasized text,
some @c code.
You can use html too like: <tt>Some code could be here</tt><p/>
Or <u>Underlined</u>, <b>bold</b>, <br/>
Normal markdown should work such as **bold**.

<A HREF="https://doxygen.nl/manual/htmlcmds.html">HTML Commands</a>

@author name goes here
@author another author name goes here

@date 21 Oct 2022 first version of program
@date 1 Jan 2023 next version

@param         parm1  this is a parameter description
@param[in]     parm2  this is an input parameter description
@param[out]    parm3  this is an output parameter description
@param[in,out] parm4  this is a parameter description for something that is input and output

@returns This describes what the code returns

@pre Pre-condition for using the code, for instance some macro variables need to be set first
@warning Warning about how to use the code
@test talk about testing here
@todo Record things here that are still to do
@bug Record any known bugs here
@xrefitem special "Special" "Special List" I can make special lists to gather items from multiple programs documentation.

#### Update History ####

   Date            Name                     Description
   -------------   -----------------------  --------------------------------------------------------
   1 Jan 2023      Phil Mason (pmason)      Sample of something that happenned.

#### SAS Called ####
@li gplot.sas is used in some way
@li b.sas some comments about it
@li c.sas (this one does not exist yet, so doesn't get a link)

#### Diagram(s) ####
@dot
digraph example {
in -> out
out -> report
}
@enddot
**/

proc print data=sashelp.springs ;
    run ;
    
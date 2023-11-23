/**
@file
@author Jean-Michel Bodart (B&D Life Sciences)
@date 03SEP2015 (1.0)

@ingroup ARGENX_BIO_GENERAL_MACROS_UTIL_DATASET
@ingroup ARGENX_BIO_GENERAL_MACROS_CHECKS
@ingroup ARGENX_BIO_GENERAL_MACROS_UTIL_GENERAL
@brief   Retrieve, generate and/or manipulate lists of SAS variables,
         existing or not in one or more SAS datasets.
         Retrieve variable(s) attribute(s) from a SAS dataset.
         Optionally generate code by inserting each variable name and/or attribute(s)
         in a specified pattern.

  License         : MIT license: http://opensource.org/licenses/MIT

                    Copyright (c) 2015 Jean-Michel Bodart, Business & Decision Life Sciences

                    Permission is hereby granted, free of charge, to any person obtaining a copy
               of this software and associated documentation files (the "Software"), to deal
               in the Software without restriction, including without limitation the rights
               to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
               copies of the Software, and to permit persons to whom the Software is furnished
               to do so, subject to the following conditions:

                    The above copyright notice and this permission notice shall be included
               in all copies or substantial portions of the Software.

                    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
               INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
               FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
               OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
               OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
               IN THE SOFTWARE.


@param[in] DATA      (space-separated list of) dataset(s) to retrieve variables from.
                    default:
                       #default#  : If parameter VAR=#default#, or contains any of the following
                                    special values (#num# #char# #all# #<i># #<i>-<j># /<pattern>/),
                                    use dataset specified by &SYSLAST.
                                    Otherwise, variables are not retrieved from any dataset and
                                    only those variables explicitly specified in parameter VAR
                                    are considered.
                    special values:
                       <empty>    : if parameter DATA has an empty value, an empty list of variables
                                    is returned.
                       <non-existing dataset>
                       or <invalid dataset name>
                                  : considered as a dataset with no variables
                       <dataset>:<alias>
                                  :if a dataset name is followed by a colon (:) and an alias, the defined alias
                                   can be used in the formatted results variable list (see paraemeter PATTERN)
                    dataset operators:
                       #union#    : (DEFAULT) consider variables that are at least in one of the specified datasets
                       #except#   : exclude variables that are present in the right-hand dataset(s)
                       #intersect#: consider only variables that are present in both left-hand and
                                    right-hand datasets
                       #xor#      : consider only variables that are present in either left-hand or
                                    right-hand datasets, not in both
                       #or#       : equivalent to #union#
                       #and#      : equivalent to #intersect#
                       #not#      : equivalent to #except#
                       <space>    : equivalent to #union#
@param[in] VAR       (space-separated) list of variable names, to be matched against the contents of
                     datasets specified in DATA parameter) and variable operators.
                    The complete list is first evaluated against the first dataset specified in DATA parameter,
                    providing a resulting list, before being evaluated again against the next dataset (if any).
                    The resulting lists corresponding to separate datasets will be combined sequentially
                    according to the specified dataset operators.
                    Note: It is expected that all variable names respect the option VALIDVARNAME=V7.
                    Variables lists operators are evaluated sequentially, i.e.
                    - the first operator processes the list of variables specified on its left
                      against the list of variables specified on its right (up to the next operator
                      or the end of the variables list is encontered)
                    - this resolves into a new list of variables on the left of the next operator (if any),
                      to be processed similarly by that operator against the list of variables specified on its right
                      (up to the next operator or the end of the variables list is encontered)
                    - the final list of variables is obtained after the last operator processing
                    default:
                       #default#  : i.e. consider all variables in the specified dataset
                   special values:
                    -  #all#      : consider all variables in the specified dataset
                    -  #num#      : consider all numerical variables in the specified dataset
                    -  #char#     : consider all character variables in the specified dataset
                    -  #<i>#      : consider variable number <i> in the specified dataset
                    -  #<i>-<j>#  : consider variable numbers between <i> and <j> (inclusive)
                                    in the specified dataset
                                    (where <i> and <j> are integer values >=0)
                                       e.g. use #1-5# to refer to the first 5 variables in the
                                            specified dataset (or less if the dataset has less than 5 variables)
                                            use #5-1# to refer to the first 5 variables in reverse order
                    -  <var><i>-<j>: consider the list of variables named from <var><i> to <var><j>
                                    (where <var> is a variable root (not ending with a number)
                                     and <i> and <j> are integer values >= 0, in ascending or descending order)
                                       e.g. use v8-v10 to refer to the sequence: v8 v9 v10
                                            use col008-col010 to refer to the sequence: col008 col009 col010
                                            use t100-t098 to refer to the sequence: t100 t099 t098
                                     note: the list of variables can be generated without any dataset specified,
                                           but if a dataset is specified only those variables found in the dataset
                                           will be kept
                    -  <varX>-<varY>
                                   : consider all variables from the specified dataset with a name that is between
                                     <varX> and <varY> in the alphabetical order (or reverse order) (case insensitive)
                                     Note: variables <varX> and <varY> do not have to exist in the specified dataset.
                    -  <varX>--<varY>
                                   : consider all variables with a position between <varX> and <varY> (inclusive)
                                     in the specified dataset
                                     Note: variables <varX> and <varY> have to exist in the specified dataset.
                    -  <root>:     : consider all variables with a name starting with <root> in the specified dataset
                    -  :<suffix>   : consider all variables with a name ending with <suffix> in the specified dataset
                    -  <root>:<suffix>
                                   : consider all variables with a name both starting with <root> and ending with <suffix>
                                     in the specified dataset
                    -  /<pattern>/: any variable matching the PERL regular expression <pattern>
                                    Note: <pattern> should not contain any blank character.
                                    e.g. /^trt\d\dn?$/ matches any variable name starting with "trt"
                                                       followed by two digits (from 00 to 99)
                                                       followed optionally by "n", and without any
                                                       additional characters.  A case-insensitive
                                                       match is applied.
                    -  <null>     : (e.g. parameter VAR is assigned the value of a macro-variable that resolves
                                     to a null string or blank(s) characters)
                                    results in returning an empty list of variables
                    -variables operators:
                    -   #except#   : exclude all variables specified on the right hand of this operator
                                    from those specified on the left hand.
                    -   #not#      : equivalent to #except#
                    -   #intersect#: consider only variables that are present both on the left-hand and on
                                    the right-hand of the operator
                    -   #and#      : equivalent to #intersect#
                    -   #xor#      : consider only variables that are present either on the left-hand or
                                    on the right-hand of the operator, not on both sides
@param[in] PREFIX   zero, one or more (space-separated) variable name fragments or Perl Regular Expression Patterns (/.../),
                    to be compared successively against the start of variable name #var# until the first match, or no match at all
                    is found.  If a match is found, the corresponding leading part (substring) of the variable name
                    becomes the value of keyword #pre# for that variable, and that part is removed from the opriginal variable
                    name #var# to form the "bare" variable name #bvar# (from which the suffix, if any is identified, will be
                    removed in a second step). Matches are always performed in a case-insensitive way, and any Perl RegExp pattern
                    specified must start and end with a forward slash (no modifier allowed) and cannot contain any space.
@param[in] SUFFIX   zero, one or more (space-separated) variable name fragments or Perl Regular Expression Patterns (/.../),
                    to be compared successively against the end of the remaining part of variable name #var# (after removing
                    the prefix #pre# if any was identified for that variable) until the first match, or no match at all
                    is found.  If a match is found, the corresponding trailing part (substring) of the variable name
                    becomes the value of keyword #suf# for that variable, and that part is also removed from the opriginal
                    variable name #var# (after first removing the #pre# part) to form the "bare" variable name #bvar#.
                    Matches are always performed in a case-insensitive way, and any Perl RegExp pattern specified must start
                    and end with a forward slash (no modifier allowed) and cannot contain any space.
@param[in] PATTERN  specifies a litteral expression used to "format" each variable name
                    in the final resulting list, where the following keywords have special meanings:
                    - #var# will be replaced by the variable name
                    - #tmpvar# will be replaced by a valid temporary variable name generated on the template #var#_X
                               where #var# refers to the original variable name truncated to 28 characters if applicable,
                                _ represents one or more underscore characters and X represents one or more
                               digit(s), lowercase letter(s) or underscore character(s), combined to form a valid SAS
                               V7 name (max length 32 characters).
                               The temporary variable name will be unique: different from any of the existing variables
                               from the specified datasets, different from any of the variables specified (valid or not and
                               found or in any of the specified datasets), and different from any of the temporary variable
                               names generated in the current %varlist call.
                    - #bvar# will be replaced by the "bare" variable name i.e. after removal of any prefix and/or suffix
                             as specified by parameters PREFIX= and SUFFIX= (note: this might not be a valid variable name
                             e.g. an empty string or a string starting with a number)
                    - #pre# will be replaced by the part of the variable name that matches a prefix definition so that
                            the full variable name #var# can be reconstructed by concatenating #pre#, #bvar# and #suf#.
                    - #suf# will be replaced by the part of the variable name that matches a suffix definition so that
                            the full variable name #var# can be reconstructed by concatenating #pre#, #bvar# and #suf#.
                            Note: #suf# is determined after removing the #pre# component of #var#.
                    - #dsn# will be replaced by the (first) dataset name containing the variable #var#
                    - #dsa# will be replaced by the dataset alias of the (first) dataset containing the variable #var#
                            if an alias was specified for that dataset (see parameter DATA), otherwise
                            by the dataset name itself (similar to #dsn#)
                    - #vnum# will be replaced by #var# variable number from dataset #dsn# if defined, otherwise empty
                    - #vlen# will be replaced by #var# variable length from dataset #dsn# if defined, otherwise empty
                    - #vmxlen# will be replaced by #var# variable maximum length across all datasets that contain it (if any), otherwise empty
                    - #vtlen# will be replaced by #var# variable length from dataset #dsn# if defined, preceded by "$" if type is C, otherwise empty
                             [format suitable for use as part of a data step LENGTH statement]
                    - #vtmxlen# will be replaced by #var# variable maximum length across all datasets that contain it (if any), preceded by "$" if type is C, otherwise empty
                             [format suitable for use as part of a data step LENGTH statement]
                    - #vtyp# will be replaced by #var# variable type (C or N) from dataset #dsn# if defined, otherwise empty
                    - #vfmt# will be replaced by #var# variable format from dataset #dsn# if defined, otherwise empty
                    - #vfmtkeywd# will be replaced by 'format=<format>' from dataset #dsn# if #var# variable format is defined, otherwise empty
                    - #vfmtdef# will be replaced by #var# variable format from dataset #dsn# if defined, otherwise
                                by default format ($#vlen#. for a character variable, &defnumfmt. for a numeric variable)
                    - #vfmtdefq# will be replaced by #var# variable format from dataset #dsn# if defined, otherwise
                                 by $quote. format for a character variable, &defnumfmt. for a numeric variable
                    - #vinfmt# will be replaced by #var# variable informat from dataset #dsn# if defined, otherwise empty
                    - #vinfmtkeywd# will be replaced by 'informat=<informat>' from dataset #dsn# if #var# variable informat is defined, otherwise empty
                    - #vinfmtdef# will be replaced by #var# variable informat from dataset #dsn# if defined, otherwise
                                by default format ($#vlen#. for a character variable, &defnumfmt. for a numeric variable)
                    - #vlab# or #vlabel# will be replaced by #var# variable label from dataset #dsn# if defined, otherwise empty
                    - #isnull# will be replaced by 1 if #var# variable has null values (num=. or char=' ') on all records, otherwise by 0.
                    - #isfound# will be replaced by 1 if #var# variable has been found in at least one of the specified datasets, otherwise by 0.
                    - #vlabsrc# or #vlabelsrc# will be replaced by #var# variable label from dataset #dsn# if defined, otherwise empty,
                                   with FIRST source dataset and variable appended as [<DATASET>.<VARIABLE>]
                            <b>Caution: if a variable results from the COALESCE() of multiple variables from separate
                                     datasets, this will not be apparent from the resulting variable label.</b>
                    - #vlabnam# or #vlabelnam# will be replaced by #var# variable label from dataset #dsn# if defined, otherwise empty,
                                   with variable appended as [<VARIABLE>]
                    - #vlabq# or #vlabelq# will be replaced by #var# variable quoted label from dataset #dsn# if defined, otherwise " "
                    - #vlabsrcq# or #vlabelsrcq# will be replaced by #var# variable quoted label from dataset #dsn# if defined, otherwise " ",
                                   with FIRST source dataset and variable appended as [<DATASET>.<VARIABLE>]
                    - #vlabnamq# or #vlabelnamq# will be replaced by #var# variable quoted label from dataset #dsn# if defined, otherwise " ",
                                   with variable appended as [<VARIABLE>]
                    - #vlenlabfmt# or #vlenlabelfmt# will be replaced by the sequence:
                               <variable> [LENGTH=<length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the associated dataset (if specified in DATA parameter)
                            Note: This sequence is approprite to specify new variables in SQL syntax with the same attributes
                                  as an existing variable.
                    - #vmxlenlabfmt# will be replaced by the sequence:
                               <variable> [LENGTH=<max_length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the associated dataset (if specified in DATA parameter)
                            <max_length> is replaced by variable maximum length across all datasets that contain it (if any)
                            Note: This sequence is approprite to specify new variables in SQL syntax with the same attributes
                                  as an existing variable.
                    - #vlenlabsrcfmt# or #vlenlabelsrcfmt# will be replaced by the sequence:
                               <variable> [LENGTH=<length>] LABEL=<quoted label + [<DATASET>.<VARIABLE>]> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the FIRST associated dataset (if specified in DATA parameter)
                            Note: This sequence is approprite to specify new variables in SQL syntax with the same attributes
                                  as an existing variable, when the the variable name (with its FIRST source dataset) needs
                                  to be identifiable from its label.
                    - #vtlenlabsrcfmt# will be replaced by the sequence:
                               <variable> [LENGTH=[$]<length>] LABEL=<quoted label + [<DATASET>.<VARIABLE>]> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the FIRST associated dataset (if specified in DATA parameter)
                            Note: This sequence is approprite to specify attributes of new variables in an ATTRIB statement
                                  within a DATA step, when the the variable name (with its FIRST source dataset) needs
                                  to be identifiable from its label.
                    - #vtlenlabfmt# or #vattrib# will be replaced by the sequence:
                               <variable> [LENGTH=[$]<length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the associated dataset (if specified in DATA parameter)
                            [$] will be replaced by the character '$' in case of a character variable, otherwise blank.
                            Note: This sequence is approprite to specify attributes of new variables in an ATTRIB statement
                                  within a DATA step.
                    - #vtmxlenlabfmt# will be replaced by the sequence:
                               <variable> [LENGTH=[$]<max_length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                            where parts between square brackets [] will only be present if the corresponding variable attribute
                            could be retrieved from the associated dataset (if specified in DATA parameter)
                            <max_length> is replaced by variable maximum length across all datasets that contain it (if any)
                            [$] will be replaced by the character '$' in case of a character variable, otherwise blank.
                            Note: This sequence is approprite to specify attributes of new variables in an ATTRIB statement
                                  within a DATA step.
                    - #vtnull# will be replaced by the null value appropriate according to <variable> type: . (Num) or ' ' (Char).
                    - #vvalcatsq# will be replaced either by the expression: cats(#var#) for numeric variables
                                  or by the expression: quote(cats(#var#)) for character variables,
                            So the returned expression evaluated in the context of data step, sql or where clause will generate
                            a value without leading or trailing spaces, and quoted if it comes out of a character variable.
                            Used with sep=||','|| it will generate a list of comma-separated values where the character variable values
                            are quoted and can therefore contain the separator character (comma).
                            Note: in order to have quotes also inserted around numeric variables values, use: quote(cats(#var#)).
                            Note: in order to have quotes also inserted around formatted variables values, use: quote(cats(put(#var#, #vfmtdef#))).
                    - #vvalcattq# will be replaced either by the expression: cats(#var#) for numeric variables
                                  or by the expression: quote(catt(#var#)) for character variables (preserving leading spaces),
                            So the returned expression evaluated in the context of data step, sql or where clause will generate
                            a value without leading or trailing spaces if numeric, or quoted and without trailing spaces if character.
                            Used with sep=||','|| it will generate a list of comma-separated values where the character variable values
                            are quoted and can therefore contain the separator character (comma).
                            Note: in order to have quotes also inserted around numeric variables values, use: quote(catt(#var#)).
                            Note: in order to have quotes also inserted around formatted variables values, use: quote(catt(put(#var#, #vfmtdef#))).
                    - #vvalcatq# will be replaced either by the expression: cats(#var#) for numeric variables
                                  or by the expression: quote(cat(#var#)) for character variables (preserving leading and trailing spaces),
                            So the returned expression evaluated in the context of data step, sql or where clause will generate
                            a value without leading or trailing spaces if numeric, or quoted and with leading and trailing spaces if character.
                            Used with sep=||','|| it will generate a list of comma-separated values where the character variable values
                            are quoted and can therefore contain the separator character (comma).
                            Note: in order to have quotes also inserted around numeric variables values, use: quote(cat(#var#)).
                            Note: in order to have quotes also inserted around formatted variables values and keep leading blanks
                                  for numeric variables, use: quote(cat(put(#var#, #vfmtdef#))).
                    - #putattrib# :
                            When used as only contens of parameter PATTERN=,
                            generates and executes a data _null_ step with put statements that writes to the LOG
                            a nicely formatted ATTRIB statement with the attributes of all selected variables.
                    - #vareq-<w>-<x>[-<y>[-<z>]]#
                            will be replaced with:
                            (<w>.<variable>=<x>.<variable> [ and <w>.<variable>=<y>.<variable> [ and <w>.<variable>=<z>.<variable> ]])
                            (where parts between square brackets [] are optional
                                   <w>, <x>, <y>, <z> are single words corresponding to dataset names or aliases to dataset )
                            Note: This is meant to be used typically within the ON sql-expression used with SQL OUTER JOIN(s).
                    - #coal-<w>-<x>[-<y>[-<z>]]#
                            will be replaced with:
                               COALESCE(<w>.<variable>, <x>.<variable>[, <y>.<variable> [, <z>.<variable> ]])
                               as <variable> [LENGTH=<length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                            (where parts between square brackets [] are optional
                                   <w>, <x>, <y>, <z> are single words corresponding to dataset names or aliases to dataset )
                            Note: This is meant to be used typically within SQL SELECT expression used with SQL (inner/ outer/ left/ right) JOIN(s).
                    - #autoCOAL#
                    -       will be replaced with:
                               COALESCE(<dsa1>.<variable>, <dsa2>.<variable>[, <dsa3>.<variable> [, ... ]])
                                  as <variable> [LENGTH=<length>] LABEL=<quoted label> [FORMAT=<format>] [INFORMAT=<informat>]
                               if <variable> was retrieved from multiple datasets combined with dataset operators #OR#, #UNION#, #AND", #INTERSECT#
                    -       or with:
                               <dsa1>.<variable>
                               if <variable> was retrieved from a single dataset
                                  (where <dsa1>..<dsa(n)> are the dataset aliases (or dataset names if aliases are not provided)
                                                              of all those datasets from which <variable> was retrieved
                                         parts between square brackets [] will only be present if the corresponding variable attribute
                                                        could be retrieved from the associated dataset (if specified in DATA parameter)
                    -       Note: This is meant to be used typically within SQL SELECT expression used with SQL (inner/ outer/ left/ right) JOIN(s).
                    - #autoCOALb# (for autoCOAL, bare)
                    -       will be replaced with:
                               COALESCE(<dsa1>.<variable>, <dsa2>.<variable>[, <dsa3>.<variable> [, ... ]])
                               if <variable> was retrieved from multiple datasets combined with dataset operators #OR#, #UNION#, #AND", #INTERSECT#
                    -       or with:
                               <dsa1>.<variable>
                               if <variable> was retrieved from a single dataset
                                  (where <dsa1>..<dsa(n)> are the dataset aliases (or dataset names if aliases are not provided)
                                                              of all those datasets from which <variable> was retrieved)
                    -       Note: This is meant to be used typically within SQL GROUP BY clause,
                                  especially when receiving the message: ERROR: Ambiguous reference, column <variable> is in more than one table..
                    - #autoCOALsrc#
                    -       will be replaced similarly to #autoCOAL# but with list of source variables between square brackets []
                            appended to the original variable label,
                            i.e.:  LABEL=<quoted label + [coalesce: <dataset1>.<variable>, <dataset2>.<variable>[, <dataset3>.<variable> [, ... ]]]>
                    -       Note: This is meant to be used typically within SQL SELECT expression used with SQL (inner/ outer/ left/ right) JOIN(s),
                                  when the exact source of each variable needs to be identifiable from its label.
                    - #autoEQ#
                    -       will be replaced with:
                               (COALESCE(<dsa1>.<variable>, <dsa2>.<variable>[, <dsa3>.<variable> [, ... ]]) = <dsa(n)>.<variable>)
                                  if <variable> was retrieved from >2 datasets combined with dataset operators #OR#, #UNION#, #AND", #INTERSECT#
                                  where <dsa1>..<dsa(n)> are the dataset aliases of all those datasets from which <variable> was retrieved
                    -       or with:
                               (<dsa1>.<variable> = <dsa2>.<variable>)
                                  if <variable> was retrieved from  exactly 2 datasets combined with dataset operators #OR#, #UNION#, #AND", #INTERSECT#
                    - #comma#, #coma#, #c#                   : will be replaced by one comma (,) - alternative to %bquote(,)
                    - #cs#                                   : will be replaced by one comma (,) and one space ( ) - alternative to %bquote(, )
                    - #s#, #space#                           : will be replaced by one space ( ) - alternative to %quote( )
                    - #semicolon#, #semicol#, #scol#, #sc#   : will be replaced by one semicolon (;) - alternative to %bquote(;)
                    - #scs#                                  : will be replaced by one semicolon (;) and one space ( ) - alternative to %bquote(; )
                    - #lpar#                                 : will be replaced by left parenthesis '('
                    - #rpar#                                 : will be replaced by right parenthesis ')'
                    - #pct#                                  : will be replaced by percent character '%'
                    - #sep#                                  : will be replaced by an empty string for the first <variable>, then by the value of parameter SEP
                    - #squot#, #dquot#                       : will be replaced by single ("'") and double ('"') quote character respectively
                    - #n#                                    : will be replaced by the number of the variable being processed in the return list
                    - #autoFULLEQ#, #autoLEFTEQ#, #autoRIGHTEQ#, #autoINNEREQ# : when specified as the full contents of the pattern= parameter,
                            will be replaced by some code to be used as the contents of a SQL FROM clause respectively for one or more
                            FULL JOIN(s), LEFT JOIN(s), RIGHT JOIN(s), INNER JOIN(s)
                            with the ON clause(s) corresponding to the equality of all variables in common between the right-hand dataset and the
                            (previously joined) left-hand dataset(s) (equijoin).  If no variables are in common, the ON clause criterion
                            will be specified as (1 EQ 1) i.e. an always true condition, which should result in something equivalent to
                            a cartesian product or CROSS JOIN.
                            Alternatively, a similar FROM clause can be generated and appended to the list of variables returned by
                            the normal %VARLIST call (with the FROM keyword inserted after the list of variables) by specifying
                            similar keywords as part of the from= parameter.
                    - Any other text will appear unchanged
                    - default: #var#
@param[in] PATTERNALT  specifies an "alternative" litteral expression used to "format" each variable name in the final resulting list,
                    for "variables" that do not meet the WHERE criteria, that are not found in specified or DEFAULT dataset(s),
                    or that are not valid SAS V7 names (if no dataset is specified).
                    Default: empty - i.e. variables not meeting the WHERE criteria or not found in specified dataset(s) are skipped, as well as
                    non valid variable names.
                    CAUTION: If not empty, the pattern is included in the returned list WITH/WITHOUT SEPARATORs for variables that are not found
                             in specified or DEFAULT dataset(s), or that are not valid SAS V7 names (if no dataset is specified)
                             (as specified by parameters ALTSEP and ALTSEPPOS).
                    The following keywords are recognized:
                    - #var#                                  : will be replaced by the "variable" name
                    - #pre#, #suf# and #bvar#                : will be replaced respectively by the prefix, suffix and "bare" parts of the "variable"
                                                               name.
                    - #isnull#                               : will be replaced by 1.
                    - #isfound#                              : will be replaced by 0 if #var# is either not a valid SAS V7 name, or a variable
                                                               not found in the specified dataset(s).
                    - #isvalid#                              : will be replaced by 1 if #var# is a valid SAS V7 name, otherwise by 0.
                    - #comma#, #coma#, #c#                   : will be replaced by one comma (,) - alternative to %bquote(,)
                    - #cs#                                   : will be replaced by one comma (,) and one space ( ) - alternative to %bquote(, )
                    - #s#, #space#                           : will be replaced by one space ( ) - alternative to %quote( )
                    - #semicolon#, #semicol#, #scol#, #sc#   : will be replaced by one semicolon (;) - alternative to %bquote(;)
                    - #scs#                                  : will be replaced by one semicolon (;) and one space ( ) - alternative to %bquote(; )
                    - #lpar#                                 : will be replaced by left parenthesis '('
                    - #rpar#                                 : will be replaced by right parenthesis ')'
                    - #pct#                                  : will be replaced by percent character '%'
                    - #squot#, #dquot#                       : will be replaced by single ("'") and double ('"') quote character respectively
                    - #n#                                    : will be replaced by the number of the variable being processed in the return list
                    - #sep#                                  : will be replaced by an empty string for the first <variable>, then by the value of parameter
                                                               SEP for the subsequent <variable>s.
@param[in] SEP      separator between variables (formatted according to the specified PATTERN) in the resulting string,
                    where the following keywords have special meanings:
                    - #comma#, #coma#, #c#                   : will be replaced by one comma (,)
                    - #semicolon#, #semicol#, #scol#, #sc#   : will be replaced by one semicolon (;)
                    - #space#, #s#                           : will be replaced by one space ( )
                    - #commaspace#, #comaspace#, #cs#        : will be replaced by one comma followed by one space (, )
                    - #semicolonspace#, #semicolons#, #semicolspace#, #semicols#, #scols#, #scs#
                                                            : will be replaced by one semicolon followed by one space (; )
                    - #and#                                  : will be replaced by " and " (without quotes)
                    - #or#                                   : will be replaced by " or " (without quotes)
                    - #put#                                  : will be replaced by "; %put %str( )" (without quotes) in order to print the variable
                                                              preceded by a space in the log on a new line.
                    - default: #space#
@param[in] LSEP      If specified, indicates the separator to use in front of the last variable (default=#sep# i.e. use same separator
                     specified by parameter SEP).
                     Other keywords with special meaning: see SEP.
@param[in] ALTSEP    If specified, indicates the separator to use for variables not found in specified dataset(s) / with not valid names
                     (in absence of any specified dataset) when PATTERNALT is not empty.
                     - NOTE: For variables found in specified dataset(s) / with valid names in absence of any specified dataset, but that
                           do not meet the WHERE criteria, the separator specified by parameter SEP is still used.
                     - Default=#sep# i.e. use same separator specified by parameter SEP).
                     - Other keywords with special meaning: see SEP.
@param[in] ALTSEPPOS Specifies (Y/N) whether or not to insert a separator (as specified by SEP / LSEP)
                        - in front of
                        - between
                        - after
                     variables not found in specified dataset(s) / with not valid names (in absence of any specified dataset)
                     (Default: NNN)
                     If less than 3 letters are specified, then the first letter is used for 'in front of', the last letter is used for 'after',
                     and a separator is used 'between' only if set to 'Y' for both 'in fron' and 'after'.
@param[in] PERSEP    Specifies an additional separator (default: empty string) to be inserted periodically (after the regular
                     sep=, lsep= or altsep= separator), each time the number of "variables" (either found, or (if PATTERNALT is not empty)
                     not found or with invalid names) processed is a multiple of the value specified by parameter PERIOD= (if > 0).
@param[in] PERIOD    Specifies the number of "variables" (either found, or (if PATTERNALT is not empty) not found
                     or with invalid names) after which the periodic separator (parameter PERsep=) will be inserted (if > 0).
@param[in] PHASE     Number by which to shift the periodicity of PERsep (default=0).
                     (this corresponds to periodically inserting special separators)
@param[in] FROM      If specified, appends to the returned list of variables (meant to be inserted in a PROC SQL SELECT clause)
                     an SQL FROM clause [with the SQL keyword FROM included], based on dataset(s) in data= parameter,
                     including one or more SQL JOIN(s) between the specified datasets (if more than one).
                     - In case of JOIN, this will be an EQUIJOIN based on variables in common between datasets (also taking into account the var= parameter),
                     JOIN type is according to parameter keywords (case-insensitive):
                     - #autoFULLEQ#  : FULL JOIN
                     - #autoLEFTEQ#  : LEFT JOIN
                     - #autoRIGHTEQ# : RIGHT JOIN
                     - #autoINNEREQ# : INNER JOIN
                     -Note: The corresponding ON clause(s) will be generated according to the variables in common between the (pairs of) datasets.
                     If no variables are in common the ON clause will specify the condition : 1 EQ 1 (always true) which in case of a FULL JOIN
                     should result in a JOIN equivalent to a cartesian product or CROSS JOIN.
                     It is also possible to generate a FROM clause (without the FROM keyword) from a separate call to %VARLIST, where the type
                     of join is specified as the full contents of the pattern= parameter (#autoFULLEQ#, #autoLEFTEQ#, #autoRIGHTEQ# or #autoINNEREQ#).
@param[in] WHERE    Optional condition that can be used to subset the list of returned variables (if PATTERNALT= parameter is not specified),
                    or to apply a different pattern for variables that do not meet the condition (if PATTERNALT= parameter is specified).
                    The condition must be met before a variable is added to the resulting string (formatted according to the specified PATTERN)
                    Default = 1 (i.e. an always true condition).  The condition should refer to the currently processed variable using keyword #var#, and
                    the corresponding single-variable attributes can be referred to using the same keywords that are available for use in PATTERN.
                    In addition, macro-functions can be used but they should be quoted using e.g. %nrstr or %nrbquote, or have their % sign replaced by #pct#
                    to prevent their evaluation before the keywords are replaced by their corresponding values.
                    -The following can be used to subset the list of retrieved variables to those having an associated format:
                    -    WHERE= %nrstr(%length)(#vfmt#) > 0
                    -The following can be used to subset the list of retrieved variables to those having a label containing the string "date" (case insensitive):
                    -    WHERE= %nrstr(%sysfunc)(prxmatch(/date/i, #vlabel#))
                    -The following can be used to select (character) variables #var# having a numeric counterpart #var#n in the same dataset:
                    -    WHERE= #pct#index(#s##pct#upcase(#num#)#s##c# #s##pct#upcase(#var#n)#s#)
                    -E.g. to display the variables from SASHELP.VTABLE having "observation" in their label, with their attributes, use:
                    -   %put %varlist(data=sashelp.vtable, WHERE= %nrstr(%sysfunc)(prxmatch(/observation/i, #vlabel#)), pattern=#putattrib#);
@param[in] PRETEXT  Optional text to be inserted in front of the list (of variables processed through patterns) to be returned, such as
                   an opening tag or bracket or step boundary.  Keywords referring to special characters (e.g. #s#, #c#, #sc#, #lpar#, #rpar#, #pct#) or
                   to the list of datasets passed in parameter DATA= (#data#) are resolved.
@param[in] POSTTEXT Optional text to be inserted at the end of the list (of variables processed through patterns) to be returned, such as
                   a closing tag or bracket or step boundary.  Keywords referring to special characters (e.g. #s#, #c#, #sc#, #lpar#, #rpar#, #pct#) or
                   to the list of datasets passed in parameter DATA= (#data#) are resolved.
@param[in] NVAR    (integer value or empty) Similar to NOBS dataset obtion, specifies a maximum number of variables retrieved from the input dataset(s)/list
                   to be processed/returned.  (default: . or empty - i.e. no limit is specified to the number of variables to be processed/returned.)
@param[in] FIRSTVAR (integer value or empty) Similar to FIRSTOBS dataset obtion, specifies the number of the first variable retrieved from the input dataset(s)/list
                   to be processed/returned. (default: 1 - i.e. process/return all variables from the first one)
@param[in] UNQUOTE (Optional)  If set to Y (=default), return value is macro-unquoted.
@param[in] UNIQUE  If Y (=Default), prevents a variable name to appear in more than one PATTERN in the final resulting
                   string (although a single pattern could contain multiple occurrences of the variable name)
@param[in] EDIT    If N (=Default), or if SAS does not run in an interactive session, does not prompt the user to edit/modify/confirm the parameter values
                   with which %varlist is called.
@param[in] DEFNUMFMT Default format to be used for keywords #vfmtdef# #vfmtdefq# #vinfmtdef# in numerical variables (Default: Best12.).
@param[in] ALWAYS   if set to Y, PRETEXT= and POSTTEXT= text is returned even if the output list of variables is empty.
@param[in] RETURN  If not empty, the specified text will be returned instead of the pretext value, variables list and posttext
                   value, after resolving special keywords (e.g. #s#, #c#, #sc#, #lpar#, #rpar#, #pct#, #data#, #n#)
                   where #n# indicates the number of variables that would have been returned.
@param[in] INTO    Specifies a macro-variable name and the text value to set it to after resolving special keywords
                   (e.g. #s#, #c#, #sc#, #lpar#, #rpar#, #pct#, #data#, #n#) where #n# indicates the number of variables that were / would have been returned.
                   The parameter value is specified as INTO= NAME TEXT_VALUE.

Additional parameters to be implemented:

@param[in] META    Optionally identifies the fields (column names) contained in a metadata datset that can be used as an indirect source of variable names and
                   attributes, instead of directly retrieving them from the actual datasets.  This means a dataset with that name does not need to have already been created.
                   -Syntax: [[metalibrary.]metadataset]@#dsn#:<dsn_field>#var#:<var_field>#type#:<type_field>[#label#:<label_field>][#fmt#:<fmt_field>][#infmt#:<infmt_field>]
                   -   where 'metadataset' (optional) is the name of the dataset containing the metadata, optionally preceded by a metalibrary name, to be used by default.
                   -          '@' (madatory) indicates the start of the (#attribute#:field_name) pairs, some of them are mandatory, others (between square brackets [])
                                 are optional.  The #attribute# part is fixed, while the field name (between angle brackets <>) should be adapted to reflect the field names
                                 containing the corresponding information in the metadata dataset.
                   -   default: @#dsn#:TDOMAIN#var#:TVAR#type#:TTYPE#length#:TLENGTH#label#:TLABEL#fmt#:FORMAT
                   -Each dataset that should be looked up indirectly from the metadata must be preceded by the '@' character in the parameter DATA=.  This character can itself
                   be preceded by [[library.]metadataset] in order to specify and use a metadataset that differs between datasets.  Otherwise a common metadataset can be specified
                   in the parameter META=.
                   Additionally, a libname can be specified between the '@' and the dataset name in parameter DATA=.
                   Note: even if different metadatasets are used, they should all use the same field names specified in parameter META=.
@param[in] ORDER   variables are ordered according to their position
                    - in VAR parameter, if specified litterally
                    - in the dataset where they are found first, according to dataset position in DATA parameter,
                      if specified using special values #default#, #all#, #num#, #char#, /<pattern>/

#### Update History ####

    Date             Name                        Description
    ------------     --------------------------  -----------------------------------------------------------------------------
   04-Dec-16      Jean-Michel Bodart         Added keyword #vtlen# for use in PATTERN= parameter.
   17-Feb-17      Jean-Michel Bodart         Added keywords #vtlenlabfmt# and #vatttrib# for use in PATTERN= parameter.
                                             If &VAR starts with keyword #not#, consider it as equivalent to #all# #not#.
                                             If &VAR starts with keyword #except#, consider it as equivalent to #all# #except#.
                                             Added keyword #putattrib# to use in PATTERN= parameter.  When used as unique content of parameter
                                             PATTERN=, writes to the LOG a nicely formatted ATTRIB statement (via a DATA _null_ step)
                                             with the attributes of all selected variables.
   20-Feb-17      Jean-Michel Bodart         Added parameter WHERE=.
   21-Feb-17      Jean-Michel Bodart         Corrected: If &VAR starts with keyword #except#, consider it as equivalent to #all# #except#.
                                             Allowed keywords in parameter WHERE to be in upper case or mixed case.
                                             For PATTERN=#putattrib#, do not consider default (in)formats assigned automatically e.g. by VIEWTABLE->SAVEAS
                                             (e.g. BEST12., F8., $F40., $<length>.).
   06-Mar-17      Jean-Michel Bodart         Matching of VAR=/pattern/ was case-sensitive, change to case-insensitive.
                                             Added keyword #isnull# for use in PATTERN= and/or WHERE=.
                                             Added parameters PRETEXT and POSTTEXT.
   29-Jan-18      Jean-Michel Bodart         Allow for use of keyword #cs# inside PATTERN= parameter.
   30-Jan-18      Jean-Michel Bodart         Changed %scan to %qscan to avoid message: lowcase() has too few arguments when &var is empty.
   07-Feb-18      Jean-Michel Bodart         Allow for use of keyword #scs# inside PATTERN= parameter.
   22-Feb-18      Jean-Michel Bodart         Allow for use of keywords #lpar#, #rpar# and #pct# inside PATTERN= parameter.
   24-Feb-18      Jean-Michel Bodart         When WHERE is used, only insert separator when the existing part of the return string is not empty.
   26-Feb-18      Jean-Michel Bodart         Added parameters NVAR= and FIRSTVAR=.
   27-Feb-18      Jean-Michel Bodart         Allow for use of keywords #lpar#, #rpar# and #pct# inside WHERE= parameter.
                                             Add parameter UNQUOTE=.
   12-Mar-18      Jean-Michel Bodart         Implemented UNIQUE=N.
                                             Added parameters PATTERNALT, LSEP, ALTSEP, ALTSEPPOS.
                                             Allow using keywords #s#, #space# and #isfound# within parameters PATTERN, PATTERNALT and WHERE.
                                             Allow using keyword #sep# within parameters PATTERN, PATTERNALT.
   19-Apr-18      Jean-Michel Bodart         Implemented keyword #tmpvar#, #vfmtkeywd# and #vinfmtkeywd" in PATTERN and PATTERNALT.
                                             Apply PATTERNALT to variables found in specified datasets but that do not meet the WHERE= condition.
   10-Aug-18      Jean-Michel Bodart         Allow for use of usual keywords as well as #data# (the (list of) dataset(s) processed)
                                             inside PRETEXT= and POSTTEXT= parameters.
   10-Aug-18      Jean-Michel Bodart         Added keywords #vvalcatsq#, #vvalcattq# and #vvalcatq# for use inside PATTERN= and WHERE= parameters.
   13-Aug-18      Jean-Michel Bodart         Add keywords #vmxlen# and #vtmxlen# for use in PATTERN and WHERE parameters.
   17-Aug-18      Jean-Michel Bodart         Re-implement the processing of variables found and not found.
   07-Sep-18      Jean-Michel Bodart         Correction of incorrect application of #xor# dataset operator (when PATTERNALT is empty).
   28-Aug-18      Jean-Michel Bodart         Stop wrongly attempting to resolve <var><i>-<j> (where <i> and <j> are positive integers)
                                             as <varX>-<varY> (where <varX> and <varY> are variable names starting with a letter or underscore but not a digit)
                                             in list of variables to look up
   10-Sep-18      Jean-Michel Bodart         Define macro-variable dsselectvars as local.
   17-Aug-18      Jean-Michel Bodart         Resolve keywords #all# #num# #char# in WHERE= parameter, allowing to retrieve only numerical #var#
                                             with a matching character counterpart #var#c, or only character #var# with a matching numeric counterpart #var#n.
   05-Dec-18      Jean-Michel Bodart         In &dsvarlist: avoid concatenating datasets when all variables occurrences are returned (UNIQUE=N).
                                             Explictly remove trailing space(s) from &ds (otherwise kept due to macro quoting).
                                             Make sure &dsa only contains a single dataset.
   29-Jan-19      Jean-Michel Bodart         Added keywords #vmxlenlabfmt# and #vtmxlenlabfmt# for use inside PATTERN= and WHERE= parameters.
   01-Feb-19      Jean-Michel Bodart         Added keywords #vlabnam# (or #vlabelnam#) and #vlabnamq# (or #vlabelnamq#) for use inside PATTERN= and WHERE= parameters.
   07-Feb-19      Jean-Michel Bodart         Added parameter EDIT= (Default:N).
   16-Feb-19      Jean-Michel Bodart         Restructure the list of macro-parameters so that each parameter is specified on a separate line
                                             and followed by a comment summarizing its usage.
   16-Feb-19      Jean-Michel Bodart         Added parameters PERsep=, PERIOD= and PHASE= (these correspond to periodically inserting special separators).
   19-Mar-19      Jean-Michel Bodart         Added keyword #n# for use inside PATTERN= and PATTERNALT= parameters.
   24-Mar-19      Jean-Michel Bodart         Added parameters PREFIX= and SUFFIX= together with keywords #pre#, #bvar# and #suf# for use inside PATTERN=,
                                             PATTERNALT= and WHERE= parameters.
   26-Mar-19      Jean-Michel Bodart         resolve #n# in PRETEXT= and POSTTEXT=.
   16-Oct-19      Jean-Michel Bodart         Use single quotes when quoting variable label to avoid unresolved macro references messages
                                             when the label contains special characters '&' or '%'.
   07-Nov-19      Jean-Michel Bodart         Update pattern used to identify valid var names to:  /^[a-z_]\w*$/i
                                             Include #vfmtkeywd# and  #vinfmtkeywd# in the list of variable attribute keywords when checking whether
                                             PATTERN=, PATTERNALT= or WHERE= parameters contain any reference to variable attributes.
   06-Dec-19      Jean-Michel Bodart         Avoid using %qsubstr() with 1st argument between double quotes
                                             as this leads to unexpected er-ror messages when macro is itself called
                                             within a double-quoted string:
                                             ER-ROR:-Macro-function-%QSUBSTR-has-too-few-arguments.
                                             ER-ROR:-Expected-close-parenthesis-after-macro-function-invocation-not-found.
                                             Avoid clash between macro-variables &suffix related respectively to :<suffix> and SUFFIX=
                                             (rename first one as &_suffix_).
                                             Resolve #ds# in PREFIX= and SUFFIX=.
                                             For SUFFIX=, replace incorrect code: %let patt=s/&patt./i; with: %let patt=s/^%qsubstr(&patt, 2, %eval(&l-1))/i;
   09-Apr-20      Jean-Michel Bodart         Added keyword #vtnull#.
   22-Jul-20      Jean-Michel Bodart         Added keyword #vfmtdefq#.
   30-Jul-20      Jean-Michel Bodart         Added parameter DEFNUMFMT=.
   12-Nov-20      Jean-Michel Bodart         Added parameter PAD=.
                                             Added keyword #put#.
   13-Sep-21      Jean-Michel Bodart         Added keywords  #squot#, #dquot#.
   17-May-22      Jean-Michel Bodart         Added keyword #vtlenlabsrcfmt# for use in PATTERN= parameter.
   18-Aug-22      Jean-Michel Bodart         Added parameters ALWAYS= (default: empty) and RETURN= (default: empty).
                                             Fixed issue when SEP= is empty, where LSEP, ALTsep and PERsep would by default be set to a single space.
                                             Make sure %str() is returned rather than an empty string.
   02-Sep-22      Jean-Michel Bodart         For pattern #putattrib#, add top line indicating the source dataset(s).
   04-Oct-23      Jean-Michel Bodart         Add parameter INTO=.


#### Examples ####
@code
option &mcompilenote;
%let debug=Y; *%symdel debug;
%put %varlist(data=sashelp.class);

%put %varlist(data=sashelp.class, var=age sex name, pattern=#s#, pretext=#n#);
%put %varlist(data=sashelp.class, var=age, pattern=#s#, pretext=#n#);
%put %varlist(data=sashelp.class, var=var_not_found does_not_exist, pattern=#s#, pretext=#n#);

%put %varlist(data=sashelp.class, var=age sex name, pattern=#s#, pretext=#n#, always=Y);
%put %varlist(data=sashelp.class, var=age, pattern=#s#, pretext=#n#, always=Y);
%put %varlist(data=sashelp.class, var=var_not_found does_not_exist, pattern=#s#, pretext=#n#, always=Y);

%put %varlist(data=sashelp.class, var=age sex name, return=#n#);
%put %varlist(data=sashelp.class, var=age, return=#n#);
%put %varlist(data=sashelp.class, var=var_not_found does_not_exist, return=#n#);

%symdel varlist_into / nowarn;
%put %varlist(data=sashelp.class, var=age sex name, into=varlist_into #data# #lpar##n##rpar#);
%put varlist_into = %superq(varlist_into);

%macro test();
   %local varlist_into;
   %let varlist_into = INITIAL_VALUE;
   %put %varlist(data=sashelp.class, var=age sex name, into=varlist_into #data# #lpar##n##rpar#);
   %put varlist_into = %superq(varlist_into);
%mend test;
%let varlist_into = GLOBAL_VALUE;
%test();
%put varlist_into = %superq(varlist_into);


%put %varlist(data=sashelp.class, var=age, into=varlist_into #n#);
%put varlist_into = %superq(varlist_into);
%put %varlist(data=sashelp.class, var=var_not_found does_not_exist, into=varlist_into #n#);
%put varlist_into = %superq(varlist_into);


%put %varlist(data=sashelp.class, var=var_not_found does_not_exist, return=Found #n# of the selected variables in #data#.);

%let debug=Y; %put >%varlist(data=sashelp.class, var=age sex name weight height, pattern=., sep=)<;
%put >%varlist(data=sashelp.class, var=age sex name, pattern=., sep=)<;
%put %length(%varlist(data=sashelp.class, var=age sex name, pattern=., sep=));
%put >%varlist(data=sashelp.class, var=age sex name var_not_found does_not_exist, pattern=., sep=)<;
%put %length(%varlist(data=sashelp.class, var=age sex name var_not_found does_not_exist, pattern=., sep=));
%put %length(%varlist(data=sashelp.class, var=var_not_found age does_not_exist, pattern=., sep=));
%put %length(%varlist(data=sashelp.class, var=var_not_found does_not_exist, pattern=., sep=));

%put %length(%varlist(data=sashelp.class));
%put %length(%varlist(data=sashelp.class, var=var_not_found));
%put %length(%varlist(data=sashelp.class, unquote=N));
%put %length(%varlist(data=sashelp.class, var=var_not_found, unquote=N));
%put %varlist(data=sashelp.class, sep=#cs#);
%put sashelp.class has the following variables: %varlist(data=sashelp.class, sep=#cs#, lsep=#and#).;
%put %varlist(data=sashelp.class, sep=#cs#, lsep=#and#, pretext=sashelp.class has the following variables:%str( ), posttext=.);
%put %varlist(data=sashelp.class, var= name sex age);
%put %varlist(var= name sex age);

%put %varlist(data=sashelp.class, var= name sex age clown);
%put %varlist(var= name sex age clown);

%put %varlist(data=sashelp.class, var= name sex age cl@wn);
%put %varlist(var= name sex age cl@wn); %* cl@wn is dropped as invalid variable name - OK  *;

%put %varlist(data=sashelp.class, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(data=sashelp.class, var= name sex age, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(var= name sex age, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);

%put %varlist(data=sashelp.class, var= name sex age clown, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(data=sashelp.class, var= name sex age clown, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(var= name sex age clown, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);

%put %varlist(data=sashelp.class, var= name sex age cl@wn, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(data=sashelp.class, var= name sex age cl@wn, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(var= name sex age cl@wn, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);

%put %varlist(var= name sex age cl@wn age*sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#s##var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(var= name sex age cl @ wn age * sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar##s#);
%put %varlist(var= name sex age cl @ wn age * sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar##s#, unique=N);

%put %varlist(data=sashelp.class, var= name sex age cl@wn age*sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#s##var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#); %*- name sex age should be found -) OK -*;
%put %varlist(data=sashelp.class, var= name sex age cl @ wn age * sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#s##var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#);
%put %varlist(data=sashelp.class, var= name sex age cl @ wn age * sex, pattern=#var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, PATTERNALT=#s##var# #lpar#isfound=#isfound# isvalid=#isvalid##rpar#, unique=N);

%put %varlist(data=sashelp.bweight, sep=#cs#);
%put %varlist(data=sashelp.bweight, pattern=#putattrib#);
%put Logistic model with Recurrence as dependent variable and %varlist(data=sashelp.bweight, var= Weight Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel interaction between MomEdLevel and Black
             , pattern=#vlabel#, PATTERNALT=(#var#: not found)#s#, unquote=N, unique=N, sep=#cs#) as independent variable(s).;
%put Logistic model with Recurrence as dependent variable and %varlist(data=sashelp.bweight, var= Weight Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel interaction between MomEdLevel and Bl
             , pattern=#vlabel#, PATTERNALT=#sep#(#var#: not found), unquote=N, unique=N, sep=#cs#) as independent variable(s).;
%put Logistic model with Recurrence as dependent variable and %varlist(data=sashelp.bweight, var= Weight Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel interaction between MomEdLevel and Black
             , pattern=#vlabel#, PATTERNALT=#var##s#, unquote=N, unique=N, sep=#cs#) as independent variable(s).;
%let txt = Logistic model with %varlist(data=sashelp.bweight, var= Weight as dependent variable and Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel interaction between MomEdLevel and Black
             , pattern=#vlabel#, PATTERNALT=#var#, unquote=N, unique=N, sep=#cs#, ALTSEP=#s#, ALTSEPpos=NYY) as independent variable(s).;
%put &txt;
%put %qsysfunc(prxchange(s/%bquote(,) (as|and) / \1 /i, -1, %superq(txt)));
%let txt = %varlist(pretext=Logistic model with%str( ), data=sashelp.bweight, var= Weight as dependent variable and Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel interaction between MomEdLevel and Black
             , pattern=#vlabel#, PATTERNALT=#var#, unquote=N, unique=N, sep=#cs#, ALTSEP=#s#, ALTSEPpos=NYY, posttext=%str( )as independent variable(s).);
%put %qsysfunc(prxchange(s/%bquote(,) (as|and) / \1 /i, -1, %superq(txt)));
%put %varlist(pretext=Logistic model with%str( ), data=sashelp.bweight, var= Weight as dependent variable and Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel and MomEdLevel * Black
             , pattern=#vlabel#, PATTERNALT=#var#, unquote=N, unique=N, sep=#cs#, ALTSEP=#s#, ALTSEPpos=YYY, posttext=%str( )as independent variable(s).);
%put %varlist(pretext=Logistic model with%str( ), data=sashelp.bweight, var= Weight as dependent variable and Black Married Boy MomAge MomSmoke CigsPerDay MomWtGain Visit MomEdLevel and MomEdLevel interaction with Black
             , pattern=#vlabel#, PATTERNALT=#var#, unquote=N, unique=N, sep=#cs#, ALTSEP=#s#, ALTSEPpos=YYY, posttext=%str( )as independent variable(s).);



proc format; value $sex "M"="Male" "F"="Female"; run; quit;

data class;
   set sashelp.class;
   studyid="SCHOOL001";
   class="Sea classes";
   dob="01JAN2000"d+ranuni(0)*365;
   format dob E8601da. sex $sex.;
   length text $400;
   drop i;
   do i=1 to 10 + round(ranuni(0)*20);
      text=catx(" ", text, repeat('X', round(ranuni(0)*20)));
   end;
   label age="Captain's age" height="Sailor's height (in)" weight="Weight (lbs)" studyid="Study Identifier" class="Class Type" text="Subject's comments" dob="Date of Birth";
run;
%put %varlist(data=class, var=#num#);

%macro l;
   %local debug;
   %*let debug=Y;
   *- Convert numerical variables to charcater without applying formats. Converted variables become last in the dataset -*;
   data class2;
      set class;
      %varlist(data=class, var=#num#, pattern=attrib #tmpvar# label=#vlabelq##scs# #tmpvar#=left(put(#var#, best32.))#scs# drop #var##scs# rename #tmpvar# = #var##scs#);
   run;
   %symdel debug / nowarn;
%mend l;
option mprint;
%l;

*- Convert numerical variables to character without applying formats. Other variables are re-defined identically. Original order of variables is maintained -*;
data class2;
   set class;
   %varlist(data=class, where=#vtyp#=N, pattern=label #tmpvar#=#vlabelq##scs# #tmpvar#=left(put(#var#, best32.))#scs# drop #var##scs# rename #tmpvar# = #var##scs#
                                      , patternalt=attrib #tmpvar# length=#vtlen# label=#vlabq# #vfmtkeywd# #vinfmtkeywd# #scs# #tmpvar#=#var##scs# drop #var##scs# rename #tmpvar# = #var##scs#);
run;

*- Convert numerical variables ***without*** a format to character while applying default formats. Other variables are re-defined identically. Original order of variables is maintained -*;
data class3;
   set class;
   %varlist(data=class, where="#vfmt#"=" ", pattern=label #tmpvar#=#vlabelq##scs# #tmpvar#=left(put(#var#, #vfmtdef#))#scs# drop #var##scs# rename #tmpvar# = #var##scs#
                                          , patternalt=attrib #tmpvar# length=#vtlen# label=#vlabq# #vfmtkeywd# #vinfmtkeywd# #scs# #tmpvar#=#var##scs# drop #var##scs# rename #tmpvar# = #var##scs#);
run;

***- Convert all numerical variables to character while applying formats. Character variables are re-defined identically. Original order of variables is maintained -***;
data class4;
   set class;
   %varlist(data=class, where=#vtyp#=N, pattern=label #tmpvar#=#vlabelq##scs# #tmpvar#=left(put(#var#, #vfmtdef#))#scs# drop #var##scs# rename #tmpvar# = #var##scs#
                                      , patternalt=attrib #tmpvar# length=#vtlen# label=#vlabq# #vfmtkeywd# #vinfmtkeywd# #scs# #tmpvar#=#var##scs# drop #var##scs# rename #tmpvar# = #var##scs#);
run;

*- Convert all variables to character while applying formats. Original order of variables is maintained -*;
data class5;
   set class;
   %varlist(data=class, pattern=label #tmpvar#=#vlabelq##scs# #tmpvar#=left(put(#var#, #vfmtdef#))#scs# drop #var##scs# rename #tmpvar# = #var##scs#);
run;

%put done;

%put %varlist(data=class, var=dob, pattern=#var# length=#vtlen# label=#vlabq# #vfmtkeywd#);

*- Return all variables from multiple datasets, with a format not matching a pattern -*;
proc sql noprint;
   %let dslist=;
   select distinct catx('.', libname, memname) into :dslist separated by ' '
      from sashelp.vtable where libname in ('SASHELP') and memtype in ('DATA') and memname < "H";
   %put dslist=&dslist;
quit;
%put %varlist(data=&dslist,  var=#all#, where=#pct#sysfunc(prxmatch(/"((\$|\$CHAR|BEST|\d)\d*\.\d?| )"/i, "#vfmt#"))=0, pattern=#dsn#.#var#(#vfmt#), unique=N);

*- Return all variables from multiple datasets, with a format matching a pattern -*;
proc sql noprint;
   %let dslist=;
   select distinct catx('.', libname, memname) into :dslist separated by ' '
      from sashelp.vtable where libname in ('SASHELP') and (memname < "H" or memname > "T"); * and memtype in ('DATA');
   %put dslist=&dslist;
quit;
%put %varlist(data=&dslist,  var=#all#, where=#pct#sysfunc(prxmatch(/"(DDMMYY|YYMMDD|DATE|TIME|DATETIME)\d*\.\d?"/i, "#vfmt#")), pattern=#dsn#.#var#(#vfmt#), unique=N);





*- combine variable name and label as new label -*;
data sasuser.baseball;
   set sashelp.baseball;
   label %varlist(data=sashelp.baseball, pattern=#var#=#vlabnamq#);
run;

*- periodically insert an additional separator -*;
%put %varlist(data=sashelp.baseball, period=2, persep=%str(= ));
%put %varlist(data=sashelp.baseball, period=2, phase=1, persep=%str(= ));
%put %varlist(data=sashelp.baseball, period=2, phase=-1, persep=%str(= ));
%put %varlist(data=sashelp.baseball, sep=%str(    ), period=4, persep=#scs#%nrstr(%put ));
%put %varlist(data=sashelp.baseball, sep=%str(    ), period=4, phase=1, persep=#scs#%nrstr(%put ));
%put %varlist(data=sashelp.baseball, sep=%str(    ), period=4, phase=-1, persep=#scs#%nrstr(%put ));


%put %varlist(var=TRT01P TRT01PN TRT01A TRT01AN TRT02P TRT02PN TRT02A TRT02AN TR01SDT TR01EDT TR02SDT TR02EDT
             ,prefix=TRT0 TR0, pattern=#var#=#pre#_#bvar#_#suf#
             ,suffix=/[PA]N?/ SDT EDT);

%put %varlist(data=sashelp.baseball, prefix=cr, pattern=#var#=#pre#_#bvar#, where=(#pre#^=));
%put %varlist(data=sashelp.baseball, prefix=cr, pattern=#var#=career_#bvar#, where=(#pre#^=));
%put %varlist(data=sashelp.baseball, prefix=cr n, pattern=#var#=#pre#_#bvar#, patternalt=#var#, where=(#pre#^=));

%put %varlist(data=sashelp.demographics, suffix=pct, pattern=#var#=#pre#_#bvar#_#suf#);
%put %varlist(data=sashelp.demographics, suffix=pct, pattern=#var#=#pre#_#bvar#_percent, patternalt=#var#, where=(#suf#^=));
%put %varlist(data=sashelp.demographics, prefix=male female, suffix=pct, pattern=#var#=#pre#_#bvar#_percent, where=(#suf#^=));
%put %varlist(data=sashelp.demographics, suffix=pct, pattern=#var#=#pre#_#bvar#_percent, where=(#pct#lowcase(#suf#)=pct));
%put %varlist(data=sashelp.demographics, suffix=pct, pattern=#var#=#pre#_#bvar#_percent, where=(#suf#=pct));
%put %varlist(data=sashelp.demographics, suffix=pct, pattern=#var#=#pre#_#bvar#_percent, where=(#suf#=PCT));

data v;
   v = "%varlist(data=sashelp.class)";
   put v=;
   stop;
run;

data ae; studyid="xx"; usubjid="xx-xxx-xxxx"; aeterm="PNEMONIA"; aedecod="PNEMONIA"; AESER="Y"; AESTDTC="2010-02-01"; AEENDTC="2010-02-03"; AEOUT="FATAL"; run;
data cm; studyid="xx"; usubjid="xx-xxx-xxxx"; cmterm="PENICILLIN"; cmdecod="PENICILLIN"; CMROUT="iv"; CMSTDTC="2010-01-02"; CMENDTC="2010-02-01"; CMFRQ="Q6H"; run;
%put %varlist(data=ae cm, prefix=#ds#, pattern=#var#=#pre#_#bvar#, where=(#pre#^=));
%put %varlist(data=ae cm, prefix=/../, pattern=#var#=#pre#_#bvar#, where=(#pre#^=));

data aecm;
   set ae cm;
   %varlist(data=ae cm, prefix=#ds#, suffix=dtc, pattern=if cmiss(#var#)=0 then #bvar#dt=input(#var#, b8601DA.)#scs# format #bvar#dt E8601DA.#scs#, where=(#suf#^=));
run;

%put %varlist(data=ae cm, suffix=/../, pattern=#var#=#bvar#_#suf#, where=(#suf#^=));
%put %varlist(data=ae cm, prefix=#ds#, pattern=#bvar# #vtmxlen#, where=(#pre#^=));

data class;
   set sashelp.class;
   output;
   %varlist(data=sashelp.class, var=#not# name, pattern=#var#=#vtnull##scs#);
   output;
run;

%*- print wrapped, indented list of variables aligned in columns -*;
%put %varlist(var=STUDYID  USUBJID  ENRLFL   RANDFL   SAFFL    SRENRLFL MSFL     FASFL  PPROTFL  TRT01P   TRT01PN  TRT02P   TRT02PN  TRTSDT   TRTSDTM  TRTEDT  TRTEDTM  TR01SDT  TR01SDTM TR01EDT
                  TR01EDTM TR02SDT  TR02SDTM TR02EDT  TR02EDTM FVISDT   LVISDT   COMPSFL  CMPS01FL CMPW24FL PGADABFL TSPBFL  BASFIBFL BASDABFL SITESUBJ RCSSUBJ  BLGARW   REGION1  REGION1N PTNFEXFL
                  PTNFEXFN
             ,pretext=%str(WAR)NING: Variables compared (in ADSL):#put#
             ,sep=#cs#
             ,persep=#put#
             ,period=8
             ,pad=8
             );

@endcode

**/

/*
%let mcompilenote=%sysfunc(getoption(mcompilenote, keyword));
option mcompilenote=all;
*/
%macro varlist(data=#default#  /*- space-separated list of datasets (optionally with keywords corresponding to set operators) for variables lookup -*/
              ,var=#default#   /*- space-separated input list of variables (or by extension alternative text including special characters) -*/
              ,prefix=         /*- space separated list of variable name fragments or RegExp to be identified as prefix when matching a variable name -*/
              ,suffix=         /*- space separated list of variable name fragments or RegExp to be identified as suffix when matching a variable name -*/
              ,pattern=#var#   /*- string to be output for each variable in the input list
                                   (that is found in the set of datasets specified by DATA= parameter, if any),
                                   after replacement of embedded #keywords# by variable attributes or other special values -*/
              ,PATTERNALT=     /*- string to be output for each "variable" (or alternative item) in the input list
                                   (that is NOT found in the set of datasets specified by DATA= parameter, if any
                                    or that does not correspond to a valid SAS V7 name),
                                   after replacement of embedded #keywords# by corresponding values
                                   (#keywords corresponding to variable attributes will resolve to empty strings) -*/
              ,sep=%str( )     /*- separator to insert between the output strings coreesponding to successive variables -*/
              ,lsep=#sep#      /*- different separator to be inserted instead of the normal separator, before the last output string -*/
              ,ALTSEP=#sep#    /*- alternative separator to be inserted in front of / between / after varibles not found or or alternative items
                                   according to ALTSEPpos= parameter -*/
              ,ALTSEPpos=NNN   /*- specifies whether or not to insert the alternative separator in front of / between / after varibles not found
                                   or or alternative items -*/
              ,PERsep=         /*- additional separator to be inserted periodically (after the regular sep=, lsep= or altsep= separator)
                                   each time the number of variables or alternative items processed is a multiple of the
                                   value specified by parameter PERIOD= (if > 0) -*/
              ,period=0        /*- specifies the number of variables or alternative items after which the periodic separator
                                   (parameter PERsep=) will be inserted (if > 0) -*/
              ,phase=0         /*- number by which to shift the periodicity of PERsep -*/
              ,pad=0           /*- if length of "variable" or alternative item is < PAD, trailing spaces are added to reach that length -*/
              ,unique=Y        /*- if Y, prevents repeated occurrences of "variables" or alternative items to appear in the output -*/
              ,order=data      /*- specifies the order in which "variables" or alternative items will appear in the output -*/
              ,pretext=        /*- text inserted once in front of the complete output list, if that output list is not empty -*/
              ,posttext=       /*- text inserted once at the end of the complete output list, if that output list is not empty -*/
              ,from=
              ,where=1         /*- condition to be evaluated for each variable (after replacing embedded #keywords# by their value)
                                   to determine whether the variable will be included in the output list or not -*/
              ,nvar=           /*- if specified, indicates the maximum number of variables or alternative items to be included
                                   in the output list in case FIRSTVAR= parameter value is <= 1 -*/
              ,firstvar=1      /*- if > 1, indicates the number of the first variable or alternative item to be included
                                   in the output list -*/
              ,unquote=Y       /*- specifies whether the assembled output string should be returned macro-quoted, or after
                                   final un-quoting (which includes the resolution of embedded macro-code if any,
                                   and may be necessary for the output string to be recognized as valid SAS code) -*/
              ,edit=N          /*- specifies whether the user should be presented with the values of all parameters
                                   in order to review/edit them before proceding to the processingof these parameters -*/
              ,defnumfmt=Best12. /*- Default format for numeric variables -*/
              ,always=         /*- if set to Y, pretext= and posttext= text is returned even if the output list of variables is empty -*/
              ,return=         /*- if not empty, the specified text will be returned instead of the pretext value, variables list and posttext
                                   value, after resolving special keywords (e.g. #s#, #c#, #sc#, #lpar#, #rpar#, #pct#, #data#, #n#)
                                   where #n# indicates the number of variables that would have been returned -*/
              ,into=           /*- (optional) specifies a macro-variable name and the text value to set it to after resolving special keywords
                                   The parameter value is specified as INTO= NAME TEXT_VALUE -*/
              )
              ;
   %local i j k l len p r r0 varlist_o varlist varlist2 dslist ds_i var_i var luvar type ds dsid nvars prx prx2 prx3 prx_put _n_ confirm
          num char all lookupvars lookupvars2 selectvars oper dsoper alldsvars dsvar dsvarlist dsvarlist2
          patternin patternout dsn dsa refvarattr refauto sepout refisnull ALTpatternout
          vnum vlen vtlen vtyp vtnull vfmt vinfmt vlab vlabq vlenlabfmt vmxlenlabfmt vtlenlabfmt vtmxlenlabfmt vlenlabsrcfmt vtlenlabsrcfmt vfmtdef vfmtdefq vinfmtdef vfmtkeywd vinfmtkeywd
          vvalcatsq vvalcattq vvalcatq vlabsrc vlabsrcq vlabnam vlabnamq

          dsnl dsal autocoal autocoalsrc autoeq item root _suffix_ step first last
          join_type prev_datasets tmpvar tmpvars_list reftmpvar
          putattrib vnam_pos vtlen_pos vlab_pos vfmt_pos vinfmt_pos
          wheval isnull isfound isvalid isprvfound isprvvalid islast lsep foundlist
          lookupvarsNF dsselectvarsNF selectvarsNF  w_selectvars w_dsselectvars dsselectvars
          get_mx_len num_ds oneds_i oneds onedsid onevarnum vmxlen vtmxlen
          NFbefore NFafter NFbetween
          force_exit iter periodic_sep
          pre suf bvar bvar1 refpresufbvar patt
          squot prx
          pretext_spec poststext_spec
          macvar_into
          ;
   %if %symexist(debug)=0 %then %local debug;

   %*- store initial parameters values -*;
   %let pretext_spec=&pretext;
   %let posttext_spec=&posttext;

      %*- special characters -*;
   %local sp squot dquot pct amper lpar rpar comma slash sc;
   %let sp=%qsysfunc(byte(32));
   %let dquot=%qsysfunc(byte(34));
   %let pct=%qsysfunc(byte(37));
   %let amper=%qsysfunc(byte(38));
   %let squot=%qsysfunc(byte(39));
   %let lpar=%qsysfunc(byte(40));
   %let rpar=%qsysfunc(byte(41));
   %let comma=%qsysfunc(byte(44));
   %let slash=%qsysfunc(byte(47));
   %let sc=%qsysfunc(byte(59));

   %if %length(%superq(into))>0 %then %do;
      %let macvar_into = %qscan(%superq(into), 1, %str( ));
      %if %sysfunc(prxmatch(%bquote(/^[A-Za-z_]\w{0,31}$/), %superq(macvar_into))) = 0 %then %do;
         %put %str(WAR)NING:(&sysmacroname): Ignoring invalid parameter INTO=%superq(into).;
         %let into = ;
         %let macvar_into = ;
      %end; %else %do;
         %if %symexist(&macvar_into) = 0 %then %do;
            %global &macvar_into;
         %end;
      %end;
   %end;

  %if %qupcase(%superq(edit))^=%quote(N) %then %do;  /*- Let the user review, edit and confirm the values of the specified parameters -*/
     %if (%upcase(&debug)=Y) %then %put (&sysmacroname): SYSMENV=&SYSMENV (S=macro invoked as part of a SAS program, D=macro invoked from the command line of a SAS window).;
     %if &sysmenv=S %then %do;
       %let confirm=data var prefix suffix pattern PATTERNALT sep lsep ALTSEP ALTSEPpos unique order pretext posttext from where nvar firstvar unquote;
         %if (%upcase(&debug)=Y) %then %do;
            %put (&sysmacroname): CONFIRM: Letting the user %bquote(Review,) Edit and Confirm the values of PARAMETERs: &confirm..;
       %end;
         %LET _message_ =%bquote(Review,) Edit and Confirm the values of %upcase(&sysmacroname) Parameters:;
         %LET _i_ = 1; %LET _wparm_=/; %LET _dummy_=;
         %DO %WHILE( %LENGTH(%SCAN(&confirm, &_i_ ))>0);
           %LET _varnam_ = %SCAN(&confirm, &_i_ );
           %LET _varlen_ =%LENGTH(&&_varnam_);
           %IF &_varlen_ <150 %THEN %LET _varlen_ = 150;
           %LET _wparm_ = &_wparm_ / @2 "&_varnam_" COLOR=blue @20 &_varnam_ &_varlen_ ;
           %LET _i_ = %EVAL( &_i_ + 1);
         %END;
         %LET _nvar_ = %EVAL (&_i_ - 1);
          %WINDOW Confirm color=gray columns=180
              #1 @ 15 "&_message_" COLOR=blue PROTECT=YES
              / @ 14 "%SYSFUNC(REPEAT(*,%EVAL(%LENGTH(&_message_) + 1)))" COLOR=blue
              &_wparm_
              / @1 _dummy_ 20 PROTECT=YES
              // @15 "Click or use [Tab] to move between fields.  [Pg Down] when done." COLOR=blue
              ;
          %DISPLAY Confirm BELL;
     %end; %else %do;
         %if (%upcase(&debug)=Y) %then %put (&sysmacroname): EDIT: As macro was invoked from the command line of a SAS window it is not possible
to let the user Review, Edit and Confirm the values of PARAMETERs: &confirm..;
     %end;
  %end;



   %if %length(%superq(nvar))=0 %then %let nvar=.;
   %if %length(%superq(firstvar))=0 %then %let firstvar=1;

   %if %sysevalf(%superq(period) <= 0) or %sysevalf(%superq(period) > 999999) %then %let period=0;
   %if %sysevalf(%superq(phase) <= -999999) or %sysevalf(%superq(phase) > 999999) %then %let phase=0;

   %*- Determine whether to insert a separator before, between, after variables that are not found in specified dataset(s) or invalid names if no dataset is specified -*;
   %let NFbefore = %qupcase(%qsubstr(%superq(ALTSEPpos)N, 1, 1));
   %let NFafter  = %qupcase(%qsubstr(N%superq(ALTSEPpos), %eval(%length(%superq(ALTSEPpos))+1), 1));
   %if %length(%superq(ALTSEPpos))=3
       %then %let NFbetween = %qupcase(%qsubstr(%superq(ALTSEPpos), 2, 1));
   %else %if (&NFbefore = &NFafter)
       %then %let NFbetween = &NFbefore;
       %else %let NFbetween = N;
   %if (%upcase(&debug)=Y) %then %put ALTSEPpos=&ALTSEPpos --> NFbefore=&NFbefore NFafter=&NFafter NFbetween=&NFbetween;
   /*
   %let i=%index(%upcase(&data), #DEFAULT#);
   %let l=%length(&data);
   %if (%upcase(&debug)=Y) %then %put i=&i l=&l;
   %if (&i = 1) %then %let data=&syslast %substr(&data%str(  ), 10);
   %else %if &i >1 %then %let data=%substr(&data%str(  ), 1, %eval(&i-1))%str(&syslast)%substr(&data%str(  ), %eval(&i+10));
   */
   %*- If &VAR starts with keyword #not# we consider it as equivalent to #all# #not# -*;
   %if %qsysfunc(lowcase(%qscan(&var, 1, %str( ))))=%quote(#not#)     /*- jbodart 2018-01-30 - changed %scan to %qscan to avoid message lowcase has too few arguments when &var is empty -*/
    or %qsysfunc(lowcase(%qscan(&var, 1, %str( ))))=%quote(#except#)  /*- jbodart 2018-01-30 - changed %scan to %qscan to avoid message lowcase has too few arguments when &var is empty -*/
      %then %let var=#all# &var;
      %if (%upcase(&debug)=Y) %then %put VAR considered as: &var;

   %let dslist=&data;   %*- store contents of DATA parameter -*;
   %let varlist_o=&var; %*- store contents of VAR parameter -*;

   %*- Initialize list of variables to be returned -*;
   %let varlist=;
   %let alldsvars=;
   %let dsvarlist=;
   %let tmpvars_list=;

   %let vnam_pos=6;
   %let vtlen_pos=0;
   %let vlab_pos=0;
   %let vfmt_pos=0;
   %let vinfmt_pos=0;
   %let _n_=0;

   %*- Convert keywords to lowercase in parameters PATTERN, PATTERNALT, WHERE and SEP -*;
      %let prx=%sysfunc(prxparse(s/(#\S+#)/\L$1/i));
      %if (%upcase(&debug)=Y) %then %put Original PATTERN: &pattern;
      %let pattern=%qsysfunc(prxchange(&prx, -1, &pattern));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter PATTERN: &pattern;
      %if (%upcase(&debug)=Y) %then %put Original PATTERNALT: &PATTERNALT;
      %let PATTERNALT=%qsysfunc(prxchange(&prx, -1, &PATTERNALT));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter PATTERNALT: &PATTERNALT;
      %if (%upcase(&debug)=Y) %then %put Original WHERE: &where;
      %let where=%qsysfunc(prxchange(&prx, -1, &where));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter WHERE: &where;
      %if (%upcase(&debug)=Y) %then %put Original SEP: &sep;
      %let sep=%qsysfunc(prxchange(&prx, -1, &sep));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter SEP: &sep;

      %if (%upcase(&debug)=Y) %then %put Original PRETEXT: &PRETEXT;
      %let PRETEXT=%qsysfunc(prxchange(&prx, -1, &PRETEXT));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter PRETEXT: &PRETEXT;

      %if (%upcase(&debug)=Y) %then %put Original POSTTEXT: &POSTTEXT;
      %let POSTTEXT=%qsysfunc(prxchange(&prx, -1, &POSTTEXT));
      %if (%upcase(&debug)=Y) %then %put Keywords converted to lowercase in parameter POSTTEXT: &POSTTEXT;

      %syscall prxfree(prx);

%IF   (%qupcase(&pattern)=#AUTOFULLEQ#)
   or (%qupcase(&pattern)=#AUTOLEFTEQ#)
   or (%qupcase(&pattern)=#AUTORIGHTEQ#)
   or (%qupcase(&pattern)=#AUTOINNEREQ#)
%THEN %DO;
   %*- Specific processing of PATTERNs: #autoFULLEQ#, #autoLEFTEQ#, #autoRIGHTEQ#, #autoINNEREQ# -*;
   %let join_type=%sysfunc(tranwrd(%sysfunc(tranwrd(%qupcase(&pattern), #AUTO, %str( ))), EQ#, %str( )));
   %if (%upcase(&debug)=Y) %then %put join_type=&join_type;

   %let i=1;
   %let prev_datasets=;
   %do %while(%qscan(&data, &i, %str( ))^=);
      %let dsn=%qscan(&data, &i, %str( ));
      %if (%index(&dsn, #) EQ 0) %then %do;
         %if (&i>1) %then %do;
           %let varlist=&varlist &join_type JOIN;
         %end;
           %let varlist=&varlist %sysfunc(tranwrd(&dsn, :, %str( as )));
         %if (&i>1) %then %do;
           %let varlist2=%VARLIST(data=&prev_datasets #INTERSECT# &dsn, var=&varlist_o, sep=#and#, pattern=#autoEQ#);
           %if %length(&varlist2)>0 %then %do;
              %let varlist=&varlist ON &varlist2;
           %end; %else %do;
              %let varlist=&varlist ON (1 EQ 1);  %*- No variables in common, so try the equivalent of a Cartesian Product or CROSS JOIN -*;
           %end;
         %end;
         %let prev_datasets=&prev_datasets &dsn;
      %end;
      %let i=%eval(&i+1);
      %if (%upcase(&debug)=Y) %then %do;
         %put ## SPECIFIC PROCESSING STEP &i, dsn=&dsn ##;
         %put varlist=&varlist;
      %end;
   %end;


%END; %ELSE %DO;
   %*- General processing of all other cases -*;

   %if (%qupcase(&data)=%quote(#DEFAULT#)) %then %do;
      %*- Use dataset &syslast if VAR parameter contains #default#, #all#, #num#, #char#, #<i>#, #<i>-<j># or /<pattern>/ -*;
      %*let prx=%sysfunc(prxparse(/\s(#default#|#all#|#num#|#char#|\w+:|#\d+#|#\d+-\d+#|\/.*\/)\s/i));
      %let prx=%sysfunc(prxparse(/\s(#default#|#all#|#num#|#char#|\w+--?[A-Z_]\w+|\w+:\w*|\w*:\w+|#\d+#|#\d+-\d+#|\/.*\/)\s/i));
      %if %sysfunc(prxmatch(&prx, %str( )%superq(var)%str( ))) %then %let dslist=&syslast;
      %syscall prxfree(prx);
   %end;
   %if (%upcase(&debug)=Y) %then %put %str(Not)ice: (&sysmacroname): DATA evaluated as: &dslist. .;

   %*- loop across datasets -*;
   %let dsoper = #union#;
   %let ds_i=1;
   %do %while(%length(%qscan(&dslist, &ds_i, %str( )))>0);
      %let ds=%qscan(&dslist, &ds_i, %str( ));
      %if (%qsubstr(&ds.#, 1, 1)=%quote(#)) and (%qupcase(&ds)^=%quote(#DEFAULT#)) %then %do;
         %*- Not a dataset but a dataset operator -*;
         %let dsoper=&ds;
         %if (%upcase(&debug)=Y) %then %put :: found dsoper = &dsoper ::;
      %end; %else %do;
         %if (%upcase(&debug)=Y) %then %put :: found ds = &ds ::;

         %*- Retrieve all, num and char variables in dataset -*;
         %LET all=;
         %LET num=;
         %LET char=;
         %let dsid=0;
         %let nvars=0;
         %if (%qupcase(&ds)^=%quote(#DEFAULT#)) %then %let dsid=%sysfunc(open(%qscan(&ds, 1, :))); %* open current dataset (for read) *;
         %IF &dsid %THEN %DO; %* dataset opened successfully *;
               %LET nvars=%SYSFUNC(attrn(&dsid, nvars));  %* number of variables in current dataset *;
               %DO var_i=1 %TO &nvars; %* loop across all variables in current dataset *;
                  %LET var=%SYSFUNC(varname(&dsid, &var_i));
                  %LET type=%SYSFUNC(vartype(&dsid, &var_i));
                  %LET all=&all &var;                                    %* all variables in current dataset *;
                  %IF       &type = C %THEN %LET char=&char &var;        %* character variables in current dataset *;
                  %ELSE %IF &type = N %THEN %LET num=&num &var;          %* numerical variables in current dataset *;
                  %ELSE %PUT Unknown variable type: ds=&ds var=&var type=&type;
               %END;
               %LET rc=%sysfunc(close(&dsid));
         %END;
         %IF (&dsid>0) or (%qupcase(&ds)=%quote(#DEFAULT#)) %THEN %DO;

               %let lookupvars = &varlist_o;

               %*- resolve patterns /<..>/ in list of variables to look up -*;
               %let i=1;
               %let lookupvars2=;
               %let prx=%sysfunc(prxparse(/^\/.*\/i?$/i));
               %do %while(%length(%qscan(&lookupvars, &i, %str( )))>0);
                   %let luvar=%qscan(&lookupvars, &i, %str( ));
                   %if %sysfunc(prxmatch(&prx, &luvar)) %then %do;
                       %let prx2=%sysfunc(prxparse(&luvar.i)); /*- JMB 06MAR2017: perform case-insensitive pattern matching -*/
                       %if (%upcase(&debug)=Y) %then %put Identified pattern: &luvar -> prx2=&prx2;
                       %*- &luvar identified as a pattern -> look for matching variables in dataset -*;
                       %let matchvars=;
                       %let var_i=1;
                       %do %while(%length(%qscan(&all, &var_i, %str( )))>0);
                          %LET var=%qscan(&all, &var_i, %str( ));
                          %if %sysfunc(prxmatch(&prx2, %superq(var))) %then %let matchvars=&matchvars &var;
                          %let var_i=%eval(&var_i+1); %*- loop to next item in list &all -*;
                       %end;
                       %syscall prxfree(prx2);
                       %if (%upcase(&debug)=Y) and (%length(&matchvars)=0) %then %put Identified pattern: &luvar has no match among &var_i variables in &ds..;
                       %if (%upcase(&debug)=Y) and (%length(&matchvars)>0) %then %put Identified pattern: &luvar has following matches among &var_i variables in &ds.: &matchvars..;
                       %let lookupvars2=&lookupvars2 &matchvars;
                   %end; %else %do;
                       %let lookupvars2=&lookupvars2 &luvar;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %syscall prxfree(prx);
               %*- replace with updated lookup variables list -*;
               %let lookupvars=&lookupvars2;
               %let lookupvars2=;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After resolving patterns /<..>/, lookup variables list = &lookupvars;
               %end;

               %*- resolve <root>: in list of variables to look up -*;
               %*- resolve :<suffix> in list of variables to look up -*;
               %*- resolve <root>:<suffix> in list of variables to look up -*;
               %let i=1;
               %let lookupvars2=;
               %let prx=%sysfunc(prxparse(/^(\w+:\w*|\w*:\w+)$/));
               %do %while(%length(%qscan(&lookupvars, &i, %str( )))>0);
                  %let luvar=%qscan(&lookupvars, &i, %str( ));
                   %if %sysfunc(prxmatch(&prx, &luvar)) %then %do;
                       %let root=%qscan(%str( )&luvar%str( ), 1, %quote(:));
                       %let _suffix_=%qscan(%str( )&luvar%str( ), 2, %quote(:));
                       %let matchvars=;
                       %let var_i=1;
                       %do %while(%length(%qscan(&all, &var_i, %str( )))>0);
                          %LET var=%qscan(&all, &var_i, %str( ));
                          %if (%sysfunc(index(%str( )%upcase(&var), %qupcase(&root)))=1)
                          and (%sysfunc(index(%str( )%upcase(&var)%str( ), %qupcase(&_suffix_)))>=1)
                             %then %let matchvars=&matchvars &var;
                          %let var_i=%eval(&var_i+1); %*- loop to next item in list &all -*;
                       %end;
                       %if (%upcase(&debug)=Y) and (%length(&matchvars)=0) %then %put Resolved &luvar (root=&root suffix=&_suffix_) as &matchvars in dataset &ds..;
                       %let lookupvars2=&lookupvars2 &matchvars;
                   %end; %else %do;
                       %let lookupvars2=&lookupvars2 &luvar;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %syscall prxfree(prx);
               %*- replace with updated lookup variables list -*;
               %let lookupvars=&lookupvars2;
               %let lookupvars2=;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After resolving <root>:, :<suffix> and <root>:<suffix>, lookup variables list = &lookupvars;
               %end;

               %*- resolve <varX>-<varY> in list of variables to look up -*;
               %let i=1;
               %let lookupvars2=;
               %let prx=%sysfunc(prxparse(/^[A-Z_]\w*-[A-Z_]\w*$/i));
               %do %while(%length(%qscan(&lookupvars, &i, %str( )))>0);
                   %let luvar=%qscan(&lookupvars, &i, %str( ));
                   %if (%upcase(&debug)=Y) %then %put Looking for pattern <varX>-<varY> in ->&luvar<- ( prx=&prx);
                   %if %sysfunc(prxmatch(&prx, &luvar)) %then %do;
                       %if (%upcase(&debug)=Y) %then %put Identified <varX>-<varY> : &luvar;
                       %let first=%qupcase(%qscan(&luvar, 1, %quote(-)));
                       %let last=%qupcase(%qscan(&luvar, 2, %quote(-)));
                       %if (&first > &last) %then %do;
                          %let first=%qupcase(%qscan(&luvar, 2, %quote(-)));
                          %let last=%qupcase(%qscan(&luvar, 1, %quote(-)));
                       %end;
                       %let matchvars=;
                       %let var_i=1;
                       %do %while(%length(%qscan(&all, &var_i, %str( )))>0);
                          %LET var=%qscan(&all, &var_i, %str( ));
                           %if (%upcase(&debug)=Y) %then %put Testing if var (%qupcase(&var)) is beetween first (&first) and last (&last) of the range (%qupcase(&luvar));
                          %if (&first <= %qupcase(&var))
                          and (%qupcase(&var) <= &last)
                             %then %let matchvars=&matchvars &var;
                          %let var_i=%eval(&var_i+1); %*- loop to next item in list &all -*;
                       %end;
                       %if (%upcase(&debug)=Y) and (%length(&matchvars)=0) %then %put Resolved &luvar (first=&first last=&last) as &matchvars in dataset &ds..;
                       %let lookupvars2=&lookupvars2 &matchvars;
                   %end; %else %do;
                       %let lookupvars2=&lookupvars2 &luvar;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %syscall prxfree(prx);
               %*- replace with updated lookup variables list -*;
               %let lookupvars=&lookupvars2;
               %let lookupvars2=;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After resolving <varX>-<varY>, lookup variables list = &lookupvars;
               %end;

               %*- resolve <varX>--<varY> in list of variables to look up -*;
               %let i=1;
               %let lookupvars2=;
               %let prx=%sysfunc(prxparse(/^\w+--\w+$/));
               %do %while(%length(%qscan(&lookupvars, &i, %str( )))>0);
                   %let luvar=%qscan(&lookupvars, &i, %str( ));
                   %if %sysfunc(prxmatch(&prx, &luvar)) %then %do;
                       %let first=%sysfunc(index(%str( )%qupcase(&all)%str( ), %str( )%qupcase(%qscan(&luvar, 1, %quote(-)))%str( )));
                       %let last=%sysfunc(index(%str( )%qupcase(&all)%str( ), %str( )%qupcase(%qscan(&luvar, 2, %quote(-)))%str( )));
                       %if (&first > &last) %then %do;
                          %let temp=&first;
                          %let first=&last;
                          %let last=&temp;
                       %end;
                       %let matchvars=;
                       %let var_i=1;
                       %if (&first >0) %then %do %while(%length(%qscan(&all, &var_i, %str( )))>0);
                          %LET var=%qscan(&all, &var_i, %str( ));
                          %let p = %sysfunc(index(%str( )%qupcase(&all)%str( ), %str( )%qupcase(&var)%str( )));
                          %if (&first <= &p) and (&p <= &last)
                             %then %let matchvars=&matchvars &var;
                          %let var_i=%eval(&var_i+1); %*- loop to next item in list &all -*;
                       %end;
                       %if (%upcase(&debug)=Y) and (%length(&matchvars)=0) %then %put Resolved &luvar (first=&first last=&last) as &matchvars in dataset &ds..;
                       %let lookupvars2=&lookupvars2 &matchvars;
                   %end; %else %do;
                       %let lookupvars2=&lookupvars2 &luvar;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %syscall prxfree(prx);
               %*- replace with updated lookup variables list -*;
               %let lookupvars=&lookupvars2;
               %let lookupvars2=;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After resolving <varX>--<varY>, lookup variables list = &lookupvars;
               %end;

               %*- resolve remaining special names in list of variables to look up -*;
               %if (%qupcase(&varlist_o)=%quote(#DEFAULT#)) %then %let lookupvars=&all;

               %*- resolve #<i># and #<i>-<j># -*;
               %let prx=%sysfunc(prxparse(/\#(\d+|\d+-\d+)\#/i));
               %do %while(%sysfunc(prxmatch(&prx, %superq(lookupvars))) >0);
                   %let p=%sysfunc(prxmatch(&prx, %superq(lookupvars)));
                   %let item=%qscan(%qsubstr(%superq(lookupvars), &p), 1, %str( ));
                   %let lookupvars2=;
                   %let i=%qscan(&item, 1, %bquote(-#));
                   %let j=%qscan(&item, -1, %bquote(-#));
                   %if (%upcase(&debug)=Y) %then %put Resolving &item as variables numbered from &i to &j;
                   %if (&i <= &j)
                       %then %let step=1;
                       %else %let step=-1;
                   %do k = &i %to &j %by &step;
                      %let lookupvars2=&lookupvars2 %qscan(&all, &k, %str( ));
                   %end;
                   %if (&p>1)
                       %then %let lookupvars=%qsubstr(%superq(lookupvars), 1, %eval(&p-1))%qsysfunc(tranwrd(|%qsubstr(%superq(lookupvars), &p), |&item, &lookupvars2));
                       %else %let lookupvars=%qsysfunc(tranwrd(|&lookupvars, |&item, &lookupvars2));
                  %if (%upcase(&debug)=Y) %then %do;
                     %put After resolving &item., lookup variables list = &lookupvars;
                  %end;
               %end;
               %syscall prxfree(prx);
               %*- resolve <var><i>-<j> -*;
               %let prx=%sysfunc(prxparse(/\w*\D\d+-\d+/));
               %let prx2=%sysfunc(prxparse(s/\w*\D(\d+-\d+)/\1/));
               %let prx3=%sysfunc(prxparse(s/(\w*\D)\d+-\d+/\1/));
               %do %while(%sysfunc(prxmatch(&prx, %superq(lookupvars))) >0);
                   %let p=%sysfunc(prxmatch(&prx, %superq(lookupvars)));
                   %let item=%qscan(%qsubstr(%superq(lookupvars), &p), 1, %str( ));
                   %let root=%qsysfunc(prxchange(&prx3, -1, &item));
                   %let _suffix_=%qsysfunc(prxchange(&prx2, -1, &item));
                   %let lookupvars2=;
                   %let i=%qscan(&_suffix_, 1, %bquote(-));
                   %let j=%qscan(&_suffix_, 2, %bquote(-));
                   %let l=%length(&i);
                   %if (%length(&j) > &l) %then %let l=%length(&j);
                   %if (%length(&i) > 1) and (%substr(&i, 1, 1)=0) or (%length(&j) > 1) and (%substr(&j, 1, 1)=0) %then %do;
                       %let fmt=Z&l..;
                       %if (%upcase(&debug)=Y) %then %put item=&item root=&root suffix=&_suffix_ i=&i j=&j fmt=&fmt;
                       %if (%upcase(&debug)=Y) %then %put Resolving &item as variables numbered from &root.%sysfunc(putn(&i., &fmt.)) to &root.%sysfunc(putn(&j., &fmt.));
                       %if (&i <= &j)
                           %then %let step=1;
                           %else %let step=-1;
                       %do k = &i %to &j %by &step;
                          %let lookupvars2=&lookupvars2 &root.%sysfunc(putn(&k., &fmt.));
                       %end;
                   %end; %else %do;
                       %if (%upcase(&debug)=Y) %then %put item=&item root=&root suffix=&_suffix_ i=&i j=&j;
                       %if (%upcase(&debug)=Y) %then %put Resolving &item as variables numbered from &root.&i to &root.&j;
                       %if (&i <= &j)
                           %then %let step=1;
                           %else %let step=-1;
                      %do k = &i %to &j %by &step;
                          %let lookupvars2=&lookupvars2 &root.&k.;
                       %end;
                   %end;
                   %if (%upcase(&debug)=Y) %then %put lookupvars2=&lookupvars2;
                   %if (&p>1)
                       %then %let lookupvars=%qsubstr(%superq(lookupvars), 1, %eval(&p-1))%qsysfunc(tranwrd(|%qsubstr(%superq(lookupvars), &p), |&item, &lookupvars2));
                       %else %let lookupvars=%qsysfunc(tranwrd(|&lookupvars, |&item, &lookupvars2));
                  %if (%upcase(&debug)=Y) %then %do;
                     %put After resolving &item., lookup variables list = &lookupvars;
                  %end;
               %end;
               %syscall prxfree(prx);
               %syscall prxfree(prx2);
               %syscall prxfree(prx3);

               %let lookupvars = %qsysfunc(tranwrd(&lookupvars, #all#, &all));
               %let lookupvars = %qsysfunc(tranwrd(&lookupvars, #num#, &num));
               %let lookupvars = %qsysfunc(tranwrd(&lookupvars, #char#, &char));
               %if (%upcase(&debug)=Y) %then %do;
                  %put After resolving remaining special names, lookup variables list = &lookupvars;
               %end;

               %*- Selecting variables from list that are found in current dataset (if they exist) -*;
               %*- JMB 2018-03-04 - All variables (found or not) are stored in &lookupvarsNF -*;
               %if (%qupcase(&ds)^=%quote(#DEFAULT#)) %then %do;
                  %if (%upcase(&debug)=Y) %then %do;
                     %put Selecting variables from &ds (if they exist)...;
                  %end;
                  %let lookupvars2=;
                  %let lookupvarsNF=;
                  %let i=1;
                  %do %while(%length(%qscan(&lookupvars, &i, %str( )))>0);
                      %let luvar=%qscan(&lookupvars, &i, %str( ));
                      %if (%qsubstr(&luvar, 1, 1)=%quote(#)) %then %do;
                          %let lookupvars2=&lookupvars2 &luvar;
                      %end; %else %do;
                         %let j=%index(%str( )%qupcase(&all)%str( ), %str( )%qupcase(&luvar)%str( ));
                         %let l=%length(&luvar);
                         %if (&j > 0) %then %let lookupvars2=&lookupvars2.%substr(%str( )&all%str( ), &j, %eval(&l+2));
                         %let lookupvarsNF=&lookupvarsNF. &luvar; %*- keep all vars in &lookupvarsNF even if not found -*;
                      %end;
                      %let i=%eval(&i+1);
                  %end;
                  %if (%upcase(&debug)=Y) %then %do;
                     %put Updated variables list according to presence in dataset &ds = &lookupvars2;
                  %end;
                  %let lookupvars=&lookupvars2;
                  %let lookupvars2=;
               %end; %else %do;
                  %let lookupvarsNF=&lookupvars;
               %end;

               %*- Process variables found (in &lookupvars) according to variable operators -*;
               %if (%upcase(&debug)=Y) %then %put Processing variables found according to variable operators;
               %let oper=;
               %let leftvars=;
               %let rightvars=;
               %let i=1;
               %let done=0;
               %do %until(&done=1);
                   %let luvar=%qscan(&lookupvars, &i, %str( ));
                   %*if (%upcase(&debug)=Y) %then %put i=&i oper=&oper luvar=&luvar leftvars=&leftvars rightvars=&rightvars;
                   %if (%qsubstr(&luvar.#,1,1)=#) %then %do;
                       %if (%quote(&oper)=) %then %do;
                           %let oper=&luvar;
                       %end; %else %do;
                          %if (%upcase(&debug)=Y) and (%quote(&oper)^=) %then %do;
                             %put Processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                          %end;
                          %if (%quote(&oper)=) %then %do;
                               %*- end of varlist reached with no operator to process: nothing to do -*;
                           %end; %else %if (%qupcase(&oper)=%quote(#EXCEPT#)) or (%qupcase(&oper)=%quote(#NOT#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ;  %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#INTERSECT#)) or (%qupcase(&oper)=%quote(#AND#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#XOR#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars &rightvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars &rightvars, &j, %str( ));
                                  %if ( (%index(%str( )%qupcase(&leftvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                       +(%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                       eq 1)
                                       and (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#OR#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars &rightvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars &rightvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end;
                           %else %do;
                              %PUT %STR(WAR)NING: (&sysmacroname): Invalid Variables Operator: &oper.;
                           %end;
                       %end;
                   %end; %else %do;
                       %if (%quote(&oper)=) %then %do;
                          %let leftvars=&leftvars &luvar;
                       %end; %else %do;
                          %let rightvars=&rightvars &luvar;
                       %end;
                   %end;
                   %if (%length(%qscan(&lookupvars, &i, %str( )))=0) %then %let done=1;
                   %let i=%eval(&i+1);
               %end;
               %let lookupvars2=&leftvars;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After processing variable operators, lookup variables list = &lookupvars2;
                  %put %str(  )leftvars=&leftvars;
                  %put %str(  )rightvars=&rightvars;
               %end;

               %*- Process variables FOUND OR NOT (in &lookupvarsNF) according to variable operators -*;
               %if (%upcase(&debug)=Y) %then %put Processing variables FOUND OR NOT according to variable operators;
               %if (%upcase(&debug)=Y) %then %put lookupvarsNF=>%superq(lookupvarsNF)<;
               %let oper=;
               %let leftvars=;
               %let rightvars=;
               %let i=1;
               %let done=0;
               %do %until(&done=1);
                   %let luvar=%qscan(&lookupvarsNF, &i, %str( ));
                   %*if (%upcase(&debug)=Y) %then %put i=&i oper=&oper luvar=&luvar leftvars=&leftvars rightvars=&rightvars;
                   %if (%qsubstr(&luvar.#,1,1)=#) %then %do;
                       %if (%quote(&oper)=) %then %do;
                           %let oper=&luvar;
                       %end; %else %do;
                          %if (%upcase(&debug)=Y) and (%quote(&oper)^=) %then %do;
                             %put Processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                          %end;
                          %if (%quote(&oper)=) %then %do;
                               %*- end of varlist reached with no operator to process: nothing to do -*;
                           %end; %else %if (%qupcase(&oper)=%quote(#EXCEPT#)) or (%qupcase(&oper)=%quote(#NOT#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ;  %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#INTERSECT#)) or (%qupcase(&oper)=%quote(#AND#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#XOR#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars &rightvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars &rightvars, &j, %str( ));
                                  %if ( (%index(%str( )%qupcase(&leftvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                       +(%index(%str( )%qupcase(&rightvars)%str( ), %str( )%qupcase(&luvar)%str( )) > 0)
                                       eq 1)
                                       and (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end; %else %if (%qupcase(&oper)=%quote(#OR#)) %then %do;
                              %let selectvars=;
                              %let j=1;
                              %do %while(%length(%qscan(&leftvars &rightvars, &j, %str( )))>0);
                                  %let luvar=%qscan(&leftvars &rightvars, &j, %str( ));
                                  %if (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&luvar)%str( )) = 0)
                                     %then %let selectvars=&selectvars &luvar;
                                  %let j=%eval(&j+1);
                              %end;
                              %let leftvars=&selectvars;
                              %let rightvars=;
                              %let selectvars=;
                              %if (%upcase(&debug)=Y) %then %do;
                                 %put Finished processing Variables Operator: &oper. ; %put %str(   ) leftvars=&leftvars; %put %str(   ) rightvars=&rightvars;
                              %end;
                              %let oper=;
                           %end;
                           %else %do;
                              %PUT %STR(WAR)NING: (&sysmacroname): Invalid Variables Operator: &oper.;
                           %end;
                       %end;
                   %end; %else %do;
                       %if (%quote(&oper)=) %then %do;
                          %let leftvars=&leftvars &luvar;
                       %end; %else %do;
                          %let rightvars=&rightvars &luvar;
                       %end;
                   %end;
                   %if (%length(%qscan(&lookupvarsNF, &i, %str( )))=0) %then %let done=1;
                   %let i=%eval(&i+1);
               %end;
               %let lookupvarsNF=&leftvars;
               %if (%upcase(&debug)=Y) %then %do;
                  %put After processing variable operators, lookup variables FOUND OR NOT list = &lookupvarsNF;
                  %put %str(  )leftvars=&leftvars;
                  %put %str(  )rightvars=&rightvars;
               %end;

               %*- Selecting variables from current dataset (if they exist) or from the VAR list (if not found in the dataset)-*;
               %if (%qupcase(&ds)=%quote(#DEFAULT#)) %then %do;
                  %*- Purely processing list of variables and operators in VAR parameter,
                      with no dataset to lookup variables
                      so dsselectvars will not have any dataset information -*;
                  %let dsselectvars=&lookupvars2;
                  %if (%upcase(&debug)=Y) %then %do;
                     %put ==>> Selected dataset.variables (no dataset to look up) = &dsselectvars;
                  %end;
               %end; %else %do;
                  %*- Store variables found in current dataset with dataset information in dsselectvars -*;
                  %let dsselectvars=;
                  %let i=1;
                  %do %while(%length(%qscan(&lookupvars2, &i, %str( )))>0);
                      %let luvar=%qscan(&lookupvars2, &i, %str( ));
                      %let dsselectvars=&dsselectvars &ds..&luvar;
                      %let i=%eval(&i+1);
                  %end;
                  %if (%upcase(&debug)=Y) %then %do;
                     %put ==>> Selected dataset.variables from &ds : dsselectvars = &dsselectvars;
                  %end;
                  %*- Store variables FOUND OR NOT in current dataset with dataset information in dsselectvarsNF -*;
                  %let dsselectvarsNF=;
                  %let i=1;
                  %do %while(%length(%qscan(&lookupvars2, &i, %str( )))>0);
                      %let luvar=%qscan(&lookupvars2, &i, %str( ));
                      %let dsselectvarsNF=&dsselectvarsNF &ds..&luvar;
                      %let i=%eval(&i+1);
                  %end;
                  %if (%upcase(&debug)=Y) %then %do;
                     %put ==>> Selected dataset.variables FOUND OR NOT from &ds : dsselectvarsNF = &dsselectvarsNF;
                  %end;
               %end;
               %let selectvars=&lookupvars2;
               %let selectvarsNF=&lookupvarsNF;

         %END; %ELSE %DO;  /* End of "%IF (&dsid>0) or (%qupcase(&ds)=%quote(#DEFAULT#)) %THEN %DO" */

              %PUT %STR(WAR)NING: (&sysmacroname): Could not open &ds: ;
              %PUT %STR(         )%SYSFUNC(sysmsg());

         %END;

         %if (%upcase(&debug)=Y) %then %put :: done processing ds = &ds ::;

         %if (%upcase(&debug)=Y) %then %put :: processing dsoper = &dsoper ::;

         %if %length(%superq(PATTERNALT)) %then %do;
             %let w_selectvars = &selectvarsNF;
             %let w_dsselectvars = &dsselectvarsNF;
             %if (%upcase(&debug)=Y) %then %do;
                %put ==>>  Using Selected Variables including NOT FOUND ones.;
                %put   --> selectvarsNF = &selectvarsNF;
                %put     ( selectvars = &selectvars );
                %put   --> dsselectvarsNF = &dsselectvarsNF;
                %put     ( dsselectvars = &dsselectvars );
             %end;
         %end; %else %do;
             %let w_selectvars = &selectvars;
             %let w_dsselectvars = &dsselectvars;
             %if (%upcase(&debug)=Y) %then %do;
                %put Empty PATTERNALT ==>>  Using Selected Variables BUT ONLY THOSE THAT WERE FOUND.;
                %put   --> selectvars = &selectvars ;
                %put   --> dsselectvars = &dsselectvars ;
             %end;
         %end;

         %if (%qupcase(&dsoper)=%quote(#OR#)) or (%qupcase(&dsoper)=%quote(#UNION#)) %then %do;
             %*- add selected variables from current dataset (from &w_selectvars) to the list of variables to be returned (&varlist), if not yet present there or &UNIQUE=N -*;
               %let i=1;
               %do %while(%length(%qscan(&w_selectvars, &i, %str( )))>0);
                   %let var=%qscan(&w_selectvars, &i, %str( ));
                   %let dsvar=%qscan(&w_dsselectvars, &i, %str( ));
                   %let isfound=0;
                   %if (    %index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&var)%str( )) > 0
                        or  %length(%superq(PATTERNALT))=0
                       )
                       %then %let isfound=1;
                   %*let ds=%qsysfunc(tranwrd(&dsvar%str( ), .&var%str( ), %str()));
                   %if (%index(%str( )%qupcase(&varlist)%str( ), %str( )%qupcase(&var)%str( )) = 0) %then %do; %*- no previous occurrence of &var -*;
                      %let varlist=&varlist &var;
                      %let dsvarlist=&dsvarlist &dsvar;
                      %let foundlist=&foundlist &isfound;
                      %*let dsvarlist=&dsvarlist &ds..&var;
                   %end; %else %do; %*- not the first occurrence of &var -*;
                      %if (%qupcase(%superq(unique))=%quote(N)) %then %do;
                          %let varlist=&varlist &var;
                          %let foundlist=&foundlist &isfound;
                          %*let dsvarlist=&dsvarlist &dsvar;
                      %end;
                      %*- keep track of all datasets containing the variable &var -*;
                      %let p=0;
                      %let dsvar=;
                      %let prx=%sysfunc(prxparse(/\S+\.&var /i));
                      %if (&prx > 0) %then %let p=%sysfunc(prxmatch(&prx, %str( )&dsvarlist%str( )));
                      %if (&p > 0) %then %let dsvar=%qscan(%qsubstr(%str( )&dsvarlist%str( ), &p), 1, %str( ));  %*- if variable was previously found, dsvar content looks like:
                                                                                                                        [libname1.]memname1.variable
                                                                                                                        or
                                                                                                                        [libname1.]memname1|[libname2.]memname2.variable
                                                                                                                   -*;
                      %if (%upcase(&debug)=Y) %then %put var=&var previously found? prx=&prx p=&p dsvar=&dsvar;
                      %if (&prx > 0) %then %syscall prxfree(prx);
                      %if (%length(&dsvar)>0) %then %do;
                          %let newdsvar=%qsysfunc(tranwrd(&dsvar%str( ), .%qscan(&dsvar, -1, .)%str( ), |&ds..%qscan(&dsvar, -1, .)));
                                                                                                                 %*- newdsvar content looks like:
                                                                                                                        [libname1.]memname1|[libname.]memname.variable
                                                                                                                        or
                                                                                                                        [libname1.]memname1|[libname2.]memname2|[libname.]memname.variable
                                                                                                                   -*;
                        /*%let dsvarlist=%qsysfunc(tranwrd(%str( )&dsvarlist%str( ), %str( )&dsvar%str( ), %str( )&newdsvar%str( )));*/
                        %if (%qupcase(%superq(unique))^=%quote(N))  %then
                           %let dsvarlist=%qsysfunc(tranwrd(%str( )&dsvarlist%str( ), %str( )&dsvar%str( ), %str( )&newdsvar%str( )));
                        /*%if (%qupcase(%superq(unique))=%quote(N)) %then %let dsvarlist=&dsvarlist &newdsvar;*/
                          %if (%qupcase(%superq(unique))=%quote(N)) %then %let dsvarlist=&dsvarlist %scan(&newdsvar, -1, |);  /*- JMB 20181205 - avoid concatenating datasets when all variables occurrences are returned -*/
                          %if (%upcase(&debug)=Y) %then %do;
                              %put newdsvar=&newdsvar;
                              %put New dsvarlist=&dsvarlist;
                          %end;
                      %end;
                   %end;
                   %let i=%eval(&i+1);
               %end;

         %end; %else %if (%qupcase(&dsoper)=%quote(#NOT#)) or (%qupcase(&dsoper)=%quote(#EXCEPT#)) %then %do;
             %*- remove selected variables from current dataset from the list of variables to be returned (from previous dataset), if present there -*;
               %let varlist2=;
               %let dsvarlist2=;
               %let foundlist2=;
               %let i=1;
               %do %while(%length(%qscan(&varlist, &i, %str( )))>0);
                   %let var=%qscan(&varlist, &i, %str( ));
                   %let dsvar=%qscan(&dsvarlist, &i, %str( ));
                   %let isfound=%qscan(&foundlist, &i, %str( ));
                             %*- dsvar content looks like:
                                    [libname.]memname.variable
                                    or
                                    [libname1.]memname1|[libname.]memname.variable
                                    or
                                    [libname1.]memname1|[libname2.]memname2|[libname.]memname.variable
                               -*;
                   %if (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&var)%str( )) = 0) %then %do;
                      %let varlist2=&varlist2 &var;
                      %let dsvarlist2=&dsvarlist2 &dsvar;
                      %let foundlist2=&foundlist2 &isfound;
                   %end; %else %if %length(%superq(PATTERNALT))>0 %then %do;
                      %let varlist2=&varlist2 &var;
                      %let dsvarlist2=&dsvarlist2 &dsvar;
                      %let foundlist2=&foundlist2 0;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %let varlist=&varlist2;
               %let varlist2=;
               %let dsvarlist=&dsvarlist2;
               %let dsvarlist2=;
               %let foundlist=&foundlist2;
               %let foundlist2=;

         %end; %else %if (%qupcase(&dsoper)=%quote(#AND#)) or (%qupcase(&dsoper)=%quote(#INTERSECT#)) %then %do;
             %*- keep variables that are both selected from current dataset and from previous dataset -*;
               %let varlist2=;
               %let dsvarlist2=;
               %let foundlist2=;
               %let i=1;
               %do %while(%length(%qscan(&varlist, &i, %str( )))>0);
                   %let var=%qscan(&varlist, &i, %str( ));
                   %let dsvar=%qscan(&dsvarlist, &i, %str( ));
                   %let isfound=%qscan(&foundlist, &i, %str( ));
                             %*- dsvar content looks like:
                                    [libname1.]memname1.variable
                                    or
                                    [libname1.]memname1|[libname2.]memname2.variable
                                    or
                                    [libname1.]memname1|[libname2.]memname2|[libname3.]memname3.variable
                               -*;
                   %if (%index(%str( )%qupcase(&w_selectvars)%str( ), %str( )%qupcase(&var)%str( )) > 0) %then %do;
                      %let varlist2=&varlist2 &var;
                      %if (%index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&var)%str( )) = 0) %then %let isfound=0;
                      %let foundlist2=&foundlist2 &isfound;
                      %let newdsvar=%qsysfunc(tranwrd(&dsvar%str( ), .%qscan(&dsvar, -1, .)%str( ), |&ds..%qscan(&dsvar, -1, .)));
                             %*- newdsvar content looks like:
                                    [libname1.]memname1|[libname.]memname.variable
                                    or
                                    [libname1.]memname1|[libname2.]memname2|[libname.]memname.variable
                                    or
                                    [libname1.]memname1|[libname2.]memname2|[libname3.]memname3|[libname.]memname.variable
                               -*;
                      %let dsvarlist2=&dsvarlist2 &newdsvar;
                      %if (%upcase(&debug)=Y) %then %do;
                          %put newdsvar=&newdsvar;
                          %put New dsvarlist2=&dsvarlist2;
                      %end;
                   %end;
                   %let i=%eval(&i+1);
               %end;
               %let varlist=&varlist2;
               %let varlist2=;
               %let dsvarlist=&dsvarlist2;
               %let dsvarlist2=;
               %let foundlist=&foundlist2;
               %let foundlist2=;

         %end; %else %if (%qupcase(&dsoper)=%quote(#XOR#)) %then %do;
             %*- keep variables that are either selected from current dataset or from previous dataset, but not from both -*;
               %let varlist2=;
               %let dsvarlist2=;
               %let foundlist2=;
               %let i=1;
               %do %while(%length(%qscan(&varlist &w_selectvars, &i, %str( )))>0);
                   %let var=%qscan(&varlist &w_selectvars, &i, %str( ));
                   %let dsvar=%qscan(&dsvarlist &w_dsselectvars, &i, %str( ));
                   %let isfound=%qscan(&foundlist, &i, %str( ));
                   %if %superq(isfound)=%quote() or %superq(isfound)=%quote(0) %then %do;
                      %if (    %index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&var)%str( )) > 0
                          )
                          %then %let isfound=1;
                   %end; %else %do;
                      %if (    %index(%str( )%qupcase(&selectvars)%str( ), %str( )%qupcase(&var)%str( )) > 0
                          )
                          %then %let isfound=0;
                   %end;

                   %if ((%index(%str( )%qupcase(&w_selectvars)%str( ), %str( )%qupcase(&var)%str( )) > 0)
                       +(%index(%str( )%qupcase(&varlist)%str( ), %str( )%qupcase(&var)%str( )) > 0)
                       eq 1)
                      %then %do;
                          %let varlist2=&varlist2 &var;
                          %let dsvarlist2=&dsvarlist2 &dsvar;
                          %let foundlist2=&foundlist2 &isfound;
                      %end;
                   %let i=%eval(&i+1);
               %end;
               %let varlist=&varlist2;
               %let varlist2=;
               %let dsvarlist=&dsvarlist2;
               %let dsvarlist2=;
               %let foundlist=&foundlist2;
               %let foundlist2=;

         %end; %else %do;
             %PUT %STR(WAR)NING: (&sysmacroname): Invalid Dataset Operator: &dsoper.;

         %end;

         %*- if next dataset is not prceded by a dataset operator, consider <space> operator whichis equivalent to #UNION# -*;
         %let dsoper = #UNION#;

      %end;

      %let ds_i=%eval(&ds_i+1); %*- loop: next dataset -*;
   %end;

   %if (%upcase(&debug)=Y) %then %put ==>> Done processing all datasets -- dsvarlist=&dsvarlist;

   %*- format list of variables according to PATTERN, separated by SEP -*;
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#put#), #sc##pct#put #pct#str#lpar# #rpar#));
   %if (%upcase(&debug)=Y) %then %put sep = %superq(sep);
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicolon#), &sc));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicol#), &sc));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#scol#), &sc));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#sc#), &sc));
   %if (%upcase(&debug)=Y) %then %put sep = %superq(sep);
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#comma#), &comma));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#coma#), &comma)); %*- allow for misspelling -*;
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#c#), &comma)); %*- allow for abbreviation -*;
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#space#), &sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#s#), &sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#commaspace#), &comma.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#comaspace#), &comma.&sp));  %*- allow for misspelling -*;
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#cs#), &comma.&sp));  %*- allow for abbreviation -*;
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicolonspace#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicolons#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicolspace#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#semicols#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#scols#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#scs#), &sc.&sp));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#and#), %str( and )));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#or#), %str( or )));
   %if (%upcase(&debug)=Y) %then %put sep = %superq(sep);
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#lpar#), &lpar));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#rpar#), &rpar));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#pct#) , &pct));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#squot#) , &squot));
   %let sep=%qsysfunc(tranwrd(&sep, %quote(#dquot#) , &dquot));
   %if (%upcase(&debug)=Y) %then %put sep = >%superq(sep)<;
   %*- last separator -*;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#put#), #sc##pct#put #pct#str#lpar# #rpar#));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicolon#), &sc.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicol#), &sc.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#scol#), &sc.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#sc#), &sc.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#comma#), &comma.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#space#), &sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#s#), &sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#commaspace#), &comma.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#comaspace#), &comma.&sp.));  %*- allow for misspelling -*;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#cs#), &comma.&sp.));  %*- allow for abbreviation -*;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicolonspace#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicolons#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicolspace#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#semicols#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#scols#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#scs#), &sc.&sp.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#and#), %str( and )));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#or#), %str( or )));
   %if (%upcase(&debug)=Y) %then %put sep = >%superq(sep)< lsep = >%superq(lsep)<;
   %if %length(|%superq(sep)|) > 2
      %then %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#sep#), %superq(sep)));
      %else %let lsep=%qsysfunc(prxchange(s/#sep#/%superq(sep)/, -1, %superq(lsep)));
   %if (%upcase(&debug)=Y) %then %put lsep = >%superq(lsep)<;
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#lpar#), &lpar.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#rpar#), &rpar.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#pct#), &pct.));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#squot#), &squot));
   %let lsep=%qsysfunc(tranwrd(&lsep, %quote(#dquot#), &dquot));
   %if (%upcase(&debug)=Y) %then %put lsep = >%superq(lsep)<;
   %*- separator for variables not found in specified dataset(s) / invalid variable names (if no dataset was specified) -*;
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#put#), #sc##pct#put #pct#str#lpar# #rpar#));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicolon#), &sc.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicol#), &sc.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#scol#), &sc.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#sc#), &sc.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#comma#), &comma.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#space#), &sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#s#), &sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#commaspace#), &comma.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#comaspace#), &comma.&sp.));  %*- allow for misspelling -*;
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#cs#), &comma.&sp.));  %*- allow for abbreviation -*;
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicolonspace#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicolons#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicolspace#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#semicols#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#scols#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#scs#), &sc.&sp.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#and#), %str( and )));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#or#), %str( or )));
   %if %length(|%superq(sep)|) > 2
      %then %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#sep#), %superq(sep)));
      %else %let ALTSEP=%qsysfunc(prxchange(s/#sep#/%superq(sep)/, -1, %superq(ALTSEP)));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#lpar#), &lpar.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#rpar#), &rpar.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#pct#) , &pct.));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#squot#) , &squot));
   %let ALTSEP=%qsysfunc(tranwrd(&ALTSEP, %quote(#dquot#) , &dquot));
   %if (%upcase(&debug)=Y) %then %put ALTSEP = %superq(ALTSEP);
   %*- additional periodic separator -*;
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#put#), #sc##pct#put #pct#str#lpar# #rpar#));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicolon#), &sc.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicol#), &sc.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#scol#), &sc.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#sc#), &sc.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#comma#), &comma.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#space#), &sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#s#), &sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#commaspace#), &comma.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#comaspace#), &comma.&sp.));  %*- allow for misspelling -*;
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#cs#), &comma.&sp.));  %*- allow for abbreviation -*;
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicolonspace#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicolons#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicolspace#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#semicols#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#scols#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#scs#), &sc.&sp.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#and#), %str( and )));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#or#), %str( or )));
   %if %length(|%superq(sep)|) > 2
      %then %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#sep#), %superq(sep)));
      %else %let PERSEP=%qsysfunc(prxchange(s/#sep#/%superq(sep)/, -1, %superq(PERSEP)));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#lpar#), &lpar.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#rpar#), &rpar.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#pct#) , &pct.));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#squot#) , &squot));
   %let PERSEP=%qsysfunc(tranwrd(&PERSEP, %quote(#dquot#) , &dquot));
   %if (%upcase(&debug)=Y) %then %put PERSEP = %superq(PERSEP);

   %if (%upcase(&debug)=Y) %then %put sep = &sep;
   %let varlist2=;
   %let i=1;
   %let sepout=; %*- no separator before first item -*;

   %let patternin=&pattern;
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;
   %*- Expand patterns as follows
   #vareq-<w>-<x>[-<y>[-<z>]]#
      as:
         (<w>.#var#=<x>.#var# [ and <w>.#var#=<y>.#var# [ and <w>.#var#=.#var# ]] )

   #coal-<w>-<x>[-<y>[-<z>]]#
      as:
         COALESCE(<w>.#var#, <x>.#var#[, <y>.#var# [, <z>.#var# ]]) as #vlenlabfmt#
   -*;
   %let prx=%sysfunc(prxparse(%bquote(s/#vareq-(\w+)-(\w+)#/(\1.#var#=\2.#var#)/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;
   %let prx=%sysfunc(prxparse(%bquote(s/#vareq-(\w+)-(\w+)-(\w+)#/(\1.#var#=\2.#var# and \1.#var#=\3.#var#)/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;
   %let prx=%sysfunc(prxparse(%bquote(s/#vareq-(\w+)-(\w+)-(\w+)-(\w+)#/(\1.#var#=\2.#var# and \1.#var#=\3.#var# and \1.#var#=\4.#var#)/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;

   %let prx=%sysfunc(prxparse(%bquote(s/#coal-(\w+)-(\w+)#/COALESCE(\1.#var#, \2.#var#) as #vlenlabfmt#/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;
   %let prx=%sysfunc(prxparse(%bquote(s/#coal-(\w+)-(\w+)-(\w+)#/COALESCE(\1.#var#, \2.#var#, \3.#var#) as #vlenlabfmt#/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;
   %let prx=%sysfunc(prxparse(%bquote(s/#coal-(\w+)-(\w+)-(\w+)-(\w+)#/COALESCE(\1.#var#, \2.#var#, \3.#var#, \4.#var#) as #vlenlabfmt#/i)));
   %let patternin=%qsysfunc(prxchange(&prx, -1, &patternin));
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put patternin = &patternin;

   %*- check whether PATTERN or WHERE contains any reference to a variable attribute -*;
   %let refvarattr=;
   %let prx=%sysfunc(prxparse(/(#vt?(mx)?len#|#vnum#|#vtyp#|#vtnull#|#vfmt(defq?|keywd)?#|#(v|put)attrib#|#vinfmt(def|keywd)?#|#vlab(el)?(nam|src)?q?#|#vlab(el)?q#|#vt?(mx)?lenlab(el)?fmt#|#vt?lenlab(el)?srcfmt#|#isnull#|#vvalcat[st]?q#)/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
    or %sysfunc(prxmatch(&prx, %superq(where)))
    or %sysfunc(prxmatch(&prx, %superq(patternalt)))
      %then %let refvarattr=Y;
      %else %let refvarattr=N;
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put PATTERN and/or WHERE has/have references to any variable attribute: &refvarattr..;

   %*- check whether PATTERN or WHERE contains any reference to the max variable length (across multiple datasets) -*;
   %let get_mx_len = N;
   %let num_ds = 0;
   %let prx=%sysfunc(prxparse(/#vt?mxlen(lab(el)?(fmt)?)?#/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
    or %sysfunc(prxmatch(&prx, %superq(where)))
    or %sysfunc(prxmatch(&prx, %superq(patternalt)))
   %then %do;
      %let oneds_i=1;
      %do %while(%length(%qscan(&dslist, &oneds_i, %str( )))>0);
         %let oneds=%qscan(&dslist, &oneds_i, %str( ));
         %let onedsid=0;
         %let onedsid=%sysfunc(open(%qscan(&oneds, 1, :))); %* open current dataset (for read) *;
         %IF &onedsid %THEN %DO; %* dataset opened successfully *;
            %let num_ds=%eval(&num_ds+1);
            %let rc=%sysfunc(close(&onedsid));
         %END;
         %let oneds_i=%eval(&oneds_i+1);
      %end;
      %if (&num_ds > 1) %then %let get_mx_len=Y;
   %end;
   %if (%upcase(&debug)=Y) %then %put PATTERN and/or WHERE has/have references to max variable length (across multiple datasets): &get_mx_len..;

   %*- check whether PATTERN or WHERE contains #isnull# -*;
   %let refisnull=;
   %let prx=%sysfunc(prxparse(/(#isnull#)/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
    or %sysfunc(prxmatch(&prx, %superq(where)))
    or %sysfunc(prxmatch(&prx, %superq(patternalt)))
      %then %let refisnull=Y;
      %else %let refisnull=N;
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put PATTERN and/or WHERE has/have references to #isnull#: &refisnull..;

   %*- check whether PATTERN or WHERE contains #tmpvar# -*;
   %let reftmpvar=;
   %let prx=%sysfunc(prxparse(/(#tmpvar#)/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
    or %sysfunc(prxmatch(&prx, %superq(where)))
    or %sysfunc(prxmatch(&prx, %superq(patternalt)))
      %then %let reftmpvar=Y;
      %else %let reftmpvar=N;
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put PATTERN and/or WHERE has/have references to #tmpvar#: &reftmpvar..;

   %*- check whether PATTERN or WHERE contains #pre#, #bvar# and/or #suf# -*;
   %let refpresufbvar=;
   %let prx=%sysfunc(prxparse(/(#pre#|#bvar#|#suf#)/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
    or %sysfunc(prxmatch(&prx, %superq(where)))
    or %sysfunc(prxmatch(&prx, %superq(patternalt)))
      %then %let refpresufbvar=Y;
      %else %let refpresufbvar=N;
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put PATTERN and/or WHERE has/have references to #pre#, #bvar# and/or #suf#: &refpresufbvar..;

   %*- check whether PATTERN contains any reference to #autoEQ#, #autoCOAL# and/or #autoCOALsrc# -*;
   %let refauto=;
   %let prx=%sysfunc(prxparse(/(#autoEQ#|#autoCOALb?#|#autoCOALsrc#)/i));
   %if %sysfunc(prxmatch(&prx, %superq(patternin)))
      %then %let refauto=Y;
      %else %let refauto=N;
   %syscall prxfree(prx);
   %if (%upcase(&debug)=Y) %then %put PATTERN has references to #autoEQ#, #autoCOAL# and/or #autoCOALsrc# : &refauto..;

   %let isvalid=1;
   %let isfound=1;
   %let islast=0;

   %do %while(%length(%qscan(&varlist, &i, %str( )))>0);
       %if %length(%qscan(&varlist, %eval(&i+1), %str( )))=0 %then %let islast=1;
       %let var=%qscan(&varlist, &i, %str( ));
       %let dsvar=%qscan(&dsvarlist, &i, %str( ));
       %let isfound=%qscan(&foundlist, &i, %str( ));
     /*%let ds=%qsysfunc(tranwrd(&dsvar%str( ), .&var%str( ), %str()));*/
       %if %index(&dsvar%str( ), .&var%str( ))
          %then %let ds=%qsysfunc(trim(%qsysfunc(tranwrd(&dsvar%str( ), .&var%str( ), %str()))));   /*- JMB 20181205 - remove trailing space(s) from &ds -*/
          %else %let ds=%qsysfunc(trim(%qsysfunc(tranwrd(&dsvar%str( ), .%scan(&dsvar, -1, .)%str( ), %str()))));
       %if (%upcase(&debug)=Y) %then %put >>> ds retrieved from dsvar=&dsvar by replacing .var=.&var by a zero-length string: ds=&ds;
       %let dsnl=;
       %let dsal=;
       %let dsnvarl=;
       %let autocoal=;
       %let autocoalb=;
       %let autoeq=;
       %if (%qsubstr(&ds%str( ), 1, 1) = %quote(#)) %then %do;
          %let dsn=;
          %let dsa=;
          %let isprvvalid=&isvalid;
          %let isprvfound=&isfound;
          /*%let isfound=0;*/
          %if %sysfunc(prxmatch(/^[a-z_]\w*$/i, %superq(var)))
              %then %let isvalid=1;
              %else %let isvalid=0;
          %if (%upcase(&debug)=Y) %then %put i=&i var=&var dsvar=&dsvar ds=&ds dsn=&dsn isvalid=&isvalid;
       %end; %else %do;
          %let isprvvalid=&isvalid;
          %let isprvfound=&isfound;
        /*%let dsn=%qscan(%qscan(&ds, 1, |), 1, :);*/
        /*%let dsn=%qscan(%qscan(&ds,-1, |), 1, :);*/
          %let dsn=%qscan(%qscan(&ds, 1, |), 1, :);
        /*%let dsa=%qscan(%qscan(&ds, 1, |), 2, :);*/
        /*%let dsa=%qscan(%qscan(&ds,-1, |), 2, :);*/
          %let dsa=%qscan(%qscan(&ds, 1, |), 2, :);
        /*%if (%quote(&dsa)=%quote()) %then %let dsa=%qscan(&ds, -1, .);*/
          %if (%quote(&dsa)=%quote()) %then %let dsa=%qscan(&dsn, -1, .);  /*- JMB 20181205 - make sure &dsa only contains a single dataset */
          %let j=1;
          %let vnum=;
          %let vlen=;
          %let vmxlen=;
          %let vtlen=;
          %let vtmxlen=;
          %let vtyp=;
          %let vtnull=;
          %let vfmt=;
          %let vinfmt=;
          %let vlab=;
          %let vlabnam=;
          %let vlabsrc=;
          %let vlabq=" ";
          %let vlabsrcq=" ";
          %let vlabnamq=" ";
          %let vlenlabfmt=&var;
          %let vmxlenlabfmt=&var;
          %let vtlenlabfmt=&var;
          %let vtmxlenlabfmt=&var;
          %let vtlenlabsrcfmt=&var;
          %let vlenlabsrcfmt=&var;
          %let putattrib=@vnam_pos@ %sysfunc(quote(%superq(var)));
          %if %sysfunc(prxmatch(/^[a-z_]\w*$/i, %superq(var)))
              %then %let isvalid=1;
              %else %let isvalid=0;
          %if (%upcase(&debug)=Y) %then %do;
              %put Checking whether qscan(dsvar, -1, |)=%qscan(%superq(dsvar), -1, |) exists among the list of variables found in a dataset, i.e. in dsselectvars=&dsselectvars ;
              %put %str(   EITHER:);
              %put %str(      a.) preceded and followed by a space, OR;
              %put %str(      b.) preceded by a pipe (|) and followed by a space;
          %end;
          /*
          %if %length(%superq(dsn))>0 and &isvalid=1
             and (   %index(%str( )%qupcase(%superq(dsselectvars))%str( ), %str( )%qupcase(%qscan(%superq(dsvar), -1, |))%str( ))>0
                  or %index(%str( )%qupcase(%superq(dsselectvars))%str( ), %str(|)%qupcase(%qscan(%superq(dsvar), -1, |))%str( ))>0
                  or  %length(%superq(PATTERNALT))=0
                 )
             %then %let isfound=1;
             %else %let isfound=0;
          */
          %if (%upcase(&debug)=Y) %then %put i=&i var=&var dsvar=&dsvar ds=&ds dsn=&dsn isvalid=&isvalid isfound=&isfound  isprvvalid=&isprvvalid isprvfound=&isprvfound;
          %do %while(%length(%qscan(&ds, &j, |))>0);
             %let dsnl=&dsnl %qscan(%qscan(&ds, &j, |), 1, :);
             %if (%length(%superq(dsnvarl))>0) %then %do;
                %let dsnvarl=&dsnvarl.%bquote(,);
               %let dsnvarl=&dsnvarl %qscan(%qscan(&ds, &j, |), 1, :).&var;
            %end;

             %if (%length(&dsn)>0) and (&j=1) and (&refauto=Y) %then %do;
                %let dsid=%sysfunc(open(&dsn));
                %if &dsid>0 and &isvalid=1 %then %do;
                   %let vnum=%sysfunc(varnum(&dsid, &var));
                   %if (%upcase(&debug)=Y) %then %put vnum=&vnum;
                   %if &vnum %then %do;
                      %let vlen=%sysfunc(varlen(&dsid, &vnum));
                      %let vtyp=%sysfunc(vartype(&dsid, &vnum));
                      %let vfmt=%sysfunc(varfmt(&dsid, &vnum));
                      %let vinfmt=%sysfunc(varinfmt(&dsid, &vnum));
                      %let vlab=%qsysfunc(varlabel(&dsid, &vnum));
                 %if %length(&vlab) %then %do;
                         %let vlabsrc=%qsysfunc(prxchange(s/\[&dsn.\.&var.\]$//i, 1, &vlab)) [%upcase(&dsn..&var)];
                         %let vlabnam=%qsysfunc(prxchange(s/\[&var.\]$//i, 1, &vlab)) [%upcase(&var)];
                 %end; %else %do;
                         %let vlabsrc=[%upcase(&dsn..&var)];
                         %let vlabnam=[%upcase(&var)];
                 %end;
                      %if (%length(&vlab)=0)
                         %then %let vlabq=" ";
                         %else %let vlabq=%sysfunc(quote(&vlab, &squot.));
                      %let vlabsrcq=%sysfunc(quote(&vlabsrc, &squot.));
                      %let vlabnamq=%sysfunc(quote(&vlabnam, &squot.));
                   %end; %else %do;
                      %let isfound=0;
                      %if (%upcase(&debug)=Y) %then %put Updated isfound=&isfound (from lookup up variable &var in dataset &dsn - fid = &fid);
                   %end;
                   %let rc=%sysfunc(close(&dsid));
                %end;
                %if (&get_mx_len=Y) %then %do; %*- get variable max length across multiple datasets -*;
                   %let oneds_i=1;

                   %do %while(%length(%qscan(&dslist, &oneds_i, %str( )))>0);
                        %let oneds=%scan(&dslist, &oneds_i, %str( ));
                        %let onedsid=0;
                        %let onedsid=%sysfunc(open(%scan(&oneds, 1, :))); %* open current dataset (for read) *;
                        %IF &onedsid %THEN %DO; %* dataset opened successfully *;
                           %LET onevarnum=%SYSFUNC(varnum(&onedsid, &var));
                           %if &onevarnum >0 %then %do;
                               %if (%sysfunc(varlen(&onedsid, &onevarnum)) > &vmxlen) %then %let vmxlen = %sysfunc(varlen(&onedsid, &onevarnum));
                           %end;
                           %let rc=%sysfunc(close(&onedsid));
                        %END;
                        %let oneds_i=%eval(&oneds_i+1);
                    %end;
                %end; %else %do; %*- if only one dataset set vmxlen = &vlen -*;
                   %let vmxlen = &vlen;
                %end;
                %if %length(&var) > &vtlen_pos %then %let vtlen_pos=%length(&var);
                %if (&vtyp=C) %then %let vtnull=' ';
                %if (&vtyp=N) %then %let vtnull=.;
                %if (%length(&vlen)>0) and (&vtyp=C) %then %let vtlen=$&vlen;
                %if (%length(&vlen)>0) and (&vtyp=N) %then %let vtlen=&vlen;
                %if (%length(&vmxlen)>0) and (&vtyp=C) %then %let vtmxlen=$&vmxlen;
                %if (%length(&vmxlen)>0) and (&vtyp=N) %then %let vtmxlen=&vmxlen;
                %if (%length(&vlen)>0) %then %let vlenlabfmt=&vlenlabfmt length=&vlen;
                %if (%length(&vtlen)>0) %then %let vtlenlabfmt=&vtlenlabfmt length=&vtlen;
                %if (%length(&vmxlen)>0) %then %let vmxlenlabfmt=&vmxlenlabfmt length=&vmxlen;
                %if (%length(&vtmxlen)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt length=&vtmxlen;
                %if (%length(&vtlen)>0) %then %let putattrib=&putattrib @vtlen_pos@ "length=&vtlen";
                %if %length(&vtlen) > &vlab_pos %then %let vlab_pos=%length(&vtlen);
                %let vlenlabfmt=&vlenlabfmt label=&vlabq;
                %let vmxlenlabfmt=&vmxlenlabfmt label=&vlabq;
                %let vtlenlabfmt=&vtlenlabfmt label=&vlabq;
                %let vtmxlenlabfmt=&vtmxlenlabfmt label=&vlabq;
                %let putattrib=&putattrib @vlab_pos@ %sysfunc(quote(label=&vlabq, &squot.));
                %if %length(&vlabq) > &vfmt_pos %then %let vfmt_pos=%length(&vlabq);
                %if (%length(&vfmt)>0) %then %let vlenlabfmt=&vlenlabfmt format=&vfmt;
                %if (%length(&vfmt)>0) %then %let vmxlenlabfmt=&vmxlenlabfmt format=&vfmt;
                %if (%length(&vfmt)>0) %then %let vtlenlabfmt=&vtlenlabfmt format=&vfmt;
                %if (%length(&vfmt)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt format=&vfmt;
                %*- JMB 21FEB2017 - do not consider default formats assigned automatically e.g. by VIEWTABLE->SAVEAS -*;
                %if (%length(&vfmt)>0) and %sysfunc(prxmatch(/^(\$?F\d+|BEST12|\$&vlen)\.$/, &vfmt))=0 %then %do;
                    %let putattrib=&putattrib @vfmt_pos@ "format=&vfmt";
                    %if %length(&vfmt) > &vinfmt_pos %then %let vinfmt_pos=%length(&vfmt);
                %end;
                %if (%length(&vinfmt)>0) %then %let vlenlabfmt=&vlenlabfmt informat=&vinfmt;
                %if (%length(&vinfmt)>0) %then %let vmxlenlabfmt=&vmxlenlabfmt informat=&vinfmt;
                %if (%length(&vinfmt)>0) %then %let vtlenlabfmt=&vtlenlabfmt informat=&vinfmt;
                %if (%length(&vinfmt)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt informat=&vinfmt;
                %*- JMB 21FEB2017 - do not consider default informats assigned automatically e.g. by VIEWTABLE-SAVEAS -*;
                %if (%length(&vinfmt)>0) and %sysfunc(prxmatch(/^(\$?F\d+|BEST12|\$&vlen)\.$/, &vinfmt))=0
                    %then %let putattrib=&putattrib @vinfmt_pos@ "informat=&vinfmt";
                %if (%length(&vlen)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt length=&vlen;
                %if (%length(&vtlen)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt length=&vtlen;
                %let vlenlabsrcfmt=&vlenlabsrcfmt label=&vlabsrcq;
                %let vtlenlabsrcfmt=&vtlenlabsrcfmt label=&vlabsrcq;
                %if (%length(&vfmt)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt format=&vfmt;
                %if (%length(&vinfmt)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt informat=&vinfmt;
                %if (%length(&vfmt)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt format=&vfmt;
                %if (%length(&vinfmt)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt informat=&vinfmt;
             %end;

             %if (&refauto=Y) %then %do;
                %if (&j>1) %then %let autocoal=&autocoal.%quote(,);
                %if (&j>1) %then %let autoeq=&autoeq. %quote(=);
                %if (%qscan(%qscan(&ds, &j, |), 2, :)=%quote()) %then %do;
                   %let dsal=&dsal %qscan(%qscan(&ds, &j, |), 1, :);
                   %let autocoal=&autocoal %qscan(%qscan(%qscan(&ds, &j, |), 1, :), -1, .).&var;
                   %let autoeq=&autoeq %qscan(%qscan(%qscan(&ds, &j, |), 1, :), -1, .).&var;
                %end; %else %do;
                   %let dsal=&dsal %qscan(%qscan(&ds, &j, |), 2, :);
                   %let autocoal=&autocoal %qscan(%qscan(&ds, &j, |), 2, :).&var;
                   %let autoeq=&autoeq %qscan(%qscan(&ds, &j, |), 2, :).&var;
                %end;
                %if (%upcase(&debug)=Y) %then %put (looping..) j=&j dsal=&dsal autocoal=&autocoal autoeq=&autoeq;
             %end;
             %let j=%eval(&j+1);
          %end;
          %if (&refauto=Y) %then %do;
             %*- auto-equal variables from all datasets that contain it -*;
             %if (&j >3)
                %then %let autoeq=(coalesce(%qsysfunc(tranwrd(&autocoal.|, %bquote(, )%qscan(&autocoal.|, -1, %str( )), ))) = %qscan(&autoeq, -1, %str( )));
                %else %if (&j =3)
                          %then %let autoeq=(&autoeq);
                          %else %let autoeq=(&dsa..&var eq &dsa..&var);
             %*- auto-coalesce variables from all datasets that contain it -*;
             %if (&j >2) %then %do;
                %let autocoalb=coalesce(&autocoal);
                %let autocoalsrc=coalesce(&autocoal) as &var;
                %if (%length(&vlen)>0) %then %let autocoalsrc=&autocoalsrc length=&vlen;
                %*let autocoalsrc=&autocoalsrc %qsysfunc(quote(&vlab [%qupcase(&autocoal)]));
                %let autocoalsrc=&autocoalsrc %qsysfunc(quote(&vlab [coalesce: %qupcase(&dsnvarl)], &squot.));
                %if (%upcase(&debug)=Y) %then %put autocoalsrc=&autocoalsrc;
                %if (%length(&vfmt)>0) %then %let autocoalsrc=&autocoalsrc format=&vfmt;
                %if (%length(&vinfmt)>0) %then %let autocoalsrc=&autocoalsrc informat=&vinfmt;
                %if (%upcase(&debug)=Y) %then %put autocoalsrc=&autocoalsrc;
                %let autocoal=coalesce(&autocoal) as &vlenlabfmt;
             %end; %else %do;
                %let autocoalsrc=&dsa..&var as &vlenlabsrcfmt;
                %let autocoal=&dsa..&var;
                %let autocoalb=&autocoal;
             %end;
          %end;
       %end;

       %let pre=;
       %let suf=;
       %let bvar=&var;
       %if (&refpresufbvar=Y) %then %do; %*- identify any prefix and/or suffix found in "variable" name, and derive "bare" variable name -*;
          %let j=1;
           %let patt = %qscan(%superq(prefix), &j, %str( ));
           %do %while(%length(%superq(pre))=0 and %length(%superq(patt))>0);
              %let l = %length(%superq(patt));
              %if &l > 2 and %qsubstr(&patt, 1, 1)=&slash. and %qsubstr(&patt, &l, 1)=&slash.
               /*%then %let patt=s/&patt./i;*/
                 %then %let patt=s/^%qsubstr(&patt, 2, %eval(&l-1))/i;
                 %else %let patt=s/^&patt//i;
              %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): Suffix pattern: &patt;
              %let patt=%qsysfunc(prxchange(s/#ds#/&ds/, -1, &patt));
              %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): Prefix pattern: &patt;
              %if %sysfunc(prxmatch(&patt, &bvar))=1 %then %do;
                 %let bvar1 = %qsysfunc(prxchange(&patt, 1, &bvar));
                 %let l = %eval(%length(%superq(bvar))-%length(%superq(bvar1)));
                 %if &l >0 %then %do;
                    %let pre = %qsubstr(&var, 1, &l);
                    %let bvar = &bvar1;
                 %end;
              %end;
              %let j=%eval(&j+1);
              %let patt = %qscan(&prefix, &j, %str( ));
           %end;
           %let j=1;
           %let patt = %qscan(%superq(suffix), &j, %str( ));
           %do %while(%length(%superq(suf))=0 and %length(%superq(patt))>0 and %length(%superq(bvar))>0);
              %let l = %length(%superq(patt));
              %if &l > 2 and %qsubstr(&patt, 1, 1)=&slash. and %qsubstr(&patt, &l, 1)=&slash.
                 %then %let patt=s%qsubstr(&patt, 1, %eval(&l-1))$//i;
                 %else %let patt=s/&patt$//i;
              %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): Suffix pattern: &patt;
              %let patt=%qsysfunc(prxchange(s/#ds#/&ds/, -1, &patt));
              %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): Suffix pattern: &patt;
              %if %sysfunc(prxmatch(&patt, &bvar))>0 %then %do;
                 %let bvar1 = %qsysfunc(prxchange(&patt, 1, &bvar));
                 %let l = %eval(%length(%superq(bvar))-%length(%superq(bvar1)));
                 %if &l >0 %then %do;
                    %let suf = %qsubstr(&bvar, %eval(%length(%superq(bvar1))+1));
                    %let bvar = &bvar1;
                 %end;
              %end;
              %let j=%eval(&j+1);
              %let patt = %qscan(&suffix, &j, %str( ));
           %end;
           %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): For variable #var#, #pre#=&pre #bvar#=&bvar #suf#=&suf;
       %end;

       %if (&reftmpvar=Y) %then %do; %*- generate #tmpvar# based on #var#_X template -*;
          %*- take &var and truncate or pad with spaces to 28 charcaters then replace any non-alphanumeric character by _ -*;
          %if (%upcase(&debug)=Y) %then %put Generating temporary variable name correspoinding to VAR=&var;
          %let tmpvar = %qsysfunc(prxchange(s/[[:^alnum:]]/_/i, -1, %qsysfunc(trim(%qsysfunc(putc(&var, $char28.))))____));
          %let len = %length(%superq(tmpvar));
          %let r0=1;
          %let force_exit=0;
          %do %until(  (     %index(%str( )%qupcase(%superq(lookupvarsNF))%str( ), %str( )%qupcase(%superq(tmpvar))%str( ))=0
                         and %index(%str( )%qupcase(%superq(tmpvars_list))%str( ), %str( )%qupcase(%superq(tmpvar))%str( ))=0)
                       or (&force_exit=1)
                    );
                %let iter=&len;
                %let r0=%eval(&r0+1);
                %if %sysfunc(mod(&r0, 36))=0 %then %do;
                    %if (&iter>2) and (%substr(&tmpvar, %eval(&iter-1), 1)=_) %then %do;
                        %let iter=%eval(&iter-1);
                    %end; %else %do;
                        %if &len < 32 %then %do;
                            %let len=%eval(&len+1);
                            %if %qupcase(%superq(debug))=Y %then %put %str(Not)ice:(&sysmacroname): Incrementing name length to &len..;
                        %end; %else %do;
                            %put %str(WAR)NING:(&sysmacroname): Reached maximum length &len. without finding a new #tempvar# name, using existing name &tmpvar..;
                            %let force_exit=1;
                        %end;
                    %end;
                %end;
                %let r=%sysfunc(round(%sysfunc(ranuni(0)) * 36));
                %if       &r<10 %then %let r=%eval(&r+48);  %*- [0-9] -*;
                %else %if &r<36 %then %let r=%eval(&r+87); %*- [a-z] -*;
                                %else %let r=95; %*- [_] -*;
                %let tmpvar=%qsubstr(&tmpvar, 1, %eval(&iter-1))%qsysfunc(byte(&r))%qsubstr(&tmpvar%str( ), %eval(&iter+1));
                %if (%upcase(&debug)=Y) %then %put Tentative: tmpvar=&tmpvar;
          %end;
          %let tmpvars_list = &tmpvars_list &tmpvar;
          %if (%upcase(&debug)=Y) %then %put ---> temporary variable: &tmpvar  tmpvars_list=&tmpvars_list;
       %end;

       %let patternout=&patternin;
       %if &i > 1 %then %let sepout=&sep;
       %if (&islast=1) %then %let sepout=&lsep;

       %let ALTpatternout=&PATTERNALT;
       %if (%quote(&ds) = %quote(#default#)) %then %do;
          %if (&isvalid=0) %then %do;
              %if (%upcase(&debug)=Y) %then %put var=&var isvalid=&isvalid ds=&ds -> setting patternout to PATTERNALT.;
              %let patternout=&PATTERNALT;
          %end;
          %if (&isvalid=0) and (&isprvvalid=0) %then %do;
             %if (&NFbetween^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end; %else %if (&isprvvalid=0) %then %do;
             %if (&NFafter^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end; %else %if (&isvalid=0) %then %do;
             %if (&NFbefore^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end;
          %if (%upcase(&debug)=Y) %then %put var=&var isvalid=&isvalid isprvvalid=&isprvvalid NFbefore=&NFbefore NFbetween=&NFbetween NFafter=&NFafter ds=&ds -> setting sepout (1) to >&sepout<;
       %end; %else %do;
          %if (&isfound=0) %then %do;
              %if (%upcase(&debug)=Y) %then %put var=&var isfound=&isfound ds=&ds -> setting patternout to PATTERNALT.;
              %let patternout=&PATTERNALT;
          %end;
          %if (&isfound=0) and (&isprvfound=0) %then %do;
             %if (&NFbetween^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end; %else %if (&isprvfound=0) %then %do;
             %if (&NFafter^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end; %else %if (&isfound=0) %then %do;
             %if (&NFbefore^=%quote(Y))
                %then %let sepout=%superq(sepout);
                %else %let sepout=&ALTSEP;
          %end;
          %if (%upcase(&debug)=Y) %then %put var=&var isfound=&isfound isprvfound=&isprvfound NFbefore=&NFbefore NFbetween=&NFbetween NFafter=&NFafter ds=&ds -> setting sepout (2) to >&sepout<;
       %end;
       %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;

       %let whcond=&where;
       %*- If PATTERN and/or WHERE contain(s) the sequence #dsn#.#var# and no dataset is associated to variable,
           consider this sequence as if it consisted of #var# only to avoid a variable name with leading dot
           not preceded by a dataset name -*;
       %if (%quote(&ds) = %quote(#default#)) %then %do;
          %let patternout=%qsysfunc(tranwrd(&patternout, #dsn#.#var#, #var#));
          %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #dsn#.#var#, #var#));
          %let whcond=%qsysfunc(tranwrd(&whcond, #dsn#.#var#, #var#));
       %end;
       %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #var#, &var));
       %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #dsn#, &dsn));
       %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #dsa#, &dsa));
       %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %if (&refauto=Y) %then %do;
          %let patternout=%qsysfunc(tranwrd(&patternout, #autocoalb#, &autocoalb));
          %let patternout=%qsysfunc(tranwrd(&patternout, #autocoal#, &autocoal));
          %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
          %let patternout=%qsysfunc(tranwrd(&patternout, #autocoalsrc#, &autocoalsrc));
          %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
          %let patternout=%qsysfunc(tranwrd(&patternout, #autoeq#, &autoeq));
          %if (%upcase(&debug)=Y) %then %put patternout=&patternout;
       %end;

       %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #var#, &var));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #dsn#, &dsn));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #dsa#, &dsa));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
       %if (&refauto=Y) %then %do;
          %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #autocoalb#, &autocoalb));
          %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #autocoal#, &autocoal));
          %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
          %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #autocoalsrc#, &autocoalsrc));
          %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
          %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #autoeq#, &autoeq));
          %if (%upcase(&debug)=Y) %then %put ALTpatternout=&ALTpatternout;
       %end;

       %if (%superq(where) ^= %bquote(1)) %then %do;
          %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #var#, &var));
          %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #dsn#, &dsn));
          %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #dsa#, &dsa));
          %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
          %if (&refauto=Y) %then %do;
             %let whcond=%qsysfunc(tranwrd(&whcond, #autocoalb#, &autocoalb));
             %let whcond=%qsysfunc(tranwrd(&whcond, #autocoal#, &autocoal));
             %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
             %let whcond=%qsysfunc(tranwrd(&whcond, #autocoalsrc#, &autocoalsrc));
             %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
             %let whcond=%qsysfunc(tranwrd(&whcond, #autoeq#, &whcond));
             %if (%upcase(&debug)=Y) %then %put whcond=&whcond;
          %end;
       %end;
       %let vnum=;
       %let vlen=;
       %let vmxlen=;
       %let vtlen=;
       %let vtmxlen=;
       %let vtyp=;
       %let vtnull=;
       %let vfmt=;
       %let vinfmt=;
       %let vfmtkeywd=;
       %let vinfmtkeywd=;
       %let vlab=;
       %let vlabq=" ";
       %let vlabsrc=;
       %let vlabsrcq=" ";
       %*- if for a variable, a dataset is specified and PATTERN contains a keyword referencing one or more of
           the variable attributes, attempt to retrieve the variable attributes from the dataset -*;
       %if (%length(&dsn)>0) and (&refvarattr=Y) and (&isfound=1) %then %do;
          %if (%upcase(&debug)=Y) %then %put %str(Deb)ug: (&sysmacroname): attempting to retrieve the variable &var attributes from the dataset dsn=&dsn..;
          %let dsid=%sysfunc(open(&dsn));
          %if &dsid>0 and %sysfunc(prxmatch(/^\w+$/, %superq(var)))>0 %then %do;
             %let vnum=%sysfunc(varnum(&dsid, &var));
             %if &vnum %then %do;
                %let vlen=%sysfunc(varlen(&dsid, &vnum));
                %let vtyp=%sysfunc(vartype(&dsid, &vnum));
                %let vfmt=%sysfunc(varfmt(&dsid, &vnum));
                %let vinfmt=%sysfunc(varinfmt(&dsid, &vnum));
                %let vlab=%qsysfunc(varlabel(&dsid, &vnum));
            %if %length(&vlab) %then %do;
                   %let vlabsrc=%qsysfunc(prxchange(s/\[&dsn.\.&var.\]$//i, 1, &vlab)) [%upcase(&dsn..&var)];
                   %let vlabnam=%qsysfunc(prxchange(s/\[&var.\]$//i, 1, &vlab)) [%upcase(&var)];
            %end; %else %do;
                   %let vlabsrc=[%upcase(&dsn..&var)];
                   %let vlabnam=[%upcase(&var)];
            %end;
                %let vlabsrcq=%sysfunc(quote(&vlabsrc, &squot.));
                %let vlabnamq=%sysfunc(quote(&vlabnam, &squot.));
                %if (%length(&vlab)=0)
                   %then %let vlabq=" ";
                   %else %let vlabq=%sysfunc(quote(&vlab, &squot.));
                %if (%upcase(&debug)=Y) %then %put cnum=&vnum vlen=&vlen vtyp=&vtyp vfmt=&vfmt vinfmt=&vinfmt vlab=&vlab vlabq=&vlabq;
             %end;
             %let rc=%sysfunc(close(&dsid));
             %if (%upcase(&debug)=Y) %then %put %str(Deb)ug: (&sysmacroname): &var attributes: vlen=&vlen vtyp=&vtyp vfmt=&vfmt vinfmt=&vinfmt vlab=&vlab;
          %end;
          %else %if (%upcase(&debug)=Y) %then %put %str(Deb)ug: (&sysmacroname): Could not open dataset &dsn..;
       %end;
       %if (&get_mx_len=Y) %then %do; %*- get variable max length across multiple datasets -*;
          %let oneds_i=1;

          %do %while(%length(%scan(&dslist, &oneds_i, %str( )))>0);
               %let oneds=%scan(&dslist, &oneds_i, %str( ));
               %let onedsid=0;
               %let onedsid=%sysfunc(open(%scan(&oneds, 1, :))); %* open current dataset (for read) *;
               %IF &onedsid %THEN %DO; %* dataset opened successfully *;
                  %LET onevarnum=%SYSFUNC(varnum(&onedsid, &var));
                  %if &onevarnum >0 %then %do;
                      %if (%sysfunc(varlen(&onedsid, &onevarnum)) > &vmxlen) %then %let vmxlen = %sysfunc(varlen(&onedsid, &onevarnum));
                  %end;
                  %let rc=%sysfunc(close(&onedsid));
               %END;
               %let oneds_i=%eval(&oneds_i+1);
           %end;
       %end; %else %do; %*- if only one dataset set vmxlen = &vlen -*;
          %let vmxlen = &vlen;
       %end;

       %*- if for a variable, a dataset is specified and PATTERN contains #isnull# keyword, attempt to find if that variable has any non-null values in the dataset -*;
       %let isnull=1;
       %if (%length(&dsn)>0) and (&refisnull=Y) and (&isfound=1) %then %do;
          %if (&vtyp=C) %then %do;
             %let dsid=%sysfunc(open(&dsn(where=(&var ^= ' '))));
          %end; %else %do;
             %let dsid=%sysfunc(open(&dsn(where=(&var ^= .))));
          %end;
          %let rc=%sysfunc(fetch(&dsid));
          %if &rc=-1
              %then %let isnull=1;
              %else %let isnull=0;
         %if &dsid %then %do;
             %let rc=%sysfunc(close(&dsid));
          %end;
       %end;

       %if (&vtyp=N) %then %do;
           %let vvalcatsq = cats(&var);
           %let vvalcattq = cats(&var);
           %let vvalcatq  = cats(&var);
           %let vtnull=.;
       %end; %else %do;
           %let vvalcatsq = quote(cats(&var));
           %let vvalcattq = quote(catt(&var));
           %let vvalcatq  = quote(cat(&var));
           %let vtnull=' ';
       %end;
       %let vfmtdef=&vfmt;
       %let vfmtdefq=&vfmt;
       %let vinfmtdef=&vinfmt;
       %if (%length(&vlen)>0) %then %do;
          %if (&vtyp=C)
              %then %let vtlen=$&vlen;
              %else %let vtlen=&vlen;
       %end;
       %if (%length(&vmxlen)>0) %then %do;
          %if (&vtyp=C)
              %then %let vtmxlen=$&vmxlen;
              %else %let vtmxlen=&vmxlen;
       %end;
       %if (%length(&vfmt)=0) %then %do;
          %if (&vtyp=C)
             %then %let vfmtdef=$&vlen..;
             %else %let vfmtdef=&defnumfmt.;
          %let vfmtkeywd=;
       %end; %else %do;
          %let vfmtkeywd=format=&vfmt;
       %end;
       %if (%length(&vfmt)=0) %then %do;
          %if (&vtyp=C)
             %then %let vfmtdefq=$quote.;
             %else %let vfmtdefq=&defnumfmt.;
          %let vfmtkeywd=;
       %end;
       %if (%length(&vinfmt)=0) %then %do;
          %if (&vtyp=C)
             %then %let vinfmtdef=$&vlen..;
             %else %let vinfmtdef=&defnumfmt.;
          %let vinftmkeywd=;
       %end; %else %do;
          %let vinftmkeywd=informat=&vinfmt;
       %end;
       %let vlenlabfmt=&var;
       %let vmxlenlabfmt=&var;
       %if (%length(&vlen)>0) %then %let vlenlabfmt=&vlenlabfmt length=&vlen;
       %let vlenlabfmt=&vlenlabfmt label=&vlabq;
       %if (%length(&vfmt)>0) %then %let vlenlabfmt=&vlenlabfmt format=&vfmt;
       %if (%length(&vinfmt)>0) %then %let vlenlabfmt=&vlenlabfmt informat=&vinfmt;
       %if (%upcase(&debug)=Y) %then %put vlenlabfmt=&vlenlabfmt;
       %let vtlenlabfmt=&var;
       %let vlenlabsrcfmt=&var;
       %let vtlenlabsrcfmt=&var;
       %let vtmxlenlabfmt=&var;
       %if (%length(&vtlen)>0) %then %let vtlenlabfmt=&vtlenlabfmt length=&vtlen;
       %if (%length(&vlen)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt length=&vlen;
       %if (%length(&vtlen)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt length=&vtlen;
       %if (%length(&vmxlen)>0) %then %let vmxlenlabfmt=&vmxlenlabfmt length=&vmxlen;
       %if (%length(&vtmxlen)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt length=&vtmxlen;
       %let vlenlabfmt=&vlenlabfmt label=&vlabq;
       %let vtlenlabfmt=&vtlenlabfmt label=&vlabq;
       %let vmxlenlabfmt=&vmxlenlabfmt label=&vlabq;
       %let vtmxlenlabfmt=&vtmxlenlabfmt label=&vlabq;
       %if (%length(&vfmt)>0) %then %let vtlenlabfmt=&vtlenlabfmt format=&vfmt;
       %if (%length(&vfmt)>0) %then %let vmxlenlabfmt=&vmxlenlabfmt format=&vfmt;
       %if (%length(&vfmt)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt format=&vfmt;
       %if (%length(&vinfmt)>0) %then %let vtlenlabfmt=&vtlenlabfmt informat=&vinfmt;
       %if (%length(&vinfmt)>0) %then %let vtmxlenlabfmt=&vtmxlenlabfmt informat=&vinfmt;
       %if (%upcase(&debug)=Y) %then %put vtlenlabfmt=&vtlenlabfmt;
       %if (%upcase(&debug)=Y) %then %put vtmxlenlabfmt=&vtmxlenlabfmt;
       %if (%length(&vlen)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt length=&vlen;
       %let vlenlabsrcfmt=&vlenlabsrcfmt label=&vlabsrcq;
       %if (%length(&vfmt)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt format=&vfmt;
       %if (%length(&vinfmt)>0) %then %let vlenlabsrcfmt=&vlenlabsrcfmt informat=&vinfmt;
       %let vtlenlabsrcfmt=&vtlenlabsrcfmt label=&vlabsrcq;
       %if (%length(&vfmt)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt format=&vfmt;
       %if (%length(&vinfmt)>0) %then %let vtlenlabsrcfmt=&vtlenlabsrcfmt informat=&vinfmt;

       %if %length(&var) > &vtlen_pos %then %let vtlen_pos=%length(&var);
       %if (%length(&vtlen)>0) %then %let putattrib=&putattrib @vtlen_pos@ "length=&vtlen";
       %if %length(&vtlen) > &vlab_pos %then %let vlab_pos=%length(&vtlen);
       %let putattrib=&putattrib @vlab_pos@ %sysfunc(quote(label=&vlabq, &squot.));
       %if %length(&vlabq) > &vfmt_pos %then %let vfmt_pos=%length(&vlabq);
       %*- JMB 21FEB2017 - do not consider default formats assigned automatically e.g. by VIEWTABLE->SAVEAS -*;
       %if (%length(&vfmt)>0) and %sysfunc(prxmatch(/^(\$?F\d+|BEST12|\$&vlen)\.$/, &vfmt))=0 %then %do;
           %let putattrib=&putattrib @vfmt_pos@ "format=&vfmt";
           %if %length(&vfmt) > &vinfmt_pos %then %let vinfmt_pos=%length(&vfmt);
       %end;
       %*- JMB 21FEB2017 - do not consider default informats assigned automatically e.g. by VIEWTABLE->SAVEAS -*;
       %if (%length(&vinfmt)>0) and %sysfunc(prxmatch(/^(\$?F\d+|BEST12|\$&vlen)\.$/, &vinfmt))=0
           %then %let putattrib=&putattrib @vinfmt_pos@ "informat=&vinfmt";

       %let patternout= %qsysfunc(tranwrd(&patternout, #vnum#, &vnum));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vlen#, &vlen));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vmxlen#, &vmxlen));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vtlen#, &vtlen));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vtmxlen#, &vtmxlen));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;

       %let patternout= %qsysfunc(tranwrd(&patternout, #isnull#, &isnull));
       %let patternout= %qsysfunc(tranwrd(&patternout, #isvalid#, &isvalid));
       %let patternout= %qsysfunc(tranwrd(&patternout, #isfound#, &isfound));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vtyp#, &vtyp));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vtnull#, &vtnull));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #tmpvar#, &tmpvar));
       /*
       %*- the following would replaces by one space instead of by an empty string - so we need to use prxchange to avoid this -*;
       %let patternout= %qsysfunc(tranwrd(&patternout, #pre#, &pre));
       %let patternout= %qsysfunc(tranwrd(&patternout, #bvar#, &bvar));
       %let patternout= %qsysfunc(tranwrd(&patternout, #suf#, &suf));
      */
       %let patternout= %qsysfunc(prxchange(s/#pre#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(pre)))/, -1, &patternout));
       %let patternout= %qsysfunc(prxchange(s/#bvar#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(bvar)))/, -1, &patternout));
       %let patternout= %qsysfunc(prxchange(s/#suf#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(suf)))/, -1, &patternout));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vfmt#, &vfmt));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vfmtdef#, &vfmtdef));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vfmtdefq#, &vfmtdefq));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vfmtkeywd#, &vfmtkeywd));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vinfmt#, &vinfmt));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vinfmtdef#, &vinfmtdef));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vinfmtkeywd#, &vinfmtkeywd));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout= %qsysfunc(tranwrd(&patternout, #vvalcatsq#, &vvalcatsq));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vvalcattq#, &vvalcattq));
       %let patternout= %qsysfunc(tranwrd(&patternout, #vvalcatq#,  &vvalcatq));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlab#, &vlab));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabel#, &vlab));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabsrc#, &vlabsrc));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabelsrc#, &vlabsrc));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabnam#, &vlabnam));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabelnam#, &vlabnam));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabq#, &vlabq));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabelq#, &vlabq));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabsrcq#, &vlabsrcq));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabelsrcq#, &vlabsrcq));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabnamq#, &vlabnamq));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlabelnamq#, &vlabnamq));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlenlabfmt#, &vlenlabfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vmxlenlabfmt#, &vmxlenlabfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlenlabelfmt#, &vlenlabfmt));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vtlenlabfmt#, &vtlenlabfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vattrib#, &vtlenlabfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vtmxlenlabfmt#, &vtmxlenlabfmt));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlenlabsrcfmt#, &vlenlabsrcfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vtlenlabsrcfmt#, &vtlenlabsrcfmt));
       %let patternout=%qsysfunc(tranwrd(&patternout, #vlenlabelsrcfmt#, &vlenlabsrcfmt));
       %if (%upcase(&debug)=Y) %then %put patternout{2}=&patternout;
       %*- resolve keywords for special punctuation symbols potentially used in PATTERNS -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#semicolon#), &sc.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#semicol#), &sc.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#scol#), &sc.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#sc#), &sc.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#scs#), &sc.&sp.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#comma#), &comma.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#cs#), &comma.&sp.)); %*- allow for abbreviation -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#s#), &sp.)); %*- allow for abbreviation -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#space#), &sp.)); %*- allow for abbreviation -*;
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#lpar#), &lpar.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#rpar#), &rpar.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#pct#) , &pct.));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#squot#) , &squot));
       %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#dquot#) , &dquot));
       %*- resolve keyword #sep# potentially used in PATTERNS -*;
       %if &i > 1 %then %do;
           %if (&islast=1)
              %then %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#sep#), %superq(lsep)));
              %else %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#sep#), %superq(sep)));
       %end; %else %do;
           %let patternout=%qsysfunc(tranwrd(&patternout, %quote(#sep#), %quote()));
       %end;


       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vnum#, &vnum));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vlen#, &vlen));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vtlen#, &vtlen));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #isnull#, &isnull));
      %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #isvalid#, &isvalid));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #isfound#, &isfound));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vtyp#, &vtyp));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vtnull#, &vtnull));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #tmpvar#, &tmpvar));
       /*
       %*- the following would replaces by one space instead of by an empty string - so we need to use prxchange to avoid this -*;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #pre#, &pre));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #bvar#, &bvar));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #suf#, &suf));
       */
       %let ALTpatternout= %qsysfunc(prxchange(s/#pre#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(pre)))/, -1, &ALTpatternout));
       %let ALTpatternout= %qsysfunc(prxchange(s/#bvar#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(bvar)))/, -1, &ALTpatternout));
       %let ALTpatternout= %qsysfunc(prxchange(s/#suf#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(suf)))/, -1, &ALTpatternout));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vfmt#, &vfmt));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vfmtdef#, &vfmtdef));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vfmtdefq#, &vfmtdefq));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vfmtkeywd#, &vfmtkeywd));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vinfmt#, &vinfmt));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vinfmtdef#, &vinfmtdef));
       %let ALTpatternout= %qsysfunc(tranwrd(&ALTpatternout, #vinfmtkeywd#, &vinfmtkeywd));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlab#, &vlab));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabel#, &vlab));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabsrc#, &vlabsrc));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabelsrc#, &vlabsrc));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabnam#, &vlabnam));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabelnam#, &vlabnam));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabq#, &vlabq));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabelq#, &vlabq));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabsrcq#, &vlabsrcq));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabelsrcq#, &vlabsrcq));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabnamq#, &vlabnamq));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlabelnamq#, &vlabnamq));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlenlabfmt#, &vlenlabfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vmxlenlabfmt#, &vmxlenlabfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlenlabelfmt#, &vlenlabfmt));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vtlenlabfmt#, &vtlenlabfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vattrib#, &vtlenlabfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vtmxlenlabfmt#, &vtmxlenlabfmt));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vtlenlabsrcfmt#, &vtlenlabsrcfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlenlabsrcfmt#, &vlenlabsrcfmt));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #vlenlabelsrcfmt#, &vlenlabsrcfmt));
       %if (%upcase(&debug)=Y) %then %put ALTpatternout{2}=&ALTpatternout;
       %*- resolve keywords for special punctuation symbols potentially used in PATTERNS -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#semicolon#), &sc.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#semicol#), &sc.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#scol#), &sc.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#sc#), &sc.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#scs#), &sc.&sp.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#comma#), &comma.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#cs#), &comma.&sp.)); %*- allow for abbreviation -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#s#), &sp.)); %*- allow for abbreviation -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#space#), &sp.)); %*- allow for abbreviation -*;
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#lpar#), &lpar.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#rpar#), &rpar.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#pct#) , &pct.));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#squot#) , &squot));
       %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#dquot#) , &dquot));
       %*- resolve keyword #sep# potentially used in PATTERNS -*;
       %if &i > 1 %then %do;
           %if (&islast=1)
              %then %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#sep#), %superq(lsep)));
              %else %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#sep#), %superq(sep)));
       %end; %else %do;
           %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, %quote(#sep#), %quote()));
       %end;


       %if (%superq(where) ^= %bquote(1)) %then %do;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vnum#, &vnum));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vlen#, &vlen));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vmxlen#, &vmxlen));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vtlen#, &vtlen));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vtmxlen#, &vtmxlen));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vtyp#, &vtyp));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vtnull#, &vtnull));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #tmpvar#, &tmpvar));
          %let whcond= %qsysfunc(tranwrd(&whcond, #pre#, &pre));
          %let whcond= %qsysfunc(tranwrd(&whcond, #bvar#, &bvar));
          %let whcond= %qsysfunc(tranwrd(&whcond, #suf#, &suf));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vfmt#, &vfmt));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vfmtdef#, &vfmtdef));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vfmtdefq#, &vfmtdefq));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vfmtkeywd#, &vfmtkeywd));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vinfmt#, &vinfmt));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vinfmtdef#, &vinfmtdef));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vinfmtkeywd#, &vinfmtkeywd));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond= %qsysfunc(tranwrd(&whcond, #vvalcatsq#, &vvalcatsq));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vvalcattq#, &vvalcattq));
          %let whcond= %qsysfunc(tranwrd(&whcond, #vvalcatq#,  &vvalcatq));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #isnull#, &isnull));
          %let whcond=%qsysfunc(tranwrd(&whcond, #isvalid#, &isvalid));
          %let whcond=%qsysfunc(tranwrd(&whcond, #isfound#, &isfound));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlab#, &vlab));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabel#, &vlab));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabsrc#, &vlabsrc));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabelsrc#, &vlabsrc));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabnam#, &vlabnam));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabelnam#, &vlabnam));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabq#, &vlabq));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabelq#, &vlabq));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabsrcq#, &vlabsrcq));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabelsrcq#, &vlabsrcq));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabnamq#, &vlabnamq));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlabelnamq#, &vlabnamq));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlenlabfmt#, &vlenlabfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vmxlenlabfmt#, &vmxlenlabfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlenlabelfmt#, &vlenlabfmt));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vtlenlabfmt#, &vtlenlabfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vattrib#, &vtlenlabfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vtmxlenlabfmt#, &vtmxlenlabfmt));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #vtlenlabsrcfmt#, &vtlenlabsrcfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlenlabsrcfmt#, &vlenlabsrcfmt));
          %let whcond=%qsysfunc(tranwrd(&whcond, #vlenlabelsrcfmt#, &vlenlabsrcfmt));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %let whcond=%qsysfunc(tranwrd(&whcond, #all#, &all));
          %let whcond=%qsysfunc(tranwrd(&whcond, #num#, &num));
          %let whcond=%qsysfunc(tranwrd(&whcond, #char#, &char));
          %let whcond= %qsysfunc(prxchange(s/#pre#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(pre)))/, -1, &whcond));
          %let whcond= %qsysfunc(prxchange(s/#bvar#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(bvar)))/, -1, &whcond));
          %let whcond= %qsysfunc(prxchange(s/#suf#/%sysfunc(prxchange(s/([\{\}\[\]\(\)\^\$\.\|\*\+\?\\\/])/\\\1/, -1, %superq(suf)))/, -1, &whcond));
          %if (%upcase(&debug)=Y) %then %put whcond{2}=&whcond;
          %*- resolve keywords for special punctuation symbols potentially used in PATTERNS -*;
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#semicolon#), &sc.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#semicol#), &sc.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#scol#), &sc.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#sc#), &sc.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#comma#), &comma.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#space#), &sp.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#s#), &sp.)); %*- allow for abbreviation -*;
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#lpar#), &lpar.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#rpar#), &rpar.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#pct#) , &pct.));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#squot#) , &squot));
          %let whcond=%qsysfunc(tranwrd(&whcond, %quote(#dquot#) , &dquot));
       %end;

       %let periodic_sep=;
       %if %sysevalf(&period > 0) %then %do;
          %if %sysevalf(%sysfunc(mod(%sysevalf(&_n_ - &phase), &period))=0) %then %let periodic_sep=%superq(PERsep);
       %end;
       %if  (%upcase(&debug)=Y) %then %put _n_=&_n_ phase=&phase period=&period periodic_sep=>%superq(periodic_sep)<;

       %if %eval(%unquote(&whcond)) %then %do; %*- Process current variable if the WHERE condition is met -*;
          %let _n_=%eval(&_n_ + 1);
          %if (&_n_ >= &firstvar) and ((&_n_ <= &nvar) or (&nvar = .)) %then %do;
             %if (%qupcase(&pattern)=#PUTATTRIB#) %then %do;
                %if %length(&varlist2)=0
                    %then %let varlist2= put @3 "attrib " / &putattrib;
                    %else %let varlist2= &varlist2 / &putattrib;
             %end; %else %do;
                %let patternout=%qsysfunc(tranwrd(&patternout, #n#, &_n_));
                %if %length(%superq(patternout)) < &pad %then %let patternout=%qsysfunc(putc(&patternout, $&pad..));
                %if %length(&varlist2)=0
                   %then %let varlist2=&patternout;
                   %else %let varlist2=&varlist2.&sepout.&periodic_sep.&patternout;
             %end;
          %end;
       %end; %else %if %length(%superq(PATTERNALT)) %then %do; %*- Alternative process of current variable if the WHERE condition is NOT met but PATTERNALT is defined -*;
          %let _n_=%eval(&_n_ + 1);
          %if (&_n_ >= &firstvar) and ((&_n_ <= &nvar) or (&nvar = .)) %then %do;
             %if (%qupcase(&patternALT)=#PUTATTRIB#) %then %do;
                %if %length(&varlist2)=0
                    %then %let varlist2= put @3 "attrib " / &putattrib;
                    %else %let varlist2= &varlist2 / &putattrib;
             %end; %else %do;
                %let ALTpatternout=%qsysfunc(tranwrd(&ALTpatternout, #n#, &_n_));
                %if %length(%superq(ALTpatternout)) < &pad %then %let ALTpatternout=%qsysfunc(putc(&ALTpatternout, $&pad..));
                %if %length(&varlist2)=0
                   %then %let varlist2=&ALTpatternout;
                   %else %let varlist2=&varlist2.&sepout.&periodic_sep.&ALTpatternout;
             %end;
          %end;
       %end;

       %if  (%upcase(&debug)=Y) %then %put varlist2=>%superq(varlist2)<;


       %let i=%eval(&i+1); %*- loop: next &i -*;
       %let sepout=&sep; %*- separator before following items -*;
   %end;
   %let varlist=&varlist2;
   %if (%upcase(&debug)=Y) %then %put varlist=&varlist;

   %let vtlen_pos=%eval(&vtlen_pos + &vnam_pos +1);
   %let vlab_pos=%eval(&vlab_pos + &vtlen_pos +8);
   %let vfmt_pos=%eval(&vfmt_pos + &vlab_pos +7);
   %let vinfmt_pos=%eval(&vinfmt_pos + &vfmt_pos +8);

   %let varlist=%qsysfunc(tranwrd(&varlist, @vnam_pos@,   @&vnam_pos));
   %let varlist=%qsysfunc(tranwrd(&varlist, @vtlen_pos@,  @&vtlen_pos));
   %let varlist=%qsysfunc(tranwrd(&varlist, @vlab_pos@,   @&vlab_pos));
   %let varlist=%qsysfunc(tranwrd(&varlist, @vfmt_pos@,   @&vfmt_pos));
   %let varlist=%qsysfunc(tranwrd(&varlist, @vinfmt_pos@, @&vinfmt_pos));

   %if (%qupcase(&pattern)=#PUTATTRIB#) %then %do;
       ; data _null_;
                put "*- Dataset(s): &data -*;";
                %unquote(%superq(varlist)) / @&vnam_pos ";" ;
         run;
    %let varlist=;
   %end;

   %if   (%qupcase(&from)=#AUTOFULLEQ#)
      or (%qupcase(&from)=#AUTOLEFTEQ#)
      or (%qupcase(&from)=#AUTORIGHTEQ#)
      or (%qupcase(&from)=#AUTOINNEREQ#)
   %then %do;
      %*- Auto-generate a SQL FROM clause and JOIN (if multiple datasets),
          and append it to the returned list of variables (meant to be used
          in a PROC SQL SELECT clause):
          in case of JOIN, this will be an EQUIJOIN based on variables in common between datasets (also taking into account the var= parameter),
          JOIN type is according to parameter keyword: #autoFULLEQ# (FULL), #autoLEFTEQ# (LEFT), #autoRIGHTEQ# (RIGHT), #autoINNEREQ# (INNER) -*;
      %let join_type=%qsysfunc(tranwrd(%qsysfunc(tranwrd(%qupcase(&from), #AUTO, %str( ))), EQ#, %str( )));
      %if (%upcase(&debug)=Y) %then %put join_type=&join_type;

      %let i=1;
      %let prev_datasets=;
      %do %while(%qscan(&data, &i, %str( ))^=);
         %let dsn=%qscan(&data, &i, %str( ));
         %if (%index(&dsn, #) EQ 0) %then %do;
            %if (&i=1) %then %do;
              %let varlist=&varlist FROM;
            %end; %else %do;
              %let varlist=&varlist &join_type JOIN;
            %end;
            %let varlist=&varlist %qsysfunc(tranwrd(&dsn, :, %str( as )));
            %if (&i>1) %then %do;
              %let varlist2=%VARLIST(data=&prev_datasets #INTERSECT# &dsn, var=&varlist_o, sep=#and#, pattern=#autoEQ#);
              %if %length(&varlist2)>0 %then %do;
                 %let varlist=&varlist ON &varlist2;
              %end; %else %do;
                 %let varlist=&varlist ON (1 EQ 1);  %*- No variables in common, so try the equivalent of a Cartesian Product or CROSS JOIN -*;
              %end;
            %end;
            %let prev_datasets=&prev_datasets &dsn;
         %end;
         %let i=%eval(&i+1);
         %if (%upcase(&debug)=Y) %then %do;
            %put ## SPECIFIC PROCESSING STEP &i, dsn=&dsn ##;
            %put varlist=&varlist;
         %end;
      %end;


   %end;

%END;

%*- resolve special keywords potentially used in PRETEXT -*;
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#semicolon#), &sc.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#semicol#), &sc.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#scol#), &sc.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#sc#), &sc.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#s#), &sp.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#scs#), &sc.&sp.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#comma#), &comma.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#cs#), &comma.&sp.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#lpar#), &lpar.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#rpar#), &rpar.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#pct#) , &pct.));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#squot#) , &squot));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#dquot#) , &dquot));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#data#) , %superq(data)));
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#n#) , %superq(_n_)));
%let prx_put =%sysfunc(prxparse(s/^ *#put#/&sc.&pct.put /));
%let pretext=%qsysfunc(prxchange(&prx_put, 1, &pretext));
%syscall prxfree(prx_put);
%let pretext=%qsysfunc(tranwrd(&pretext, %quote(#put#) , &sc.&pct.put &pct.str&lpar. &rpar.));
%if (%upcase(&debug)=Y) %then %put pretext=->%superq(pretext)<-;

%*- resolve special keywords potentially used in posttext -*;
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#semicolon#), &sc.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#semicol#), &sc.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#scol#), &sc.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#sc#), &sc.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#s#), &sp.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#scs#), &sc.&sp.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#comma#), &comma.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#cs#), &comma.&sp.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#lpar#), &lpar.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#rpar#), &rpar.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#pct#) , &pct.));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#squot#) , &squot));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#dquot#) , &dquot));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#data#) , %superq(data)));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#n#) , %superq(_n_)));
%let posttext=%qsysfunc(tranwrd(&posttext, %quote(#put#) , &sc.&pct.put &pct.str&lpar. &rpar.));
%if (%upcase(&debug)=Y) %then %put posttext=->%superq(posttext)<-;

%if %length(%superq(into))>0 %then %do;
   %*- resolve special keywords potentially used in into -*;
   %let into=%qsysfunc(tranwrd(&into, %quote(#semicolon#), &sc.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#semicol#), &sc.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#scol#), &sc.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#sc#), &sc.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#s#), &sp.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#scs#), &sc.&sp.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#comma#), &comma.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
   %let into=%qsysfunc(tranwrd(&into, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
   %let into=%qsysfunc(tranwrd(&into, %quote(#cs#), &comma.&sp.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#lpar#), &lpar.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#rpar#), &rpar.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#pct#) , &pct.));
   %let into=%qsysfunc(tranwrd(&into, %quote(#squot#) , &squot));
   %let into=%qsysfunc(tranwrd(&into, %quote(#dquot#) , &dquot));
   %let into=%qsysfunc(tranwrd(&into, %quote(#data#) , %superq(data)));
   %let into=%qsysfunc(tranwrd(&into, %quote(#n#) , %superq(_n_)));
   %let into=%qsysfunc(tranwrd(&into, %quote(#put#) , &sc.&pct.put &pct.str&lpar. &rpar.));
   %if (%upcase(&debug)=Y) %then %put into=->%superq(into)<-;
   %if (%upcase(&debug)=Y) %then %put (&sysmacroname): Setting INTO macro-variable: %sysfunc(prxchange(s/^([A-Za-z_]\w{0,31}) /\1 = /, 1, %superq(into)));
   %let %scan(%superq(into), 1, %str( )) = %qsysfunc(prxchange(s/^([A-Za-z_]\w{0,31}) //, 1, %superq(into))) ;
%end;

%if %length(%superq(return)) %then %do;
   %*- resolve special keywords potentially used in return -*;
   %let return=%qsysfunc(tranwrd(&return, %quote(#semicolon#), &sc.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#semicol#), &sc.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#scol#), &sc.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#sc#), &sc.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#s#), &sp.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#scs#), &sc.&sp.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#comma#), &comma.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#coma#), &comma.)); %*- allow for misspelling -*;
   %let return=%qsysfunc(tranwrd(&return, %quote(#c#), &comma.)); %*- allow for abbreviation -*;
   %let return=%qsysfunc(tranwrd(&return, %quote(#cs#), &comma.&sp.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#lpar#), &lpar.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#rpar#), &rpar.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#pct#) , &pct.));
   %let return=%qsysfunc(tranwrd(&return, %quote(#squot#) , &squot));
   %let return=%qsysfunc(tranwrd(&return, %quote(#dquot#) , &dquot));
   %let return=%qsysfunc(tranwrd(&return, %quote(#data#) , %superq(data)));
   %let return=%qsysfunc(tranwrd(&return, %quote(#n#) , %superq(_n_)));
   %let return=%qsysfunc(tranwrd(&return, %quote(#put#) , &sc.&pct.put &pct.str&lpar. &rpar.));
   %if (%upcase(&debug)=Y) %then %put return=->%superq(return)<-;
%if %qupcase(%superq(unquote))=%quote(Y) %then %do;
%str()%unquote(&return.)
%end; %else %do;
%str()&return.
%end;
%return;
%end;

%*- (resolve to) list of variables to return -*;
%if %length(%superq(varlist)) or %superq(pretext_spec)=#n# or %superq(posttext_spec)=#n# or %superq(always)=Y %then %do;
%if %qupcase(%superq(unquote))=%quote(Y) %then %do;
%str()%unquote(&pretext.&varlist&posttext.)
%end; %else %do;
%str()&pretext.&varlist&posttext.
%end;
%end;
%mend varlist;
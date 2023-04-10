Daily Tip 86 02/12/2003 1:47 PM

**Page x of y in RTF -- SAS 8**

Using SAS 8.2 you can insert some raw RTF which will be used by the word
processor to display page x of y. This works nicely, although there is a
much easier way to do it in SAS 9 (covered in a previous tip). This
technique was discovered by Lauren Haworth, author of "ODS Basics". She
added page x of y using MS Word, saved it as RTF and then examined the
RTF with notepad to see what RTF code was used to implement page x of y.
By inserting this as raw RTF we can get the feature in SAS.

Using this technique you can also discover other useful features of RTF
and insert those into SAS ODS output.

***Sample code for page x of y***

ODS ESCAPECHAR=\"\^\";

footnote J=R \"\^R/RTF\'{PAGE \\field {\\\*\\fldinst
PAGE\\\*\\MERGEFORMAT}} { OF \\field {\\\*\\fldinst NUMPAGES
\\\*\\MERGEFORMAT} }\'\";

Example tested under SAS 8.2, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb

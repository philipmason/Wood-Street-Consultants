Daily Tip 53 14/07/2003 6:19 PM

**Sending email from SAS**

You can send emails directly from a SAS data step. SAS will use your
default email settings so you don't have to specify anything other than
a filename statement using the *email* access device, and a *TO*
address. Email can also be sent using SCL or macro language.

Email can be very handy for doing things like:

> • notifying users about errors
>
> • interfacing through an SMS gateway to send messages to mobile phones
>
> • sending reports out to customers

For more information see
[http://v8doc.sas.com/sashtml/win/zasemail.htm]{.underline}

**Simple example SAS log**

35 filename mail email to=\"phil@woodstreet.org.uk\" ;

36 data ;

37 file mail ;

38 put \'hello\' ;

39 run ;

NOTE: The file MAIL is:

E-Mail Access Device

Message sent

To: phil@woodstreet.org.uk

Cc:

Subject:

Attachments:

NOTE: 1 record was written to the file MAIL.

The minimum record length was 5.

The maximum record length was 5.

NOTE: The data set WORK.DATA2 has 1 observations and 0 variables.

NOTE: DATA statement used:

real time 6.82 seconds

cpu time 0.06 seconds

**Another example SAS log**

40 filename mail email \' \'

41 to=(\'phil@woodstreet.org.uk\')

42 cc=(\'john@woodstreet.org.uk\' \'peter@woodstreet.org.uk\')

43 subject=\"Here are your graphs for &sysdate\"

44 attach =(\'c:\\gchart1.gif\' \'c:\\gchart2.gif\') ;

45 data \_null\_;

46 file mail;

47 put \"I could put some text in here to describe the graphs.\";

48 put \" \";

49 run;

NOTE: The file MAIL is:

E-Mail Access Device

Message sent

To: (\'phil@woodstreet.org.uk\' )

Cc: (\'john@woodstreet.org.uk\' \'peter@woodstreet.org.uk\' )

Subject: Here are your graphs for 18JUL03

Attachments: (\'c:\\gchart1.gif\' \'c:\\gchart2.gif\' )

NOTE: 2 records were written to the file MAIL.

The minimum record length was 1.

The maximum record length was 53.

NOTE: DATA statement used:

real time 13.89 seconds

cpu time 0.08 seconds

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

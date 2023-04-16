Daily Tip 127 25/04/2005 11:36:00

**New currency formats for UK and others**

> Some of the SAS 9.1.3 pre-production features include new National
> Language formats, including a long awaited currency format for British
> Pounds. There are a range of others, reflecting a range of currencies
> from around the world:• NLMNLAUD
>
> • NLMNLCAD
>
> • NLMNLCHF
>
> • NLMNLCNY
>
> • NLMNLDKK
>
> • NLMNLEUR
>
> • NLMNLGBP
>
> • NLMNLHKD
>
> • NLMNLILS
>
> • NLMNLJPY
>
> • NLMNLKRW
>
> • NLMNLMYR
>
> • NLMNLNOK
>
> • NLMNLNZD
>
> • NLMNLPLN
>
> • NLMNLRUR
>
> • NLMNLSEK
>
> • NLMNLSGD
>
> • NLMNLTWD
>
> • NLMNLUSD
>
> • NLMNLZAR

**Sample SAS Program**

**DATA** \_NULL\_;

x = **1234.56**;

PUT \'UK - \' @**20** x NLMNLGBP. @**40** x NLMNIGBP.

/ \'Japan - \' @**20** x NLMNLJPY. @**40** x NLMNIJPY.

/ \'Australia - \' @**20** x NLMNLAUD. @**40** x NLMNIAUD.

/ \'Euro - \' @**20** x NLMNLEUR. @**40** x NLMNIEUR.

/ \'New Zealand - \' @**20** x NLMNLNZD. @**40** x NLMNINZD. ;

**RUN**;

**Sample SAS Log**

77 DATA \_NULL\_;

78 x = 1234.56;

79 PUT \'UK - \' \@20 x NLMNLGBP. \@40 x NLMNIGBP.

80 / \'Japan - \' \@20 x NLMNLJPY. \@40 x NLMNIJPY.

81 / \'Australia - \' \@20 x NLMNLAUD. \@40 x NLMNIAUD.

82 / \'Euro - \' \@20 x NLMNLEUR. \@40 x NLMNIEUR.

83 / \'New Zealand - \' \@20 x NLMNLNZD. \@40 x NLMNINZD. ;

84 RUN;

UK - £1,234.56 GBP1,234.56

Japan - JPY1,235 JPY1,235

Australia - AU\$1,234.56 AUD1,234.56

Euro - €1,234.56 EUR1,234.56

New Zealand - NZ\$1,234.56 NZD1,234.56

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

**References**

> • VIEWS newsletter which mentions these new formats ...
> [http://www.views-uk.demon.co.uk/Newsletter/issue29.pdf]{.underline}

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

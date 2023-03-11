*  Begin EG generated code (do not edit this line);
*
*  Stored process registered by
*  Enterprise Guide Stored Process Manager v4.1
*
*  ====================================================================
*  Stored process name: extjs1
*  ====================================================================
*;


*ProcessBody;
*  End EG generated code (do not edit this line);

*ProcessBody;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css"/>
    <script type="text/javascript" src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="/ext-3.2.1/ext-all-debug.js"></script> 

    <script type="text/javascript">

        // Column Layout
        var column1 = {
            xtype:'panel',
            title: 'Column 1',
            columnWidth: .3,
            html: 'Width = 30%'
        }
        var column2 = {
            xtype: 'panel',
            title: 'Column 2',
            columnWidth: .5,
            html: 'Width = 50%'
        }
        var column3 = {
            xtype: 'panel',
            title: 'Column 3',
            width: 200,
            html: 'Width = 200px'
        }

        Ext.onReady(function() {

            var container = new Ext.Viewport({

                layout: 'column',
                defaults: {
                    bodyStyle: 'padding:10px'
                }, items: [column1, column2, column3]

            });

        });
    </script>

</head>
<body style="margin: 10px">
</body>
</html>
;;;;
run ;
%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

*  Begin EG generated code (do not edit this line);
*';*";*/;run;

*  End EG generated code (do not edit this line);

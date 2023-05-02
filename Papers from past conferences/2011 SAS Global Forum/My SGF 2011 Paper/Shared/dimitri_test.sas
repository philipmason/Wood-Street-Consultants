*ProcessBody;

/* generate html code */
data html_code;
   infile datalines4 length=l;
   input #1 htmlline $varying400. l;
datalines4;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>ExtJS Grid - SAS Dataset Example</title>
      <!-- ExtJs libraries -->
      <link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css"/>
      <script type="text/javascript" src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
      <script type="text/javascript" src="/ext-3.2.1/ext-all-debug.js"></script>
      
      <script type="text/javascript">
         Ext.onReady(function(){ /* When all ExtJS stuff is loaded we can start defining our application */
            var sasdatasetStore = new Ext.data.Store({ /* data store necessary to load data from the server */
               id : 'sasdatasetStore' /* id is a unique id of the component so we can later reference it using Ext.getCmp('sasdatasetStore') */
              ,url: 'do?_program=/CBA/dimitri_test2' /* stored process to retrieve data */
              ,reader: new Ext.data.JsonReader({ /* reader to process the json data */
                  root: 'rows', /* The property in the JSON data which contains an Array of record objects */
                  id: 'name' /* name of the value which is used as id */
               }, ['name', 'sex', 'age']) /* names of the values */
            });
            
            sasdatasetStore.load(); /* load data from server */
            
            var mainwin = new Ext.Window({ /* Create a window where we put everything, we can later reference this window with the variable name mainwin */
               xtype  : 'window' /* xtype defines the component type*/
              ,id     : 'main_win' /* id is a unique id of the component so we can later reference it using Ext.getCmp('main_win') */
              ,title  : 'ExtJS Grid - SAS Dataset Example' /* title of the window */
              ,width  : 318 /* width of the window self explainatory */
              ,height : 480 /* height of the window self explainatory */
              ,resizable: false /* configure window not to be resizable (default=true)*/
              ,layout : 'absolute' /* layout type absolute, we need to specify the positions of the components. */
              ,closeAction: 'hide' /* when we close the window it becomes hidden, so we don't need to create a new object next time we open it*/
              ,closable : true /* x mark in the top left corner to close the window (default) */
              ,items  : [ /* here we define the components in the window */
                  { /* grid to show data */
                      xtype: 'editorgrid' /* this type of grid allows you to edit the fields */
                     ,id: 'exampleGrid' /* id is a unique id of the component so we can later reference it using Ext.getCmp('exampleGrid') */
                     ,title: 'SASHELP.CLASS' /* we can put the name of the table here as a title */
                     ,height: 450
                     ,width: 304
                     ,store: sasdatasetStore /* data store containing the data */
                     ,columns: [ /* define the columns shown in the grid */
                          {
                              xtype: 'gridcolumn'
                             ,dataIndex: 'name' /* name of the variable used as an index*/
                             ,header: 'Name' /*label of the column header*/
                             ,width: 100
                             ,editor: { xtype: 'textfield' } /* we want to use a textfield as an editor */
                          }
                         ,{
                              xtype: 'gridcolumn'
                             ,dataIndex: 'sex' /* name of the variable used as an index*/
                             ,header: 'Sex' /*label of the column header*/
                             ,width: 100
                             /* we didn't specify an editor, so this field is not editable */
                          }
                         ,{
                              xtype: 'gridcolumn'
                             ,dataIndex: 'age' /* name of the variable used as an index*/
                             ,header: 'Age' /*label of the column header*/
                             ,width: 100
                             ,editor: { xtype: 'numberfield' } /* we want to use a textfield as an editor, which allows only numbers */
                          }
                      ]
                     ,sm: new Ext.grid.RowSelectionModel({ /* selection model needed to handle event when data is selected */
                         singleSelect: true /* only one row can be selected at a time */
                        ,listeners: {
                             rowselect: {
                                fn: function(sm, index, record) {
                                    /* add your code here what to do when a row is selected*/
                                }
                             }
                            ,rowdeselect: {
                                fn: function (sm, index, record) {
                                   /* add your code here what to do when a row is deselected*/
                                }
                             }
                          }
                      })
                  }
               ]
            });
            mainwin.show(); /* show the window */
         });
      </script>
      
   </head>
<body>

</body>
</html>
;;;;
run;
/* stream html code to browser */
data _null_;
   file _webout;
   set html_code;
   put htmlline;
run;
*';*";*/;run;

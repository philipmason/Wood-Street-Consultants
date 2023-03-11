*ProcessBody;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;

<html>
<head>

  <title>Chris's Help Window</title>

<link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css" />
<script src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
<script src="/ext-3.2.1/ext-all.js"></script>
   

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = 'extjs/images/s.gif';
Ext.onReady(function(){
var currenthelppage= -1;
		var pagetodisplay=0;
		var helparray = new Array();
		helparray[0]='<h1><u>Some Sample Help</u> </hi>'+
			'<br><br>'+
			'<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit,'+
			'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'+
			'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'+
			'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit'+
			'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint'+
			'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim'+
			'id est laborum.</P>';
		helparray[1]='<h1><u>Some More Sample Help</u> </hi>'+
			'<br><br>'+
			'<p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium'+
			'doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore'+
			'veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam'+
			'voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur'+
			'magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, '+
			'qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non'+
			'numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat'+
			'voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis'+
			'suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel'+
			'eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae'+
			'consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?.</p>';
		helparray[2]='<h1><u>Even More Sample Help</u><h1>'+
		'<br><br>'+
		'<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium'+
		'voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati'+
		'cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id'+
		'est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam'+
		'libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod'+
		'maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.'+
		'Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet'+
		'ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur'+
		'a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis'+
		'doloribus asperiores repellat.</p>'
		showhelp = function(pagetodisplay){
			var hwin = new Ext.Window({
				id: 'helppage'+pagetodisplay,
				title: "Help Page "+(pagetodisplay+1)+ " of "+ helparray.length,
				width: 400,
				height: 320,
				renderTo: Ext.getBody(),
				layout: 'fit',
				closable: false,
				autoscroll: true,
				resizable: false,
				minimizable: false,
				maximizable: false,
				draggable: true,
				items:[{
					html: helparray[pagetodisplay],
					bodyStyle: "padding:8px"
				}],
				bbar: [
				{
				xtype: "button",
				text: "Previous Page",
				handler: function(){
						if (currenthelppage>0){
							showhelp(currenthelppage-1);
						}
					}
					
				},
				"-",
				{
				xtype: "button",
				text: "Next Page",
				handler: function(){
						if (currenthelppage<(helparray.length-1)){
							showhelp(currenthelppage+1);
						}
					}
				},
				"-",
				{
				xtype: "button",
				text: "Close Help",
				handler: function(){
					Ext.getCmp("helppage"+currenthelppage).close();
					currenthelppage= -1;
					}
				}
				
			]
			}).show();
			//hwin.show();
			if (currenthelppage != -1) {
				Ext.get("helppage"+currenthelppage).fadeOut({
					duration: 1,
					remove: true
				})
			}
			Ext.get("helppage"+pagetodisplay).fadeIn({
				duration: 1
				});
			currenthelppage=pagetodisplay;
			
		}
		var nwin = new Ext.Window({
			title: "Sample Window",
			id: "sampwin",
			width:600,
			height: 500,
			renderTo: Ext.getBody(),
			html: "Some stuff",
			tbar: [{
				text: "Help",
				handler: function(){
					showhelp(pagetodisplay);
				}
				
			}
			]
			
		});
		nwin.show();
		
	});
	</script>
</head>

<body>

</body>
</html>

;;;;
run ;
%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;

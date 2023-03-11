/**
@file
#### Examples ####
@code
   Proc Print data=sashep.class ; run ;
@endcode
*/
/**
 @file
 @brief dummy program a

 Implicit detailed description since it comes after a blank line following @brief. Called from b.sas
  @dot['My little diagram']
 digraph example {
     node [shape=record, fontname=Helvetica, fontsize=10];
     b [ label="class B"];
     c [ label="class C"];
     b -> c [ arrowhead="open", style="dashed" ];
 }
 @enddot
 @dot
 digraph D {

   subgraph cluster_p {
     label = "Parent";

     subgraph cluster_c1 {
       label = "Child one";
       a;

       subgraph cluster_gc_1 {
         label = "Grand-Child one";
         b;
       }
       subgraph cluster_gc_2 {
         label = "Grand-Child two";
           c;
           d;
       }

     }

     subgraph cluster_c2 {
       label = "Child two";
       e;
     }
   }
 } 
 @enddot
**/
proc print data=sashelp.class;
run;
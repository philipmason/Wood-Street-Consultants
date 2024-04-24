PROC SQL; 
   CREATE TABLE WORK.QUERY_FOR_ORSALES AS  
   SELECT t1.Year,  
          t1.Quarter,  
          t1.Product_Line,  
          t1.Product_Category,  
          t1.Product_Group,  
          t1.Quantity,  
          t1.Profit,  
          t1.Total_Retail_Price 
      FROM SASHELP.ORSALES t1
		%sysfunc(ifc(%sysfunc(lengthn("&product_line"))>2,where product_line="&product_line",)) ; 
QUIT; 

proc gchart ;
	hbar product_category / subgroup=year sumvar=profit ;
run ;

proc print ;
run ;
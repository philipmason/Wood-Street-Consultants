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
      FROM SASHELP.ORSALES t1;
QUIT;
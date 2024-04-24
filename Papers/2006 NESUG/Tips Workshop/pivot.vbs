Set XL = CreateObject("Excel.Application")
XL.Visible=True
XL.Workbooks.Open "c:\workshop\hw06\class.xls"
Xllastcell= xl.cells.specialcells(11).address
XL.Sheets.Add.name = "PivotTable"
xldata="class"
XL.Sheets(xldata).select
XL.ActiveSheet.PivotTableWizard SourceType=xlDatabase,XL.Range("A1" & ":" & xllastcell),"Pivottable!R1C1",xldata

XL.ActiveSheet.PivotTables(xldata).PivotFields("Name").Orientation = 1
XL.ActiveSheet.PivotTables(xldata).PivotFields("Age").Orientation = 1
XL.ActiveSheet.PivotTables(xldata).PivotFields("Sex").Orientation = 1
XL.ActiveSheet.PivotTables(xldata).PivotFields("Height").Orientation = 4
XL.ActiveWorkbook.ShowPivotTableFieldList = False

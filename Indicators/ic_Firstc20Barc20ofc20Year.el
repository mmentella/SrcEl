condition1 = BarType <> 5 and Year( Date ) <> Year( Date[1] ) ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "FirstBar-Y" ) ;
	Alert ;
	end ;

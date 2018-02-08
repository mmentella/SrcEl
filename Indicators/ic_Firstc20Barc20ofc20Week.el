condition1 = BarType < 3 and DayOfWeek( Date ) < DayOfWeek( Date[1] ) ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "FirstBar-W" ) ;
	Alert ;
	end ;

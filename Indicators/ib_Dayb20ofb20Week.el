inputs: DayOfWk( Monday ) ;

condition1 = DayOfWeek( Date ) = DayOfWk ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "DoW" ) ;
	Alert ;
	end ;

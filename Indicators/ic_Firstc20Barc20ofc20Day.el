
condition1 = BarType <= 1 or BarType >= 5 and Date <> Date[1] ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "FirstBar-D" ) ;
	Alert ;
	end ;

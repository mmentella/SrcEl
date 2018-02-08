condition1 = BarType < 4 and Month( Date ) <> Month( Date[1] ) ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "FirstBar-M" ) ;
	Alert ;
	end ;

inputs: Length( 14 ) ;

condition1 = AverageFC( Close, Length ) > AverageFC( Open, Length ) ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "AvgC>AvgO" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;

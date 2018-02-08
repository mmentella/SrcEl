inputs: Price( Close ), Length( 14 ) ;

condition1 = Price > AverageFC( Price, Length ) ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "Pr>Avg" ) ;
	Alert ;
	end
else 
	NoPlot( 1 ) ;

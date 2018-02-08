inputs: Price( Close ), Length( 14 ), PctUp( 2 ) ;

condition1 = RateOfChange( Price, Length ) >= PctUp ;
if condition1 then
	begin
	PlotPaintBar( High, Low, "%Incr" ) ;
	Alert ;
	end
else 
	NoPlot( 1 ) ;

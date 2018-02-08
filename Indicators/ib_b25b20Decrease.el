inputs: Price( Close ), Length( 14 ), PctDn( -2 ) ;

condition1 = RateOfChange( Price, Length ) <= PctDn ;
if condition1 then
	begin
	PlotPaintBar( High, Low, "%Decr" ) ;
	Alert ;
	end
else 
	NoPlot( 1 ) ;

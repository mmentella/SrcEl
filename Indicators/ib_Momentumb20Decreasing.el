inputs: Price( Close ), MomLength( 14 ), MomAvgLength( 14 ) ;
variables: var0( 0 ) ;

var0 = Average( Momentum( Close, MomLength ), MomAvgLength ) ;

If var0 < var0[1] then 
	begin
	PlotPaintBar( High, Low, "MomDecr" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;

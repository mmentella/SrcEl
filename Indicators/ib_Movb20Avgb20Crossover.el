inputs: 
	Price( Close ), 
	FastLength( 7 ), 
	SlowLength( 14 ), 
	UpColor( Cyan ), 
	DnColor( Blue ) ;

variables: 
	var0( 0 ), 
	var1( 0 ) ;

var0 = Average( Price, FastLength ) ;
var1 = Average( Price, SlowLength ) ;

if var0 > var1 then 
	begin
	PlotPaintBar( High, Low, "MACross", UpColor ) ;
	Alert( "FastAvg above SlowAvg" ) ;
	end
else if var0 < var1 then
	begin
	PlotPaintBar( High, Low, "MACross", DnColor ) ;
	Alert( "FastAvg below SlowAvg" ) ;
	end
else
	NoPlot( 1 ) ;

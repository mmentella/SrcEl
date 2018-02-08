[IntrabarOrderGeneration = false]
inputs: ATRLength( 10 ), NumATRs( 3 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = AvgTrueRange( ATRLength ) * NumATRs ;
var1 = MarketPosition ;

if var1 = 1 then 
	begin
	condition1 = var1[1] <> 1 or High > var2 ;
	if condition1 then 
		var2 = High ;
	Sell ( "AtrLX" ) next bar at var2 - var0 stop ;
	end
else
	Sell ( "AtrLX-eb" ) next bar at High - var0 stop ;

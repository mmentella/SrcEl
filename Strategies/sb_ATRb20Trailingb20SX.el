[IntrabarOrderGeneration = false]
inputs: ATRLength( 10 ), NumATRs( 3 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = AvgTrueRange( ATRLength ) * NumATRs ;
var1 = MarketPosition ;

if var1 = -1 then 
	begin
	condition1 = var1[1] <> -1 or Low < var2 ;
	if condition1 then 
		var2 = Low ;
	Buy To Cover ( "AtrSX" ) next bar at var2 + var0 stop ;
	end
else
	Buy To Cover ( "AtrSX-eb" ) next bar at Low + var0 stop ;

[IntrabarOrderGeneration = false]
inputs: 
	ATRLength( 5 ), 
	NumATRs( 2 ), 
	NumBars( 5 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ) ;

var0 = MarketPosition ;

if var0 = 1 then 
	begin
	if var0[1] <> 1 then 
		var1 = EntryPrice + AvgTrueRange( ATRLength ) * NumATRs ;
	if BarsSinceEntry < NumBars then 
		Sell ( "ATTLX-Tgt" ) next bar at var1 limit 
	else 
		Sell ( "ATTLX-Trl" ) next bar at Low stop ;
	end ;

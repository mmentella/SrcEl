[IntrabarOrderGeneration = false]
inputs: 
	ATRLength( 5 ), 
	NumATRs( 2 ), 
	NumBars( 5 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ) ;

var0 = MarketPosition ;

if var0 = -1 then 
	begin
	if var0[1] <> -1 then 
		var1 = EntryPrice - AvgTrueRange( ATRLength ) * NumATRs ;
	if BarsSinceEntry < NumBars then 
		Buy To Cover ( "ATTSX-Tgt" ) next bar at var1 limit 
	else 
		Buy To Cover ( "ATTSX-Trl" ) next bar at High stop ;
	end ;

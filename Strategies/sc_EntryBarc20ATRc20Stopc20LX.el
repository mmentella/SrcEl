[IntrabarOrderGeneration = false]
inputs: ATRLength( 5 ), NumATRs( 1 ) ;

if MarketPosition <> 1 then
	Sell ( "EbAtrLX" ) next bar at Close - AvgTrueRange( ATRLength ) * NumATRs stop ;

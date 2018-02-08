[IntrabarOrderGeneration = false]
inputs: ATRLength( 5 ), NumATRs( 1 ) ;

if MarketPosition <> -1 then
	Buy To Cover ( "EbAtrSX" ) next bar at Close + AvgTrueRange( ATRLength ) * 
	 NumATRs stop ;

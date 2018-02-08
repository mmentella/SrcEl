[IntrabarOrderGeneration = false]
inputs: DollarRisk( 1 ) ;                              
variables: var0( DollarRisk / BigPointValue ) ;

if MarketPosition <> -1 then
	Buy To Cover ( "EbDlrSX" ) next bar at Close + var0 stop ;

[IntrabarOrderGeneration = false]
inputs:  RiskPoints( 10 ) ;                                           

if MarketPosition <> -1 then
	Buy To Cover ( "EbPntSX" ) next bar at Close + RiskPoints points stop ;

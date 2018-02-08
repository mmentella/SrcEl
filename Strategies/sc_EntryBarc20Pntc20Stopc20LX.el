[IntrabarOrderGeneration = false]
inputs:  RiskPoints( 10 ) ;                                           

if MarketPosition <> 1 then
	Sell ( "EbPntLX" ) next bar at Close - RiskPoints points stop ;

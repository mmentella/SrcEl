inputs: StopLossPct( .05 ) ;                               

SetStopShare ;
if MarketPosition = 1 then 
	SetStopLoss( EntryPrice * StopLossPct ) 
else 
	Sell ( "PctStopLX-eb" ) next bar at Close * ( 1 - StopLossPct ) stop ;

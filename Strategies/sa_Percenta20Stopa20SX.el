inputs: StopLossPct( .05 ) ;                               

SetStopShare ;
if MarketPosition = -1 then 
	SetStopLoss( EntryPrice * StopLossPct ) 
else 
	Buy To Cover ( "PctStopSX-eb" ) next bar at Close * ( 1 + StopLossPct ) stop ;

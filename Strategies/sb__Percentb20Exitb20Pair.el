inputs: 
	ProfitTargetPct( .10 ),                                                
	StopLossPct( .05 ) ;                                            

	                              

SetStopShare ;
if MarketPosition <> 0 then                                            
	begin
	if ProfitTargetPct > 0 then
		SetProfitTarget( EntryPrice * ProfitTargetPct ) ;
	if StopLossPct > 0 then
		SetStopLoss( EntryPrice * StopLossPct ) ;
	end
else                                              
	begin
	if ProfitTargetPct > 0 then
		SetProfitTarget( Close * ProfitTargetPct ) ;
	if StopLossPct > 0 then
		SetStopLoss( Close * StopLossPct ) ;
	end ;

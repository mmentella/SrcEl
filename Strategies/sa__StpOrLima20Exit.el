[IntrabarOrderGeneration = false]
inputs: 
	SellOrCover( 1 ),                                                  
	StopOrLimit( 1 ),                                                  
	TriggerPrice( 100 ),                              
	ExitQuantity( 1000 ) ;

condition1 = SellOrCover = 1 and StopOrLimit = 1 ;
if condition1 then
	Sell ExitQuantity shares next bar at TriggerPrice stop 
else
begin
	condition1 = SellOrCover = 1 and StopOrLimit <> 1 ;
	 if condition1 then
		Sell ExitQuantity shares next bar at TriggerPrice limit 
	else 
	begin 
		condition1 = SellOrCover <> 1 and StopOrLimit = 1 ;
		if condition1 then
			Buy To Cover ExitQuantity shares next bar at TriggerPrice stop 
		else 
		begin 
			condition1 = SellOrCover <> 1 and StopOrLimit <> 1 ;		
			if condition1 then
				Buy To Cover ExitQuantity shares next bar at TriggerPrice limit ;
		end;
	end;
end;

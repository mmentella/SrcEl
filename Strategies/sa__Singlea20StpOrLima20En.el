inputs: 
	LongOrShort( 1 ),                                        
	StopOrLimit( 1 ),                                                    
	DayOrGTF( 1 ),                                                    
	TriggerPrice( 100 ),                              
	Quantity( 1000 ), 
	EffectiveBarDate_YYMMDD( 030102 ),                                             
	                   
	EffectiveBarTime_HHMM( 1300 ) ;                                              
	                                                                             
	                         

variables:
	var0( iff( EffectiveBarDate_YYMMDD < 500000, EffectiveBarDate_YYMMDD 
	 + 1000000, EffectiveBarDate_YYMMDD ) ), 
	var1( false ), 
	var2( false ), 
	var3( false ), 
	var4( false ) ;

var1 = Date next bar = var0 and ( BarType = 2 or 
 ( BarType = 1 and Time next bar >= EffectiveBarTime_HHMM ) ) ;
var2 = Date next bar > var0 ;

if DayOrGTF = 1 then 
	var3 = var1 
else 
	var3 = var1 or var2 ;

if var3 then 
begin
	condition1 = LongOrShort = 1 and StopOrLimit = 1 ;
	if condition1 then
		begin
			condition1 = var4 = false and var3[1] and High >= TriggerPrice ;
			if condition1 then 
				var4 = true ;				                                          
			if var4 = false then
				Buy Quantity shares next bar at TriggerPrice stop ;
		end 
	else 
	begin
		condition1 = LongOrShort = 1 and StopOrLimit <> 1 ;
		if condition1 then
		begin
			condition1 = var4 = false and var3[1] and Low <= TriggerPrice ;
			if condition1 then 
				var4 = true ;
			if var4 = false then
				Buy Quantity shares next bar at TriggerPrice limit ;
		end 
		else 
		begin
			condition1 = LongOrShort <> 1 and StopOrLimit = 1 ;
			if condition1 then
				begin
					condition1 = var4 = false and var3[1] and Low <= TriggerPrice ;
					if condition1 then 
						var4 = true ;
					if var4 = false then
						Sell Short Quantity shares next bar at TriggerPrice stop ;
				end 
			else 
			begin 
				condition1 = LongOrShort <> 1 and StopOrLimit <> 1 ;
				if condition1 then
				begin
					condition1 = var4 = false and var3[1] and High >= TriggerPrice ;
					if condition1 then 
						var4 = true ;
					if var4 = false then
						Sell Short Quantity shares next bar at TriggerPrice limit ;
				end ;
			end;
		end;
	end;
end;

[IntrabarOrderGeneration = false]
inputs: 
	MyEntryPrice( 100 ),                               
	Quantity( 1000 ),                                          
	LongOrShort( 1 ),                                                  
	PrevBarDate_YYMMDD( 050102 ),                                           
	PrevBarTime_HHMM( 1300 ) ,                                                  
	                                                                    
	                                                                           
	OpenPriceEntryBar( 0 ) ;                                                       		
variables:
	var0( true ), 
	var1( iff( PrevBarDate_YYMMDD < 500000, PrevBarDate_YYMMDD + 1000000, 
	 PrevBarDate_YYMMDD ) ) ;                                                   
	          
condition1 = var0 and Date = var1 and ( BarType = 2 or ( BarType = 1 and Time = PrevBarTime_HHMM ) ) ;
if condition1 then begin
	condition2 = getappinfo(aistrategyauto) = 1;
	if condition2 then
		ChangeMarketPosition(iff(LongOrShort = 1, 1, -1) * Quantity, MyEntryPrice, "")
	else
	if LongOrShort = 1 then
		if MyEntryPrice > OpenPriceEntryBar then 
			Buy Quantity shares next bar at MyEntryPrice stop 
		else
			Buy Quantity shares next bar at MyEntryPrice limit
	else
		if MyEntryPrice < OpenPriceEntryBar then 
			Sell Short Quantity shares next bar at MyEntryPrice stop 
		else
			Sell Short Quantity shares next bar at MyEntryPrice limit ;
end;
condition1 = var0 = true and LastBarOnChart;
if condition1 then var0 = false;

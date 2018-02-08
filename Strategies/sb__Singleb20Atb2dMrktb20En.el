inputs: 
	LongOrShort( 1 ),                                        
	Quantity( 1000 ), 
	EntryBarDate_YYMMDD( 030102 ),                                                    
	EntryBarTime_HHMM( 1300 ) ;                                                    
	                                                                                 
	                                                       

variables:
	var0( iff( EntryBarDate_YYMMDD < 500000, EntryBarDate_YYMMDD + 1000000, 
	 EntryBarDate_YYMMDD ) ) ;

condition1 = Date next bar = var0 
	and ( BarType = 2 or ( BarType = 1 and Time next bar = EntryBarTime_HHMM ) ) ;

if condition1
then
	if LongOrShort = 1 then
		Buy Quantity shares next bar at market 
	else
		Sell Short Quantity shares next bar at market ;

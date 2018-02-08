[IntrabarOrderGeneration = false]
inputs: 
	TLRef( 1 ) ;                                                                      
	                  

variables: 
	var0( TL_GetBeginDate( TLRef ) ), 
	var1( TL_GetBeginTime( TLRef ) ), 
	var2( false ) ;

var2 = ( Date = var0 and ( BarType = 2 or ( BarType = 1 and Time >= var1 ) ) ) 
 or Date > var0 ;

condition1 = var2 and Low > TL_GetValue( TLRef, Date, Time ) ;
if condition1 then
	Sell Short next bar at TL_GetValue( TLRef, Date next bar, Time next bar ) stop ;

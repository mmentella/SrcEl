inputs: Price( Close ), Length( 9 ), ConfirmBars( 1 ) ;
variables: var0( 0 ) ;

condition1 = Price > AverageFC( Price, Length ) ;
if condition1 then 
	var0 = var0 + 1 
else
	var0 = 0 ;

condition1 = CurrentBar > ConfirmBars and var0 = ConfirmBars ;
if condition1 then                       
	Buy ( "MACrossLE" ) next bar at market ;

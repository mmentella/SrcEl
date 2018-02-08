inputs: Price( Close ), Length( 9 ) ;
variables: var0( 0 ) ;

var0 = AverageFC( Price, Length ) ;

condition1 = CurrentBar > 1 and Price crosses over var0 ;
if condition1 then                                                                    
	Buy To Cover ( "MACrossSX" ) next bar at market ;

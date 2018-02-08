inputs:  Price( Close ), Length( 14 ), OverSold( 30 ) ;
variables:  var0( 0 ) ;

var0 = RSI( Price, Length ) ;

condition1 = Currentbar > 1 and var0 crosses over OverSold ;
if condition1 then                                                                    
	Buy ( "RsiLE" ) next bar at market ;

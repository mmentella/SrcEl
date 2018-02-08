inputs: Price( Close ), FastLength( 9 ), SlowLength( 18 ) ;
variables: var0( 0 ), var1( 0 ) ;

var0 = AverageFC( Price, FastLength ) ;
var1 = AverageFC( Price, SlowLength ) ;

condition1 = CurrentBar > 1 and var0 crosses over var1 ;
if condition1 then                                                                    
	Buy ( "MA2CrossLE" ) next bar at market ;

inputs:  Price( Close ), FastLength( 4 ), MedLength( 9 ), SlowLength( 18 ) ;
variables:  var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = AverageFC( Price, FastLength ) ;
var1 = AverageFC( Price, MedLength ) ;
var2 = AverageFC( Price, SlowLength ) ;

Condition1 = Price > var0 and var0 > var1 and var1 > var2 ;

condition2 = CurrentBar > 1 and Condition1 and Condition1[1] = false;
if condition2                                                                     
then
	Buy ( "MA3CrsLE" ) next bar at market ;

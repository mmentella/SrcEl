inputs: Price( Close ), FastLength( 9 ), SlowLength( 18 ) ;
variables: var0( 0 ), var1( 0 ) ;

var0 = AverageFC( Price, FastLength ) ;
var1 = AverageFC( Price, SlowLength ) ;

condition1 = CurrentBar > 1 and var0 crosses under var1 ;
if condition1 then                                                                    
	Sell Short ( "MA2CrossSE" ) next bar at market ;

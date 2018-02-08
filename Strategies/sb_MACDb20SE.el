inputs:  FastLength( 12 ), SlowLength( 26 ), MACDLength( 9 ) ;
variables:  var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = MACD( Close, FastLength, SlowLength ) ;
var1 = XAverage( var0, MACDLength ) ;
var2 = var0 - var1 ;

condition1 = CurrentBar > 2 and var2 crosses under 0 ;
if condition1 then                                   
	Sell Short ( "MacdSE" ) next bar at market ;

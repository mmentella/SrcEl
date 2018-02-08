inputs:  Price( Close ), Length( 14 ), OverBought( 70 ) ;
variables:  var0( 0 ) ;

var0 = RSI( Price, Length ) ;

condition1 = Currentbar > 1 and var0 crosses under OverBought ;
if condition1 then                                                                    
	Sell Short ( "RsiSE" ) next bar at market ;

inputs: Length( 14 ), OverBought( 80 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ) ;

Value1 = Stochastic( H, L, C, Length, 3, 3, 1, var0, var1, var2, var3 ) ;

condition1 = CurrentBar > 2 and var2 crosses under var3 and var2 > OverBought ;
if condition1 then                                                     
	Sell Short ( "StochSE" ) next bar at market ;

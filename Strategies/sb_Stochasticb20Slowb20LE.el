inputs: Length( 14 ), OverSold( 20 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ) ;

Value1 = Stochastic( H, L, C, Length, 3, 3, 1, var0, var1, var2, var3 ) ;

condition1 = CurrentBar > 2 and var2 crosses over var3 and var2 < OverSold ;
if condition1 then                                                     
	Buy ( "StochLE" ) next bar at market ;

inputs: AfStep( 0.02), AfLimit( 0.2 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ), var4( "" ) ;

Value1 = ParabolicSAR( AfStep, AfLimit, var0, var1, var2, var3 ) ;

Plot1( var0, "ParCl" ) ;

                  
if var3 = 1 then 
		Alert( "Bullish reversal" ) 
else if var3 = -1 then 
		Alert( "Bearish reversal" ) ;

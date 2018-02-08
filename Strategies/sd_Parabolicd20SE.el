[IntrabarOrderGeneration = false]
inputs:  AfStep( 0.02 ), AfLimit( 0.2 ) ;
variables:  var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ) ;

Value1 = ParabolicSAR( AfStep, AfLimit, var0, var1, var2, var3 ) ;

if var2 = 1 then
	Sell Short ( "ParSE" ) next bar at var1 stop ;

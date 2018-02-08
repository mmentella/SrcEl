[IntrabarOrderGeneration = false]
inputs:  Price( Close ), Length( 12 ) ; ;
variables:  var0( 0 ), var1( 0 ) ;

var0 = Momentum( Price, Length ) ;
var1 = Momentum( var0, 1 ) ;                       

condition1 = var0 > 0 and var1 > 0 ;
if condition1 then
	Buy ( "MomLE" ) next bar at High + 1 point stop ;

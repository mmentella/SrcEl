[IntrabarOrderGeneration = false]
inputs: Length( 1 ) ;

condition1 = Low < Lowest( Low, Length )[1] and Close > Close[1] ;
if condition1 then
	Buy ( "KeyRevLE" ) next bar at market ;

[IntrabarOrderGeneration = false]
inputs: Price( Low ), LeftStrength( 4 ), RightStrength( 2 ) ;

condition1 = PivotLowVS( 1, Price, LeftStrength, RightStrength, RightStrength + 1 ) <> -1 ;
if condition1 then
	Buy ( "PivExtLE" ) next bar at market ;

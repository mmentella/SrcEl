[IntrabarOrderGeneration = false]
inputs: Price( High ), LeftStrength( 4 ), RightStrength( 2 ) ;

condition1 = PivotHighVS( 1, Price, LeftStrength, RightStrength, RightStrength + 1 ) <> -1 ;
if condition1 then
	Sell Short ( "PivExtSE" ) next bar at market ;

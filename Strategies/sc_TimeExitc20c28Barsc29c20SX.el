[IntrabarOrderGeneration = false]
inputs: BarToExitOn( 5 ) ;                               

if BarsSinceEntry = BarToExitOn then
	Buy To Cover ( "TimeBarsSX" ) next bar at market ;

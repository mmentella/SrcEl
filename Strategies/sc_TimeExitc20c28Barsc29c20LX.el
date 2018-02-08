[IntrabarOrderGeneration = false]
inputs: BarToExitOn( 5 ) ;                               

if BarsSinceEntry = BarToExitOn then
	Sell ( "TimeBarsLX" ) next bar at market ;

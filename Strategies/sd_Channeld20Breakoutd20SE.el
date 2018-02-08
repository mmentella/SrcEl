[IntrabarOrderGeneration = false]
input: Price( Low ), Length( 20 ) ;

Sell Short ( "ChBrkSE" ) next bar at LowestFC( Price, Length ) - 1 point stop ;

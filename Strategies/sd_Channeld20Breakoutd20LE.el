[IntrabarOrderGeneration = false]
input: Price( High ), Length( 20 ) ;

Buy ( "ChBrkLE" ) next bar at HighestFC( Price, Length ) + 1 point stop ;

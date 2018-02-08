[IntrabarOrderGeneration = false]
inputs: Length( 4 ), NumRanges( 1.2 ) ;

Buy ( "VltOpnLE" ) next bar at Open next bar + Average( Range, Length ) * NumRanges 
 stop ;

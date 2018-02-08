[IntrabarOrderGeneration = false]
inputs: Length( 5 ), NumATRs( .75 ) ;

Buy ( "VltClsLE" ) next bar at Close + AvgTrueRange( Length ) * NumATRs stop ;

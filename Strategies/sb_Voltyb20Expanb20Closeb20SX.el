[IntrabarOrderGeneration = false]
inputs: Length( 5 ), NumATRs( 1.5 ) ;

Buy To Cover ( "VltClsSX" ) next bar at Close + AvgTrueRange( Length ) * NumATRs 
 stop ;

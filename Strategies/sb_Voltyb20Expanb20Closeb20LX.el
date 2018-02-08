[IntrabarOrderGeneration = false]
inputs: Length( 5 ), NumATRs( 1.5 ) ;

Sell ( "VltClsLX" ) next bar at Close - AvgTrueRange( Length ) * NumATRs stop ;

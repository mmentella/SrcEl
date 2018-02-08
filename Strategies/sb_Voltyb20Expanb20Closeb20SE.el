[IntrabarOrderGeneration = false]
inputs: Length( 5 ), NumATRs( .75 ) ;

Sell Short ( "VltClsSE" ) next bar at Close - AvgTrueRange( Length ) * NumATRs stop ;

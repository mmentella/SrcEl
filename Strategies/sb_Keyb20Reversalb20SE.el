[IntrabarOrderGeneration = false]
inputs: Length( 1 ) ;

condition1 = High > Highest( High, Length )[1] and Close < Close[1] ;
if condition1 then
	Sell Short ( "KeyRevSE" ) next bar at market ;

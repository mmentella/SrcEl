[IntrabarOrderGeneration = false]
inputs:  Price( Close ), ConsecutiveBarsDown( 3 ) ;

if Price < Price[1] then
	Value1 = Value1 + 1                                                     
	                                                                  
else
	Value1 = 0 ;

if Value1 >= ConsecutiveBarsDown then
	Sell Short ( "ConsDnSE" ) next bar at market ;

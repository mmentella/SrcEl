inputs:	 Price( Close ), ConsecutiveBarsDown( 3 ) ;

if Price < Price[1] then
	Value1 = Value1 + 1                                                     
	                                                                  
else
	Value1 = 0 ;

if Value1 >= ConsecutiveBarsDown then
	begin
	Plot1( Low, "ConsecDn" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;

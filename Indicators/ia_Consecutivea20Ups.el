inputs:  Price( Close ), ConsecutiveBarsUp( 3 ) ;

if Price > Price[1] then
	Value1 = Value1 + 1                                                     
	                                                                
else
	Value1 = 0 ;

if Value1 >= ConsecutiveBarsUp then
	begin
	Plot1( High, "ConsecUp" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;
	
if GetAppInfo( aiRealTimeCalc ) = 1 then                                           
	begin
	var0 = InsideBid ;
	var1 = InsideAsk ;
	Plot1( var0, "Bid" ) ;
	Plot2( var1, "Ask" ) ;
	end ;

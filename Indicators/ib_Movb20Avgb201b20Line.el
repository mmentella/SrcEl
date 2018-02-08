inputs:  Price( Close ), Length( 9 ), Displace( 0 ) ;
variables:  var0( 0 ) ;
	
var0 = AverageFC( Price, Length ) ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var0, "Avg" ) ;

	                  
	if Displace <= 0 then 
		begin
		condition1 = Price crosses over var0 ;
		if condition1 then
			Alert( "Price crossing over average" ) 
		else 
		begin 
		condition1 =	Price crosses under var0 ;
		if condition1 then
			Alert( "Price crossing under average" ) ;
		end ;
		end;
	end ;

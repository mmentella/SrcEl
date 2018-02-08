inputs:
	Price( Close ),
	FastLength( 9 ),
	SlowLength( 18 ),
	Displace( 0 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = AverageFC( Price, FastLength ) ;
var1 = AverageFC( Price, SlowLength ) ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var0, "FastAvg" ) ;
	Plot2[Displace]( var1, "SlowAvg" ) ;

	                  
	if Displace <= 0 then 
		begin
		condition1 = var0 crosses over var1 ;
		if condition1 then
			Alert( "Bullish alert" ) 
		else 
		begin
		condition1 = var0 crosses under var1 ; 
		if condition1 then
			Alert( "Bearish alert" ) ;
		end ;
		end;
	end ;

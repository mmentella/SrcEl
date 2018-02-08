inputs:  
	Price( Close ), 
	FastLength( 4 ), 
	MedLength( 9 ), 
	SlowLength( 18 ), 
	Displace( 0 ) ;

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ) ;

var0 = AverageFC( Price, FastLength ) ;
var1 = AverageFC( Price, MedLength ) ;
var2 = AverageFC( Price, SlowLength ) ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var0, "FastAvg" ) ;
	Plot2[Displace]( var1, "MedAvg" ) ;
	Plot3[Displace]( var2, "SlowAvg" ) ;

	                  
	if Displace <= 0 then 
		begin		
		Condition1 = Price > var0 and var0 > var1 and var1 > var2 ;
		if Condition1 and Condition1[1] = false then
			Alert( "Bullish alert" ) 
		else 
			begin
			Condition2 = Price < var0 and var0 < var1 and var1 < var2 ;
			if Condition2 and Condition2[1] = false then
				Alert( "Bearish alert" ) ;
			end ;
		end ;
	end ;

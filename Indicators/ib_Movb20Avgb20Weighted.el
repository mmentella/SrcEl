inputs:
	Price( Close ),
	Length( 9 ),
	Displace( 0 ) ;

variables:
	var0( 0 ) ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	var0 = WAverage( Price, Length ) ;
	Plot1[Displace]( var0, "AvgWtd" ) ;

	                  
	if Displace <= 0 then 
		begin
		condition1 = Price > var0 and var0 > var0[1] and var0[1] <= var0[2] ;
		if condition1 then
			Alert( "Indicator turning up" ) 
		else 
		begin
		condition1 = Price < var0 and var0 < var0[1] and var0[1] >= var0[2] ; 
		if condition1 then
			Alert( "Indicator turning down" ) ;
		end ;
		end;
	end ;

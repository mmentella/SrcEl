inputs:  Price( Close ), Length( 20 ), NumATRs( 1.5 ), Displace( 0 ) ;
variables:  var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ) ;

var0 = AverageFC( Price, Length ) ;
var1 = NumATRs * AvgTrueRange( Length ) ;
var3 = var0 + var1 ;
var2 = var0 - var1 ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var3, "UpperBand" ) ;
	Plot2[Displace]( var2, "LowerBand" ) ;
	Plot3[Displace]( var0, "MidLine" ) ;

	                  
	if Displace <= 0 then
		begin
		condition1 = Price crosses over var3 ;
		if condition1 then
			Alert( "Price crossing over upper band" ) 
		else 
		begin
		condition1 = Price crosses under var2 ; 
		if condition1 then
			Alert( "Price crossing under lower band" ) ;
		end ;
		end;
	end ;

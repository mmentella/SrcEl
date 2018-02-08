inputs:
	BollingerPrice( Close ),
	TestPriceUBand( Close ),
	TestPriceLBand( Close ),
	Length( 20 ),
	NumDevsUp( 2 ),
	NumDevsDn( -2 ),
	Displace( 0 ) ;

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;

var0 = AverageFC( BollingerPrice, Length ) ;
var1 = StandardDev( BollingerPrice, Length, 1 ) ;
var3 = var0 + NumDevsUp * var1 ;
var2 = var0 + NumDevsDn * var1 ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var3, "UpperBand" ) ;
	Plot2[Displace]( var2, "LowerBand" ) ;
	Plot3[Displace]( var0, "MidLine" ) ;

	                  
	if Displace <= 0 then
		begin
		condition1 = TestPriceLBand crosses over var2 ;
		if condition1 then
			Alert( "Price crossing over lower price band" ) 
		else 
		begin 
		condition1 = TestPriceUBand crosses under var3 ;
		if condition1 then
			Alert( "Price crossing under upper price band" ) ;
		end;
		end ;
	end ;

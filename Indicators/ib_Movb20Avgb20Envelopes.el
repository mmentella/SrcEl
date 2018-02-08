inputs: 
	PriceH( Close ), 
	PriceL( Close ), 
	Length( 20 ), 
	PctAbove( 1 ), 
	PctBelow( 1 ), 
	Displace( 0 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 1 - ( PctBelow * .01 ) ) , 
	var3( 1 + ( PctAbove * .01 ) ) ;

var0 = AverageFC( PriceL, Length ) * var2 ;
var1 = AverageFC( PriceH, Length ) * var3 ; 

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var1, "UpperBand" ) ;
	Plot2[Displace]( var0, "LowerBand" ) ;

	                  
	if Displace <= 0 then
		begin
		condition1 = PriceL crosses over var0 ;
		if condition1 then
			Alert( "Price crossing over lower price band" ) 
		else 
		begin
		condition1 = PriceH crosses under var1 ; 
		if condition1 then
			Alert( "Price crossing under upper price band" ) ;
		end ;
		end;
	end ;

inputs: 
	Price( Close ), 
	LinRegLength( 21 ), 
	SmoothingLength( 3 ), 
	Displace( 0 ) ;

variables: 
	var0( 0 ),
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ) ;

var0 = LinearRegValue( Price, LinRegLength, 0 ) ;
var1 = Average( var0, SmoothingLength ) ;
var2 = Average( StdError( Price, LinRegLength ), SmoothingLength ) ;
var3 = var1 - var2 ;
var4 = var1 + var2 ;

condition1 = ( Displace >= 0 or CurrentBar > AbsValue( Displace ) ) and CurrentBar >= SmoothingLength ;
if condition1 then 
	begin
	Plot1[Displace]( var4, "UpperBand" ) ;
	Plot2[Displace]( var3, "LowerBand" ) ;
	Plot3[Displace]( var1, "MidLine" ) ;

	                  
	if Displace <= 0 then
		begin
		condition1 = Price crosses over var3 ;
		if condition1 then
			Alert( "Price crossing over lower price band" ) 
		else 
			begin 
			condition1 = Price crosses under var4 ;
			if condition1 then
				Alert( "Price crossing under upper price band" ) ;
			end;
		end ;
	end ;

inputs: 
	PriceH( High ),  
	PriceL( Low ), 
	PriceC( Close ), 
	StochLength( 14 ), 
	SmoothingLength1( 3 ),                                        
	SmoothingLength2( 3 ),                                
	SmoothingType( 1 ),                                         
	OverSold( 20 ), 
	OverBought( 80 ) ; 

variables:
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ) ;

Value1 = Stochastic( PriceH, PriceL, PriceC, StochLength, SmoothingLength1, 
 SmoothingLength2, SmoothingType, var0, var1, var2, var3 ) ;

Plot1( var0, "FastK" ) ;
Plot2( var1, "FastD") ;
Plot3( OverBought, "OverBot" ) ;
Plot4( OverSold, "OverSld" ) ;

condition1 = var1 crosses over OverSold ;     
if condition1 then
	Alert( "FastD exiting oversold zone" )
else 
begin 
condition1 = var1 crosses under OverBought ;
if condition1 then
	Alert( "FastD exiting overbought zone" ) ;
end;

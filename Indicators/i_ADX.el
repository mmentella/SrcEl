inputs: 
	Length( 14 ) ;

variables:
	var0( 0 ) ;

var0 = ADX( Length ) ;

Plot1( var0, "ADX" ) ;

condition1 = var0 > var0[1] and var0[1] <= var0[2] ;
if condition1 then
	Alert( "Indicator turning up" )  
	
else 
begin 
condition1 = var0 < var0[1] and var0[1] >= var0[2] ;
if condition1 
then
	Alert( "Indicator turning down" ) ;
	end

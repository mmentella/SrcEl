inputs: 
	Length( 14 ) , Level(30);

variables:
	var0( 0,data2 ) ;

if barstatus(2) = 2 then var0 = ADX(length) data2;

Plot1( var0, "ADX" ) ;
plot2(level,"Level");

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

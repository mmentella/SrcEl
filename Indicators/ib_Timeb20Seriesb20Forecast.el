inputs:
	Length( 9 ),
	BarsPlus( 7 ) ; 

variables:
	var0( 0 ) ;

var0 = TimeSeriesForecast( Length, BarsPlus ) ;

Plot1( var0, "TSF" ) ;

condition1 = Close > var0 and var0 > var0[1] and var0[1] <= var0[2] ;
if condition1 then
	Alert( "Indicator turning up" ) 
else 
begin 
condition1 = Close < var0 and var0 < var0[1] and var0[1] >= var0[2] ;
if condition1 then
	Alert( "Indicator turning down" ) ;
end;

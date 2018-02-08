inputs:
	Price( Close ),
	Length( 14 ),
	SafeLevel( 5 ) ;

variables:
	var0( 0 ) ;

var0 = UlcerIndex( Price, Length ) ;
 
Plot1( var0, "UlcerX" ) ;
Plot2( SafeLevel, "SafeLevel" ) ;

condition1 = var0 crosses over SafeLevel ;
if condition1 then
	Alert( "Indicator crossing over Safe Level" ) ;

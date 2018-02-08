inputs:
	CCILength( 14 ),
	CCIAvgLength( 9 ),
	OverSold( -100 ),
	OverBought( 100 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = CCI( CCILength ) ;
var1 = Average( var0, CCIAvgLength ) ;

Plot1( var0, "CCI" ) ;
Plot2( var1, "CCIAvg" ) ;
Plot3( OverBought, "OverBot" ) ;
Plot4( OverSold, "OverSld" ) ;

condition1 = var1 crosses over OverSold ;
if condition1 then
	Alert( "Indicator exiting oversold zone" )
else 
begin 
condition1 = var1 crosses under OverBought ;
if condition1 then
	Alert( "Indicator exiting overbought zone" ) ;
end;

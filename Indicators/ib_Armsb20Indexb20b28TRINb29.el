inputs: 
	AdvIssues( Close of data1 ), 
	AdvVol( Close of data2 ), 
	DecIssues( Close of data3 ), 
	DecVol( Close of data4 ), 
	SmoothingLength( 4 ), 
	OverSold( 1.25 ), 
	OverBought( .7 ) ;
	                                                                                 
	                         

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = ArmsIndex( AdvIssues, AdvVol, DecIssues, DecVol ) ;
var1 = Average( var0, SmoothingLength ) ;

Plot1( var0, "ArmsX" ) ;
Plot2( var1, "ArmsXAvg" ) ;
Plot3( OverSold, "OverSld" ) ;
Plot4( OverBought, "OverBot" ) ;

condition1 = var1 crosses under OverSold ;
if condition1 then
	Alert( "Indicator exiting oversold zone" )
else 
begin 
condition1 = var1 crosses over OverBought ;
if condition1 then
	Alert( "Indicator exiting overbought zone" ) ;
end;

inputs: 
	AdvIssues( Close of data1 ), 
	DecIssues( Close of data2 ), 
	FastLength( 19 ), 
	SlowLength( 39 ), 
	OverSold( -70 ), 
	OverBought( 70 ) ;

variables:
	var0( 0 ) ;

var0 = McClellanOsc( AdvIssues, DecIssues, FastLength, SlowLength) ;

Plot1( var0, "McClOsc" ) ;
Plot2( OverBought, "OverBot" ) ; 
Plot3( OverSold, "OverSld" ) ;

condition1 = var0 crosses over OverSold ;
if condition1 then
	Alert( "Indicator exiting oversold zone" )
else 
begin 
condition1 = var0 crosses under OverBought ;
if condition1 then
	Alert( "Indicator exiting overbought zone" ) ;
end;

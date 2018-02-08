inputs:
	Length( 9 ) ; 

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = WeightedClose ;
var1 = AverageFC( WeightedClose, Length ) ;

Plot1( var0, "WtdClose" ) ;
Plot2( var1, "Avg" ) ;

condition1 = var0 crosses over var1 ;
if condition1 then
	Alert( "Wtd Close crossing over its average" )
else 
begin 
condition1 = var0 crosses under var1 ;
if condition1 then
	Alert( "Wtd Close crossing under its average" );
end;

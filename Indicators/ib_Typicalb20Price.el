input:
	Length( 9 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = TypicalPrice ;
var1 = AverageFC( var0, Length ) ;

Plot1( var0, "TypPrice" );
Plot2( var1, "Avg" ) ;

condition1 = var0 crosses over var1 ;
if condition1 then
	Alert( "Typ Price crossing over its average" )
else 
begin 
condition1 = var0 crosses under var1 ;
if condition1 then
	Alert( "Typ Price crossing under its average" );
end;

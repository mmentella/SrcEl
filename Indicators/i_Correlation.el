inputs: 
	IndepData( Close of data1 ), 
	DepData( Close of data2 ), 
	Length( 14 ), 
	PosCorrAlert( .7 ), 
	NegCorrAlert( -.7 ) ;

variables:
	var0( 0 ) ;

var0 = Correlation( IndepData, DepData, Length ) ;
 
Plot1( var0, "Correl" ) ;
Plot2( PosCorrAlert, "PosCorrAlert" ) ;
Plot3( NegCorrAlert, "NegCorrAlert" ) ;

condition1 = var0 crosses over PosCorrAlert ; 
if condition1 then
	Alert( "Positive correlation alert" )
else 
begin 
condition1 = var0 crosses under NegCorrAlert ;
if condition1 then
	Alert( "Negative correlation alert" ) ;
end;

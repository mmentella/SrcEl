inputs: 
	ExpMonth( 0 ), 
	ExpYear( 0 ), 
	StrPrice( 0 ), 
	Rate100( 0 ), 
	OptMktVal( Close data2 ), 
	PutCall( Put ), 
	AssetPr( Close data1 ), 
	AlertLength( 14 ) ;

variables:
	var0( 0 ) ;

var0 = ImpliedVolatility( 
	ExpMonth, 
	ExpYear, 
	StrPrice, 
	Rate100, 
	OptMktVal, 
	PutCall, 
	AssetPr ) ;

Plot1( var0, "IV-1" ) ;

condition1 = HighestBar( var0, AlertLength ) = 0 ;
if condition1 then
	Alert( "Indicator at new high" ) 
else
begin
condition1 = LowestBar( var0, AlertLength ) = 0 ;
if condition1 then
	Alert( "Indicator at new low" ) ;
end;

inputs:  AlertLength( 14 ) ;
variables:  var0( 0 ) ;

var0 = PriceVolTrend ;

Plot1( var0, "PVT" ) ;

condition1 = LowestBar( C, AlertLength ) = 0 and LowestBar( var0, AlertLength ) > 0 ;
if condition1 then 
	Alert( "Bullish divergence - new low not confirmed" ) 
else 
begin 
condition1 = HighestBar( C, AlertLength ) = 0 and HighestBar( var0, AlertLength ) > 0 ;
if  condition1 then
	Alert( "Bearish divergence - new high not confirmed" ) ;
end;

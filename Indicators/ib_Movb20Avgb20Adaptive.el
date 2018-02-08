inputs:
	Price( Close ),
	EffRatioLength( 10 ),
	FastAvgLength( 2 ),
	SlowAvgLength( 30 ) ;

variables:
	var0( 0 ) ;

var0 = AdaptiveMovAvg( Price, EffRatioLength, FastAvgLength, SlowAvgLength ) ;

Plot1( var0, "MAA" ) ;

condition1 = Price crosses over var0 ; 
if condition1 then
	Alert( "Bullish alert" ) 
else 
begin 
condition1 = Price crosses under var0 ;
if condition1 then
	Alert( "Bearish alert" ) ;
end;

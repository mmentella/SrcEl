inputs: FastLength( 12 ), SlowLength( 26 ), MACDLength( 9 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = MACD( Close, FastLength, SlowLength ) ;
var1 = XAverage( var0, MACDLength ) ;
var2 = var0 - var1 ;

Plot1( var0, "MACD" ) ;
Plot2( var1, "MACDAvg" ) ;
Plot3( var2, "MACDDiff" ) ;
Plot4( 0, "ZeroLine" ) ;

condition1 = var2 crosses over 0 ;     
if condition1 then
	Alert( "Bullish alert" )
else 
begin 
condition1 = var2 crosses under 0 ;
if condition1 then
	Alert( "Bearish alert" ) ;
end;

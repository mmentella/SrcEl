inputs:
	FastLength( 12 ),
	SlowLength( 26 ),
	MACDLength( 9 ),
	ColorNormLength( 14 ),
	UpColor( Yellow ),
	DnColor( Magenta ) ;

variables: 
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;

var0 = MACD( Close, FastLength, SlowLength ) ;
var1 = XAverage( var0, MACDLength ) ;
var2 = var0 - var1 ;
var3 = NormGradientColor( var2, true, ColorNormLength, UpColor, DnColor ) ;

PlotPB( High, Low, Open, Close, "MACDGrad", var3 ) ;

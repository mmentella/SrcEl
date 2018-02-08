inputs:
	ColorNormLength( 14 ),
	UpColor( Yellow ),
	DnColor( Magenta ) ;

variables: 
	var0( 0 ),
	var1( 0 ) ;

if BarType >= 2 and BarType < 5 then                             
	var0 = Volume
else                        
	var0 = Ticks ;

var1 = NormGradientColor( var0, false, ColorNormLength, UpColor,
 DnColor ) ;

PlotPB( High, Low, Open, Close, "VolumeGrad", var1 ) ;

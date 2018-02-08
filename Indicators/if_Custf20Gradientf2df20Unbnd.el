inputs:
	Formula( Close ),
	CrossesZero( false ), 
	ColorNormLength( 14 ),  
	UpColor( Yellow ),
	DnColor( Cyan ) ;
	                                                                
		
variables: 
	var0( 0 ) ;

var0 = NormGradientColor( Formula, CrossesZero, ColorNormLength, UpColor,
 DnColor ) ;

PlotPB( High, Low, Open, Close, "CustGrad-Unb", var0 ) ;

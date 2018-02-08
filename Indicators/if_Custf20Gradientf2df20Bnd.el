inputs:
	Formula( FastK( 14 ) ),
	LowerBound( 0 ),
	UpperBound( 100 ),  
	UpColor( Cyan ),
	DnColor( Magenta ) ;

variables: 
	var0( 0 ) ;

var0 = GradientColor( Formula, LowerBound, UpperBound, DnColor, UpColor ) ;

PlotPB( High, Low, Open, Close, "CustGrad-Bnd", var0 ) ;

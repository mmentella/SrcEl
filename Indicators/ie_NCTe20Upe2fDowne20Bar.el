inputs:
	UpMargin_pt(5),
	UpColor( Green ),
	DnColor( Red ) ;

variables: 
	var0( 0 );

if(bartype_ex < 14 or bartype_ex = 18) then
	RaiseRuntimeError("This study can be applied only to one of the following Non-Standard Chart Types: Point & Figure, Kagi, Line Break, Renko.");

var0 = IFF(UpTicks < DownTicks, DnColor, UpColor);

Plot1(High + UpMargin_pt * (MinMove / PriceScale), "Up/Down", var0, var0 );

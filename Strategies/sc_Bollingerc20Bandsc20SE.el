inputs:
	BollingerPrice( Close ),
	TestPriceUBand( Close ),                                                         
	                             
	Length( 20 ),
	NumDevsUp( 2 ) ;

variables:
	var0( 0 ) ;

var0 = BollingerBand( Close, Length, NumDevsUp ) ;

condition1 = CurrentBar > 1 and TestPriceUBand crosses under var0 ;
if condition1 then
                                                                    
	Sell Short ( "BBandSE" ) next bar at var0 stop ;

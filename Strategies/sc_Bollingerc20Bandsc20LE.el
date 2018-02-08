inputs:
	BollingerPrice( Close ),
	TestPriceLBand( Close ),                                                        
	                             
	Length( 20 ),
	NumDevsDn( 2 ) ;

variables:
	var0( 0 ) ;

var0 = BollingerBand( BollingerPrice, Length, -NumDevsDn ) ;

condition1 = CurrentBar > 1 and TestPriceLBand crosses over var0 ;
if condition1 then
                                                                    
	Buy ( "BBandLE" ) next bar at var0 stop ;

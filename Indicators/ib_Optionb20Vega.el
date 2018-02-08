inputs: 
	ExpMonth_MM( 0 ), 
	ExpYear_YYYY( 0 ), 
	StrikePr( 0 ), 
	Rate100( 0 ), 
	Volty100( 0 ), 
	PutCall( Put ) ;

variables: var0( 0 ) ;

var0 = ExpYear_YYYY - 1900;

Plot1( @Vega( DaysToExpiration( ExpMonth_MM, var0 ), StrikePr, Close, Rate100, 
 Volty100, PutCall ), "Vega" ) ;

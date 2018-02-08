inputs: 
	MyAssetType( 1 ), 
	ExpMonth_MM( 0 ), 
	ExpYear_YYYY( 0 ), 
	StrikePr( 0 ), 
	Rate100( 0 ), 
	Yield100( 0 ), 
	ForeignRate100( 0 ), 
	Volty100( 0 ), 
	PutCall( Put ), 
	EuroAmer01( 0 ) ;

variable: var0( 0 ) ;

var0 = ExpYear_YYYY - 1900;

Plot1( OptionPrice( 
	MyAssetType, 
	DaysToExpiration( ExpMonth_MM, var0 ), 
	StrikePr, 
	Close, 
	Rate100, 
	Yield100, 
	ForeignRate100, 
	Volty100, 
	PutCall, 
	EuroAmer01 ), "OptPrice" ) ;

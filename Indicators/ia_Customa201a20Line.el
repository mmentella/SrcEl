inputs: Formula( Close - Close[10] ), AlertCondition( false ) ;

Plot1( Formula ) ;

if AlertCondition then
	Alert ;

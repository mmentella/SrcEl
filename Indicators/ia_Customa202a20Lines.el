inputs: 
	Plot1Formula( Close - Close[10] ), 
	Plot2Formula( Close - Close[10] ), 
	AlertCondition( false ) ;

Plot1( Plot1Formula ) ;
Plot2( Plot2Formula ) ;

if AlertCondition then
	Alert ;

inputs: 
	Plot1Formula( Close - Close[10] ), 
	Plot2Formula( Close - Close[10] ), 
	Plot3Formula( Close - Close[10] ), 
	AlertCondition( false ) ;

Plot1( Plot1Formula ) ;
Plot2( Plot2Formula ) ;
Plot3( Plot3Formula ) ;

if AlertCondition then
	Alert ;

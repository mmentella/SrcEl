[IntrabarOrderGeneration = false]
inputs: 
	FloorAmt( 1 ), 
	TrailingPct( 20 ),                              
	PositionBasis( false ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

if MarketPosition = 1 then 
	SetPercentTrailing( FloorAmt, TrailingPct ) ;

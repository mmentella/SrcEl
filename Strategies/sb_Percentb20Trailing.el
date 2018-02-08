[IntrabarOrderGeneration = false]
inputs: 
	PositionBasis( false ), 
	FloorAmt( 1 ), 
	TrailingPct( 20 ) ;                              

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

SetPercentTrailing( FloorAmt, TrailingPct ) ;

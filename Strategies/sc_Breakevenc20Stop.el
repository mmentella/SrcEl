[IntrabarOrderGeneration = false]
inputs: PositionBasis( false ), FloorAmt( 1 ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

SetBreakeven( FloorAmt ) ;

[IntrabarOrderGeneration = false]
inputs: PositionBasis( false ), Amount( 1 ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

SetStopLoss( Amount ) ;

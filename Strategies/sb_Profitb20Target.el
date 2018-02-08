[IntrabarOrderGeneration = false]
inputs: PositionBasis( false ), Amount( 5 ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

SetProfitTarget( Amount ) ;

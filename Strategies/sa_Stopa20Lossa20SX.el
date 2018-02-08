[IntrabarOrderGeneration = false]
inputs: Amount( 1 ), PositionBasis( false ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

if MarketPosition = -1 then
	SetStopLoss( Amount ) ;

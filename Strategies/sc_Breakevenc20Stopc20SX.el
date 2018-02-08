[IntrabarOrderGeneration = false]
inputs: FloorAmt( 1 ), PositionBasis( false ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

if MarketPosition = -1 then 
	SetBreakeven( FloorAmt ) ;

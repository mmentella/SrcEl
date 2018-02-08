[IntrabarOrderGeneration = false]
inputs: Amount( 5 ), PositionBasis( false ) ;

if PositionBasis then
	SetStopPosition
else
	SetStopShare ;

if MarketPosition = 1 then
	SetProfitTarget( Amount ) ;

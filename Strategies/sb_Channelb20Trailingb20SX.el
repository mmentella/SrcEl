[IntrabarOrderGeneration = false]
inputs: Length( 3 ), FloorAmt( 1 ), PositionBasis( false ) ;
variables: var0( 0 ), var1( 0 ) ;

var0 = HighestFC( High, Length ) ;

if PositionBasis = false then
	var1 = CurrentShares * FloorAmt 
else
	var1 = FloorAmt ;

condition1 = MarketPosition = -1 and MaxPositionProfit >= var1 ;
if condition1 then
	Buy To Cover ( "ChTrSX" ) next bar at var0 stop ;

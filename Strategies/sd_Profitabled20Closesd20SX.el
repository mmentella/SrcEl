[IntrabarOrderGeneration = false]
inputs: NumProfitCloses( 5 ) ;
variables: var0( 0 ), var1( 0 ), var2( 0 ) ;

var0 = MarketPosition ;

if var0 = -1 then
	begin
	if var0[1] <> -1 then 
		begin
		var2 = 0 ;
		var1 = EntryPrice ;
		end ;
	if Close < var1 then
		var2 = var2 + 1 ;
	if var2 = NumProfitCloses then
		Buy To Cover ( "PftClsSX" ) next bar at market ;
	end ;

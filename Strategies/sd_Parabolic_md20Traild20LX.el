[IntrabarOrderGeneration = false]
inputs:
	AccFactorStep( 0.02 ),
	AccFactorLimit( 0.2 ),
	ATRLength( 3 ),
	NumATRs( 1.5 ) ;

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;

var0 = MarketPosition ;

if var0 = 1 then 
	begin
	if var0[1] <> 1 then 
		begin
		var1 = Low - AvgTrueRange( ATRLength ) * NumATRs ;
		var2 = AccFactorStep ;
		var3 = High ;
		end
	else 
		begin
		if High > var3 then
			var3 = High ;
		var1 = var1 + var2 * ( var3 - var1 ) ;
		condition1 = var3 > var3[1] and var2 < AccFactorLimit ;
		if condition1 then 
			var2 = var2 + MinList( AccFactorStep, AccFactorLimit - var2 ) ;
		end ;
	if var1 > Low then
		var1 = Low ;
	Sell ( "ParTrLX" ) next bar at var1 stop ;
	end ;

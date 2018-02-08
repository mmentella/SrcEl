inputs:
	Formula( RSI( C, 14 ) ),
	Baseline1( 70 ),
	Baseline2( 30 ),
	PlotBaseline1( true ),
	PlotBaseline2( true ) ;

variables:
	intrabarpersist var0( 0 ),
	intrabarpersist var1( 0 ),
	intrabarpersist var2( 0 ),
	intrabarpersist var3( 0 ),
	intrabarpersist var4( 0 ) ;

condition1 = GetAppInfo( aiRealTimeCalc ) = 1 ;
if condition1 then                                           
	begin
		
	if var0 <> CurrentBar then
		begin
		var1 = Formula ;
		var2 = Formula ;
		var3 = Formula ;
		var4 = Formula ;
		var0 = CurrentBar ;
		end ;

	if Formula > var2 then
		var2 = Formula ;

	if Formula < var3 then
		var3 = Formula ;

	Plot1( var1, "FormulaOpen" ) ;
	Plot2( var2, "FormulaHigh" ) ;
	Plot3( var3, "FormulaLow" ) ;
   	Plot4( Formula, "FormulaClose" ) ;
	
	end ;

	if PlotBaseline1 then
		Plot5( Baseline1, "Baseline1" ) ;
	if PlotBaseline2 then
		Plot6( Baseline2, "Baseline2" ) ;

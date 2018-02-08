input:
	PlotOpen( true ),                                                          
	                                                               
	PlotPrevClose( false ) ;                                                      
	                                                                   

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;

condition1 = GetAppInfo( aiRealTimeCalc ) = 1 ;
if condition1 then                                           
	begin

	var1 = DailyHigh ;
	var2 = DailyLow ;
	
	Plot1( var1, "High" ) ;
	Plot2( var2, "Low" ) ;
	
	if PlotOpen then
		begin
		var0 = DailyOpen ;
		Plot3( var0, "Open" ) ;
		end ;

	if PlotPrevClose then
		begin
		var3 = PrevClose ;
		Plot4( var3, "YestClose" ) ;
		end ;

	end ;

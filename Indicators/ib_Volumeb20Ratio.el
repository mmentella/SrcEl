inputs: 
	AvgLength( 14 ), 
	UpVolAlertPct( 5 ),                                                              
	DnVolAlertPct( -5 ),                                              
	                
	ColorNormLength( 14 ),                                                       
	                                                                             
	UpColor( Yellow ),                                                             
	                             
	DnColor( Cyan ) ;        
variables:
	var0( 0 ), 
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;
 
if BarType <= 1 or BarType >= 5 then                               
	begin
	var0 = UpTicks + DownTicks ;
	if var0 > 0 then
		var1 = 100 * ( UpTicks - DownTicks ) / var0 
	else
		var1 = 0 ;
	var2 = XAverage( var1, AvgLength ) ; 

	Plot1( var2, "VolRatioAvg" ) ;
	Plot2( 0, "ZeroLine" ) ;


	condition1 = UpColor >= 0 and DnColor >= 0 ;
	if condition1 then
		begin
		var3 = NormGradientColor( var2, true, ColorNormLength, UpColor,
		 DnColor ) ;
		SetPlotColor( 1, var3 ) ;
		end ;

	                  
	condition1  = var2 crosses over UpVolAlertPct ;
	if condition1 then
		Alert( "UpVol alert" )
	else 
	begin 
	condition1 = var2 crosses under DnVolAlertPct ;
	if condition1 then
		Alert( "DnVol alert" ) ;
	end;
	end ;

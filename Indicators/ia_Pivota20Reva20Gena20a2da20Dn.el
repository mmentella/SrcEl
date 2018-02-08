inputs: 
	MinRStren( 1 ),              
	MaxRStren( 30 ),              
	LRFactor( 1 ),              
	DrawLines( true ),                                                                 
	                                                                                  
	LinesColor( Magenta ), 
	PlotColor( Cyan ),                                                                
	                                
	ColorScheme( 1 ) ;                                                           
	                                                                               
	                                                                                  

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ) ;

Value1 = PivotReversalGen( MinRStren, MaxRStren, LRFactor, -1, DrawLines, LinesColor, 
 var0, var1, var2 ) ;

if Value1 = 1 then 
	begin 
	Plot1( var0, "PivRev_Dn" ) ;
	if ColorScheme = 1 then 
		SetPlotColor( 1, PlotColor ) 
	else if ColorScheme = 2 then 
		SetPlotBGColor( 1, PlotColor ) ;
	Alert( "Pivot reversal: Lo = " + NumToStr( var0, 2 ) + ", RS = " + 
	 NumToStr( var1, 0 ) + ", LS = " + NumToStr( var2, 0 ) ) ;
	end ;

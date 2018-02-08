inputs:
	FastLength( 3 ),
	SlowLength( 10 ),
	AlertLength( 14 ),
	ColorNormLength( 14 ),                                                       
	                                                                             
	UpColor( Yellow ),                                                             
	                             
	DnColor( Red ),                                                             
	                             
	GridForegroundColor( Black ) ;                                                
	                                                                              
	                              
	 	
	                                                                            
	                                                                            
	                                                                          
                 

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ) ;

if CurrentBar = 1 then
	var0 = GetAppInfo( aiApplicationType ) ;
	
if BarType >= 2 and BarType < 5 then                              
	var2 = Volume 
else                                                                              
                                                                                 
	var2 = Ticks ;

var1 = ChaikinOsc( var2, FastLength, SlowLength ) ;

Plot1( var1, "ChaikinOsc" ) ;
Plot2( 0 , "ZeroLine" ) ;

condition1 = UpColor >= 0 and DnColor >= 0 ;                                           
if condition1 then
	begin
	var3 = NormGradientColor( var1, true, ColorNormLength, UpColor,
		 DnColor ) ;
	if var0 = 1 then                                
		SetPlotColor( 1, var3 )
	else if var0 > 1 then                                 
		begin
		SetPlotColor( 1, GridForegroundColor ) ;
		SetPlotBGColor( 1, var3 ) ;
		end ;
	end ;
		
                  
condition1 = LowestBar( C, AlertLength ) = 0 and LowestBar( var1, AlertLength ) > 0;
if condition1 
 then 
	Alert( "Bullish divergence - new low not confirmed" ) 
else 
begin 
condition1 = HighestBar( C, AlertLength ) = 0 and HighestBar( var1, AlertLength ) > 0 ;
if condition1 then
	Alert( "Bearish divergence - new high not confirmed" ) ;
end;

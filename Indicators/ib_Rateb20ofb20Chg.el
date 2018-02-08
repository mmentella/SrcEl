inputs: 
	Price( Close ), 
	ROCLength( 14 ), 
	AlertLength( 14 ), 
	ColorNormLength( 14 ),                                                       
	                                                                             
	UpColor( Cyan ),                                                             
	                             
	DnColor( Magenta ),                                                            
	                             
	GridForegroundColor( Black ) ;      
variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ) ;

if CurrentBar = 1 then
	var0 = GetAppInfo( aiApplicationType ) ;

var1 = RateofChange( Price, ROCLength ) ;
	
Plot1( var1, "ROC" ) ;
Plot2( 0, "ZeroLine" ) ;

condition1 = UpColor >= 0 and DnColor >= 0 ;
if condition1 then
	begin
	var2 = NormGradientColor( var1, true, ColorNormLength, UpColor, DnColor ) ;
	if var0 = 1 then                                
		SetPlotColor( 1, var2 )
	else if var0 > 1 then                                 
		begin
		SetPlotColor( 1, GridForegroundColor ) ;
		SetPlotBGColor( 1, var2 ) ;
		end ;
	end ;

condition1 = HighestBar( var1, AlertLength ) = 0 ;                  
if condition1 then
	Alert( "Indicator at high" )
else 
begin 
condition1 = LowestBar( var1, AlertLength ) = 0 ;
if condition1 then
	Alert( "Indicator at low" ) ;
end;

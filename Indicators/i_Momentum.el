inputs:
	Price( Close ),
	Length( 12 ),
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

var1 = Momentum( Price, Length ) ;
var2 = Momentum( var1, 1 ) ;                       

Plot1( var1, "Momentum" ) ;
Plot2( 0, "ZeroLine" ) ;

condition1 = UpColor >= 0 and DnColor >= 0 ;        
if condition1 then
	begin
	var3 = NormGradientColor( var1, true, ColorNormLength, UpColor, DnColor ) ;
	if var0 = 1 then                                
		SetPlotColor( 1, var3 )
	else if var0 > 1 then                                 
		begin
		SetPlotColor( 1, GridForegroundColor ) ;
		SetPlotBGColor( 1, var3 ) ;
		end ;
	end ;

condition1 = var1 > 0 and var2 > 0 ;                  
if condition1 then
	Alert( "Indicator positive and increasing" )
else
begin 
condition1 = var1 < 0 and var2 < 0 ;
 if condition1 then
	Alert( "Indicator negative and decreasing" ) ;
end;

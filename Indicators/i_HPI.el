inputs: 
	OneCent( 100 ), 
	SmoothingFactor( .133 ),                                                   
	AlertLength( 14 ),
	ColorNormLength( 14 ),                                                       
	                                                                             
	UpColor( Yellow ),                                                             
	                             
	DnColor( Cyan ),                                                            
	                             
	GridForegroundColor( Black ) ;                                                
	                                                                              
	                              
	 	
	                                                                            
	                                                                            
	                                                                          
                 

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ) ;

if CurrentBar = 1 then
	var0 = GetAppInfo( aiApplicationType ) ;

var1 = HPI( OneCent, SmoothingFactor ) * 0.00001 ;

Plot1( var1, "HPI" ) ;
Plot2( 0, "ZeroLine" ) ;

condition1 = UpColor >= 0 and DnColor >= 0;         
if condition1 then
	begin
	var2 = NormGradientColor( var1, true, ColorNormLength, UpColor,
	 DnColor ) ;
	if var0 = 1 then                                
		SetPlotColor( 1, var2 )
	else if var0 > 1 then                                 
		begin
		SetPlotColor( 1, GridForegroundColor ) ;
		SetPlotBGColor( 1, var2 ) ;
		end ;
 	end ;

                  
condition1 = LowestBar( C, AlertLength ) = 0 and LowestBar( var1, AlertLength ) > 0 ;
if condition1 then 
	Alert( "Bullish divergence - new low not confirmed" ) 
else 
begin 
condition1 = HighestBar( C, AlertLength ) = 0 and HighestBar( var1, AlertLength ) > 0;
if condition1
 then
	Alert( "Bearish divergence - new high not confirmed" ) ;
end;

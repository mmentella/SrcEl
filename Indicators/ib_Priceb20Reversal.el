inputs: 
	NumDays( 3 ),                                                                     
	                                                            
	MinConsolIndex( 2.25 ),                                                       
	                                                 
	FinalRangeFactor( 1 ),                                                 
	RevCriteria( 1 ),                                               
	                            
	GapSizeFactor( .2 ),                                                            
	                                                  
	HiLineColor( Magenta ), 
	LoLineColor( LightGray ) ;

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( 0 ) ;

arrays:
	arr0[ 12, 100 ]( 0 ), 
	arr1[3]( 0 ) ;

Value1 = RS_DailyDataArray( NumDays, arr0, var0, arr1 ) ;

condition1 = CurrentBar = 1 or Date <> Date[1] ;
if condition1 then 
	begin 
	Value2 = RS_TrueExtremes( NumDays, arr0, var0, var1, var2, 
	 var3 ) ;
	Value3 = RS_PriceExtension( NumDays, MinConsolIndex, FinalRangeFactor, 
	 var1, var2, var3, arr0, var0 ) ;
	end ;

Value4 = RS_ReversalPatterns( Value3, RevCriteria, GapSizeFactor, arr0, var0, 
 arr1, var4, var5 ) ;

if Value3 = 1 then 
	begin 
	Plot1( High, "Ext" ) ;
	if var4 = 1 then 
		begin 
		Plot2( Close, "Setup" ) ;
		if var5 > 0 then 
			Plot3( Low, "Trigger" ) ;
		end ;
	end 
else if Value3 = 2 then 
	begin 
	Plot1( Low, "Ext" ) ;
	if var4 = 1 then 
		begin 
		Plot2( Close, "Setup" ) ;
		if var5 > 0 then 
			Plot3( High, "Trigger" ) ;
		end ;
	end ;

condition1 = Mod( CurrentBar, 2 ) = 0 ;
if condition1 then 
	Plot4( var1, "HiLoLines", HiLineColor ) 
else 
	Plot4( var2, "HiLoLines", LoLineColor ) 


                                                                                     
                                                                                    
                            

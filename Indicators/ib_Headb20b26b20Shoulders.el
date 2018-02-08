inputs:
	NeckSwStrength( 2 ), 
	HnSSwStrength( 2 ), 
	VertProportionLimit( .33 ),                                              
	HiLo( 1 ),                                             
	ConfirmVolume( true ), 
	DrawNeckline( true ),                                                        
	                           
	BarsPast( 10 ),                                                                  
	                                                         
	Color1( Yellow ), 
	Color2( Cyan ) ;                                                                  
	                                                                                 
	                                             

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( NeckSwStrength + 1 ), 
	var4( HnSSwStrength + 1 ), 
	var5( 0 ), 
	var6( 0 ), 
	var7( HnSSwStrength * 2 ), 
	var8( false ), 
	var9( false ), 
	var10( false ), 
	var11( 0 ), 
	var12( 0 ), 
	var13( 0 ), 
	var14( false ), 
	var15( Color2 ), 
	var16( -1 ), 
	var17( -1 ), 
	var18( 0 ), 
	var19( "" ), 
	var20( 0 ), 
	var21( 0 ), 
	var22( -1 ) ;

arrays: 
	arr0[ 1, 3 ]( 0 ), 
	arr1[ 2, 4 ]( 0 ) ;

var0 = CurrentBar ;

if HiLo = 1 then 
	begin
	var1 = SwingLowBar( 1, Low, NeckSwStrength, var3 ) ;
	var2 = SwingHighBar( 1, High, HnSSwStrength, var4 ) ;
	var5 = Low ;
	var6 = High ;
	end
else if HiLo = -1 then
	begin
	var1 = SwingHighBar( 1, High, NeckSwStrength, var3 ) ;
	var2 = SwingLowBar( 1, Low, HnSSwStrength, var4 ) ;
	var5 = High ;
	var6 = Low ;
	end ;

if var1 = NeckSwStrength then 
                                   
	begin

	                              
	arr0[ 1, 0 ] = arr0[ 0, 0 ] ;
	arr0[ 1, 1 ] = arr0[ 0, 1 ] ;
	arr0[ 1, 2 ] = arr0[ 0, 2 ] ;
	arr0[ 1, 3 ] = arr0[ 0, 3 ] ;

	                                                                           
	arr0[ 0, 0 ] = var0[NeckSwStrength] ;
	arr0[ 0, 1 ] = Date[NeckSwStrength] ;
	arr0[ 0, 2 ] = Time[NeckSwStrength] ;
	arr0[ 0, 3 ] = var5[NeckSwStrength] ;
	end ;

if var2 = HnSSwStrength then 
                                  
	begin

	                             
	for Value1 = 1 downto 0 
		begin
		arr1[ Value1 + 1, 0 ] = arr1[ Value1, 0 ] ;
		arr1[ Value1 + 1, 1 ] = arr1[ Value1, 1 ] ;
		arr1[ Value1 + 1, 2 ] = arr1[ Value1, 2 ] ;
		arr1[ Value1 + 1, 3 ] = arr1[ Value1, 3 ] ;
		arr1[ Value1 + 1, 4 ] = arr1[ Value1, 4 ] ;
		end ;

	                                                                         
	arr1[ 0, 0 ] = var0[HnSSwStrength] ;
	arr1[ 0, 1 ] = Date[HnSSwStrength] ;
	arr1[ 0, 2 ] = Time[HnSSwStrength] ;
	arr1[ 0, 3 ] = var6[HnSSwStrength] ;
	if BarType >= 2 and BarType < 5 then                              
		arr1[ 0, 4 ] = Average( Volume, var7 ) 
	else                                                                              
	                                                                                 
		arr1[ 0, 4 ] = Average( Ticks, var7 ) ;

	                               
	var8 = arr1[ 0, 0 ] > arr0[ 0, 0 ] 
	 and arr0[ 0, 0 ] > arr1[ 1, 0 ] 
	 and arr1[ 1, 0 ] > arr0[ 1, 0 ] 
	 and arr0[ 1, 0 ] > arr1[ 2, 0 ] ;
	if HiLo = 1 then
		begin
		var9 = arr1[ 1, 3 ] > arr1[ 2, 3 ] 
		 and arr1[ 1, 3 ] > arr1[ 0, 3 ] ;
		var10 = arr0[0, 3] < arr1[2, 3] 
		 and arr0[ 1, 3 ] < arr1[ 0, 3 ] ;
		var11 = MinList( arr0[ 0, 3 ],  arr0[ 1, 3 ] ) ;
		var12 = arr1[ 1, 3 ] - var11 ;
		end 
	else if HiLo = -1 then
		begin
		var9 = arr1[ 1, 3 ] < arr1[ 2, 3 ] 
		 and arr1[ 1, 3 ] < arr1[ 0, 3 ] ;
		var10 = arr0[0, 3] > arr1[2, 3] 
		 and arr0[ 1, 3 ] > arr1[ 0, 3 ] ;
		var11 = MaxList( arr0[ 0, 3 ],  arr0[ 1, 3 ] ) ;
		var12 = var11 - arr1[ 1, 3 ] ;
		end ;
	var13 = AbsValue( arr0[ 0, 3 ] - arr0[ 1, 3 ] ) ;
	if var12 <> 0 then
		var14 = var13 / var12 < VertProportionLimit 
	else
		var14 = false ;

	condition1 = var8 and var9 and var10 and var14 ;                 
	if condition1 then 
		begin 

		                             
		if var15 = Color2 then
			var15 = Color1
		else
			var15 = Color2 ;

		                                                                     
		var16 = Text_New( arr1[ 0, 1 ], arr1[ 0, 2 ], arr1[ 0, 3 ], 
		 "Shoulder" ) ;
		Text_SetColor( var16, var15 ) ;
		Text_SetStyle( var16, 2, 0 ) ;
		var16 = Text_New( arr1[ 1, 1 ], arr1[ 1, 2 ], arr1[ 1, 3 ], 
		 "Head" ) ;
		Text_SetColor( var16, var15 ) ;
		Text_SetStyle( var16, 2, 0 ) ;
		var16 = Text_New( arr1[ 2, 1 ], arr1[ 2, 2 ], arr1[ 2, 3 ], 
		 "Shoulder" ) ;
		Text_SetColor( var16, var15 ) ;
		Text_SetStyle( var16, 2, 0 ) ;

		if ConfirmVolume then 
			                                                                          
			                        
			begin
			if BarType >= 2 and BarType < 5 then                              
				var18 = Average( Volume, HnSSwStrength ) 
			else                                                                      
			                                                                      
			                    
				var18 = Average( Ticks, HnSSwStrength ) ;
			if var18 > arr1[ 0, 4 ] and var18 >  arr1[ 2, 4 ] then
			                                                                         
			                                                                 
				var19 = "Volume confirm"
			else
				var19 = "Vol non-confirm" ;
			var16 = Text_New( arr0[ 1, 1 ], arr0[ 1, 2 ], var11, 
			 var19 ) ;
			Text_SetColor( var16, var15 ) ;
			Text_SetStyle( var16, 0, 1 ) ;
			end ;

		if DrawNeckline then 
			                                                                          
			                                             
			begin
			var17 = TL_New( arr0[ 1, 1 ], arr0[ 1, 2 ], arr0[ 1, 3 ], 
			 arr0[ 0, 1 ], arr0[ 0, 2 ], arr0[ 0, 3 ] ) ;
			TL_SetExtLeft( var17, false ) ;
			TL_SetExtRight( var17, false ) ;
			TL_SetColor( var17, var15 ) ;
			var20 = var0 ;
			end ;
		end ;
	end ;

                                                                                      
                                                                                   
condition1 = var17 >= 0 and var22 <> var17 and var0 - var20 <= BarsPast ;                                          
if condition1 then 
	begin
	var21 = TL_GetValue( var17, Date, Time ) ;
	condition1 = ( HiLo = 1 and Close < var21 ) or ( HiLo = -1 and Close > var21 ) ;
	if condition1 then 
		begin
		Plot1( var5, "H&S", var15 ) ;
		Alert ;
		var22 = var17 ;
		end
	else
		NoPlot( 1 ) ;                      
	end ;

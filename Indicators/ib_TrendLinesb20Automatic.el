inputs: 
	SwHiStrength( 4 ), 
	SwLoStrength( 4 ), 
	BarsPast( 10 ), 
	History( "Yes" ), 
	DnTLColor( Red ), 
	UpTLColor( Cyan ), 
	AlertType( "IntraBar" ) ;

variables: 
	var0( -1 ), 
	var1( 0 ), 
	var2( false ), 
	var3( DnTLColor ), 

	var4( -1 ), 
	var5( 0 ), 
	var6( false ), 
	var7( UpTLColor ), 

	var8( 0 ), 
	var9( 0 ), 
	var10( false ), 
	var11( UpperStr( AlertType ) ) ;

arrays: 
	arr0[10]( 0 ), 
	arr1[10]( 0 ), 
	arr2[10]( -1000000 ), 
	arr3[10]( 0 ), 
	arr4[10]( 0 ), 
	arr5[10]( 1000000 ) ;

if CurrentBar = 1 then 
	var10 = UpperStr( History ) = "YES" or UpperStr( History ) = "Y" ;
	                                                        

var9 = CurrentBar;

condition1 = SwingHighBar( 1, High, SwHiStrength, SwHiStrength + 1 ) = SwHiStrength ;
if condition1 then 
                              
	begin

	                    
	for Value1 = 9 downto 0 
		begin
		arr0[ Value1 + 1 ] = arr0[Value1] ;
		arr1[ Value1 + 1 ] = arr1[Value1] ;
		arr2[ Value1 + 1 ] = arr2[Value1] ;
		end ;

	                                                            
	arr0[0] = Date[SwHiStrength] ;
	arr1[0] = Time[SwHiStrength] ;
	arr2[0] = High[SwHiStrength] ;

	                                                                            
	for Value2 = 1 to 10 
		begin
		if arr2[Value2] > arr2[0] then 
			begin
			var8 = Value2 ;
			Value2 = 11 ;                                                          
			                                   
			end ;
		end ;

	if Value2 = 12 then                                               
		begin
		if var0 >= 0 then                                 
			begin
			condition1 = var10 and var2 = false ;
			if condition1 then 
				                                                             
				                              
				begin
				TL_SetEnd( var0, Date, Time, TL_GetValue( var0, Date, Time ) ) ;
				TL_SetExtRight( var0, false ) ;
				end
			else if var10 = false then
				                                                
				TL_Delete( var0 ) ;
			end ;
		                                                                         
		var0 = TL_New( arr0[var8], arr1[var8], arr2[var8], 
		 arr0[0], arr1[0], arr2[0] ) ;
		if var2 = true then 
			var2 = false ;
		var1 = var9 - SwHiStrength ;
		TL_SetExtLeft( var0, false ) ;
		TL_SetExtRight( var0, true ) ;
		if var3 <> 99 then 
			TL_SetColor( var0, var3 ) ;
		if var11 = "ONCLOSE" then 
			TL_SetAlert( var0, 2 )
		else if var11 = "INTRABAR" then 
			TL_SetAlert( var0, 1 )
		else
			TL_SetAlert( var0, 0 ) ;
		end ;
	end ;

condition1 = SwingLowBar( 1, Low, SwLoStrength, SwLoStrength + 1 ) = SwLoStrength ;
if condition1 then                               
	begin	                    
	for Value1 = 9 downto 0 
		begin
		arr3[Value1+1] = arr3[Value1] ;
		arr4[Value1+1] = arr4[Value1] ;
		arr5[Value1+1] = arr5[Value1] ;
		end ;

	                                                            
	arr3[0] = Date[SwLoStrength] ;
	arr4[0] = Time[SwLoStrength] ;
	arr5[0] = Low[SwLoStrength] ;

	                                                                           
	for Value2 = 1 to 10 
		begin
		if arr5[Value2] < arr5[0] then 
			begin
			var8 = Value2 ;
			Value2 = 11 ;                                                         
			                                   
			end ;
		end ;

	if Value2 = 12 then                                               
		begin
		if var4 >= 0 then                                
			begin
			condition1 = var10 and var6 = false ;
			if condition1 then 				                              
				begin
				TL_SetEnd( var4, Date, Time, TL_GetValue( var4, Date, Time ) ) ;
				TL_SetExtRight( var4, false ) ;
				end
			else if var10 = false then
				                                                
				TL_Delete( var4 ) ;
			end ;
		                                                                         
		var4 = TL_New( arr3[var8], arr4[var8], arr5[var8], 
		 arr3[0], arr4[0], arr5[0] ) ;
		if var6 = true then
			var6 = false ;
		var5 = var9 - SwLoStrength ;
		TL_SetExtLeft( var4, false ) ;
		TL_SetExtRight( var4, true ) ;
		if var7 <> 99 then 
			TL_SetColor( var4, var7 ) ;
		if var11 = "ONCLOSE" then 
			TL_SetAlert( var4, 2 )
		else if var11 = "INTRABAR" then 
			TL_SetAlert( var4, 1 )
		else
			TL_SetAlert( var4, 0 ) ;
		end ;
	end ;

                                                                                    
                                                                                     
                  
condition1 = var0 >= 0 
	and var2 = false
	and var9 > var1 + SwHiStrength + BarsPast 
	and ( Close > TL_GetValue( var0, Date, Time ) )[BarsPast];

if condition1
then 
	begin
	TL_SetEnd( var0, Date, Time, TL_GetValue( var0, Date, Time ) ) ;
	TL_SetExtRight( var0, false ) ;
	var2 = true ;
	end ;

condition1 = var4 >= 0 
	and var6 = false
	and var9 > var5 + SwLoStrength + BarsPast 
	and ( Close < TL_GetValue( var4, Date, Time ) )[BarsPast];

if condition1
then 
	begin
	TL_SetEnd( var4, Date, Time, TL_GetValue( var4, Date, Time ) ) ;
	TL_SetExtRight( var4, false ) ;
	var6 = true ;
	end ;

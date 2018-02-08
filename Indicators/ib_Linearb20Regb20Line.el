inputs: 
	Length( 30 ), 
	EndDate_YYMMDD( 0 ),                                                 
	                                                  
	EndTime_HHMM( 0 ),                                                   
	Color( Yellow ), 
	ExtRight( true ) ;

variables: 
	var0( iff( EndDate_YYMMDD < 500000, EndDate_YYMMDD + 1000000, 
	 EndDate_YYMMDD ) ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ) ;

if var4 = 0 then

                                                                           

	begin
	condition1 = var0 = 1000000 and LastBarOnChart ;
	if condition1 then 
		begin
		var1 = LinearRegValue( C, Length, 0 ) ; 
		var2 = LinearRegValue( C, Length, Length - 1 ) ;
		var3 = TL_New( Date[ Length - 1 ], Time[ Length - 1 ], var2, Date, Time, 
		 var1 ) ;
		var4 = 1 ;
		end 
	else 
	begin
	condition1 = Date = var0 and ( Time = EndTime_HHMM or EndTime_HHMM = 0 ) ;
	if condition1 then 
		begin
		var1 = LinearRegValue( C, Length, 0 ) ;
		var2 = LinearRegValue( C, Length, Length - 1 ) ;
		var3 = TL_New( Date[ Length - 1 ], Time[ Length - 1 ], var2, Date, Time, 
		 var1 ) ;
		var4 = 2 ;
		end ;
	end;
	condition1 = var4 = 1 or var4 = 2 ;
	if condition1  then
		begin
		TL_SetColor( var3, Color ) ;
		TL_SetExtLeft( var3, false ) ;
		if ExtRight then
			TL_SetExtRight( var3, true )
		else
			TL_SetExtRight( var3, false ) ;
		end ;
	end
else if var4 = 1 then

                                                                                    
                                                                           

	begin
	var1 = LinearRegValue( C, Length, 0 ) ;
	var2 = LinearRegValue( C, Length, Length - 1 ) ;
	TL_SetBegin( var3, Date[ Length - 1 ], Time[ Length - 1 ], var2 ) ;
	TL_SetEnd( var3, Date, Time, var1 ) ;
	end ;

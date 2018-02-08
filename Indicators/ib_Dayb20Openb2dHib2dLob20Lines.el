inputs:
	OpenColor( Red ), 
	HighColor( Yellow ), 
	LowColor( Cyan ),
	DataNum( 1 ) ;

variables:
	var0( false ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( 0 ), 
	var6( 0 ),
	intrabarpersist var7( 0 ),
	intrabarpersist var8( 0 ) ;

if BarType <= 1 or BarType >= 5 then                               
	begin
	condition1 = Date <> Date[1] and BarStatus( DataNum ) = 2 ;
	if condition1 then                   
		begin

		                                             
		if var0 then
			begin
			TL_SetEnd( var1, Date[1], Time[1], var4 ) ;
			TL_SetEnd( var2, Date[1], Time[1], var5 ) ;
			TL_SetEnd( var3, Date[1], Time[1], var6 ) ;
			TL_SetExtRight( var1, false ) ;
			TL_SetExtRight( var2, false ) ;
			TL_SetExtRight( var3, false ) ;
			end ;

		                                       
		var4 = Open ;
		var5 = High ;
		var6 = Low ;
		var7 = Time ;
		var8 = Time[1] ;

		                                                           
		var1 = TL_New( Date[1], Time[1], var4, Date, Time, var4 ) ;
		var2 = TL_New( Date[1], Time[1], var5, Date, Time, var5 ) ;
		var3 = TL_New( Date[1], Time[1], var6, Date, Time, var6 ) ;
		TL_SetColor( var1, OpenColor ) ;
		TL_SetColor( var2, HighColor ) ;
		TL_SetColor( var3, LowColor ) ;
		TL_SetExtLeft( var1, false ) ;
		TL_SetExtLeft( var2, false ) ;
		TL_SetExtLeft( var3,false ) ;
		TL_SetExtRight( var1, true ) ;
		TL_SetExtRight( var2, true ) ;
		TL_SetExtRight( var3, true ) ;

		            
		if var0 = false then
			var0 = true ;
		end
	else if var0 = true then
		                                                              
		begin
			
		if Time <> var7 then
			begin
			var8 = var7 ;
			var7 = Time ;
			end ;

		if High > var5 then
			begin
			var5 = High ;
			                                                                         
			                                                                      
			                                                                         
			                                                
			TL_SetEnd( var2, Date, Time, var5 ) ;
			TL_SetBegin( var2, Date[1], var8, var5 ) ;
			end ;
		if Low < var6 then
			begin
			var6 = Low ;
			                                                                    
			          
			TL_SetEnd( var3, Date, Time, var6 ) ;
			TL_SetBegin( var3, Date[1], var8, var6 ) ;
			end ;
		end ;
	end
else
	RaiseRunTimeError( "Day Open-Hi-Lo Lines requires intraday bars." ) ;

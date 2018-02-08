inputs: 
	Price( Close ), 
	RetracePnts( 5 ), 
	LineColor( Yellow ), 
	LineWidth( 1 ) ;

variables: 
	var0( 0 ), 
	var1( Price ),                                         
	var2( Date ),                                         
	var3( Time ),                                         
	var4( 0 ),                                                         
	var5( false ), 
	var6( false ), 
	var7( false ), 
	var8( 0 ) ;

                                                                               

var0 = SwingHigh( 1, Price, 1, 2 ) ;
if var0  <> -1 then 
	begin
		condition1 = var4 <= 0 and var0 >= var1 + RetracePnts ;
		if condition1 then 			                            
			begin
				var5 = true ;
				var6 = true ;
				var4 = 1 ;
			end 
		else 
		begin 
			condition1 = var4 = 1 and var0 >= var1 ;
			if condition1 then 			                                
			begin
				var5 = true ;
				var7 = true ;
			end;
		end ;
	end 
else 
	begin
	var0 = SwingLow( 1, Price, 1, 2 ) ;
	if var0 <> -1 then 
		begin
			condition1 = var4 >= 0 and var0 <= var1 - RetracePnts ;
			if condition1 then 				                            
			begin
				var5 = true ;
				var6 = true ;
				var4 = -1 ;
			end 
			else 
			begin 
				condition1 = var4 = -1 and var0 <= var1 ;
				if condition1 then 					                                
				begin
					var5 = true;
					var7 = true ;
				end ;
			end;
		end ;
	end ;

if var5 then 
	                                      
	begin
	var1 = var0 ;
	var2 = Date[1] ;
	var3 = Time[1] ;
	var5 = false ;
	end ;

if var6 then 
	                              
	begin
	var8 = TL_New( var2, var3, var1, var2[1], var3[1], 
	 var1[1] ) ;
	TL_SetExtLeft( var8, false ) ;
	TL_SetExtRight( var8, false ) ;
	TL_SetSize( var8, LineWidth ) ;
	TL_SetColor( var8, LineColor ) ;
	var6 = false ;
	end 
else if var7 then 
	                                     
	begin
	TL_SetEnd( var8, var2, var3, var1 ) ;
	var7 = false ;
	end ;

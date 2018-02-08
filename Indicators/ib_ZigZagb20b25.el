inputs: 
	Price( Close ), 
	RetracePct( 5 ), 
	LineColor( Yellow ), 
	LineWidth( 1 ) ;

variables: 
	var0( 0 ), 
	var1( Price ),                                         
	var2( Date ),                                         
	var3( Time ),                                         
	var4( 0 ),                                                         
	var5( 1 + RetracePct * .01 ), 
	var6( 1 - RetracePct * .01 ), 
	var7( false ), 
	var8( false ), 
	var9( false ), 
	var10( 0 ) ;

                                                                               

var0 = SwingHigh( 1, Price, 1, 2 ) ;
if var0  <> -1 then 
	begin
		condition1 = var4 <= 0 and var0 >= var1 * var5 ;
		if condition1 then			                            
		begin
			var7 = true ;
			var8 = true ;
			var4 = 1 ;
			end 
		else 
		begin 
			condition1 = var4 = 1 and var0 >= var1 ;
			if condition1 then 
				                                
			begin
				var7 = true ;
				var9 = true ;
			end ;
		end;
	end 
else 
	begin
	var0 = SwingLow( 1, Price, 1, 2 ) ;
	if var0 <> -1 then 
		begin
			condition1 = var4 >= 0 and var0 <= var1 * var6 ;
			if condition1 then 
				                            
				begin
				var7 = true ;
				var8 = true ;
				var4 = -1 ;
				end 
			else 
			begin 
				condition1 = var4 = -1 and var0 <= var1 ;
				if condition1 then 				                                
				begin
				var7 = true;
				var9 = true ;
				end ;
			end;
		end ;
	end ;

if var7 then 
	                                      
	begin
	var1 = var0 ;
	var2 = Date[1] ;
	var3 = Time[1] ;
	var7 = false ;
	end ;

if var8 then 
	                              
	begin
	var10 = TL_New( var2, var3, var1, var2[1], var3[1], 
	 var1[1] ) ;
	TL_SetExtLeft( var10, false ) ;
	TL_SetExtRight( var10, false ) ;
	TL_SetSize( var10, LineWidth ) ;
	TL_SetColor( var10, LineColor ) ;
	var8 = false ;
	end 
else if var9 then 
	                                     
	begin
	TL_SetEnd( var10, var2, var3, var1 ) ;
	var9 = false ;
	end ;

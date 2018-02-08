inputs:
	Length( 7 ), 
	MaxConsolIndex( 1.5 ), 
	BarsPast( 5 ), 
	DrawLines( true ), 
	DrawExtensions( true ), 
	Color1( Red ), 
	Color2( Magenta ) ;                                                             
	                              

variables: 
	var0( Length - 1 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( Color2 ), 
	var6( 0 ), 
	var7( 0 ) ;

Value1 = Pennant( Length, MaxConsolIndex, BarsPast, var1, var2, 
 var3, var4 ) ;

if Value1 = 1 then 
	begin 
	                             
	if var5 = Color2 then
		var5 = Color1
	else
		var5 = Color2 ;
	if DrawLines then 
		begin 
		var6 = TL_New( Date[var0], Time[var0], var1, Date, 
		 Time, var2 ) ;
		TL_SetExtLeft( var6, false ) ;
		TL_SetExtRight( var6, false ) ;
		TL_SetColor( var6, var5 ) ;
		var7 = TL_New( Date[var0], Time[var0], var3, Date, 
		 Time, var4 ) ;
		TL_SetExtLeft( var7, false ) ;
		TL_SetExtRight( var7, false ) ;
		TL_SetColor( var7, var5 ) ;
		end ;
	end 
else 
begin 
condition1 = Value1 = 2 or Value1 = 3 ;
if condition1 then 
	begin 
	if DrawLines then 
		begin 
		TL_SetSize( var6, 2 ) ;
		TL_SetSize( var7, 2 ) ;
		end ;
	if Value1 = 2 then 
		Plot1( High, "PenBrkoutUp" ) 
	else if Value1 = 3 then 
		Plot2( Low, "PenBrkoutDn" ) ;
	end ;
end;
if DrawExtensions then 
	begin 
	if var2 > 0 then 
		Plot3( var2, "HiExt", var5 ) ;
	if var4 > 0 then 
		Plot4( var4, "LoExt", var5 ) ;
	end ;

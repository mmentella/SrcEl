inputs: 
	NumDays( 7 ), 
	NewQualDays( 0 ), 
	OldQualDays( 0 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( 0 ), 
	var6( false ), 
	var7( false ), 
	var8( 0 ), 
	var9( 0 ) ;

arrays:
	arr0[ 12, 100 ]( 0 ), 
	arr1[3]( 0 ) ;

Value1 = RS_DailyDataArray( NumDays, arr0, var0, arr1 ) ;

condition1 = CurrentBar = 1 or Date <> Date[1] ;
if condition1 then 
	begin 
	Value2 = RS_Extremes( NumDays, arr0, var0, var1, var2, 
	 var3, var4 ) ;
	var5 = NumDays - OldQualDays ;
	var6 = var2 <= var5 and var2 > NewQualDays ;
	var7 = var4 <= var5 and var4 > NewQualDays ;
	end ;

                                                                               
                                                                                    
condition1 = var6 and High > var1 
	and IffLogic( arr0[ 12, var0 ] = arr1[3], arr1[1] <= var1, true );                            
if condition1 then 
	begin 
	if Date <> var8 then 
		Plot1( High, "NewNDayHi" ) ;
	var8 = Date ;
	end 
else 
begin 
condition1 = var7 and Low < var3 and IffLogic( arr0[ 12, var0 ] = 
	 arr1[3], arr1[2] >= var3, true ) ;
if condition1 then 
	begin 
	if Date <> var9 then 
		Plot2( Low, "NewNDayLo" ) ;
	var9 = Date ;
	end ;
end;
Plot3( var1, "HiLine" ) ;
Plot4( var3, "LoLine" ) ;
if var6 then 
	SetPlotWidth( 3, 2 ) ;
if var7 then 
	SetPlotWidth( 4, 2 ) ;

inputs: 
	NumDays( 3 ), 
	RequireReversalGap( true ), 
	BarsBetween( 10 ), 
	StartBarTime( 1000 ), 
	EndBarTime( 1430 ) ;

variables: 
	var0( NumDays + 2 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( false ), 
	var6( false ), 
	var7( BarsBetween - 1 ), 
	var8( 0 ), 
	var9( 0 ), 
	var10( 0 ), 
	var11( 0 ), 
	var12( false ), 
	var13( false ), 
	var14( 0 ), 
	var15( 0 ), 
	var16( 0 ), 
	var17( false ), 
	var18( false ), 
	var19( false ), 
	var20( false ), 
	var21( false ), 
	var22( false ), 
	var23( White ), 
	var24( Yellow ), 
	var25( Cyan ), 
	var26( DarkGray ), 
	var27( Blue ), 
	var28( LightGray ) ;

arrays:
	arr0[ 12, 100 ]( 0 ), 
	arr1[3]( 0 ) ;

Value1 = RS_DailyDataArray( var0, arr0, var1, arr1 ) ;

var2 = CurrentBar ;
var3 = var2 - arr0[ 10, var1 ]                 ;
var4 = var2 - arr0[ 11, var1 ]                 ;
var5 = var3 >= var7 ;
var6 = var4 >= var7 ;

if RequireReversalGap then 
	begin 
	condition1 = CurrentBar = 1 or Date <> Date[1] ;
	if condition1 then 
		begin 
		Value2 = RS_Extremes( NumDays, arr0, var1, var8, 
		 var9, var10, var11 ) ;
		var12 = arr0[ 1, var1 ] > var8 ;
		var13 = arr0[ 1, var1 ] < var10 ;
		var14 = RS_Average( 6, NumDays, 2, arr0, var1 ) ;
		var15 = RS_Average( 6, NumDays, 1, arr0, var1 ) ;
		var16 = RS_Average( 6, NumDays, 0, arr0, var1 ) ;
		var17 = var16 > var15 and var15 > var14 ;
		var18 = var16 < var15 and var15 < var14 ;
		var19 = var18 and var12 ;
		var20 = var17 and var13 ;
		end ;
	end 
else 
	begin 
	var19 = true ;
	var20 = true ;
	end ;

if Date = Date[1] then 
	begin 
	var21 = var3 = 0 and var5[1] and var19 ;
	var22 = var4 = 0 and var6[1] and var20 ;
	if var21 and var22 then 
		Plot1( Close, "NewHiLo", var23 ) 
	else if var21 then 
		Plot1( High, "NewHiLo", var24 ) 
	else if var22 then 
		Plot1( Low, "NewHiLo", var25 ) ;
	end ;
condition1 = Time < StartBarTime or Time > EndBarTime ;
if condition1 then 
	SetPlotColor( 1, var26 ) ;

if RequireReversalGap then 
	if var19 then 
		Plot2( Close, "RevGap", var27 ) 
	else if var20 then 
		Plot2( Close, "RevGap", var28 ) ;

Plot3( arr0[ 2, var1 ], "HiLine" ) ;
Plot4( arr0[ 3, var1 ], "LoLine" ) ;
if var5 then 
	SetPlotWidth( 3, 2 ) ;
if var6 then 
	SetPlotWidth( 4, 2 ) ;

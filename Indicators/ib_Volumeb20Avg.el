
inputs:
	AvgLength( 50 ),
	AlertPct( 50 ),
	UpColor( Cyan ),
	DownColor( Red ) ;

variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ),
	AlertFactor( 1 + AlertPct * .01 ),
	AlertStr( NumToStr( AlertPct, 2 ) ) ;

if BarType >= 2 and BarType < 5 then { not tick/intra-day data nor an advanced chart
 type (Kagi, Renko, Line Break) }
	begin
	var0 = Volume ;
	var1 = AverageFC( Volume, AvgLength ) ;
	Plot1( var0, "Vol" ) ;
	Plot2( var1, "VolAvg" ) ;
	{ Alert criteria }
	condition1 = var0 crosses over var1 * AlertFactor ;
	if condition1 then 
		Alert( "Volume breaking through " + AlertStr + "% above its avg" ) ;
	end
else { if tick/intra-day data or an advanced chart type;  in the case of minute data,
 also set the "Build Volume On:" field in the Format Instrument dialog to Trade Volume
 or Tick Count, as desired;  when using advanced chart types, Ticks returns volume
 if the chart is built from 1-tick interval data }
 	begin
	var2 = Ticks ;
	var3 = AverageFC( Ticks, AvgLength ) ;
	Plot1( var2, "Vol" ) ;
	Plot2( var3, "VolAvg" ) ;
	{ Alert criteria }
	condition1 = var2 crosses over var3 * AlertFactor ;
	if condition1 then 
		Alert( "Volume breaking through " + AlertStr + "% above its avg" ) ;
	end ;

{ Color criteria }
if C > C[1] then 
	SetPlotColor( 1, UpColor ) 
else if C < C[1] then 
	SetPlotColor( 1, DownColor ) ;


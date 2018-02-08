// SP_GomCD V2
// added May 2011 by SP for BMT forum
// option to reset daily
// option to plot only today
// averaging delta
// V2: changed plotpaintbar to plot 
input: ResetDaily	 		(true),
	//Starttime			(0000),	// option if you want to reset the Delta on a specific time, 
	//EndTime			(2400) , 	// ie 830 -1515 on a 24 hour ES chart, to plot only the Pit session delta
	PlotOnlyToday  		(true),	//false shows all days
	PlotMinMaxDelta		(true),
	PlotZeroLine			(true),
	CumulativeChart		(1);  		// 0 - NonCumulative, 1 - Cumulative

inputs:PlotAverage			(true), 
	AverageLen			(20);

inputs:
	UpCandleColor			(green),
	DnCandleColor			(red),
	NeutralColor			(lightgray);


variables:
	total_volume			(0),
	delta_volume			(0),
	open_tick			(0),
	close_tick			(0),
	intrabarpersist high_tick	(0),
	intrabarpersist low_tick	(0),
	Avbars		  		(0),
	BarsSinceLastReset		(0),
	HighestHi       		(0),
	LowestLo        		(0),
	Deltacolor      		(0),
	candle_color			(0);


	if ResetDaily then 
	begin
			If Date <> Date[1] then 
			begin  
					total_volume	= 0;
					delta_volume	= 0;
					open_tick	= 0;
					close_tick	= 0;
					high_tick	= 0;
					low_tick	= 0;
					BarsSinceLastReset = 0; 
					HighestHi  = 0;
					LowestLo   = 0;
			end;
	end;
//if time >= Starttime  and time <= EndTime then begin	
	delta_volume = upticks - downticks;
	if BarsSinceLastReset = 0 then
		total_volume = delta_volume
		else
		total_volume = total_volume[1] + delta_volume;

	open_tick = close_tick[1];
	high_tick = maxlist(high_tick, total_volume);
	low_tick  = minlist(low_tick, total_volume);
	close_tick = total_volume;
	BarsSinceLastReset = BarsSinceLastReset + 1;
	If total_volume> 0 then begin
		If high_tick > highesthi then highesthi = high_tick ;
	end;
	If total_volume< 0 then begin
		If low_tick  < lowestlo then lowestlo = low_tick  ;
	end;

	Avbars = MinList(BarsSinceLastReset,AverageLen);
	value1 = xAverage (total_volume,Avbars );
	
	
	if ( CumulativeChart = 0 ) then begin	// non cumulative chart
		if close_tick = 0 then
			open_tick = 0
		else
			if ( close_tick < 0 ) then begin
				open_tick = high_tick;
				close_tick = low_tick;
			end
			else begin
				open_tick = low_tick;
				close_tick = high_tick;
			end;

		if ( barstatus = 2 ) then
			total_volume = 0;
	end;

	candle_color =	iff(close_tick < open_tick, DnCandleColor,
					iff(close_tick > open_tick, UpCandleColor,
					NeutralColor)
				);
	if (PlotOnlyToday  = false or (PlotOnlyToday  = true and date=LastCalcDate )) then 
	begin
		if BarsSinceLastReset = 1 then begin
		Plot1 (high_tick, "", iff(low_tick > high_tick, DnCandleColor,UpCandleColor)  );
		Plot2 (low_tick, "", iff(low_tick > high_tick, DnCandleColor,UpCandleColor) );
		Plot3 (0, "", iff(low_tick > high_tick, DnCandleColor,UpCandleColor)  );
		Plot4 (close_tick, "",iff(low_tick > high_tick, DnCandleColor,UpCandleColor)  );
		end
		//plotpaintbar(high_tick, low_tick, 0, close_tick, "", iff(low_tick < high_tick, DnCandleColor,UpCandleColor),  NeutralColor)
		else
		begin
		Plot1 (high_tick, "", candle_color);
		Plot2 (low_tick, "", candle_color);
		Plot3 (open_tick, "", candle_color);
		Plot4 (close_tick, "", candle_color);
		end;
		//plotpaintbar(high_tick, low_tick, open_tick, close_tick, "", candle_color, NeutralColor);
		
		
		if PlotMinMaxDelta then 
		begin
			//Plot as dot
			Plot10(highesthi,"Highest Hi",cyan);
			plot11(lowestlo,"Lowest Lo",magenta);
		end;
			//Plot as line
		if PlotAverage then
			plot20 (value1," DeltaAv");
			If Plot20 > Plot20[1] then SetPlotColor[1](20,blue)
			else
			If Plot20 < Plot20[1] then SetPlotColor[1](20,42495)
			else 
			SetPlotColor[1](20,Yellow) ;
		if PlotZeroLine then
			Plot30 (0,"ZeroLine");
			if total_volume >0 then SetPlotColor ( 30, cyan ) else SetPlotColor ( 30, magenta );

	end;
	
	
	
	if ( barstatus = 2 ) then begin
		high_tick = total_volume;
		low_tick = total_volume;
	end;

//end;

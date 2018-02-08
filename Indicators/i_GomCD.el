
inputs:
	DeltaCalculationMode(1),	// 0 - AskBidType, 1 - UpDnVolumeType

	AskDataNumber(1),
	BidDataNumber(2);

input:
	CumulativeChart(1);  // 0 - NonCumulative, 1 - Cumulative

inputs:
	UpCandleColor(green),
	DnCandleColor(red),
	NeutralColor(lightgray);


variables:
	total_volume(0),
	delta_volume(0),

	open_tick(0),
	close_tick(0),
	intrabarpersist high_tick(0),
	intrabarpersist low_tick(0),

	initialized(false),

	candle_color(0);


if initialized then begin

	delta_volume = DeltaVolume(DeltaCalculationMode, AskDataNumber, BidDataNumber);
	total_volume = total_volume[1] + delta_volume;

	open_tick = close_tick[1];

	high_tick = maxlist(high_tick, total_volume);
	low_tick = minlist(low_tick, total_volume);

	close_tick = total_volume;

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

	//plotpaintbar(high_tick, low_tick, open_tick, close_tick, "", candle_color, NeutralColor);
	plot1(open_tick, "Open", candle_color);
	plot2(high_tick, "High", candle_color);
	plot3(low_tick, "Low", candle_color);
	plot4(close_tick, "Close", candle_color);

	if ( barstatus = 2 ) then begin
		high_tick = total_volume;
		low_tick = total_volume;
	end;
end;

initialized = initialized or lastbaronchart_s and barstatus = 2;





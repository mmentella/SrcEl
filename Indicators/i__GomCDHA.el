
inputs:
	MinCompBars(0),
	MaxCompBars(6);


inputs:
	UpCandleColor(blue),
	DnCandleColor(red),
	WarnColor(yellow);


variables:
	total_volume(0),
	delta_volume(0),

	_open(0),
	_close(0),
	intrabarpersist _high(0),
	intrabarpersist _low(0),

	open_tick(0),
	close_tick(0),
	intrabarpersist high_tick(0),
	intrabarpersist low_tick(0),

	mod_val(0),
	haMinDir(0),
	haMaxDir(0),

	initialized(false),

	candle_color(0);


if {initialized}1=1 then begin

	delta_volume = upticks - downticks;
	total_volume = total_volume[1] + delta_volume;

	_open = _close[1];

	_high = maxlist(_high, total_volume);
	_low = minlist(_low, total_volume);

	_close = total_volume;

	close_tick = ( _open + _high + _low + _close ) * .25; 	// Calculate the close
	open_tick = ( open_tick[1] + close_tick[1] ) * .5; 	// Calculate the open
	high_tick = maxlist(_high, open_tick, close_tick); 	// Calculate the high
	low_tick = minlist(_low, open_tick, close_tick); 	// Calculate the low

	if (CurrentBar > MaxCompBars) then begin
		if (close_tick > open_tick) then
			mod_val = 1
		else
			mod_val = 2;

		for value1 = 0 to MinCompBars begin
			if open_tick <= maxlist(open_tick[value1], close_tick[value1]) and
				open_tick[0] >= minlist(open_tick[value1], close_tick[value1]) and
				close_tick[0] <= maxlist(open_tick[value1], close_tick[value1]) and
				close_tick[0] >= minlist(open_tick[value1], close_tick[value1]) then
			mod_val = mod_val[value1];
		end;
		haMinDir = mod_val;

		if (close_tick > open_tick) then
			mod_val = 1
		else
			mod_val = 2;

		for value1 = 0 to MaxCompBars begin
			if open_tick <= maxlist(open_tick[value1], close_tick[value1]) and
				open_tick[0] >= minlist(open_tick[value1], close_tick[value1]) and
				close_tick[0] <= maxlist(open_tick[value1], close_tick[value1]) and
				close_tick[0] >= minlist(open_tick[value1], close_tick[value1]) then
			mod_val = mod_val[value1];
		end;

		haMaxDir = mod_val;
	end;

	if (haMinDir = 1 and haMaxDir = 1) then
		candle_color = UpCandleColor;

	if (haMinDir = 2 and haMaxDir = 2) then
		candle_color = DnCandleColor;

	if (haMinDir <> haMaxDir) then
		candle_color = WarnColor;

	plotpaintbar(high_tick, low_tick, open_tick, close_tick, "", candle_color, lightgray);

	if ( barstatus = 2 ) then begin
		_high = total_volume;
		_low = total_volume;
	end;
end;

initialized = initialized or lastbaronchart_s and barstatus = 2;





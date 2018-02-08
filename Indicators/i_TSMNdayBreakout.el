[LegacyColorValue = TRUE];

{ TSMNdayBreakout : N-Day Breakout indicator
  Copyright 1994-2004, P.J.Kaufman.  All rights reserved. }

{ period = days in lookback for breakout }

  input: period(20);
  vars:  lastbuy(0), lastsell(0), signal(0);

	signal = TSMNDBsignal(high,low,close,period);
	if signal <> signal[1] then begin
		if signal > 0 then lastbuy = high[1];
		if signal < 0 then lastsell = low[1];
	end;

	plot1(lastbuy,"TSMupBO");
	plot2(lastsell,"TSMdownBO");

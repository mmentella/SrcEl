[LegacyColorValue = TRUE];

{ Kaufman's Adaptive Moving Average smoothing constant
  Copyright 1990-2004, PJ Kaufman. All rights reserved }

	inputs:	period(8);
	vars:	efratio(0), smooth(0), fastend(.666), slowend(.0645), diff(0),
			signal(0), noise(0);

    { calculate efficiency ratio }
	efratio = 1;
	if currentbar > 1 then diff = absvalue(close - close[1]);
	if currentbar > period then begin
		signal = absvalue(close - close[period]);
		noise = summation(diff,period);
		if noise <> 0 then efratio = signal / noise;
		smooth = power(efratio*(fastend - slowend) + slowend,2);
		plot1 (smooth, "sc");
		end;

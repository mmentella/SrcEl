[LegacyColorValue = TRUE];

{ TSMAdaptive RSI : Adaptive Relative Strength Indicator
  Copyright 1998-2004, P.J.Kaufman. All rights reserved.

  Smoothing function based on RSI }

	input: period(20);
	plot1 (TSMAdaptiveRSI(period), "TSMARSI");

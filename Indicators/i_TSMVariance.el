[LegacyColorValue = TRUE];

{ TSMVariance: also see TSMMeanDeviation, the central tendency
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	TSMvar(0);

	TSMvar = TSMVariance(close,length);
	plot1(TSMvar,"TSMVariance");

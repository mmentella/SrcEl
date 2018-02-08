[LegacyColorValue = TRUE];

{ TSMMean Deviation: The central tendency
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	md(0);

	md = TSMMeanDeviation(close,length);
	plot1(md,"TSMMeanDev");

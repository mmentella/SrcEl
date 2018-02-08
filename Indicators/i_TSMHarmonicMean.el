[LegacyColorValue = TRUE];

{ TSMHarmonicMean: A time-weighted average
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	hm(0);

	hm = TSMHarmonicMean(close,length);
	plot1(hm,"TSMharmonic");

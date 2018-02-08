[LegacyColorValue = TRUE];

{ TSMTtest : Student T-test
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	Ttest(0);

	Ttest = TSMTtest(close,length);
	plot1(Ttest,"TSMTtest");

[LegacyColorValue = TRUE];

{ Ttest2v : Student T-test for 2 variables
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length1(20), length2(40);
	vars:	Tt2v(0);

	Tt2v = TSMTtest2v(close,20,close,40);
	plot1(Tt2v,"TMSTtest2v");

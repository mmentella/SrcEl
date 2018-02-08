[LegacyColorValue = TRUE];

{ TSMDoubleSmoothing: Simple double smoothing of closing prices
  Copyright 1999-2004, P.J.Kaufman. All rights reserved. }

	input: length1(40), length2(5);
	plot1 (TSMDoubleSmoothing(close,length1,length2),"TSMDblSm");

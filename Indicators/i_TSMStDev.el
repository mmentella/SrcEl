[LegacyColorValue = TRUE];

{Standard Deviation
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	sd(0);

	sd = TSMstdev(close,length);
	plot1(sd,"TSMstdev");


[LegacyColorValue = TRUE];

{ TSMPriceDensity
  Copyright 1999-2004, P J Kaufman.  All rights reserved. }
  
	input:	period(20);
	vars:		pd(0);

	pd = TSMPriceDensity(period);
	plot1(pd,"TSMDensity");

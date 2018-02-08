[LegacyColorValue = TRUE];

{ TSMSkewness : Skewness of a distribution
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

{ NOTE: Because it is calculation-intensive, this program may cause a long wait.  It
  is strongly suggested that you first plot a short interval (of six months) with
  a median length less than 50 to estimate how long it takes to finish the calculations. }

	inputs: length(20);
	vars:	k(0);

	k = TSMSkewness(close,length);
	
	plot1(k,"TSMskew");
	plot2(k[1],"Trig");

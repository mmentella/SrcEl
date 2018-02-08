[LegacyColorValue = TRUE];

{TSMMedian: The middle value of a series
  Copyright 1998-2004, PJ Kaufman. All rights reserved
  Note: If there are an even number of values in the series, then
		the average of the two middle values will be returned }

{ NOTE: Because it is calculation-intensive, this program may take some time to bring
 the values on the screen. You may want to plot a short interval (of six months) with
 a median length less than 50 to see how long it takes to finish the calculations. }

	inputs: length(45);
	vars:	med(0);

	med = TSMMedian(close,length);
	plot1(med,"TSMmedian");

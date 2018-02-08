[LegacyColorValue = TRUE];

{Mode: The largest value in a distribution
  Copyright 1998-2004, PJ Kaufman. All rights reserved
  In order to find the mode, a frequency distribution must first be created }

{ NOTE: Because it is calculation-intensive, this program may take some time to bring
 the values on the screen. You may want to plot a short interval (of six months) with
 a median length less than 50 to see how long it takes to finish the calculations. }

{ price = input series
  length = number of past items to be included in the distribution
  ncells = the number of cells in the frequency distribution (default and maximum = 20) }

	inputs: length(45), ncells(10);
	vars:	mode(0);

	mode = TSMMode(close,length,ncells);
	plot1(mode,"TSMMode");


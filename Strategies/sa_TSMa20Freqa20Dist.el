[LegacyColorValue = TRUE];

{ TSM Freq Dist: Create a frequency distribution of no more than 20 cells
  Copyright 1998-2004, PJ Kaufman. All rights reserved

  NOTE: THIS SYSTEM PRINTS THE ACCUMULATED FREQUENCY DISTRIBUTION OVER
	THE LAST 100 DAYS. USING A LONGER "LENGTH", DATA CAN BE ACCUMULATED
	OVER A LONGER PERIOD.

  length = number of past items to be included in the distribution
  ncells = the number of cells in the frequency distribution (default and maximum = 20) }

	inputs: length(100), ncells(20);
	vars:	  fd(0);

{ print to PrintLog on final calculation }
	if lastcalcdate = date then 
		fd = TSMFreqDist(close,length,ncells);

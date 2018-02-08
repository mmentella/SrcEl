[LegacyColorValue = TRUE];

{ TSMVIDYA : Variable Index Dynamic Average by Tuschar Chande
  Copyright 1997-2004, PJ Kaufman. All rights reserved.

  Period suggested at 9, histper suggested at > 9 }

	input: period(9), histper(30);

	plot1 (TSMVIDYA(period,histper), "TSMVIDYA");

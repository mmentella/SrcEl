[LegacyColorValue = TRUE];

{ PJKTrueStrength
  Copyright 1998-2004, PJ Kaufman, All rights reserved.}

  inputs: smooth1(10), smooth2(10), mom(10);
  vars: 	 ts(0);

  ts = TSMTrueStrength(close,smooth1,smooth2,mom);
  plot1(ts,"TrueStr");

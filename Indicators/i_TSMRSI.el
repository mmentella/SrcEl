[LegacyColorValue = TRUE];

{ TSMRSI: Wilder's Relative Strength Index
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);
 
  plot1(TSMRSI(close,length),"TSMRSI");

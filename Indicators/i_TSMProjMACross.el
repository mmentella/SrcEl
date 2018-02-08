[LegacyColorValue = TRUE];

{ TSMProjMACross: Projected Single Moving Average Price Cross
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);

  plot1(TSMProjMACross(close,length),"TSMProjMAX");

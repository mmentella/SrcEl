[LegacyColorValue = TRUE];

{ TSMTruRngMomVolume: True Range Momentum Volume
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20), p(10);

  plot1(TSMTruRngMomVolume(close,length,p),"TSMTRMomVol");


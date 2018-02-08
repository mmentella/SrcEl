[LegacyColorValue = TRUE];

{ TSMKurtosis-Skew
  Plot kurtosis and skew
  Copyright 2003-2004, P.J.Kaufman. All rights reserved. }

  inputs:	kurtosisper(40), skewper(15);
  vars:		k(0), s(0);

  k = kurtosis(close,kurtosisper);
  s = skew(close,skewper);
  plot1(k,"kurtosis");
  plot2(s,"skew");


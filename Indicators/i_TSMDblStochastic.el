[LegacyColorValue = TRUE];

{ TSMDblStochastic: Blau's Double Smoothed Stochastic
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  q(20), r(20), s(5);
 
  plot1(TSMDblStochastic(high,low,close,q,r,s),"TSMDblSto");

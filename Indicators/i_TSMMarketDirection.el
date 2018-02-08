[LegacyColorValue = TRUE];

{ TSMMarketDirection: Market Direction Indicator
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);

  plot1(TSMMarketDirection(close,length),"TSMMktDir");

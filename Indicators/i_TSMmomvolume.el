[LegacyColorValue = TRUE];

{ TSMMomVolume: Momentum Volume
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);
 
  plot1(TSMMomVolume(close,length),"TSMMomVol");

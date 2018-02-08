[LegacyColorValue = TRUE];

{ TSMNetMomOsc : Net Momentum Oscillator (CMO) 
  from Tushar Chande, "The New Technical Trader" (Wiley, 1994)
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);
 
  plot1(TSMNetMomOsc(close,length),"TSMCMO");

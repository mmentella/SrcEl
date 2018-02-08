[LegacyColorValue = TRUE];

{ TSMStrengthOsc: Strength Oscillator
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);
 
  plot1(TSMStrengthOsc(high,low,close,length),"TSMStength");

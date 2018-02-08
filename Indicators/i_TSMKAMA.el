[LegacyColorValue = TRUE];

{ TSMKAMA : Kaufman's Adaptive Moving Average
  Copyright 1993-2004, P J Kaufman, All rights reserved. }

   Inputs: period(8);
   vars:   KAMA(0);

{ ADAPTIVE MOVING AVERAGE }
   KAMA = TSMKAMA(period);
   Plot1(KAMA,"KAMA");

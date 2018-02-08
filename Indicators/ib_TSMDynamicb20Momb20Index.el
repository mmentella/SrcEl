[LegacyColorValue = TRUE];

{ Dynamic Mom Index
  Copyright 1997-2004, P.J.Kaufman. All rights reserved.
  This technique is adapted from Tushar Chande and Stanley Kroll, The New Market Technician (John Wiley & Sons, NY, 1994)
  It creates a dynamic, variable-length RSI using the changes in price, rather than the price itself.

  Corrects sustained periods where the oscillator has high or low values
  by adjusting by the current trend }

	input:	momlen(14), len1(5), len2(10);
	vars:		DMI(0), vlty(0);

	vlty = (summation(absvalue(close - close[1]),len1)) /
				(average(summation(absvalue(close - close[1]),len1),len2));
	DMI = IntPortion(momlen / vlty);
	plot1 (DMI,"DMI");


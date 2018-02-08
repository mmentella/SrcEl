[LegacyColorValue = TRUE];

{ Trend-Adjusted Oscillator
  Copyright 1997-2004, P.J.Kaufman. All rights reserved.
  Corrects sustained periods where the oscillator has high or low values
  by adjusting by the current trend }

	input:	OscLen(20), TrendLen(10);
	vars:		osc(0), trend(0), midpoint(50), TAosc(0); 

	if currentbar < OscLen then begin
			osc = midpoint;
			TAosc = midpoint;
			end
		else begin
			osc = 100*average( (close - low) / (high - low),OscLen);
			trend = average(osc,TrendLen);
			TAosc = midpoint - (trend - osc);
			end;
	plot1 (TAosc, "TAosc");
	plot2 (osc,"osc");


[LegacyColorValue = TRUE];

{ TSM Adaptive R2 : Adaptive Correlation Coefficient
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
  Plot smoothing function based correlation coefficient with integer series }

	input: period(9);
	
	value1 = TSMAdaptiveR2(period);
	//value2 = value1[1];

	plot1(value1,"TSMAR2");
	//plot2(value2,"TSMAR2");

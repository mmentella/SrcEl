[LegacyColorValue = TRUE];

{ TSMStDevConfidence : Standard deviation confidence level (in percent)
  Copyright 1998-2004, PJ Kaufman. All rights reserved.

  Returns confidence level, e.g., if stdev = 2.0 then confidence = 95.44,
  including both ends of the curve. To find confidence of one end of the
  distribution, divide result by 2. }

	inputs: length(20);
	vars:	sdc(0);

	sdc = TSMStDevConfidence(close,length);
	plot2(sdc,"TSMstdconf");

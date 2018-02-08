[LegacyColorValue = TRUE];

{ TSMQuadraticMean: The root-mean-square
  Copyright 1998-1999, PJ Kaufman. All rights reserved }

	inputs:  length(20);
	vars:	qm(0);

	qm = @TSMquadraticmean(close,length);
      plot1(qm,"TMSQM");


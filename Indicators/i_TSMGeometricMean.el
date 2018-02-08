[LegacyColorValue = TRUE];

{ TSMGeometricMean: The nth root of the n products
  Copyright 1998-2004, PJ Kaufman. All rights reserved }

	inputs: length(20);
	vars:	gm(0);

	gm = TSMgeometricmean(close,length);
   plot1(gm,"GeoMean");


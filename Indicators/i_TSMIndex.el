[LegacyColorValue = TRUE];

{ TSMIndex : create an index series
  Copyright 1994-2004, PJKaufman. All rights reserved }

  Inputs:	type(0);
  Vars:		index(0);

{ type		0, normal price; 1, reverse forex; 2, bond (rev to yield) }

	index = TSMindex(0, close);
	plot1(index,"TSMindex");

[LegacyColorValue = TRUE];

{ TSMAccSwingIndex: Wilder's Swing Index
  Copyright 1998-2004, PJ Kaufman. All rights reserved } 

{ input "limitmov" can be zero }

	inputs: limitmov(0);

	plot1(TSMAccSwingIndex(limitmov), "TSMAccSwg");

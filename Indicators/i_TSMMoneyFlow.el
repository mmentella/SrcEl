[LegacyColorValue = TRUE];

{ TSMMoneyFlow: Money Flow Index
  Copyright 1999-2004, P.J.Kaufman. All rights reserved.
}
  inputs:  length(20);

  plot1(TSMMoneyFlow(high,low,close,length),"TSMMoneyFlow");

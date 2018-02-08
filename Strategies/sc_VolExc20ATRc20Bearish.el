[LegacyColorValue = true]; 

{*******************************************************************
Description	: VOLEX (Volatility Expansion) Short Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Mult(1.2);

Sell Short ("VLX") Next Bar at Open Next Bar - Average(Range, 4) * Mult Stop; 

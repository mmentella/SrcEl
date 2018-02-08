[LegacyColorValue = true]; 

{*******************************************************************
Description	: VOLEX (Volatility Expansion) Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Mult(1.2);

Buy ("VLX") Next Bar at Open Next Bar + Average(Range, 4) * Mult Stop;

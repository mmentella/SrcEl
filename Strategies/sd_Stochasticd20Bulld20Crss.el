[LegacyColorValue = true]; 

{*******************************************************************
Description	: Stochastic Crossover Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(14), OverSold(30);
Variables: KLine(0), DLine(0);

KLine = SlowKCustom(High, Low, Close, Length);
DLine = SlowDCustom(High, Low, Close, Length);

If KLine Crosses Above DLine AND KLine < OverSold AND DLine < OverSold Then
	Buy ("Stch") This Bar on Close;

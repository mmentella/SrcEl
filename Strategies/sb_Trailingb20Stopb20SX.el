[LegacyColorValue = TRUE];

{*******************************************************************
Description	: Trailing Stop Short Exit
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(3), ShowText(False);
Variables: OrderPrice(0), StopText(0);

OrderPrice = HighestFC(High, Length);

ExitShort ("TrSH") Next Bar at OrderPrice Stop;

If ShowText AND LastBarOnChart Then
	StopText = ShowShortStop(OrderPrice);

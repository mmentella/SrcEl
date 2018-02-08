[LegacyColorValue = true]; 

{*******************************************************************
Description	: Trailing Stop Long Exit
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(3), ShowText(False);
Variables: OrderPrice(0), StopText(0);

OrderPrice = LowestFC(Low, Length);

Sell ("Trl") Next Bar at OrderPrice  Stop;

If ShowText AND LastBarOnChart Then
	StopText = ShowLongStop(OrderPrice);


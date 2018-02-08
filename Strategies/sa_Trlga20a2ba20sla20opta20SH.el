[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 31gen05  (improved 1feb)

 Description: Trailing SHORT oltre i limiti dello SL
****************************************}


Inputs: sl(10),TRbars(3), ShowText(False);
Variables: OrderPrice(0), StopText(0);

If {(C < (Entryprice - sl)) OR} (C > (Entryprice + sl)) then begin

	OrderPrice = HighestFC(High, TRbars);

	ExitShort ("TrSH-sl") Next Bar at OrderPrice Stop;

	If ShowText AND LastBarOnChart Then
	StopText = ShowShortStop(OrderPrice);
end

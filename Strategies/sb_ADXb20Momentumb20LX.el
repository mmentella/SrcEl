[LegacyColorValue = true]; 

{*******************************************************************
Description	: ADX Rate of Change Long & Short Exits
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Sensitivity(3), Length(14);
Variables: ADXChange(0), Acceleration(0), AccelerationChange(0);

ADXChange = ADX(Length) - ADX(Length)[1];
Acceleration = Average(ADXChange - ADXChange[1], 4);
AccelerationChange = Average(Acceleration - Acceleration[1], 4);

If Sensitivity = 1 AND AccelerationChange < AccelerationChange[1] Then 
	If MarketPosition = 1 Then
		Sell ("AML1") Next Bar at Market;

If Sensitivity = 2 AND Acceleration < Acceleration[1] Then 
	If MarketPosition = 1 Then
		Sell ("AML2") Next Bar at Market;
	
If Sensitivity = 3 AND ADXChange < ADXChange[1] Then 
	If MarketPosition = 1 Then
		Sell ("AML3") Next Bar at Market;




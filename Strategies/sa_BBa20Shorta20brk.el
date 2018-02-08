[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 24gen05

 Description: if C < BBlw

****************************************}
Inputs: Length(9), StdDevDn(2);
Variables: BBtop(0),BBbot(0);

BBtop = BollingerBand(Close, Length, StdDevDn);
BBBot = BollingerBand(Close, Length, -StdDevDn);

If Close < BBbot  Then
	Sell ("BBsh") Next Bar at Open;

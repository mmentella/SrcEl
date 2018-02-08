[LegacyColorValue = TRUE];

{ TSM Kurtosis-Skew

  Copyright 2003-2004, P.J.Kaufman. All rights reserved.
  This program is a modified version of "PriceDist BO_FD" provided as
  part of the Omega Research System Trading and Development Club.
  For information on the club and other Omega Research educational
  services, please call 800-422-8587 or 305-551-9991.	 

*********************************************************************************}

Inputs: TrdType(3), KurtLen(40), SkewLen(15), ExBars(10), StpPts(5), VolMin(.8), 
			VolMax(1.1), ATRLen(10);
Vars:  MP(0), StopPrice(0), Kurt(0), Skewv(0), Vol(0);


Kurt = Kurtosis(Close,KurtLen);
Skewv = Skew(Close,SkewLen);
Vol = Average(TrueRange of Data2,ATRlen);

{ENTRY RULES - BREAKOUT}
If (TrdType = 1 or TrdType = 3) and 
	Vol > VolMin and Kurt crosses under 0 then Begin
{ test maximum volatility }
    if Vol < VolMax or VolMax = 0 then begin
	 		If Skewv > 0 then 
				Buy ("BO-Long")this bar at close;
			If Skewv < 0 then
				Sellshort ("BO-Short") this bar at close;
			end
{ exit only if volatility exceeds maximum }
		else begin
	 		If Skewv > 0 then buytocover ("BO-XS")this bar at close;
			If Skewv < 0 then sell ("BO-XL") this bar at close;
		end;
	end;

{ENTRY RULES - FADE}
If (TrdType = 2 or TrdType = 3) and 
	Vol > VolMin and Kurt crosses above 0 then Begin
	If Skewv < 0 then Buy ("FD-Long")this bar at close;
	If Skewv > 0 then	Sellshort ("FD-Short") this bar at close;
	end;

if exbars <> 0 then begin
{ long exit }
	sell ("LLStop") next bar Lowest(Low,ExBars)[0] - StpPts Points Stop;
{ short exit }
	buytocover ("HHStop") next bar Highest(High,ExBars)[0] + StpPts Points Stop;
	end;

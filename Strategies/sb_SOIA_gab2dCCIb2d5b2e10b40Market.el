[LegacyColorValue = TRUE];

Input: NOS(4), CCILen(15), AvgLenCCI(8), maxtrade(1),
       AVGLength(300), TimeIN(1100), TimeOUT(2200), SStop(800), BRK(400), Target(1100),TRStart(1100), TRLevel(2000);
Vars: AvgCCI(0), BSetup(False), SSetup(False), UPLine(False), DOWNLine(False), 
	  _CCI(0,data2), var0(0,data2), canshort(false), canlong(false), Up(0), Down(0), LastVal(0);

{ Position Variables }
Vars: posHi(0.0), posLo(0.0), maxContractGain(0.0);

{ Position Update }
if marketposition > 0 then begin
	if barssinceentry = 0 or High > posHi then begin
		posHi = High; maxContractGain = (posHi - entryprice) * bigpointvalue;
	end;
end
else
if marketposition < 0 then begin
	if barssinceentry = 0 or Low < posLo then begin
		posLo = Low; maxContractGain = (entryprice - posLo) * bigpointvalue;
	end;
end;

//Check Position
if barstatus(2)=2 then begin
   canshort = false;
   canlong = false;
   
	if marketposition = 0 and LastVal = 0 then begin
		if marketposition(1) = 0 then begin canshort = true; canlong = true; end;
		if marketposition(1) = 1 then canshort = true;
		if marketposition(1) = -1 then canlong = true;
	end;
	if marketposition = 1 or LastVal = 1 then canshort = true;
	if marketposition = -1 or LastVal = -1 then canlong = true;
end;

{ Strategy Analisys }
var0 = AverageFC( Close data2, AVGLength )data2;
_CCI = CCI(CCILen)data2;
AvgCCI = Average(_CCI, AvgLenCCI);

UPLine = AvgCCI >= UP; 
DOWNLine = AvgCCI <= DOWN;
condition1 = close of data2 > var0;
condition2 = close of data2 < var0;

BSetup = UPLine and condition1;
SSetup = DOWNLine and condition2;

condition99= time >= TimeIN and time < TimeOUT ;

{Entry Long @ Market}
	if canlong and BSetup and TradesToday(date)<maxtrade and condition99 then begin
		if LastVal <= 0 then
			Buy ("Long") NOS shares Next Bar at market;
		LastVal = 1;
	end;
	
	{Entry Short @ Market}
	if canshort and SSetup and TradesToday(date)<maxtrade and condition99 Then begin
		if LastVal >= 0 then
			sellshort ("Short") NOS shares Next Bar at market;
		LastVal = -1;
	end;

if time >= 810 and time < 2250 then begin
setstopshare;
setstoploss(SStop);

 //Breakeven
 if marketposition = 1 then begin
   if maxcontractprofit > BRK then sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
 end;
 if marketposition = -1 then begin
   if maxcontractprofit > BRK then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
 end;

 //Uscita Modale
if currentcontracts = nos then begin 
  if marketposition = 1 then sell("trgL1") nos/2 shares next bar at entryprice + Target/bigpointvalue limit;
  if marketposition = -1 then begin
		  		{print(Date:7:0, " - ", Time:4:0, ": Trailing Stop on MP ", NumToStr(marketposition, 0));
	  				      print("    : MODAL exit - EntryPrice = ", EntryPrice:1:4,
	  				      ", MaxGain = ", MaxContractProfit*nos, "$ (Global)",
	  				      ", MaxGain = ", MaxContractProfit, "$ (xContract)",
	  				      ", Limit @", entryprice - Target/bigpointvalue:1:4,
	  				      ", Actual Close: ", Close:1:4);}
  	buytocover("trgS") nos/2 shares next bar at entryprice - Target/bigpointvalue limit;
  end;
end;
 
 //Trailing
		if TRStart > 0 and currentcontracts < NOS then begin
		  	if maxContractGain > TRStart then begin
		  		//print(Date:7:0, " - ", Time:4:0, ": Trailing Stop on MP ", NumToStr(marketposition, 0));
		  		
		  		if marketposition > 0 then begin
					sell ("XL-Trl") currentcontracts shares next bar at entryprice + (maxContractGain-TRLevel)/bigpointvalue stop;
	  				      {print("    : LONG trailing - EntryPrice = ", EntryPrice:1:4,
	  				      ", MaxGain = ", maxpositionprofit/nos,
	  				      ", Stop @", entryprice + ((maxpositionprofit/nos)-TRLevel)/bigpointvalue:1:4,
	  				      ", Actual Close: ", Close:1:4);}
	  			end;
		  			 			
				if marketposition < 0 then begin
	 				buytocover ("XS-Trl") currentcontracts shares next bar at entryprice - (maxContractGain - TRLevel)/bigpointvalue stop;
	  				      {print("    : SHORT trailing - EntryPrice = ", EntryPrice:1:4,
	  				      ", MaxGain = ", maxContractGain*nos, "$ (Global)",
	  				      ", MaxGain = ", maxContractGain, "$ (xContract)",
	  				      ", Stop @", entryprice - (maxContractGain - TRLevel)/bigpointvalue:1:4,
	  				      ", Actual Close: ", Close:1:4);}
	  			end;
  			end;
	  	end;

 
end;

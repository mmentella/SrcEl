{********* - MV RB- *********
 Engine: Range Breakout
 Author: Martsynyak Vasyl
         Romana Acquisizioni S.r.l.
 Year: 2010
 Market: MINI DOW JONS
 TimeFrame: 2 + 60 min.
 BackBars: 65
 Update: 15 Ott 2010
*************************************}



[LegacyColorValue = true]; 
//Motor Inputs
Input: NoS(2);
Inputs: f1L(0.60),f1S(0.07), 
        f2L(0.29), f2S(0.20), 
        f3L(0.40), f3S(0.23), 
        div(10);
Inputs: Reverse$L(950), Reverse$S(1750);
Inputs: StartTime(800), StopTime(1900);
inputs: Percent(0.75), PercMin(0.5), PercMax(1.0);

//Money Management Inputs
Inputs: {StopPerc(0),} DayRestart(false), MoneyMng(true);
Inputs: StopL(1250), StopDL(950), BreakL(0), TRStartL(0), TRLevelL(0), ModL1(1050), TpDL(0), TpL(3700); 
Inputs: StopS(2000), StopDS(1200), BreakS(0), TRStartS(0), TRLevelS(0), ModS1(850), TpDS(0), TpS(2050);
Inputs: DayLimit("4.75%"), SettleTime(2215);


//Motor Vars
vars: HighDay(0.0, data2), LowDay(0.0, data2), HighDay2(0.0, data2), LowDay2(0.0, data2), CloseDay(0.0, data2), CloseDay2(0.0, data2), DifClose(0.0, data2);
vars: ATRValue(0.0, data2), ContATR(0, data2), SomATR(0.0, data2), MedATR(33.40, data2), PercInc(0.0, data2), 
	PRL(f1L, data2), PSS(f1S, data2), PR2L(f3L, data2), PS2S(f3S, data2), PES(f2L, data2), PEL(f2S, data2); 
Vars: Resistenza1(0, data2),  Supporto1(0, data2), EnterS(0, data2),  EnterL(0, data2), RunShort(false, data2), RunLong(false, data2),
	Resistenza2(0, data2), Supporto2(0, data2), MinLow(0, data2),  MaxHigh(9999, data2), EnterSVal(0.0, data2), EnterLVal(0.0, data2), 
      startnow(0), RBLong(false, data2), RBShort(false, data2), trade(true), PosProfit(0);

//Money Management Variables
Vars: dayMax(0), dayPerc(false), settlePrice(0);
Vars: stopVal(0), stopMin(0.0), stopMax(9999999), dayTrade(true), Rev(true);
Vars: dayPos(0), newDay(true), yc(0), dayPos2(0);
Vars: posHi(0.0), posLo(0.0), maxContractGain(0.0);
Vars: TradeCost((Commission + Slippage) * 2 * 1.5),app(0);

Vars: StopLong(StopL), StopDLong(StopDL - TradeCost), BreakLong(BreakL), TRStartLong(TRStartL), 
	TRLevelLong(TRLevelL), ModLong1(ModL1), TpDLong(TpDL), TpLong(TpL);
Vars: StopShort(StopS), StopDShort(StopDS - TradeCost), BreakShort(BreakS), TRStartShort(TRStartS),
	 TRLevelShort(TRLevelS), ModShort1(ModS1), TpDShort(TpDS), TpShort(TpS);
Vars: eqTotal(0.0), eqYestClose(0.0), eqDay(0.0), eqDayPos(0.0);

if currentbar = 1 then begin
	startnow = 0;
	if DayLimit <> "" then
		if RightStr(DayLimit, 1) = "%" then begin
			dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)) / 100; dayPerc = true; end
		else begin
			dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
	 end;
end;

{ Gain-per-Contract Update }
if marketposition > 0 then begin
	if BarsSinceEntry = 0 or High > posHi then begin
		posHi = High; maxContractGain = (posHi - entryprice) * bigpointvalue;
	end;
end
else
if marketposition < 0 then begin
	if BarsSinceEntry = 0 or Low < posLo then begin
		posLo = Low; maxContractGain = (entryprice - posLo) * bigpointvalue;
	end;
end;//end Gain-per-Contract Update

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if Date > Date[1] then begin
       NewDay = True;
       yc = c[1];
       eqYestClose = eqTotal[1];
{
       if StopPerc <> 0 then begin
       	StopMax = c[1]*(1+StopPerc);
       	StopMin = c[1]*(1-StopPerc);
       end;
}
end;//end Day Position
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if settlePrice = 0 then settlePrice = Close[1];
  if dayPerc then begin
   stopMax = settlePrice * (1 + dayMax);
   stopMin = settlePrice * (1 - dayMax);
  end else begin        
   stopMax = settlePrice + dayMax;
   stopMin = settlePrice - dayMax;
  end;
//Print(StrNow, ": Today limits [", stopMin:1:3, " - ", stopMax:1:3, "] (", settlePrice:1:3, ")");
  settlePrice = 0;
 end else
  if SettleTime > 0 then
   if Time >= SettleTime and settlePrice = 0 then settlePrice = Close;
 if High > stopMax then stopMax = High;
 if Low < stopMin then stopMin = Low;
end;

{ Daily Limits }
eqDay = eqTotal - eqYestClose;
if marketposition <> 0 then eqDayPos = eqDay/currentcontracts;

PosProfit = PositionProfit;
{Motor Control Entry}
if Date = EntryDate then trade = false;
if Date <> Date [1] then trade = true;
{*******************}

{********
  Motor
********}
if barstatus(2) = 2 then begin
	if date of data2 > date[1] of data2 then begin
		startnow = startnow + 1;
		
		{***ATR Percentual***}
			ATRValue = AvgTrueRange(100) of data2;
			
			PercInc = ((ATRValue - MedATR) / MedATR) * Percent;
			if PercInc < -PercMin then PercInc = -PercMin;
			if PercInc > PercMax then PercInc = PercMax;
		{********************}

		{***Motor Calculation***}
		CloseDay= (CloseDay2 + Close[1] of data2)/2;
		DifClose = Close[1] of data2 - CloseDay;

		HighDay = (HighDay2 + MaxHigh[1])/2 + DifClose;
		LowDay = (LowDay2 + MinLow[1])/2 + DifClose;
		CloseDay = CloseDay + DifClose; 

		Resistenza1 = HighDay + PRL * (CloseDay - LowDay);
		Supporto1 = LowDay - PSS * (HighDay - CloseDay);
		Resistenza2 = Resistenza1 + PR2L * (Resistenza1 - Supporto1);
		Supporto2 = Supporto1 - PS2S * (Resistenza1 - Supporto1);
		EnterS = ((1 + PES) / 2) * (HighDay + CloseDay) - (PES) * LowDay;
		EnterL = ((1 + PEL) / 2) * (LowDay + CloseDay) - (PEL) * HighDay;

		HighDay2 = MaxHigh[1];
		LowDay2 = MinLow[1];
		CloseDay2 = Close[1] of data2;

		MaxHigh = High of data2;
		MinLow = Low of data2;
		{***********************}

	end
	else begin
		if High of data2 > MaxHigh then MaxHigh = High of data2;
		if Low of data2 < MinLow then MinLow = Low of data2;
		
		RBLong = marketposition < 1 and High of data2 > Resistenza2;
		RBShort = marketposition > -1  and Low of data2 < Supporto2;
		
		RunShort = MaxHigh >= Resistenza1 and marketposition > -1;
		if RunShort then EnterSVal = EnterS + (MaxHigh-Resistenza1) / div;
		
		RunLong = MinLow <= Supporto1 and marketposition < 1;
		if RunLong then EnterLVal = EnterL - (Supporto1-MinLow) / div;
	end;
end;
{***********}

{*** Money Management Volatility***}
if PercInc <> PercInc[1] then begin			
	BreakLong = Percentual(BreakL, PercInc);
	TRStartLong = Percentual(TRStartL, PercInc);
	TRLevelLong = Percentual(TRLevelL, PercInc);
	ModLong1= Percentual(ModL1, PercInc);
	TpDLong= Percentual(TpDL, PercInc);
	TpLong= Percentual(TpL, PercInc);
	
	BreakShort= Percentual(BreakS, PercInc);
	TRStartShort= Percentual(TRStartS, PercInc);
	TRLevelShort= Percentual(TRLevelS, PercInc);
	ModShort1= Percentual(ModS1, PercInc);
	TpDShort= Percentual(TpDS, PercInc);
	TpShort= Percentual(TpS, PercInc);		
end;
{***********************************}

if Time >= 800 and Time <= 2250 then begin

	{control revers}
	app = marketposition;
	if app <> app[1] then Rev = true;
	if PosProfit > 200 then Rev = false;
	{**************}


	{***Day Position Check***}	
	if dayPos > 0 and BarsSinceExit(1) < 2 and ExitPrice <= Close - (eqDayPos + StopDLong)/BigPointValue then dayTrade = false;
	if dayPos < 0 and BarsSinceExit(1) < 2 and Close >= Close + (eqDayPos + StopDShort)/BigPointValue then dayTrade = false;
	{************************}

	{***Daily Restart***}
	if newDay then begin
		newDay = false;
		if not dayTrade then begin
			dayTrade = true;
			if DayRestart then begin
				{if dayPos > 0 then
					Buy ("EL-Restart.m") dayPos shares next bar at Market
				else}
				if dayPos < 0 then
					SellShort ("ES-Restart.m") -dayPos shares next bar at Market;
			 end;
		end;
	end;// end Daily Restart
	{*******************}

{*******************
  Strategy StartUps
 *******************}
if Time >= StartTime and Time <= StopTime and startnow >= 3 and trade and dayTrade then begin

	if RunShort then
		if Close <= EnterSVal then SellShort("ES.m") Next Bar  NoS shares market
		else if stopMin < EnterSVal and EnterSVal < stopMax then SellShort("ES.s") Next Bar  NoS shares EnterSVal stop;
	if RunLong then
		if Close >= EnterLVal then Buy("EL.m") Next Bar  NoS shares market
		else if stopMin < EnterLVal and EnterLVal < stopMax then Buy("EL.s") Next Bar  NoS shares EnterLVal stop;

	if Rev and marketposition = -1 and Reverse$S > 0 then begin
		stopVal = entryprice + (Reverse$S/bigpointvalue);
		if Close >= stopVal then Buy("ReverseS.m") Next Bar NoS shares market
		else if stopMin < stopVal and stopVal < stopMax then Buy("ReverseS.s") Next Bar NoS shares stopVal stop;
	end;
	if Rev and marketposition = 1 and Reverse$L > 0 then begin
		stopVal = entryprice - (Reverse$L/bigpointvalue);
		if Close <= stopVal then SellShort("ReverseL.m") Next Bar NoS shares market
		else if stopMin < stopVal and stopVal < stopMax then SellShort("ReverseL.s") Next Bar NoS shares stopVal stop;
	end;
	
	if RBLong then
		if Close >= Resistenza2 then Buy("RBL.m") Next Bar NoS shares at market
		else if stopMin < Resistenza2 and Resistenza2 < stopMax then Buy("RBL.s") Next Bar NoS shares at Resistenza2 stop;
	if RBShort then
		if Close <= Supporto2 then SellShort("RBS.m") Next Bar NoS shares at market
		else if stopMin < Supporto2 and Supporto2 < stopMax then SellShort("RBS.s") Next Bar NoS shares at Supporto2 stop;
		
end;


{******************
 Money Management
******************}
	if MoneyMng then begin
		
		if MarketPosition <> 0 then begin
		    	
			SetStopContract; // set stop per contratto

			{Stop Long}
			if MarketPosition = 1 then begin
			       
			       //StopLoss

				if (Reverse$L = 0) or (not Rev) or (not trade) or (Time > Stoptime and Time <= 1730) then begin	
				 	if StopLong > 0 then begin
					       StopVal = EntryPrice-(StopLong - TradeCost)/BigPointValue;
						if Close <= StopVal then Sell("XL-Stop.m") next bar at Market
						else if StopMin < StopVal and StopVal < StopMax then SetStopLoss(StopLong);
				 	end;
				end;
				//StopDaily
				if StopDLong > 0 then begin
					dayPos = nos;
					StopVal = Close - (eqDayPos + StopDLong)/BigPointValue;
					if Close <= stopVal then Sell("XL-StopD.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then Sell("XL-StopD.s") next bar at StopVal stop;
				end;
						
			       //BreakEven
				if BreakLong > 0 and MaxContractProfit > BreakLong then begin
					StopVal = EntryPrice + TradeCost/BigPointValue;
					if Close <= StopVal then Sell("XL-Brk.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Brk.s") next bar at StopVal Stop;
				end;
				
				//Trailing
				if TRStartLong > 0 and maxContractGain > TRStartLong {and CurrentContracts = nos/2} then begin
			  		StopVal = EntryPrice + (maxContractGain-(TRLevelLong - TradeCost))/BigPointValue;
			  		if Close <= StopVal then Sell ("XL-Trl.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then Sell ("XL-Trl.s") next bar at StopVal Stop;
			 	end;
			 	
			 	//Uscita Modale1
			 	if ModLong1 > 0 and CurrentContracts = nos then begin
			 	       StopVal = EntryPrice + (ModLong1 + TradeCost)/BigPointValue;
			 	       if High >= StopVal then Sell ("XL-Mod1.m") CurrentContracts/2 shares next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then Sell ("XL-Mod1.s") CurrentContracts/2 shares next bar at StopVal limit;
			 	end;
			 	
			 	//Day Profit Target
				if TpDLong > 0 and Date > EntryDate then begin
			 	       StopVal = yc + (TpDLong + TradeCost)/BigPointValue;
			 	       if High >= stopVal then Sell ("XL-TakepD.m") next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then Sell ("XL-TakepD.s") next bar at StopVal limit;
			 	end;
			 	
			 	//Take Profit
			 	if TpLong > 0 then begin
			 	       StopVal = EntryPrice + (TpLong + TradeCost)/BigPointValue;
			 	       if High >= StopVal then Sell ("XL-Takep.m") next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then Sell ("XL-Takep.s") next bar at StopVal limit;
			 	end;
			 		
			 {Stop Short}
			 end else begin
				
				//StopLoss
				if (Reverse$S = 0) or (not Rev) or (not trade) or (Time > Stoptime and Time <= 1730) then begin
				 	if  StopShort > 0 then begin
					  	StopVal = EntryPrice+(StopShort-TradeCost)/BigPointValue;
						if Close >= StopVal then BuyToCover("XS-Stop.m") next bar at Market
						else if StopMin < StopVal and StopVal < StopMax then SetStopLoss(StopShort);
					 end;
				end;
				//StopDaily
				if StopDShort > 0 then begin
					dayPos = -nos;
					StopVal = Close + (eqDayPos + StopDShort)/BigPointValue;
					if Close >= stopVal then BuyToCover("XS-StopD.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-StopD.s") next bar at StopVal stop;
				end;

			       //BreakEvan
				if BreakShort > 0 and MaxContractProfit > BreakShort then begin
					StopVal = EntryPrice - TradeCost/BigPointValue;
					if Close >= StopVal then BuyToCover("XS-Brk.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Brk.s") next bar at StopVal Stop;
				end;

				//Trailing
				if TRStartShort > 0 and maxContractGain > TRStartShort {and CurrentContracts = nos/2} then begin
					StopVal = EntryPrice - (maxContractGain-(TRLevelShort - TradeCost))/BigPointValue;
			  		if Close >= StopVal then BuyToCover ("XS-Trl.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover ("XS-Trl.s") next bar at StopVal Stop;
				end;
				
			       //Uscita Modale1
			 	if ModShort1 > 0 and CurrentContracts = nos then begin
			 	       StopVal = EntryPrice - (ModShort1 + TradeCost)/BigPointValue;
			 	       if Low <= StopVal then BuyToCover ("XS-Mod1.m") CurrentContracts/2 shares next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then BuyToCover ("XS-Mod1.s") CurrentContracts/2 shares next bar at StopVal limit;
			 	end;
			 	
			 	//Day Profit Target
			 	if TpDShort > 0 and Date > EntryDate then begin
			 	       StopVal = yc - (TpDShort + TradeCost)/BigPointValue;
			 	       if Low <= StopVal then Sell ("XS-TakepD.m") next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then Sell ("XS-TakepD.s") next bar at StopVal limit;
			 	end;
			 	
			 	//Take Profit
			 	if TpShort > 0 then begin
			 	       StopVal = EntryPrice - (TpShort + TradeCost)/BigPointValue;
			 	       if Low <= StopVal then BuyToCover ("XS-Takep.m") next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then BuyToCover ("XS-Takep.s") next bar at StopVal limit;
			 	end;

			    end;

		end;
			
	end;//end of Money Management
end;


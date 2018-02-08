[IntraBarOrderGeneration = false];

Inputs: Nos(2), MaxTrade(1);

{ Strategy Inputs }
Inputs: MinLen(16), MaxLen(29), lungSTD(30);
Inputs: lungadx(18), bandaadx(30);

{ Process Inputs }
Inputs: TimeIN(1030), TimeOUT(1700); 

{ Money Management Inputs }
Input: SStopL(0), SStopS(0), BRKL(0), BRKS(0), TargetL(0), TargetS(0), TargetL2(0), TargetS2(0),
       TRStart(0), TRLevelL(0), TRLevelS(0), 
       StopDayL(550), StopDayS(900), StopDayLNP(550), StopDaySNP(900), 
       TargetLDay(1400), TargetSDay(1200), TargetLDayNP(1400), TargetSDayNP(1200);

Input: StopLimitPerc(0), SettleTime(0); 


{ Strategy Variables }
Vars: X(0, data2), Y(0, data2), Variazione(0, data2), VA(0, data2), VB(0, data2), OldA(0, data2), CanADX(false, data2);

{ Money Management Variables }
Vars: StopMin(0), StopMax(999999), LastDate(0), SettlePrice(0);   
Vars: posHi(0.0), posLo(0.0), maxContractGain(0.0), yc(0); 

{ Process Variables }
Vars: lastT1(0), lastT2(0, Data2), enableTrade(false);


{ max/min Stop Update }
if StopLimitPerc > 0 then begin 
	if Date > Date[1] then begin
		if SettleTime = 0 then
			SettlePrice = Close[1];
		StopMin = SettlePrice*(1-StopLimitPerc/100);
		StopMax = SettlePrice*(1+StopLimitPerc/100);
		SettlePrice = 0; 
	end;
	if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;

{ Gain-per-Contract Update }
if marketposition > 0 then begin
	if barssinceentry = 0 or High > posHi then begin
		posHi = High; maxContractGain = (posHi - entryprice) * bigpointvalue; end;
end
else
if marketposition < 0 then begin
	if barssinceentry = 0 or Low < posLo then begin
		posLo = Low; maxContractGain = (entryprice - posLo) * bigpointvalue; end;
end;

if date <> date[1] then yc = close[1];

// New TimeFrame2 bar
if BarStatus(2) = 2 then begin

	lastT2 = Time of Data2;

	{ Strategy Analisys }
	If CurrentBar of data2 = 1 then begin 
		VA = 20; 
		X = StddevPino(Close of data2 , lungSTD) of data2; 
	end; 

	Y = X;
	X = StddevPino(Close of data2, lungSTD) of data2; 
	Variazione = (X - Y) / X;

	OldA = VA;
	VA = OldA * (1 + Variazione);
	VA = MaxList(VA, MinLen);
	VA = MinList(VA, MaxLen);  
	VB = VA * .5; 
	
	CanADX = adxPino(lungadx) of data2 < bandaadx;
	
end;   // of new TimeFrame2 bar

if lastT1 <> lastT2 then begin
   lastT1 = lastT2; enableTrade = true; end;

//print(currentbar:0:0, " - ", strnow, " - OldA: ", OldA, " - VA: ", VA, " - X: ", X:0:8, " - Y: ", Y:0:8, " - Variazione: ", (Variazione*100):1:2, "% - Max:", VA, " - Min:", VA);

// Market StartUp
if time of data2 > TimeIN and time of data2 < TimeOUT then 
	begin

 		//if adxPino(lungadx) of data2 < bandaadx then 
		 	//begin
		 		//if marketposition[1] = 0 or marketposition = -1 then
			 	if marketposition <> 1 and CanADX then
			 		begin
		 				if TradesToday(date) < MaxTrade {and enableTrade} then 
		 				begin
							Buy("EL.S") Nos share next bar at Highest(High of data2 , intportion(VA)) Stop;
							//enableTrade = false;
						end;
					end;
				//if marketposition[1] = 0 or marketposition = 1 then
				if marketposition <> -1 and CanADX then
					begin
						if TradesToday(date) < MaxTrade {and enableTrade} then 
						begin
							Sell Short("ES.S") Nos shares next bar at Lowest(Low of data2 , intportion(VA)) Stop;
							//enableTrade = false;
						end;
					end;
			//end;

	end; // of Market Startup

// Money Management
Vars: TimeStart(0910), TimeStop(1730), StopVal(0);

if TimeStart <= Time and Time < TimeStop then begin

	setstopcontract;

	// StopLoss
	if MarketPosition = 1 and SStopL > 0 then begin
		StopVal = EntryPrice-SStopL/BigPointValue;
		if Close <= StopVal then Sell("XL-Stop.M") next bar at Market
		else if StopMin < StopVal and StopVal < StopMax then SetStopLoss(SStopL);
	end
	else
	if MarketPosition = -1 and SStopS > 0 then begin
		StopVal = EntryPrice+SStopS/BigPointValue;
		if Close >= StopVal then BuyToCover("XS-Stop.M") next bar at Market
		else if StopMin < StopVal and StopVal < StopMax then SetStopLoss(SStopS);
	end;

	//BreakEven
	if MarketPosition = 1 and BrkL > 0 and MaxContractProfit > BrkL then begin
		StopVal = EntryPrice + 100/BigPointValue;
		if Close <= StopVal then Sell("XL-Brk.M") next bar at Market
		else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Brk.S") next bar at StopVal Stop;
	end
	else
	if MarketPosition = -1 and BrkS > 0 and MaxContractProfit > BrkS then begin
		StopVal = EntryPrice - 100/BigPointValue;
		if Close >= StopVal then BuyToCover("XS-Brk.M") next bar at Market
		else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Brk.S") next bar at StopVal Stop;
	end;

	//Uscita Modale 1
	if CurrentContracts = Nos then begin
		if MarketPosition = 1 and TargetL > 0 then begin
			StopVal = EntryPrice + TargetL/BigPointValue;
			if High >= StopVal then Sell("XL-Mod1.M") Nos*.5 shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Mod1.S") Nos*.5 shares next bar at StopVal Limit;
		end
		else
		if MarketPosition = -1 and TargetS > 0 then begin
			StopVal = EntryPrice - TargetS/BigPointValue;
			if Low <= StopVal then BuyToCover("XS-Mod1.M") Nos*.5 shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Mod1.S") Nos*.5 shares next bar at StopVal Limit;
		end;
	end;
	
	//Uscita Modale2
	if CurrentContracts < Nos then begin
		if MarketPosition = 1 and TargetL2 > 0 then begin
			StopVal = EntryPrice + TargetL2/BigPointValue;
			if High >= StopVal then Sell("XL-Mod2.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Mod2.S") currentcontracts shares next bar at StopVal limit;
		end
		else
		if MarketPosition = -1 and TargetS2 > 0 then begin
			StopVal = EntryPrice - TargetS2/BigPointValue;
			if Low <= StopVal then BuyToCover("XS-Mod2.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Mod2.S") currentcontracts shares next bar at StopVal limit;
		end;	
	end;
	
	//Uscita Modale 1 Day
	if CurrentContracts = Nos and entrydate(0) < date then begin
		if MarketPosition = 1 and TargetLDay > 0 then begin
			StopVal = yc + TargetLDay/BigPointValue;
			if High >= StopVal then Sell("XL-Mod1Day.M") Nos{*.5} shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Mod1Day.S") Nos{*.5} shares next bar at StopVal Limit;
		end
		else
		if MarketPosition = -1 and TargetSDay > 0 then begin 
			StopVal = yc - TargetSDay/BigPointValue;
			if Low <= StopVal then BuyToCover("XS-Mod1Day.M") Nos{*.5} shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Mod1Day.S") Nos{*.5} shares next bar at StopVal Limit;
		end;
	end;
	
	//Uscita Modale 1 da ingresso
	if CurrentContracts = Nos and entrydate(0) = date then begin
		if MarketPosition = 1 and TargetLDayNP > 0 then begin
			StopVal = entryprice + TargetLDayNP/BigPointValue;
			if High >= StopVal then Sell("XL-Mod1DayNP.M") Nos*.5 shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-Mod1DayNP.S") Nos*.5 shares next bar at StopVal Limit;
		end
		else
		if MarketPosition = -1 and TargetSDayNP > 0 then begin
			StopVal = entryprice - TargetSDayNP/BigPointValue;
			if Low <= StopVal then BuyToCover("XS-Mod1DayNP.M") Nos*.5 shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Mod1DayNP.S") Nos*.5 shares next bar at StopVal Limit;
		end;
	end;
		
	//Uscita Stop Day
	if entrydate(0) < date and StopDayL > 0 then begin
		if MarketPosition = 1 then begin
			StopVal = yc - StopDayL/BigPointValue;
			if Low <= StopVal then Sell("XL-StopD.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-StopD.S") currentcontracts shares next bar at StopVal Stop;
		end
		else
		if MarketPosition = -1 and StopDayS > 0 then begin
			StopVal = yc + StopDayS/BigPointValue;
			if High >= StopVal then BuyToCover("XS-StopD.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-StopD.S") currentcontracts shares next bar at StopVal stop;
		end;
	end;
	
	//Uscita Stop Day da ingresso
	if entrydate(0) = date and StopDayLNP > 0 then begin
		if MarketPosition = 1 then begin
			StopVal = entryprice - StopDayLNP/BigPointValue;
			if Low <= StopVal then Sell("XL-StopDNP.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell("XL-StopDNP.S") currentcontracts shares next bar at StopVal Stop;
		end
		else
		if MarketPosition = -1 and StopDaySNP > 0 then begin
			StopVal = entryprice + StopDaySNP/BigPointValue;
			if High >= StopVal then BuyToCover("XS-StopDNP.M") currentcontracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-StopDNP.S") currentcontracts shares next bar at StopVal stop;
		end;
	end;
	
	//Trailing
	if TRStart > 0 and maxContractGain > TRStart and CurrentContracts < Nos then begin
  		if MarketPosition > 0 then begin
  			StopVal = EntryPrice + (maxContractGain-TRLevelL)/BigPointValue;
  			if Close <= StopVal then Sell ("XL-Trl.M") CurrentContracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then Sell ("XL-Trl.S") CurrentContracts shares next bar at StopVal Stop;
  		end
  		else
		if MarketPosition < 0 then begin
  			StopVal = EntryPrice - (maxContractGain-TRLevelS)/BigPointValue;
  			if Close >= StopVal then BuyToCover ("XS-Trl.M") CurrentContracts shares next bar at Market
			else if StopMin < StopVal and StopVal < StopMax then BuyToCover ("XS-Trl.S") CurrentContracts shares next bar at StopVal Stop;
  		end;
	end;
	
end;   // of Money Management


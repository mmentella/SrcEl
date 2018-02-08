{********* - MV Pivot2- *********
 Engine: Pivot2_Short
 Author: Martsynyak Vasyl
         Romana Acquisizioni S.r.l.
 Year: 2011
 Market: CAFFE
 TimeFrame: 2min + 60min + 260min
 BackBars: 20
 Update: 06 Lug 2011
*************************************}



[LegacyColorValue = true]; 
//Motor Inputs
Input: NoS(2);
Inputs:	lenADX_S(30), sogliaS(10), passoS(6),
		lenADX_L(8), sogliaL(-8), passoL(13);
Inputs: Length(110), Mirror(7), AdxLimitHigh(5.5);
        
Inputs: StartTime(1000), StopTime(1900);

//Money Management Inputs
Inputs: OpenTime(930), CloseTime(1950), LimitDay(0), LimitTime(0), DayStop(true), StopTrade(true), MoneyMng(true);
Inputs: MaxStopS(2200), StopS(095), MaxStopDS(2500), StopDS(0.9), BreakS(0.9), GateS(0), GateLevelS(0), TRStartS(0), TRLevelS(0), ModS1(1.65), TpS(2.6);
Input:  Benda(false);


//Motor Vars
vars: f1(0,data2), f2(0,data2), k(0,data2), maxrel(0,data2), minrel(0,data2), TrendL(0,Data2),angleTrend(0,data2),
      adxValueS(0,data2), adxValueL(0,data2), EntryL(false,data2), EntryS(false,data2),
      trade(true), Trend(false, data2);
Vars: Cont(0, data2), Period(false);
Vars: SADXval(0, data2), Diff(0, data2);

//Money Management Variablesa
Vars: stopVal(0), stopMin(0.0), stopMax(9999999),dayTrade(true), Rev(true);
Vars: dayPos(0), newDay(true), SetYesterday(0), yc(0);
Vars: posHi(0.0), posLo(0.0), maxContractGain(0.0);
Vars: TradeCost(((Commission + Slippage)*2*1.5)/bigpointvalue), MarketPos(0), ContractNow(0), PosProfit(0), SetRange(0, Data2), Mucchetta(700.0);

Vars: StopShort(StopS), StopDShort(StopDS), BreakShort(BreakS), GateShort(GateS), GateLevelShort(GateLevelS),
	  TRStartShort(TRStartS), TRLevelShort(TRLevelS), ModShort1(ModS1), TpShort(TpS);
Vars: EqTotal(0.0), EqYestClose(0.0), EqDay(0.0), EqDayPos(0.0), MotorStart(false);

{***Gain-per-Contract Update***}
if marketposition > 0 then begin
	if BarsSinceEntry = 0 or High > PosHi then begin
		PosHi = High; MaxContractGain = (PosHi - entryprice) * bigpointvalue;
	end;
end
else
if marketposition < 0 then begin
	if BarsSinceEntry = 0 or Low < PosLo then begin
		PosLo = Low; MaxContractGain = (entryprice - PosLo) * bigpointvalue;
	end;
end;//end Gain-per-Contract Update
{******************************}

{***Day Position***}
if LimitTime <> 0 and SetYesterday = 0 then if Time >= LimitTime then SetYesterday = Close; 
if High > StopMax then StopMax = High;
if Low < StopMin then StopMin = Low;

EqTotal = NetProfit + PositionProfit;
if Date > Date[1] then begin
	MotorStart = false;
	if SetYesterday = 0 then SetYesterday = c[1];
       NewDay = True;
       yc = c[1];
       EqYestClose = EqTotal[1];
       if LimitDay <> 0 then begin 
       	if LimitDay < 1 then begin //controllo se e' percentuale o valor assoluto
	       	StopMax = SetYesterday*(1+LimitDay);
	       	StopMin = SetYesterday*(1-LimitDay);
	       end
	        else begin
	        	StopMax = SetYesterday + (LimitDay/bigpointvalue);
	        	StopMin = SetYesterday - (LimitDay/bigpointvalue);
	        end;
       end;
       SetYesterday = 0;
end;//end Day Position
{******************}

//---------
MarketPos = marketposition;
ContractNow = currentcontracts;
EqDay = EqTotal - EqYestClose;
if MarketPos = 0 then begin 
	if MarketPos[1] <> 0 then eqDayPos = EqDay/ContractNow[1];
end
 else EqDayPos = EqDay/ContractNow;
//---------
	
PosProfit = PositionProfit;
{Motor Control Entry}
if Date = EntryDate then trade = false;
if Date <> Date [1] then trade = true;
{*******************}

if marketposition = 1 then dayPos = nos;
if marketposition = -1 then daypos = -nos;

Mucchetta = WeekCow(4);	

{********
  Motor
********}
if BarStatus(2) = 2 then begin
	adxValueS=gdSADX(lenADX_S)of data2;
	adxValueL=gdSADX(lenADX_L)of data2;
	f1=adxValueS-adxValueS[passoS];
	f2=adxValueL-adxValueL[passoL];
	
	SADXval = gdSADX(Length) of data2;
	Diff = (SADXval - SADXval[Mirror])*10;
	
	//----------------------------
	if f1[1]>0 and f1<0 and adxValueS>sogliaS then begin 
		maxrel=adxValueS;	
	end else maxrel=0;
	//----------------------------	
	if f2[1]<0 and f2>0 and adxValueL<sogliaL then begin 
		minrel=adxValueL;	
	end else minrel=0;
	
	EntryS=maxrel>maxrel[1] and Diff < AdxLimitHigh; 
	if currentcontracts=nos then
		EntryL = (minrel<minrel[1] or Diff > AdxLimitHigh) 
	else
		EntryL=false;			
end;
{***********}
//Control entry after first motor calculation

If Benda then Period = (Date > 1071212 and Date < 1090310)
	else Period = false;

if not Period then begin   

	if Time >= OpenTime and Time <= CloseTime then begin
		
		{***Day Position Check***}	
		if dayPos < 0 and StopDShort > 0 and MarketPos <> MarketPos[1] and marketposition = 0 and High >= Close + (eqDayPos/bigpointvalue + StopDShort - TradeCost) then dayTrade = false;
		{************************}

		{***Daily Restart***}
		if newDay then begin
			newDay = false;
			if not dayTrade then dayTrade = true;
		end;// end Daily Restart
		{*******************}

	{*******************
	  Strategy StartUps
	 *******************}	
	if Time >= StartTime and Time <= StopTime and trade and dayTrade then begin
	{***Ingressi***}	
	if marketposition=0 and EntryS then begin
	   	sellshort("ES.m") nos shares next bar at market;
	   	EntryL=false;			   	
	end;
	{**************}
	{***Uscite***}
    if marketposition=-1 and EntryL then begin
		buytocover("XS.m") nos shares next bar at market;
		EntryS=false;			
	end;
	{************}
	end;

	{******************
	 Money Management
	******************}
	SetStopContract; // set stop per contratto

		if MoneyMng then begin
			
		if MarketPosition = -1 then begin
			    //BreakEvan
				if BreakShort > 0 and (maxContractGain/bigpointvalue >= BreakShort*Mucchetta or CurrentContracts < nos) then begin
					StopVal = EntryPrice - TradeCost;
					if Close >= StopVal then BuyToCover("XS-Brk.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Brk.s") next bar at StopVal Stop;
				end;
				
				//Gate
				if GateShort > 0 and maxContractGain/bigpointvalue > GateShort*Mucchetta then begin
					StopVal = EntryPrice - GateLevelShort*Mucchetta + TradeCost;
					if Close >= StopVal then BuyToCover("XS-Gate.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Gate.s") next bar at StopVal Stop;
				end;

				//Trailing
				if TRStartShort > 0 and maxContractGain/bigpointvalue > TRStartShort*Mucchetta {and CurrentContracts = nos/2} then begin
					StopVal = EntryPrice - maxContractGain/bigpointvalue - (TRLevelShort*Mucchetta - TradeCost);
			  		if Close >= StopVal then BuyToCover ("XS-Trl.m") next bar at Market
					else if StopMin < StopVal and StopVal < StopMax then BuyToCover ("XS-Trl.s") next bar at StopVal Stop;
				end;
				
			    //Uscita Modale1
			 	if ModShort1 > 0 and CurrentContracts = nos then begin
			 	       StopVal = EntryPrice - ModShort1*Mucchetta + TradeCost;
			 	       if Low <= StopVal then BuyToCover ("XS-Mod1.m") CurrentContracts/2 shares next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then BuyToCover ("XS-Mod1.s") CurrentContracts/2 shares next bar at StopVal limit;
			 	end;
			 	
			 	//Take Profit
			 	if TpShort > 0 then begin
			 	       StopVal = EntryPrice - TpShort*Mucchetta + TradeCost;
			 	       if Low <= StopVal then BuyToCover ("XS-Takep.m") next bar at Market
			 	       else if StopMin < StopVal and StopMax > StopVal then BuyToCover ("XS-Takep.s") next bar at StopVal limit;
			 	end;
		end;
				
		end;//end of Money Management
		
		{***Daily Stop***}
		if DayStop then begin
			if MarketPosition = -1 then begin
		 			//StopDaily Short
					if StopDShort > 0 then begin
						StopDShort = StopDS*Mucchetta;
						if StopDShort > MaxStopDS/bigpointvalue then StopDShort = MaxStopDS/bigpointvalue;
						dayPos = -nos;
						StopVal = Close + (eqDayPos/bigpointvalue + StopDShort - TradeCost);
						if Close >= stopVal then BuyToCover("XS-StopD.m") next bar at Market
						else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-StopD.s") next bar at StopVal stop;
					end;
			 end;
		end;
		{***************}
		
		{***Stop Trade***}
		if StopTrade then begin
			if MarketPosition = -1 then begin
					//StopLoss
				 	if  StopShort > 0 then begin
				 		StopShort = StopS*Mucchetta;
				 		if StopShort > MaxStopS/bigpointvalue then StopShort = MaxStopS/bigpointvalue;	 	
					  	StopVal = EntryPrice + StopShort - TradeCost;
						if Close >= StopVal then BuyToCover("XS-Stop.m") next bar at Market
						else if StopMin < StopVal and StopVal < StopMax then BuyToCover("XS-Stop.s") next bar at StopVal stop;
					end;
			 end;
		end;
		{***************}
	end;
	
end
 else begin
	if marketposition = 1 then sell("EXS_time") next bar at Market;
	if marketposition = -1 then buytocover("EXL_time") next bar at Market;
 end;


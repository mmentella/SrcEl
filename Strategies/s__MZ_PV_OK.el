[LegacyColorValue = true]; 

{*********************************-Pivot-*************************************
di Matteo Zucchini
Time frame:  data1 = 240 minuti
Operatività: Overnight
Strumenti= Forex ->eurusd
		   Futures->E6
******************************************************************}

Input: StopLossPts(1.5);
       SetStopContract;
       SetStopLoss(StopLossPts * BigPointValue);

{Dichiarazione delle variabili ed input}
Inputs: tla1(0.8),tla2(0.2),stb1(0.7),stb2(0.3);
Inputs: MoneyMng(true);
Inputs: MoneyMng2(False);
Inputs: StopLossLong(3750), StopLossShort(3750);
Inputs: StopLimitPerc(5);
//Inputs: CAPINV(10000), StL(3), StS(3);


Vars: EP(0), MP(0), PivPnt(0), Resistance1(0), Support1(0), NumCont(0);

{ Money Management Constants }
Variables: tickUnit(MinMove / PriceScale),
           stopLong(Floor((StopLossLong / BigPointValue) / (MinMove / PriceScale)) * (MinMove / PriceScale)),
           stopShort(Ceiling((StopLossShort / BigPointValue) / (MinMove / PriceScale)) * (MinMove / PriceScale));

{ Money Management Variables }
Vars: posHL(0.0), posStop(0.0), stopLoss(0);
Vars: stopMin(0.0), stopMax(1000000.0), stopVal(0.0);

{ Process Variables }
Vars: lastDate(0), lastMP(0);



{*****************************-Calcolo capitale da investire-*************************}
//If C[1] <> 0 Then numcont= (Intportion ((Capinv/10)/C[1]))*10;

{*************-Assegnamento variabili e calcolo di supporto e resistenza-******************}
PivPnt = (H + L + C + O)/4;
Resistance1 = (PivPnt) + avgtruerange(5); 
Support1 = (PivPnt) - avgtruerange(5);
MP = MarketPosition; 
EP = EntryPrice; 

{******************************-Engine-*************************}
If  MP = 0 Then Begin
	//Short
	If C < O and L < L[1] and H < H[1] and C < C[1] and C[1] < C[2] Then buy ("PVT-S") Next Bar at Support1 -1 Point Stop;
	{Plotta livello di vendita}
    Value3 = TL_New(D[1], T[1], Support1 -1 Point, D, T, Support1 -1 Point);
    TL_SetColor(Value3, Tool_Red); TL_SetStyle(Value3, Tool_Solid); TL_SetSize(Value3, 1);
    TL_SetExtLeft(Value3, False); TL_SetExtRight(Value3, False);
	//Buy
	If C > O and H > H[1] and L > L[1] and C > C[1] and C[1] > C[2] Then sellshort ("PVT-L") Next Bar  at Resistance1 +1 Point Stop;
	{Plotta livello di vendita}
    Value4 = TL_New(D[1], T[1], Resistance1 +1 Point, D, T, Resistance1 +1 Point);
    TL_SetColor(Value4, Tool_Green); TL_SetStyle(Value4, Tool_Solid); TL_SetSize(Value4, 1);
    TL_SetExtLeft(Value4, False); TL_SetExtRight(Value4, False);
End;

//IF Open + 1 point > Highest[30] Then Buy ("BUY") at market	


{******************
  Money Management 1
 ******************}

if MoneyMng then begin

	{ New Day = new limits }
	if StopLimitPerc > 0 then begin
		if Date > lastDate then begin
			lastDate = Date;
			stopMax = (Floor(CloseD(1) * (1 + StopLimitPerc / 100) / tickUnit) - 1) * tickUnit;
			stopMin = (Ceiling(CloseD(1) * (1 - StopLimitPerc / 100) / tickUnit) + 1) * tickUnit;
			if MarketPosition <> 0 then begin
				if stopMin <= posStop and posStop <= stopMax then
					stopVal = stopLoss
				else
					stopVal = 0;
			end;
		end;
	end;
	
	if MarketPosition = 0 then
		lastMP = 0

	else begin

		if MarketPosition <> lastMP then begin   { just entered the market }
			lastMP = MarketPosition;
			posHL = EntryPrice;
			if MarketPosition > 0 then begin
				posStop = posHL - stopLong;
				stopLoss = StopLossLong;
			end
			else begin
				posStop = posHL + stopShort;
				stopLoss = StopLossShort;
			end;
			stopVal = stopLoss;
			if StopLimitPerc > 0 then
				if posStop <= stopMin or posStop >= stopMax then
					stopVal = 0;
		end

		else begin   { Position already running }
			SetStopContract;
			if stopVal > 0 then
				SetStopLoss(stopVal);
	
		end;
	
	end;

end;





{******************
  Money Management 2
 ******************}

//if MoneyMng2 then begin

{********************Trailing momentaneo****************}
{If MP = 1 then 	Setpercenttrailing(tla1,tla2);
	//1.5, 0.5
	//stop 
If MP = -1 then Setpercenttrailing(stb1,stb2);
	//1.5, 0.5
	
//**********************************-Stop loss-***********************************
If MP = 1 Then SetStopLoss (0.006); // ("SLL")  at (StopLossPts*1.5/100) stop;
If MP = -1 Then setstoploss (0.003);// ("SLS") at (Entryprice*2.2/100) stop;}

//SetStopLoss(StopLossPts * BigPointValue);	
	
		
{******************************-Trailing stop-************************************
If MP = 1 Then Sell ("TRL") Next Bar  (Lowest(L, 2)[1]) Stop;
If MP = -1 Then Buy to Cover ("TRS") Next Bar  (Highest(H, 2)[1]) Stop;

**********************************-Stop loss-***********************************
If MP = 1 Then Sell ("SLL") Next Bar  at (EP - EP * StL / 100) Stop;
If MP = -1 Then Buy to Cover ("SLS") Next Bar  at (EP + EP * StS / 100) Stop;}


{**************************************************************************
Oxford Copyright 2008 dott. Enrico Malverti 
www.enricomalverti.com
***************************************************************************}

{[intrabarordergeneration = true];}

vars: 	NotBef(30),NotAft(1615);
inputs:	MaxTDay(2), nos(2);
Vars:		Flr1Perc(.3), Flr2Perc(.4), Flr3Perc(.5),
			LTrailP1(.5), LTrailP2(.4), LTrailP3(.25),
			STrailP1(.5), STrailP2(.4), STrailP3(.25);			
inputs:		RevPerc(.52);

Vars: 	Pivot(0), 
		Support1(0), Support2(0), Support3(0), 
		Resistance1(0), Resistance2(0), Resistance3(0);
Vars: 	Floor1(0), Floor2(0), Floor3(0),		
		PercLongTrail1(0), PercLongTrail2(0), PercLongTrail3(0),
		PercShortTrail1(0), PercShortTrail2(0), PercShortTrail3(0),
		LXTrail(0), SXTrail(0);
Vars:	NumTDay(0),
		LastEntryDate(0), LastEntryTime(0), LastMP(0),
		HH(0),LL(0), Reverse(0);

{Evaluate the count of trades done}
if (MarketPosition <> 0)and
	(	(EntryDate <> LastEntryDate)or
		(EntryTime <> LastEntryTime)or
		(LastMP <> MarketPosition)	) then
	begin
   	numTDay = numTDay + 1;
		LastEntryDate = EntryDate;
		LastEntryTime = EntryTime;
		LastMP = MarketPosition;
	end;

{initialization}
if CurrentBar = 1 then
	begin
		PercLongTrail1 = (100-LTrailP1);
		PercLongTrail2 = (100-LTrailP2);
		PercLongTrail3 = (100-LTrailP3);

		PercShortTrail1 = (100-STrailP1);
		PercShortTrail2 = (100-STrailP2);
		PercShortTrail3 = (100-STrailP3);
		HH = H data2; LL = L data2;
	end;


{ Calculate Pivots at the begining of the day }
If ( Date <> Date[1] ) then Begin
	Pivot = ( Lowd(1) + Highd(1) + Closed(1)) / 3;

	Resistance1 = ( Pivot * 2 ) - Lowd(1);
	Resistance2 = Pivot + (highd(1) - lowd(1));
	Resistance3 = Resistance1 + (highd(1) - lowd(1));

	Support1 = ( Pivot * 2 ) - Highd(1);
	Support2 = Pivot - (highd(1) - lowd(1));
	Support3 = Support1 - (highd(1) - lowd(1));

	numTDay = 0;							
	HH = Highd(1); LL = Lowd(1);
End;


If ( Time > sess1firstbartime + NotBef) 
	and (Time < NotAft) 
	and (numTDay < MaxTDay)
    and adx(14) data2 < 35 and t <> 1430 then 
	Begin
		{ Placement of Short orders }
		If Lowd(1) > Support3 then 
		Begin
			{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			If marketposition = 0 then sellshort("S3 b") next bar at Support3 -5 stop;
			If marketposition = 0 then sellshort("S2 b") next bar at Support2 -5 stop; 
		End;

		{ Placement of long orders }
		If Highd(1) < Resistance3 then 
		Begin
			{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			If marketposition = 0 then Buy("R2 b") next bar at Resistance2 +5 stop;
			If marketposition = 0 then Buy("R3 b") next bar at Resistance3 +5 stop;
		End;	
	End;

{Evaluate the count of trades done}
if (MarketPosition <> 0)and
	(	(EntryDate <> LastEntryDate)or
		(EntryTime <> LastEntryTime)or
		(LastMP <> MarketPosition)	) then
	begin
   	numTDay = numTDay + 1;
		LastEntryDate = EntryDate;
		LastEntryTime = EntryTime;
		LastMP = MarketPosition;
	end;

{Reverse}
if (MarketPosition > 0) 
	and adx(5) data2 < 25 and t <> 1430 
	and OBV data2 >= average(OBV data2, 20) 
	then begin
		Reverse = (EntryPrice * RevPerc) / 100;	 
		if (numTDay < MaxTDay) then {reverse}
			begin
			    {DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
				sellshort("Rlong") next bar at EntryPrice - Reverse Stop;
			end
			else 
			begin
				sell("StopLong") next bar at EntryPrice - Reverse Stop;
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end;
	end;
if (MarketPosition < 0) 
	and adx(14) data2 < 22 and t <> 1430 
	and OBV data2 >= average(OBV data2, 20) 
	then begin
		Reverse = (EntryPrice * RevPerc) / 100;	 
		if (numTDay < MaxTDay) then {reverse}
			begin
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
				Buy("Rshort") next bar at EntryPrice + Reverse Stop;
			end else {no more buy signals are allowed, so this is a stop loss}
			begin
				buytocover("StopShort")next bar at  EntryPrice + Reverse Stop;
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end;
	end;

{Evaluate the count of trades done}
if (MarketPosition <> 0)and
	(	(EntryDate <> LastEntryDate)or
		(EntryTime <> LastEntryTime)or
		(LastMP <> MarketPosition)	) then
	begin
   	numTDay = numTDay + 1;
		LastEntryDate = EntryDate;
		LastEntryTime = EntryTime;
		LastMP = MarketPosition;
	end;


if HH < Highd(1) then HH = Highd(1);
if LL > Lowd(1) then LL = Lowd(1);

{Trail Stop Exits}
if (MarketPosition > 0) then  {Long}
	Begin
		Floor1 = EntryPrice * Flr1Perc / 100;
		Floor2 = EntryPrice * Flr2Perc / 100;
		Floor3 = EntryPrice * Flr3Perc / 100;
		if HH - EntryPrice > Floor3 then
  			begin
				LXTrail = EntryPrice + ((HH - EntryPrice)* PercLongTrail3)/100;
				{sell("LX Trail, floor3") next bar at LXTrail stop;}
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end ELSE
		if HH - EntryPrice > Floor2 then
  			begin
				LXTrail = EntryPrice + ((HH - EntryPrice)* PercLongTrail2)/100;
				{sell("LX Trail, floor2") next bar at LXTrail stop;}
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end ELSE
		if HH - EntryPrice > Floor1 then 
  			begin
				LXTrail = EntryPrice + ((HH - EntryPrice)*PercLongTrail1)/100;
				sell ("LX Trail, floor1") next bar at LXTrail stop;				
			    {DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end;
	End;

if (MarketPosition < 0) then {Short}
	Begin
		Floor1 = EntryPrice * Flr1Perc / 100;
		Floor2 = EntryPrice * Flr2Perc / 100;
		Floor3 = EntryPrice * Flr3Perc / 100;
		if EntryPrice - LL > Floor3 then
  			begin
				SXTrail = EntryPrice - ((EntryPrice - LL)* PercShortTrail3)/100;
				{buytocover("SX Trail, floor3") next bar at SXTrail stop;}
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end ELSE
		if EntryPrice - LL > Floor2 then
  			begin
				SXTrail = EntryPrice - ((EntryPrice - LL)* PercLongTrail2)/100;
				{buytocover("SX Trail, floor2") next bar at SXTrail stop;}
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end ELSE
		if EntryPrice - LL > Floor1 then 
  			begin
				SXTrail = EntryPrice - ((EntryPrice - LL)* PercLongTrail1)/100;
				buytocover("SX Trail, floor1") next bar at SXTrail stop;
				{DefineDLLFunc:"RACRT.dll",int,"CONTROLLER","AX ","EM Harvard","2"int,int,int,float;}
			end;
	End;

if marketposition = 1 then sell ("tgl") currentcontracts/2 shares next bar at entryprice+ 4.8*avgtruerange(14) limit;
if marketposition = -1 then buytocover ("tgs") currentcontracts/2 shares next bar at entryprice - 4.8*avgtruerange(14) limit;

if marketposition = 1 then sell ("maxl") next bar at entryprice*0.98 stop;
if marketposition = -1 then buytocover ("maxs") next bar at entryprice*1.02 stop;

if currentcontracts <= nos/2 THEN BEGIN
   if marketposition = 1 then sell ("DayL") next bar at lowd(0) -10 stop;
   if marketposition = -1 then buytocover ("DayS") next bar at highd(0) +10 stop;
END;

if T = 1735 Then Begin
	if marketposition = 1 then sell ("eodl") next bar at market;
	if marketposition = -1 then buytocover ("eods") next bar at market;
end;
{End of Day exits}
setexitonclose;
//Value99 = WriteTrades3(0, 0, 0, "c:\MSA\"+Getsymbolname+"_"+GetStrategyName+".csv");

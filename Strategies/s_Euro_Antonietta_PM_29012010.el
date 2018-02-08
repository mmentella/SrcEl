[LegacyColorValue = true]; 
[IntrabarOrderGeneration = true];
{*********************************************** - EuroPino v.2.0 - ***************************
Trading system by Romana Acquisizioni
Author: Pino Mascio
Year: 2009
Intraday 10 + Daily minutes w/t OverNight
***********************************************************************************************}

Inputs: NoS(2), bas(40), alt(10), lungSTD(30), apertura(1000), chiusura(2100), aperturaStop(0815), chiusuraStop(2250);
Inputs: lungadx(20), bandaadx(25);
Inputs: par(0.2);
Inputs: LongBandPerc(0.005), ShortBandPerc(0.19),VarPercIngresso(-0.25);
Inputs: ProfitTL(2500),StoppLL(2000),ProfitTS(1500),StoppLS(2000);
Inputs: MarAnt(false);
//Trailing stop
Inputs: TRL(6000),TL(1000),TRS(6000),TS(1000);
Vars: hh(0),ll(0);
//BreakEven
Input: BRLValore(5000),BKSValore(3000),BreakL(1000),BreakS(500);
vars: LvlTrl(0),LvlTrS(0), BRKL(false),BRKS(false);
vars: LvlBRL(0),LvlBRS(0);
vars: TrlA(false),Trsa(false);

Vars: X(0), Y(0), Variazione(0), VA(0), VB(0), OldA(0);
Variables: PosLow(0), ATRVals(0);
Variables: PosHighl(0), ATRVall(0);

Vars: diff(0), med(0), nos2(0);
Vars: gain(0.0), gLoss(0.0), brkActive(false);
Vars: hBand(0.0), lBand(0.0), band(0.0);
Vars: VX(0);

if MarAnt=true then begin
if (t>aperturastop and t<chiusurastop) then begin
	
	
	
	//profit target
	if marketposition=1 and openpositionprofit>= (ProfitTL*nos) then
	begin
		sell("TargetL") nos shares this bar on close;
	end;
	
	if marketposition=-1 and openpositionprofit>= (ProfitTS*nos) then
	begin
		buytocover("TargetS") nos shares this bar on close;
	end;	
	
	
	
end;
end;
if (t>aperturastop and t<chiusurastop) then
begin
       //StopLoss
	SetStoploss(StoppLL*nos);
	SetStoploss(StoppLS*nos);
	
	
	//Trailing Stop
	if marketposition=1 and openpositionprofit>=TRL then
	begin
		TrlA=true;
		Trsa=false;
	end;
	
	if marketposition=-1 and openpositionprofit>=TRS then
	begin
		Trsa=true;
		TrlA=false;
	end;
	
	if marketposition=0 then 
	begin
		TrlA=false;
		Trsa=false;
	end;
	
	if High>=hh then hh=High;
	if Low<=ll then ll=Low;
	
	
	LvlTrl = hh-((TL*nos)/bigpointvalue);
	LvlTrS = ll+((TS*nos)/bigpointvalue);
	
	
	if TrlA and l cross under LvlTrl then
	begin
		sell("TRL") (currentcontracts/2) shares next bar at market;
	end;
	
	if Trsa and h cross over LvlTrS then
	begin
		buytocover("TR") (currentcontracts/2) shares next bar at market;
	end;
	//
	
	//breakeven
	if marketposition=1 and openpositionprofit>= BRLValore then
	begin
		BRKL=true;
		BRKS=false;
	end;
	
	if marketposition=-1 and openpositionprofit>= BKSValore then
	begin
		BRKS=true;
		BRKL=false;
	end;
	
	
	if marketposition=0 then
	begin
		BRKS=false;
		BRKL=false;
       end;
       
       LvlBRL= entryprice+(BreakL/bigpointvalue);
       LvlBRS = entryprice-(BreakS/bigpointvalue);
       
       if brkl and l cross under LvlBRL then
       begin
       	sell("BRKL") nos shares next bar at market;
       end;
       
       if BRKS and h cross over LvlBRS then
       begin
       	buytocover("BRKS") nos shares next bar at market;
       end;
	//
end;
{
if positionprofit(0)>ProfitT and (t>aperturastop and t<chiusurastop) then begin
		if marketposition>0 then Exitlong("ProfitL") next bar at entryprice+(1500/bigpointvalue) stop;	
    	if marketposition<0 then Exitshort("ProfitS") next bar at entryprice-(1500/bigpointvalue) stop;
		SetStoploss(StoppL);
end;
}





Y = X;
X = Stddev(Close of Data(2), lungSTD);
Variazione = (X - Y) / X;

If CurrentBar = 1 then
	VA = 20;

OldA = VA;
VA = OldA * (1 + Variazione);
VA = MaxList(VA, alt);
VA = MinList(VA, bas);
VB=VA * par;
VX=VA*(1+VarPercIngresso);

if T > apertura and T < chiusura then begin
	if Adx(lungadx) of Data(2) < bandaadx then begin
		hBand = Highest(High of Data(2), VX);
		lBand = Lowest(Low of Data(2), VX);
		band = hBand - lBand;
		lBand = lBand - band * ShortBandPerc;
		hBand = hBand + band * LongBandPerc;
		if marketposition[1]=0 or marketposition=-1 then
 		begin

		Buy("EL1") NoS share next bar at hBand Stop;
		end;
		if marketposition[1]=0 or marketposition=1 then
		begin

		Sell Short("ES1") NoS shares next bar at lBand Stop;
		end;
 	end;
	Sell("XL1") NoS share next bar at Lowest(Low of Data(2), VB) Stop;
	Buy to Cover("XS1") NoS share next bar at Highest(High of Data(2), VB) Stop;
end;







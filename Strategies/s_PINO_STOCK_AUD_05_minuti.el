//[IntrabarOrderGeneration = true];

Inputs: Nos(2),STLen(20),COLen(25),MediaStock(11),stdUp(25),stdDown(10),MediaStdUp(7),MediaStdDown(8);
Inputs: FirstTargetShort(4000);
Inputs: FirstTargetLong(9000);
Inputs: TraL(300);
Inputs: Apertura(900),Chiusura(2100), PerditaMaxL(2200),  ProfittoMaxL(1500),  TrailIngStopValL(3200);
Inputs: PerditaMaxS(2200),ProfittoMaxS(700),TrailIngStopValS(2900);

Inputs: FiltroRocLong(-1.70),FiltroRocShort(0),MytrailingLongAttivazione(2000),MyTrailingLongVal(500);;        
Inputs: MytrailingShortAttivazione(5000),MyTrailingShortVal(100);

Vars:   _$Num1(0),_$Denom1(0),_$Ratio1(0),_$PctK1(0),_$Num2(0),_$Denom2(0),
        _$Ratio2(0),_$PctK2(0),_$MB(0),_$UB(0),_$LB(0),_$PctD(0),
        StartOK(false),Bnd(2),SellLine(70),BuyLine(30),Roc(0),TrailingLongAttivo(false),ValoreStopTrailLong(0),HHLT(0);
vars: TrailingShortAttivo(false),ValoreStopTrailShort(0),LLST(-99999);
        
Vars: contagiorni(0),contagiorniApp(0);
condition1= ((t)>=Apertura) and ((t)<chiusura) ;

Inputs: BreakLongAttivazione(3000),BreakStopLong(700),BreakShortAttivazione(1500),BreakStopShort(700);
vars: BLAttivazione(false),BSAttivazione(false);

//Breakeven
if openpositionprofit>= BreakLongAttivazione and marketposition>0 then
begin
	BLAttivazione=true;
	BSAttivazione=false;
end;

if openpositionprofit>= BreakShortAttivazione and marketposition<0 then
begin
	BSAttivazione=true;
	BSAttivazione=false;
end;



if marketposition=0 then
begin
	BLAttivazione=false;
	BSAttivazione=false;
end;


if BLAttivazione and marketposition>0 and condition1 then
begin
	if barssinceentry>0 then sell("BrkL") currentcontracts/2 shares next bar at entryprice+(100/bigpointvalue) stop;
end;

if BSAttivazione and marketposition<0 and condition1 then
begin
	if barssinceentry>0 then buytocover("BrkS") currentcontracts/2 shares next bar at entryprice-(100/bigpointvalue) stop;
end;

//

//MyProfitLong
if marketposition>0 and condition1 then
	begin
	if barssinceentry>0 then	sell("PrimoTrgLong") (currentcontracts/2) shares next bar at entryprice+(FirstTargetLong/bigpointvalue) limit;
	end;

//MyProfitShort
if marketposition<0 and condition1 then
	begin
	if barssinceentry>0 then	buytocover("PrimoTrgShort") (currentcontracts/2) shares next bar at entryprice-(FirstTargetLong/bigpointvalue) limit;
	end;




//My Trailing Long
if marketposition>0 and openpositionprofit>MytrailingLongAttivazione then
	begin
		TrailingLongAttivo=true;
	end;

if marketposition<0 or marketposition=0 then
	begin
		TrailingLongAttivo=false;
	end;

if TrailingLongAttivo and openpositionprofit>0 and condition1 then
	begin
		if h>HHLT then HHLT=h;
		if barssinceentry>1 then sell("MyTrailingL") Nos shares next bar at HHLT-(MyTrailingLongVal/bigpointvalue) stop;
	end;

//My Trailing Short

if marketposition<0 and openpositionprofit>MytrailingShortAttivazione then
	begin
		TrailingShortAttivo=true;
	end;

if marketposition>0 or marketposition=0 then
	begin
		TrailingShortAttivo=false;
	end;

if TrailingShortAttivo and openpositionprofit>0  and condition1 then
	begin
		if l<LLST then LLST=l;
		if barssinceentry>1 then buytocover("MyTrailingS") Nos shares next bar at LLST+(MyTrailingShortVal/bigpointvalue) stop;
	end;

//Chiusura temporale
if marketposition>0 and (d-entrydate)>2 and openpositionprofit<1000 and condition1 then
	begin
		//sell("chiusuraTempL") this bar on close;
		//if barssinceentry>1 then sell("chiusuraTempL") Nos shares this bar on close;
	end;

{if marketposition<0 and (d-entrydate)>2 and openpositionprofit<0 then
	begin
		//buytocover("chiusuraTempS") this bar on close;
		buytocover("chiusuraTempS") Nos shares next bar at entryprice+(TraS/bigpointvalue) stop;

	end;}

Roc = RateOfChange(c data2,100);

{Stoc-1}
_$Num1=C data2-Lowest(L of data(2) ,STLen) ;
_$Denom1=Highest(H data2,STLen)-Lowest(L data2  ,STLen);
_$Ratio1=IFF(_$Denom1>0,(_$Num1/_$Denom1)*100,_$Ratio1[1]);
_$PctK1=IFF(CurrentBar=1,_$Ratio1,_$PctK1[1]+(.5*(_$Ratio1-_$PctK1[1])));

{Stoc-2}
_$Num2=_$PctK1-Lowest(_$PctK1,STLen);
_$Denom2=Highest(_$PctK1,STLen)-Lowest(_$PctK1,STLen);
_$Ratio2=IFF(_$Denom2>0,(_$Num2/_$Denom2)*100,_$Ratio2[1]);
_$PctK2=IFF(CurrentBar=1,_$Ratio2,_$PctK2[1]+(.5*(_$Ratio2-_$PctK2[1])));

{Moving Average}
_$PctD=_SMA(_$PctK2,COLen); 

{Bands}
If Bnd=1 then begin
   _$UB=SellLine;
   _$LB=BuyLine;
End;
If Bnd=2 then begin
   _$MB=_SMA(_$PctK2,MediaStock);
   _$UB=_SMA(_$MB+(1*(StdDev(_$PctK2,stdUp))),MediaStdUp);
   _$LB=_SMA(_$MB+(-1*(StdDev(_$PctK2,stdDown))),MediaStdDown);
End;



if condition1 then
begin
	if marketposition>0 then
	begin
		if barssinceentry>1 then setstoploss(PerditaMaxl*nos);
		//setprofittarget(ProfittoMaxl*nos);
		//setdollartrailing(TrailingStopVall*nos);
	end;
	if marketposition<0 then
	begin
		if barssinceentry>1 then setstoploss(PerditaMaxs*nos);
		//setprofittarget(ProfittoMaxs*nos);
		//setdollartrailing(TrailingStopVals*nos);

	end;
end;


if (_$PctD cross over _$LB) and condition1  and Roc>FiltroRocLong and barstatus(2)=2 then
	begin
		buy nos shares this bar on close;
	end;
	
if (_$PctD cross under _$UB) and condition1 and Roc<FiltroRocShort and barstatus(2)=2  then 
	begin
		sellshort nos shares this bar on close;
	end;	





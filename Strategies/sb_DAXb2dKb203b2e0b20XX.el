[IntraBarOrderGeneration = true]
Inputs:NoS(2),SLL(900),SLS(900),PTarget(4725),TargetL(1400),TargetS(1800),StepL(600),StepS(600);

Inputs: NBL(4),NBS(4),BreakEvenL(700),BreakEvenS(800);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0),level(0),n(0);
Vars: brkl(0),brks(0),posProfit(0);

if barssinceentry > 0 then begin
 setstopshare;
 if marketposition = 1 then setstoploss(SLL);
 if marketposition = -1 then setstoploss(SLS);
 SetProfitTarget(PTarget);
end;

if marketposition = 1 then begin
if positionprofit >= BreakEvenL and barssinceentry > 0 then
 sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
end;

if marketposition = -1 then begin
if positionprofit >= BreakEvenS and barssinceentry > 0 then
 buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
end;

if marketposition = 1 then begin
if barssinceentry >= NBL and maxpositionprofit < 100 and positionprofit < -100 then
 sell("TLL") next bar at market;
end;

if marketposition = -1 then begin
if barssinceentry >= NBS and maxpositionprofit < 100 and positionprofit < -100 then
 buytocover("TLS") next bar at market;
end;

if currentcontracts = (NoS/2) then begin
 
 if positionprofit >= TargetL then posProfit = positionprofit
 else posProfit = TargetL;
 
 if marketposition = 1 then begin
  n = Floor((posProfit)/(currentcontracts*StepL));
  if n >= 1 then begin
   level = (currentcontracts*StepL*(n - 1))/bigpointvalue;
   sell("StepL") next bar at entryprice + level stop;
  end;
 end;
 
 if positionprofit >= TargetS then posProfit = positionprofit
 else posProfit = TargetS;
 
 if marketposition = -1 then begin
  n = Floor((posProfit)/(currentcontracts*StepS));
  if n >= 1 then begin
   level = (currentcontracts*StepS*(n - 1))/bigpointvalue;
   buytocover("StepS") next bar at entryprice - level stop;
  end;
 end;
 
end;

if currentcontracts = NoS and barssinceentry > 0 then begin
 if marketposition = 1 then sell("TrgtL") (NoS/2) shares next bar at entryprice + TargetL/bigpointvalue limit;
 if marketposition = -1 then buytocover("TrgtS") (NoS/2) shares next bar at entryprice - TargetS/bigpointvalue limit;
end;

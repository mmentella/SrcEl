[IntraBarOrderGeneration = true];
Inputs: StopLossL(2500),StopLossS(2500),brkStart(800),perc(.25);
vars: nos(0);

if marketposition <> 0 and barssinceentry = 0 then nos = currentcontracts;

setstopshare;
if marketposition = 1 then begin
 setstoploss(stoplossl);
 if currentcontracts = nos then begin
  if maxpositionprofit > brkStart then sell("brkl") next bar at entryprice + (brkStart*(1-perc))/bigpointvalue stop;
 end;
end;
if marketposition = -1 then begin
 setstoploss(stoplosss);
 if currentcontracts = nos then begin
  if maxpositionprofit > brkStart then buytocover("brks") next bar at entryprice - (brkStart*(1-perc))/bigpointvalue stop;
 end;
end;

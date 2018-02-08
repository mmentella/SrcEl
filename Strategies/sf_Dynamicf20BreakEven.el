//[IntraBarOrderGeneration = true];
Inputs: NoS(2),StepL(500),StepS(500),StopLoss(2500);
Vars: Step(0),level(0),stopp(0),k(0);

//Trailing Stop a Gradino
step = (High - entryprice)*bigpointvalue;
if marketposition = 1 and step > 0 then begin 
 k = step/stepl;
 stopp = Floor(stepl*(1 + 1/k));
 level = (k*step - stopp)/bigpointvalue;
 sell next bar at entryprice + level stop;
end;

step = (entryprice - low)*bigpointvalue;
if marketposition = -1 and step > 0 then begin 
 k = step/steps;
 stopp = Floor(steps*(1 + 1/k));
 level = (stopp - k*step)/bigpointvalue;
 buytocover next bar at entryprice + level stop;
end;

setstopshare;
setstoploss(stoploss);

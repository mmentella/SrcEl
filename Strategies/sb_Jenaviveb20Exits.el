Inputs: StepL(50),StepS(50),Stopp(50),Intrabar(true);

Vars: n(0),level(0),nos(0);

Vars: outOfDate(false);

outOfDate = date > 9991231;

if outOfDate = false then begin

//if Intrabar then [IntrabarOrderGeneration = true]

nos = absvalue(currentcontracts);

if positionprofit > 0 and nos <> 0 then begin
 
  if marketposition = 1 then begin
   n = Floor(positionprofit/(nos*stepL));
   if n >= 1 then begin
    level = (nos*StepL*(n + 1 + 1/n))/bigpointvalue;
    sell next bar at entryprice + level stop;
   end;
  end;
  
  if marketposition = -1 then begin
   n = Floor(positionprofit/(nos*StepS));
   if n >= 1 then begin
    level = (nos*StepS*(n + 1 + 1/n))/bigpointvalue;
    buytocover next bar at entryprice - level stop;
   end;
  end;
  
end;
 
if marketposition <> 0 then SetStopLoss(Stopp*nos);

end;

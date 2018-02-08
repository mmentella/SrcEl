[IntraBarOrderGeneration = true];
Vars: NoS(2),MinLen(5),MaxLen(30),VolLen(30),VLen(20);
Inputs: StopL(1400),StopS(1500),TargetL(4400),TargetS(2200),StepL(300),StepS(300);

Vars: vadx(0),bull(false),bear(false),len(0),k(0),hh(0),ll(0),VAR0(0),intrabar(false);
Vars: Step(0),level(0),stopp(0),n(0);

if barstatus = 2 then begin
 vadx = VIDYADX(Close,vlen);
 bull = vadx > vadx[1];
 bear = vadx < vadx[1];
 VAR0 = StdDev(Close,VolLen);
 k =  iff(var0<>0,1 - VAR0[1]/VAR0,0);
 len = len*(1+k);
 len = minlist(len,maxlen);
 len = maxlist(len,minlen);
 hh = highest(high,len);
 ll = lowest(low,len);
end;

if time > 800 and time < 2200 then begin
 
 if barssinceentry > 0 then begin
  if marketposition = 1 then begin
   sell("stopL") next bar at entryprice - StopL/bigpointvalue stop;
   if currentcontracts = NoS then begin 
    sell("tgtl") (NoS/2) shares next bar at entryprice + TargetL/bigpointvalue limit;
   end;
  end;
  if marketposition = -1 then begin
   buytocover("stopS") next bar at entryprice + StopS/bigpointvalue stop;
   if currentcontracts = NoS then begin 
    buytocover("tgts") (NoS/2) shares next bar at entryprice - TargetS/bigpointvalue limit;
   end;
  end;
 end;
 
 if marketposition <> 0 then intrabar = barssinceentry = 0;
 if marketposition = 0 and marketposition(1) = 0 then intrabar = false;
 if marketposition = 0 and marketposition(1) <> 0 then intrabar = barssinceexit(1) = 0;
 
 if intrabar = false then begin
  if bull then buy nos shares next bar at hh stop;
  if bear then sellshort nos shares next bar at ll stop;
 end;
 
end;

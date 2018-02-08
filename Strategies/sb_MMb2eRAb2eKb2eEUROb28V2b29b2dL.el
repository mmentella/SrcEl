Inputs: NoS(2),FL(2.65),FS(3.7),KLenL(14),KLenS(11),MinLen(5),MaxLen(44);
Inputs: TargetL(2800),StopL(2600),BKL(700);

Vars: UpperK(0,data2),LowerK(0,data2),K(0,data2),SD(0,data2),lenl(MinLen,data2),lens(MinLen,data2),posprofit(0),work(false);
vars: stpv(0),stpw(0),stp(true),mkt(false),reason(0),position(0),stoploss(1),breakeven(12),target(2),bpv(1/bigpointvalue);
vars: buy1(true),short1(true);
{***************************}
{***************************}
work = time data2 > 1000 and time data2 < 2000;

posprofit = MM.MaxContractProfit;

sd = StdDev(h,klenl) data2;
k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl) data2;
 
sd = StdDev(l,klens) data2;
k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs) data2;
{***************************}
{***************************}
buy1   = work and c < upperk and c data2 < upperk;
short1 = work and c > lowerk and c data2 > lowerk;
{***************************}
{***************************}
if work then begin
 if c < upperk and c data2 < upperk then buy("el") nos shares next bar at upperk stop;
 if c > lowerk and c data2 > lowerk then sell("es") nos shares next bar at lowerk stop;
end;
{***************************}
{***************************}
if marketposition = 1 and 800 < t and t < 2300 then begin
 
 stpw   = lowerk;
 reason = position;
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 
 if short1 then begin
  if stpv > stpw then begin
   stpw   = stpv;
   reason = stoploss;
  end;
 end else begin
  stpw   = stpv;
  reason = stoploss;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 8*MinMove points;
 
 if posprofit > bkl*bpv then begin
  if stpv > stpw then begin
   stpw   = stpv;
   reason = breakeven;
  end;
 end;
 
 if reason > position then begin
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = breakeven then begin
   if stp then sell("xl.brk") next bar stpw stop
   else if mkt then sell("xl.brk.m") this bar c;
  end;
 end;
 
 //MODAL
 stpv = entryprice + targetl*bpv;
 stp  = currentcontracts = nos and c <  stpv;
 mkt  = currentcontracts = nos and c >= stpv;
 
 if stp then sell("xl.mod") .5*nos shares next bar stpv limit
 else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
 
end;
{***************************}
{***************************}

Vars: NoS(2),FL(2.65),FS(3.7),KLenL(14),KLenS(11),MinLen(5),MaxLen(44);
Vars: TargetL(2800),TargetS(1400),StopL(2600),StopS(1000),BKL(700),BKS(1200);

Vars: UpperK(0,data2),LowerK(0,data2),K(0,data2),SD(0,data2),lenl(MinLen,data2),lens(MinLen,data2),
      posprofit(0),work(false);
      
if MM.TradingRights then begin

work = time data2 > 1000 and time data2 < 2000;

setstopshare;
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

if work then begin
 if c < upperk and c data2 < upperk then buy("el") nos shares next bar at upperk stop;
 if c > lowerk and c data2 > lowerk then sellshort("es") nos shares next bar at lowerk stop;
end;

if t > 800 and t < 2300 then begin
 if marketposition = 1 then setstoploss(stopl);
 if marketposition = -1 then setstoploss(stops);
end;

if currentcontracts = nos and t > 800 and t < 2300 then begin
 if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + TargetL/bigpointvalue limit;  
 if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - TargetS/bigpointvalue limit;
end;

if t > 800 and t < 2300 then begin
 if marketposition = 1 then
  if posprofit > bkl/bigpointvalue then sell("bkl") next bar at entryprice + 100/bigpointvalue stop;
 if marketposition = -1 then
  if posprofit > bks/bigpointvalue then buytocover("bks") next bar at entryprice - 100/bigpointvalue stop;
end;

end;

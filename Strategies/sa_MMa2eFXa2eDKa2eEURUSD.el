Inputs: FL(0.2),FS(1.2),KLenL(33),KLenS(27),MinLen(9),MaxLen(50);
Inputs: stopl(1000);
Inputs: stops(410 );

vars: UpperK(0),LowerK(0),K(0),SD(0),lenl(MinLen),lens(MinLen);
vars: stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue);

sd = StdDev(h,klenl);
if sd <> 0 then k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl);
 
sd = StdDev(l,klens);
if sd <> 0 then k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs);

if marketposition <> 0 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
    
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
 end;

end;

if marketposition < 1 and c < upperk then
 buy("el") next bar upperk stop;
if marketposition > -1 and c > lowerk then
 sellshort("es") next bar lowerk stop;

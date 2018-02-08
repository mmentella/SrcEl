Inputs: FL(0.4),FS(1.9),KLenL(2),KLenS(12),MinLen(13),MaxLen(38);
Inputs: stopl(100000);
Inputs: stops(410000);

vars: upk(0),lok(0),k(0),sdl(0),sds(0),lenl(MinLen),lens(MinLen);
vars: stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue);

sdl = StdDev(h,klenl);
if sdl <> 0 then k = 1 - sdl[1]/sdl;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

upk = KeltnerChannel(h,lenl,fl);
 
sds = StdDev(l,klens);
if sds <> 0 then k = 1 - sds[1]/sds;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lok = KeltnerChannel(l,lens,-fs);

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

if c < upk then
 buy("el") next bar upk stop;
if c > lok then
 sellshort("es") next bar lok stop;

Inputs: nos(2),lenl(26),kl(1.188),lens(82),ks(2.888),alphal(.121),alphas(.21),adxlen(13),adxlimit(29);
Inputs: stopl(2900),stopdl(2300),modl(2200),tl(4400);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2);
vars: stpv(0),stpw(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),trade(true);

vars: short1(true),reason(0),position(0),stoploss(10),daystop(11),bpv(1/bigpointvalue);
vars: adxval1(0),es1(false),mp(0),vmp(0);

if d <> d[1] then begin yc = c[1]; trade = true; end;

if vmp > -1 and trade[1] and adxval1 < adxlimit and mp[1] > -1 and c[1] > lok and es1[1] and l < lok and 800 < t[1] and t[1] < 2200 then begin
 trade = false;
 vmp   = -1;
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 adxval = adx(adxlen)data2;
end;

mcp = MM.MaxContractProfit;

adxval1 = adxval;
es1     = es;
mp      = marketposition;
short1  = trade and adxval < adxlimit and marketposition = 1 and c > lok and es;

if t > 800 and t < 2200 then begin

 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
  if marketposition = 1 then begin
   
   vmp = 1;
   
   reason = position;
   stpw   = lok;
   
   //STOPLOSS
   stpv = entryprice - stopl*bpv;
   
   if short1 then begin
    if stpv > stpw then begin
     reason = stoploss;
     stpw   = stpv;
    end;
   end else begin
    reason = stoploss;
    stpw   = stpv;
   end;
   
   //DAYSTOP
   stpv = yc - stopdl*bpv;
   
   if d < entrydate and stpv > stpw then begin
    reason = daystop;
    stpw   = stpv;
   end;
   
   if reason > position then begin
    
    stp = c >  stpw and stpw > minstop;
    mkt = c <= stpw;
    
    if reason = stoploss then begin
     if stp then sell("xl.stp") next bar stpw stop
     else if mkt then sell("xl.stp.m") this bar c;
    end else
    if reason = daystop then begin
     if stp then sell("xl.funk") next bar stpw stop
     else if mkt then sell("xl.funk.m") this bar c;
    end;
   
   end;
   
   //PROFIT TARGET
   stpv = entryprice + (tl + currentcontracts*(slippage+commission))/bigpointvalue;
   stp  = currentcontracts = .5*nos and c < stpv and stpv < maxstop;
   mkt  = currentcontracts = .5*nos and c >= stpv;
   
   if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
   else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
   
   //MODAL EXIT
   stpv = entryprice + modl/bigpointvalue;
   stp  = currentcontracts = nos and c < stpv and stpv < maxstop;
   mkt  = currentcontracts = nos and c >= stpv;
   
   if stp then sell("xl.mod") .5*nos shares next bar stpv limit
   else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
      
  end;
  
 end;
 
 if trade and adxval < adxlimit then begin
 
  if marketposition < 1 and c < upk and el then
   buy("el") nos shares next bar at upk stop;
   
  if marketposition = 1 and c > lok and es then
   sell("es") nos shares next bar at lok stop;
   
 end;

end;

//RELEASE
if d = 1100624 and d <> d[1] then begin
 value1 = text_new(d,t,h,"Inizio Equity Reale: "+NewLine+MM.ELDateToString_IT(1100624));
 text_setbgcolor(value1,lightgray);
 text_setborder(value1,true);
 text_setcolor(value1,black);
end;

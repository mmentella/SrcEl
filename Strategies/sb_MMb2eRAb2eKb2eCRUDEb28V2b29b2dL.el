{**** - MM.RA.K.CRUDED(V2)-L - ****
 Engine: Keltner Channel
 Author: Matteo Montella
 Year: 2010
 Market: Crude Oil futures
 TimeFrame: 2 + 60 min.
 BackBars: 50
 Update: 11 Lug 2011
***********************************}
Inputs: NoS(2),LenL(19),KL(2.07),LenS(6),KS(4.85),ADXLen(24),ADXLimit(24);
Inputs: StopL(0490),BRKL(700),TL(3100),TRSL(2100);
Inputs: StopS(1700),BRKS(700),TS(1900),TRSS(2900);
Inputs: StopLimitPerc(0),SettleTime(0),goshort(false);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0);
Vars: underK(false,data2),overK(false,data2);
Vars: stpv(0),stpw(0),stp(true),mkt(false),stopMin(0),stopMax(999999),SettlePrice(0);
vars: reason(0),position(0),stoploss(1),breakeven(2),trailing(3),bpv(1/bigpointvalue);

{ Process Variables }
Vars: OpenTime(0800), CloseTime(2200);


{ max/min Stop Update }
if StopLimitPerc > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  stopMin = SettlePrice*(1-StopLimitPerc/100);
  stopMax = SettlePrice*(1+StopLimitPerc/100);
  settlePrice = 0; 
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;

// new TimeFrame2 bar
if BarStatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
end; // of new TimeFrame2 bar

if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

if OpenTime < Time and time < CloseTime then begin
 
 if marketposition = 1 then begin
  
  stpw   = lowerk;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if stpv > stpw or not (adxval < adxlimit and overK and c > lowerk) then begin
   reason = stoploss;
   stpw   = stpv;
   stp    = c > stpv and stpw > stopMin;
   mkt    = c <= stpv; 
  end;
  
  //BREAKEVEN
  stpv = entryprice + 100*bpv;
  
  if mpp > brkl*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
   stp    = mpp > brkl*bpv and c > stpv and stpw > stopMin;
   mkt    = mpp > brkl*bpv and c <= stpv;
  end;
  
  //TRAILING STOP
  stpv = entryprice + mpp - trsl*bpv;
  
  if mpp > brkl*bpv and stpv > stpw then begin
   reason = trailing;
   stpw   = stpv;
   stp    = mpp > brkl*bpv and c > stpw and stpw > stopMin;
   mkt    = mpp > brkl*bpv and c <= stpw; 
  end;
  
  if reason <> position then begin
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
    
   end else if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
    
   end else if reason = trailing then begin
    if stp then sell("xl.trl") next bar stpw stop
    else if mkt then sell("xl.trl.m") this bar c;   
     
   end;
   
  end;
  
  //MODAL
  stpv = entryprice + tl*bpv;
  stp  = nos > 1 and currentcontracts = nos and c < stpv and stpw < stopMax;
  mkt  = nos > 1 and currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.mod") nos - 1 shares next bar stpv limit
  else if mkt then sell("xl.mod.m") nos - 1 shares this bar c;
  
 end else if marketposition = -1 then begin
  
  stpw   = upperk;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  
  if stpv < stpw or not (adxval < adxlimit and overK and c > lowerk) then begin
   reason = stoploss;
   stpw   = stpv;
   stp    = c < stpv and stpw < stopMax;
   mkt    = c >= stpv; 
  end;
  
  //BREAKEVEN
  stpv = entryprice - 100*bpv;
  
  if mpp > brks*bpv and stpv < stpw then begin
   reason = breakeven;
   stpw   = stpv;
   stp    = mpp > brks*bpv and c < stpv and stpw < stopMax;
   mkt    = mpp > brks*bpv and c <= stpv;
  end;
  
  if reason <> position then begin
   
   if reason = stoploss then begin
    if stp then buy to cover("xs.stp") next bar stpw stop
    else if mkt then buy to cover("xs.stp.m") this bar c;
    
   end else if reason = breakeven then begin
    if stp then buy to cover("xs.brk") next bar stpw stop
    else if mkt then buy to cover("xs.brk.m") this bar c;
    
   end else if reason = trailing then begin
    if stp then buy to cover("xs.trl") next bar stpw stop
    else if mkt then buy to cover("xs.trl.m") this bar c;   
     
   end;
   
  end;
  
  //MODAL
  stpv = entryprice - ts*bpv;
  stp  = nos > 1 and currentcontracts = nos and c > stpv and stpw > stopMin;
  mkt  = nos > 1 and currentcontracts = nos and c <= stpv;
  
  if stp then buy to cover("xs.mod") nos - 1 shares next bar stpv limit
  else if mkt then buy to cover("xs.mod.m") nos - 1 shares this bar c;
  
 end;

 //ENGINE
 if adxval < adxlimit then begin
  
  if marketposition < 1 and underK and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  
  if not goshort then begin
   if marketposition > -1 and overK and c > lowerk then
    sell("xshort") nos shares next bar at lowerk stop;
  end else if goshort then begin
   if marketposition > -1 and overK and c > lowerk then
    sell short("short") nos shares next bar at lowerk stop;
  end;
 end;

end;

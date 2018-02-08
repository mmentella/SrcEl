Inputs: nos(2),lenl(16),kl(2.02),lens(6),ks(3.8),adxlen(6),adxlimit(28);
Inputs: stopl(1300),stops(1600),mcpl(500),mcps(800),brkl(1900),brks(1900);
Inputs: modl(1500),mods(1100),tl(7900),ts(4700);

vars: upk(0,data2),lok(0,data2),adxv(0,data2),bsetup(false,data2),ssetup(false,data2);
vars: trade(true),mcp(0),bar2(false),nbar2(false,data2),bounce(false);
vars: xl.mod(false),xs.mod(false);

mcp = MM.MaxContractProfit;
if nbar2 <> bar2 then trade = true;
bounce = false;

if barstatus(2) = 2 then begin
 
 nbar2 = not nbar2;
 
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 bsetup = c data2 < upk and t data2 >= 800;
 ssetup = c data2 > lok and t data2 >= 800;
 
 adxv = adx(adxlen)data2;
end;

if t >= 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
  xl.mod = h >= entryprice + (tl + currentcontracts*(slippage+commission))/bigpointvalue;
  xs.mod = l <= entryprice - (ts + currentcontracts*(slippage+commission))/bigpointvalue;  
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(iff(marketposition=1,MM.StopLoss(stopl),MM.StopLoss(stops)));
  if marketposition = 1 and mcp < mcpl/bigpointvalue then begin
   sell("xl.sl") next bar at MM.TrailingStop(stopl,mcp) stop;
   bounce = lok < MM.TrailingStop(stopl,mcp);
  end;
  if marketposition = -1 and mcp < mcps/bigpointvalue then begin
   buytocover("xs.sl") next bar at MM.TrailingStop(stops,mcp) stop;
   bounce = upk > MM.TrailingStop(stops,mcp);
  end;
  
  //PROFIT TARGET
  setprofittarget(iff(marketposition=1,MM.ProfitTarget(tl),MM.ProfitTarget(ts)));
  
  //BREAK EVEN
  if marketposition = 1 and mcp > brkl/bigpointvalue then begin
   sell("xl.brk") next bar at MM.BreakEven(100) stop;
   if not bounce then bounce = lok < MM.BreakEven(100);
  end;
  if marketposition = -1 and mcp > brks/bigpointvalue then begin
   buytocover("xs.brk") next bar at MM.BreakEven(100) stop;
   if not bounce then bounce = upk > MM.BreakEven(100);
  end;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("xl.mod") nos/2 shares next bar at MM.ModalExit(modl) limit;
   if marketposition = -1 then buytocover("xs.mod") nos/2 shares next bar at MM.ModalExit(mods) limit;   
  end;
  
  //CORRECTION
  if marketposition = 1 then begin
   if xl.mod then sell("xl.mod.m") this bar on c;
  end;
  if marketposition = -1 then begin
   if xs.mod then buytocover("xs.mod.m") this bar on c;
  end;
  
 end;
 
 //ENGINE
 if barstatus(2) <> 2 then begin
  if adxv < adxlimit and trade then begin
   if marketposition < 1 and bsetup and not bounce then
    if c < upk then buy("el.s") nos shares next bar at upk stop;
   if marketposition > -1 and ssetup and not bounce then
    if c > lok then sellshort("es.s") nos shares next bar at lok stop;
  end;
 end;
  
end;

if barstatus(2) <> 2 then bar2 = nbar2;

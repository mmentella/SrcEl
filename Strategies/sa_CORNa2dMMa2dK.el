Inputs: nos(2),lenl(11),kl(0.61),lens(46),ks(2.73),alpha(.1),adxlen(14),adxlimit(29),sod(1000),eod(2000);
Inputs: stopl(800),stops(800),brkl(500),brks(600),modl(900),mods(800),tl(2600),ts(4700);

vars: upk(0,data2),lok(0,data2),bst(false,data2),engine(false,data2),sst(false,data2),adxv(0,data2),mcp(0);
vars: trade(false),bar2(false),nbar2(false,data2);

mcp = MM.MaxContractProfit;

if bar2 <> nbar2 then trade = true;

if currentbar > 10 then begin

if barstatus(2) = 2 then begin
 
 nbar2 = not nbar2;
 
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 bst = c data2 < upk;
 sst = c data2 > lok;
 
 adxv = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;
end;

if t > 800 and t < eod then begin
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(iff(marketposition=1,MM.StopLoss(stopl),MM.StopLoss(stops)));
  
  //PROFIT TARGET
  setprofittarget(iff(marketposition=1,MM.ProfitTarget(tl),MM.ProfitTarget(ts)));
  
  //BREAK EVEN
  if marketposition = 1 and mcp > brkl/bigpointvalue then
   sell("xl.brk") next bar at MM.BreakEven(100) stop;
  if marketposition = -1 and mcp > brks/bigpointvalue then
   buytocover("xs.brk") next bar at MM.BreakEven(100) stop;
   
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("xl.mod") nos/2 shares next bar at MM.ModalExit(modl) limit;
   if marketposition = -1 then buytocover("xs.mod") nos/2 shares next bar at MM.ModalExit(mods) limit;   
  end;
  
 end;

 if adxv < adxlimit and engine and trade then begin
  if marketposition < 1 and bst then
   buy("el") nos shares next bar at upk stop;
  if marketposition > -1 and sst then
   sellshort("es") nos shares next bar at lok stop;
 end;

end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;

if barstatus(2) <> 2 then bar2 = nbar2;

Inputs: nos(4),lenl(22),kl(2.61),lens(23),ks(2.05),alpha(.21),adxlen(19),adxlimit(26),sod(800),eod(1930);
Inputs: stopl(1500),stops(1300),brkl(1700),brks(1500),modl(1600),mods(1000),tl(7600),ts(4000);

vars: upk(0,data2),lok(0,data2),bsetup(false,data2),ssetup(false,data2),adxv(0,data2),mcp(0);

if currentbar > 10 then begin

mcp = MM.MaxContractProfit;

if barstatus(2) = 2 then begin

upk = KeltnerChannel(h,lenl,kl)data2;
lok = KeltnerChannel(l,lens,-ks)data2;

upk = MM.Smooth(upk,alpha);
lok = MM.Smooth(lok,alpha);

bsetup = c data2 < upk;
ssetup = c data2 > lok;

adxv = adx(adxlen)data2;

end;

if t > sod and t < eod then begin
 
 if marketposition <> 0 then begin
  
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

 if adxv < adxlimit then begin
  if marketposition < 1 and bsetup then
   buy("el") nos shares next bar at upk stop;
  if marketposition > -1 and ssetup then
   sellshort("es") nos shares next bar at lok stop;
 end;

end;

end else begin
 if barstatus(2) = 2 then begin
  upk = KeltnerChannel(h,lenl,kl)data2;
  lok = KeltnerChannel(l,lens,-ks)data2;
 end;
end; 

//Inputs: stopl(1500),stops(1300),brkl(1700),brks(1500),modl(1600),mods(1000),tl(7600),ts(4000);

Inputs: nos(2),lenl(45),kl(.05),lens(35),ks(4.22),alpha(.14),adxlen(5),adxlimit(34),sod(800),eod(1900);
Inputs: stopl(1950),stops(1600),brkl(850),brks(900),modl(1300),mods(1300),tl(4300),ts(4300);

vars: upk(0,data2),lok(0,data2),adxv(0,data2),engine(true,data2),bs(true,data2),ss(true,data2),mcp(0);

mcp = MM.MaxContractProfit;

if currentbar > 10 then begin

if barstatus(2) = 2 then begin
 
 upk   = KeltnerChannel(h,lenl,kl)data2;
 lok   = KeltnerChannel(l,lens,-ks)data2;
 
 upk   = MM.Smooth(upk,alpha);
 lok   = MM.Smooth(lok,alpha);
 
 bs = c data2 < upk;
 ss = c data2 > lok;
 
 adxv  = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;

end;

if t > 800 and t < 2200 then begin
 
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
   if marketposition = 1 then sell("xl.mod") nos/2 shares next bar at MM.ModalExit(modl) limit
   else buytocover("xs.mod") nos/2 shares next bar at MM.ModalExit(mods) limit;   
  end;
  
 end;

 if adxv < adxlimit and engine then begin
 
  if marketposition < 1 and bs then
   buy("el") nos shares next bar at upk stop;
   
  if marketposition > -1 and ss then
   sellshort("es") nos shares next bar at lok stop;
   
 end;
 
end;

end else begin
 upk   = KeltnerChannel(h,lenl,kl)data2;
 lok   = KeltnerChannel(l,lens,-ks)data2;
end;

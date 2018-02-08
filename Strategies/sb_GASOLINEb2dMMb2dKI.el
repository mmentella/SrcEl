Inputs: nos(2),lenl(11),kl(2),lens(26),ks(2),pl(1),ps(1),reverse(false),maxtrades(1),sod(1000),eod(2300),closetime(2300);
Inputs: stopl(100000),stops(100000),brkl(100000),brks(100000),modl(100000),mods(100000),tl(100000),ts(100000);

vars: upk(0),lok(0),adxv(0),trades(0),mcp(0);

if d <> d[1] then trades = 0;

if t > sod then begin
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 mcp = MM.MaxContractProfit;
 
 if marketposition <> 0 then begin
  
  //TRADES COUNTER
  if barssinceentry = 0 then trades = trades + 1;
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(iff(marketposition =1,stopl,stops));
  
  //PROFIT TARGET
  setprofittarget(iff(marketposition =1,tl,ts));
  
  //BREAKEVEN
  if marketposition = 1 and mcp > brkl/bigpointvalue then
   sell("xl.brk.s") next bar at entryprice + 100/bigpointvalue stop;
  if marketposition = -1 and mcp > brks/bigpointvalue then
   buytocover("xs.brk.s") next bar at entryprice - 100/bigpointvalue stop;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("xl.mod.s") nos/2 shares next bar at entryprice + modl/bigpointvalue limit;
   if marketposition = -1 then buytocover("xs.mod.s") nos/2 shares next bar at entryprice - mods/bigpointvalue limit;
  end;
  
  //REVERSE
  if reverse and trades < 2 and positionprofit < 0 then begin
   if marketposition = 1 then sellshort("rev.s") nos shares next bar at entryprice - (stopl-100)/bigpointvalue stop;
   if marketposition = -1 then buy("rev.l") nos shares next bar at entryprice + (stops-100)/bigpointvalue stop;
  end;
  
 end;
 
 //ENGINE
 if t < eod and  trades < maxtrades then begin
  if c < upk and range < avgtruerange(floor(pl*lenl)) then buy nos shares next bar at upk stop;
  if c > lok and range < avgtruerange(floor(ps*lens)) then sellshort nos shares next bar at lok stop;
 end;

end;

if t >= closetime then begin
 if marketposition = 1 then sell("xl.eod") this bar on close;
 if marketposition = -1 then buytocover("xs.eod") this bar on close;
end;

setexitonclose;

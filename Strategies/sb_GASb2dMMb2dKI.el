Inputs: nos(2),lenl(20),kl(2),lens(23),ks(2),pl(1),ps(1.5),maxtrades(1),sod(1440),eod(2030);
Inputs: stopl(1200),stops(600),brkl(900),brks(600),modl(3200),mods(2400);

vars: upk(0),lok(0),cek(0),trades(0),mcp(0);

if d <> d[1] then trades = 0;

if t > sod then begin
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 cek = .5*(upk+lok);
 
 mcp = MM.MaxContractProfit;
 
 if marketposition <> 0 then begin
  
  //TRADES COUNTER
  if barssinceentry = 0 then trades = trades + 1;
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(iff(marketposition =1,stopl,stops));
  
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
  
 end;
 
 //ENGINE
 if t < eod and  trades < maxtrades then begin
  if c < upk and range < avgtruerange(floor(pl*lenl)) then buy nos shares next bar at upk stop;
  if c > lok and range < avgtruerange(floor(ps*lens)) then sellshort nos shares next bar at lok stop;
 end;

end;

if t >= 2230 then begin
 if marketposition = 1 then sell("xl.eod") this bar on c;
 if marketposition = -1 then buytocover("xs.eod") this bar on c;
end;

setexitonclose;

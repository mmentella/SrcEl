Inputs: nos(2),lenl(22),lens(15),kl(1.13),ks(3.19),stochlen(14),os(34),ob(74),alpha(.2);
Inputs: stopl(500),stops(500),brkl(700),brks(500),modl(2000),mods(1200),tl(4300),ts(2400),trsl(1700),trss(1200);
Inputs: StopLimitPerc(0), SettleTime(0);

vars: upk(0,data2),lok(0,data2),stochval(0,data2),bs(true,data2),ss(true,data2),mcp(0);
Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0),trades(0);

{ MAX/MIN STOP UPDATE }
if StopLimitPerc > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  stopMin = SettlePrice*(1-StopLimitPerc/100);
  stopMax = SettlePrice*(1+StopLimitPerc/100);
  settlePrice = 0; 
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;

if d <> d[1] then trades = 0;

if barstatus(2) = 2 then begin
 upk      = KeltnerChannel(h,lenl,kl)data2;
 lok      = KeltnerChannel(l,lens,-ks)data2;
 
 upk      = alpha*upk + (1-alpha)*upk[1];
 lok      = alpha*lok + (1-alpha)*lok[1];
 
 bs       = c data2 < upk; 
 ss       = c data2 > lok;
 
 stochval = SlowK(stochlen)data2;
end;

mcp = MM.MaxContractProfit;
if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if marketposition <> 0 then begin
 
 
 
end;

//ENGINE
if trades < 1 and stochval > os and stochval < ob then begin
 if marketposition < 1 and bs and c < upk then
  buy("el.s") nos shares next bar at upk stop;
 if marketposition > -1 and ss and c > lok then
  sellshort("es.s") nos shares next bar at lok stop;
end;

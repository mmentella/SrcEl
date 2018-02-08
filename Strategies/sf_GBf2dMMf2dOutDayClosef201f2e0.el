Inputs: NoS(2),lenl(15),kl(3.13),lens(20),ks(4.69),alfa(.2),k(3.5),k1(10);
Inputs: stoploss(1500),brk(100000),tgl(1500),tgs(1200),tgl1(2600),tgs1(2300);

Vars: th(0),tl(0),yh(0),yl(0),buysetup(false),sellsetup(false),upperk(0),lowerk(0),mcp(0),gap(false);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

mcp = MM.MaxContractProfit;

if currentbar > MaxBarsBack then begin
 
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];
 
 if d > d[1] then begin
  th = h;
  tl = l;
  yh = th[1];
  yl = tl[1];
  buysetup = false;
  sellsetup = false;
  gap = l > h[1] + k*range[1] or h < l[1] - k*range[1];
 end;
 
 th = maxlist(h,th);
 tl = minlist(l,tl);
 
 if buysetup = false then buysetup = th > yh;
 if sellsetup = false then sellsetup = tl < yl;
 
 if marketposition <> 0 then begin
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(stoploss);
  if gap = true then begin
   if marketposition = 1 then sell next bar at market;
   if marketposition = -1 then buytocover next bar at market;
  end;
  
  if barssinceentry = 0 and range > k1*range[1] then begin
   if marketposition = 1 then sell this bar on close;
   if marketposition = -1 then buytocover this bar on close;
  end;
  
  //BREAKEVEN
  if mcp > brk/bigpointvalue then begin
   if marketposition = 1 then sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
   if marketposition = -1 then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  end;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tgl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - tgs/bigpointvalue limit;
  end;
  
  //PROFIT TARGET
  if currentcontracts = nos/2 then begin
   if marketposition = 1 then setprofittarget(tgl1);
   if marketposition = -1 then setprofittarget(tgs1);
  end;
  
 end;
 
 //ENGINE
 if gap = false then begin
  if buysetup and c < upperk then
   buy nos shares next bar at upperk stop;
  if sellsetup and c > lowerk then
   sellshort nos shares next bar at lowerk stop;
 end;
 
end;


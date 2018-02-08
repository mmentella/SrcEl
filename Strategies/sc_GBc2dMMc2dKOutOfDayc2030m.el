Inputs: NoS(2),lenl(20),kl(1.5),lens(20),ks(1.5),alfa(.2);
//Inputs: stoploss(1500),brk(1300),tgl(1400),tgs(1600),tgl1(5000),tgs1(1700),k(3.5);

Vars: th(0),tl(0),yh(0),yl(0),buysetup(false),sellsetup(false),upperk(0),lowerk(0),mcp(0);

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
 end;
 
 th = maxlist(h,th);
 tl = minlist(l,tl);
 
 if buysetup = false then buysetup = th > yh;
 if sellsetup = false then sellsetup = tl < yl;
 
 if marketposition <> 0 then begin
  {
  setstopshare;
  
  //STOPLOSS
  setstoploss(stoploss);
    
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
  }
 end;
 
 //ENGINE
 if buysetup and c < upperk then
  buy nos shares next bar at upperk stop;
 if sellsetup and c > lowerk then
  sellshort nos shares next bar at lowerk stop;
  
end;


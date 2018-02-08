Inputs: NoS(2),lenl(15),kl(3.13),lens(20),ks(4.69),alfa(.2);

Vars: th(0),tl(0),yh(0),yl(0),buysetup(false),sellsetup(false),upperk(0),lowerk(0),mcp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

mcp = MM.MaxContractProfit;

if currentbar > MaxBarsBack then begin
 
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];
 
 if d > d[1] then begin
  yh = th;
  yl = tl;
  th = h;
  tl = l;
  buysetup = false;
  sellsetup = false;
 end;
 
 th = maxlist(h,th);
 tl = minlist(l,tl);
 
 if buysetup = false then buysetup = th > yh;
 if sellsetup = false then sellsetup = tl < yl;
 
 //ENGINE
 if buysetup and c < upperk then
  buy nos shares next bar at upperk stop;
 if sellsetup and c > lowerk then
  sellshort nos shares next bar at lowerk stop;
  
end;


Inputs: nos(2),kl(1.4),ks(1.8),adxlen(14),adxlimit(30),alfa(.02);
Inputs: stoploss(400);

vars: upperk(0),lowerk(0),adxval(0),lens(0),lenl(0),sin(0),lsin(0);

LeadingSine(h,sin,lsin,lenl);
LeadingSine(l,sin,lsin,lens);

if lenl < 1 then lenl = 1;
if lens < 1 then lens = 1;

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen);

//ENGINE
 if adxval < adxlimit then begin
  if marketposition < 1 and c < upperk and range < AvgTrueRange(lenl) then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk and range < AvgTrueRange(lens) then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

Inputs: nos(2),lenl(20),kl(2),lens(20),ks(2),adxlen(14),adxlimit(30),alfa(.2);
Inputs: stoploss(500);

Vars: upperk(0,data2),lowerk(0,data2),centerk(0,data2),adxval(0,data2),mcp(0);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

//centerk = (upperk+lowerk)/2;

if marketposition <> 0 then begin
 
 setstopshare;
 
 //STOPLOSS
 //setstoploss(stoploss);
 
 //if marketposition = 1 then sell("xl") next bar at upperk limit;
 //if marketposition = -1 then buytocover("xs") next bar at lowerk limit;
 
end;

adxval = adx(adxlen)data2;

if adxval < adxlimit then begin
 if marketposition > -1 and c > upperk then
  sellshort("rs") nos shares next bar at upperk stop;
 if marketposition < 1 and c < lowerk then
  buy("rl") nos shares next bar at lowerk stop;
end; 

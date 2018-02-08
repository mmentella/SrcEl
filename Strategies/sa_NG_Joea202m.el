Inputs: NoS(2),Length(28),K(2),OffSet(1),SOD(1450),EOD(2200),MaxTrades(1);

Inputs: StopLoss(500),Profit(.25),BRKS(1000),BRKL(750);

Vars: var0(0),var1(0),compression(false);

if time > sod and time < eod then begin

 var0 = TradesToday(d);

 if var0 < MaxTrades then begin
  compression = range < average(range,length*k);
  var0 = highest(h,length) + offset point;
  var1 = lowest(l,length) - offset point;
  
  if compression then begin
   buy("long") nos shares next bar at var0 stop;
   sellshort("short") nos shares next bar at var1 stop;
  end;  
 end;
  
 if marketposition = 1 then begin
  sell("tl") next bar at entryprice + profit limit;
  if maxpositionprofit > brkl*nos then sell("brkl") next bar at entryprice + .01 stop;
 end;
 if marketposition = -1 then begin
  buytocover("ts") next bar at entryprice - profit limit;
  if maxpositionprofit > brks*nos then buytocover("brks") next bar at entryprice - .01 stop;
 end;
 
 setstopshare;
 if marketposition <> 0 then setstoploss(stoploss);
 
end;

if time > eod then begin
 if marketposition = 1 then sell("eodl") this bar on close;
 if marketposition = -1 then buytocover("eods") this bar on close;
end;

setexitonclose;

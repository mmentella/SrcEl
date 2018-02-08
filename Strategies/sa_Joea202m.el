Inputs: NoS(2),Length(8),K(2),OffSet(1),SOD(1415),EOD(2200),MaxTrades(1);

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
 
 setstopshare;
 setstoploss(500);
 
end;

if time > eod then begin
 if marketposition = 1 then sell this bar on close;
 if marketposition = -1 then buytocover this bar on close;
end;

setexitonclose;

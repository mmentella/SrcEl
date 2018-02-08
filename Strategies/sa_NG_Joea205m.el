[IntraBarOrderGeneration = true];
Inputs: NoS(2),Length(8),K(2),OffSet(1),SOD(1415),EOD(2300),MaxTrades(1),PctXL(.65),PctXS(.8),NumDaysC(6);

Inputs: StopLoss(600);

Vars: var0(0),var1(0),compression(false),posprofit(0),cow(0);

ngjoecow(numdaysc,sod,eod);

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
 
 if barssinceentry > 0 then begin
   
 end;
 
end;//eod

if time > eod then begin
 if marketposition = 1 then sell("eodl") this bar on close;
 if marketposition = -1 then buytocover("eods") this bar on close;
end;

setexitonclose;

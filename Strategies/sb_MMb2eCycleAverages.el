vars: var0(0),var1(0),dcperiod(0),nos(0);

dcperiod = MM.DominantCyclePeriod(MedianPrice);

if currentbar > MaxBarsBack then begin
 
  if dcperiod <> 0 then begin
   var0 = average(medianprice,ceiling(dcperiod/4));
   var1 = average(medianprice,2*dcperiod);
   
   if var0 > var1 then buy next bar at market;
   if var0 < var1 then sellshort next bar at market;
  end;
  
end;

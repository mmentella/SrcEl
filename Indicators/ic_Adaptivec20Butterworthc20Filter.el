input: period(20),minlen(6),maxlen(50);

vars:	change(0), noise(0), diff(0), ratio(0), signal(0),len(minlen),len2(maxlen),butt1(0),butt(2);

ratio = 0;
diff = AbsValue(close - close[1]);

if currentbar > period then begin
 change = close - close[period];
 signal = AbsValue(change);
 noise = summation(diff,period);
 if noise <> 0 then ratio = signal/noise;
 
 len = minlen + ratio*(maxlen-minlen);
 len2 = maxlen + ratio*(minlen-maxlen);
 
 butt  = MM.ButterworthFilter(medianprice,len,2);
 butt1 = MM.ButterworthFilter(medianprice,len2,2);
 
 plot10(butt,"NOISE",red);
 plot20(butt1,"EFFICIENCY",white);
 
 //if len < len2 then PlotPB(h,l,o,c,"",red);
 //if len > len2 then PlotPB(h,l,o,c,"",white);
end;

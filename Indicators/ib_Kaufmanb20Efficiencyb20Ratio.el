input: period(20), navg(5);

vars:	change(0), noise(0), diff(0), ratio(0), signal(0), ERavg(0),min(2),max(-1);

ratio = 0;
diff = AbsValue(close - close[1]);

if currentbar > period then begin
 change = close - close[period];
 signal = AbsValue(change);
 noise = summation(diff,period);
 if noise <> 0 then ratio = signal/noise;
 max = maxlist(max,ratio);
 min = minlist(min,ratio);
 ERavg = average(ratio,navg);
end;

plot1(ratio,"ER");
if LastBarOnChart then begin
 plot2(max,"ERMax");
 plot3(min,"ERMin");
end;

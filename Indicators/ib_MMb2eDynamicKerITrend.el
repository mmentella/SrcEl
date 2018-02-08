Inputs: Period(20),showtrig(false);

vars: itrend(0),trig(0),ker(0);
vars:	change(0), noise(0), diff(0), ratio(0), signal(0);

ratio = 0;
diff = AbsValue(close - close[1]);

if currentbar > period then begin
 change = close - close[period];
 signal = AbsValue(change);
 noise = summation(diff,period);
 ratio = 0;
 if noise <> 0 then ratio = signal/noise;
end;

MM.ITrend(medianprice,ratio,itrend,trig);

plot1(itrend,"Trend");
if showtrig then plot2(trig,"Trigger");

input: period(0.05);

var: vtrend(0),vtrig(0),vol(0);

vol = Volume;

MM.ITrend(vol,period,vtrend,vtrig);

plot1(Volume,"Vol",yellow);
plot2(vtrend,"Trend",white);
plot3(vtrig,"Trig",red);

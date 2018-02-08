vars: vol(0),trend(0),trig(0);

vol = iff(bartype>=2,Volume,Ticks);

MM.ITrend(vol,0.07,trend,trig);

plot1(trend,"Volume trend");
plot2(trig,"Trigger");
//plot3(vol,"Volume");
